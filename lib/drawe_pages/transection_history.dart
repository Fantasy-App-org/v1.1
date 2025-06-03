import 'package:flutter/material.dart';

class TransactionHistoryPage extends StatefulWidget {
  @override
  _TransactionHistoryPageState createState() => _TransactionHistoryPageState();
}

class _TransactionHistoryPageState extends State<TransactionHistoryPage>
    with TickerProviderStateMixin {
  String selectedFilter = 'All';
  TextEditingController searchController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    searchController.dispose();
    super.dispose();
  }

  List<Transaction> transactions = [
    Transaction(
      id: 1,
      type: 'Contest Entry',
      game: 'IND vs AUS T20',
      amount: -100,
      status: 'Completed',
      date: '2024-05-20',
      time: '14:30',
      result: 'Won',
      winAmount: 250,
    ),
    Transaction(
      id: 2,
      type: 'Contest Entry',
      game: 'MI vs CSK IPL',
      amount: -50,
      status: 'Completed',
      date: '2024-05-19',
      time: '19:45',
      result: 'Lost',
      winAmount: 0,
    ),
    Transaction(
      id: 3,
      type: 'Wallet Add',
      game: 'UPI Payment',
      amount: 500,
      status: 'Completed',
      date: '2024-05-18',
      time: '16:20',
      result: 'Success',
      winAmount: 0,
    ),
    Transaction(
      id: 4,
      type: 'Contest Entry',
      game: 'RCB vs KKR IPL',
      amount: -75,
      status: 'Completed',
      date: '2024-05-17',
      time: '20:00',
      result: 'Won',
      winAmount: 150,
    ),
    Transaction(
      id: 5,
      type: 'Withdrawal',
      game: 'Bank Transfer',
      amount: -200,
      status: 'Pending',
      date: '2024-05-16',
      time: '11:15',
      result: 'Processing',
      winAmount: 0,
    ),
    Transaction(
      id: 6,
      type: 'Contest Entry',
      game: 'ENG vs PAK ODI',
      amount: -120,
      status: 'Completed',
      date: '2024-05-15',
      time: '13:30',
      result: 'Lost',
      winAmount: 0,
    ),
    Transaction(
      id: 7,
      type: 'Contest Entry',
      game: 'GT vs LSG IPL',
      amount: -25,
      status: 'Completed',
      date: '2024-05-14',
      time: '15:45',
      result: 'Won',
      winAmount: 45,
    ),
    Transaction(
      id: 8,
      type: 'Bonus Added',
      game: 'Welcome Bonus',
      amount: 100,
      status: 'Completed',
      date: '2024-05-13',
      time: '10:00',
      result: 'Success',
      winAmount: 0,
    ),
  ];

  List<Transaction> get filteredTransactions {
    List<Transaction> filtered = transactions;

    if (selectedFilter != 'All') {
      filtered =
          filtered.where((transaction) {
            switch (selectedFilter) {
              case 'Won':
                return transaction.result == 'Won';
              case 'Lost':
                return transaction.result == 'Lost';
              case 'Deposits':
                return transaction.type == 'Wallet Add';
              case 'Withdrawals':
                return transaction.type == 'Withdrawal';
              default:
                return true;
            }
          }).toList();
    }

    if (searchController.text.isNotEmpty) {
      filtered =
          filtered
              .where(
                (transaction) =>
                    transaction.game.toLowerCase().contains(
                      searchController.text.toLowerCase(),
                    ) ||
                    transaction.type.toLowerCase().contains(
                      searchController.text.toLowerCase(),
                    ),
              )
              .toList();
    }

    return filtered;
  }

  double get totalBetAmount {
    return transactions
        .where((t) => t.type == 'Contest Entry')
        .fold(0.0, (sum, t) => sum + t.amount.abs());
  }

  double get totalWinnings {
    return transactions.fold(0.0, (sum, t) => sum + t.winAmount);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen =
        screenWidth < 375; // iPhone SE or similar small devices

    return Scaffold(
      backgroundColor: Color(0xFFF8FAFC),
      body: CustomScrollView(
        slivers: [
          // Modern App Bar
          SliverAppBar(
            expandedHeight: isSmallScreen ? 100 : 120,
            floating: false,
            pinned: true,
            backgroundColor: Colors.white,
            foregroundColor: Color(0xFF1E293B),
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Transaction History',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: isSmallScreen ? 20 : 24,
                  color: Color(0xFF1E293B),
                ),
              ),
              centerTitle: false,
              titlePadding: EdgeInsets.only(
                left: isSmallScreen ? 16 : 20,
                bottom: isSmallScreen ? 12 : 16,
              ),
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(1),
              child: Container(
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Color(0xFFE2E8F0),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                children: [
                  SizedBox(height: isSmallScreen ? 12 : 20),

                  // Enhanced Stats Section
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: isSmallScreen ? 12 : 20,
                    ),
                    child: _buildStatsSection(context),
                  ),

                  SizedBox(height: isSmallScreen ? 16 : 24),

                  // Modern Search and Filter Section
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: isSmallScreen ? 12 : 20,
                    ),
                    child: _buildSearchAndFilter(context),
                  ),

                  SizedBox(height: isSmallScreen ? 16 : 24),
                ],
              ),
            ),
          ),

          // Transaction List
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: isSmallScreen ? 12 : 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF64748B).withOpacity(0.06),
                    spreadRadius: 0,
                    blurRadius: 20,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      isSmallScreen ? 16 : 24,
                      isSmallScreen ? 16 : 24,
                      isSmallScreen ? 16 : 24,
                      16,
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.history, color: Color(0xFF475569), size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Recent Transactions',
                          style: TextStyle(
                            fontSize: isSmallScreen ? 16 : 18,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        Spacer(),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${filteredTransactions.length}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF475569),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: filteredTransactions.length,
                    separatorBuilder:
                        (context, index) => Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: isSmallScreen ? 16 : 24,
                          ),
                          height: 1,
                          color: Color(0xFFF1F5F9),
                        ),
                    itemBuilder: (context, index) {
                      return _buildTransactionItem(
                        filteredTransactions[index],
                        index,
                        context,
                      );
                    },
                  ),
                  SizedBox(height: 8),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }

  Widget _buildStatsSection(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 375;

    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF3B82F6).withOpacity(0.25),
            spreadRadius: 0,
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.account_balance_wallet,
                color: Colors.white,
                size: isSmallScreen ? 20 : 24,
              ),
              SizedBox(width: isSmallScreen ? 8 : 12),
              Text(
                'Portfolio Overview',
                style: TextStyle(
                  fontSize: isSmallScreen ? 16 : 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: isSmallScreen ? 12 : 20),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Total Bets',
                  '₹${totalBetAmount.toStringAsFixed(0)}',
                  Icons.sports_cricket,
                  Colors.white.withOpacity(0.9),
                  true,
                  context,
                ),
              ),
              SizedBox(width: isSmallScreen ? 8 : 12),
              Expanded(
                child: _buildStatCard(
                  'Winnings',
                  '₹${totalWinnings.toStringAsFixed(0)}',
                  Icons.trending_up,
                  Colors.white.withOpacity(0.9),
                  true,
                  context,
                ),
              ),
            ],
          ),
          SizedBox(height: isSmallScreen ? 8 : 12),
          _buildStatCard(
            'Net P&L',
            '₹${(totalWinnings - totalBetAmount).toStringAsFixed(0)}',
            (totalWinnings - totalBetAmount) >= 0
                ? Icons.arrow_upward
                : Icons.arrow_downward,
            Colors.white.withOpacity(0.9),
            true,
            context,
            isNetPL: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 375;

    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 16.0 : 20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF64748B).withOpacity(0.06),
            spreadRadius: 0,
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Enhanced Search Bar
          // Corrected version of the search bar container
          Container(
            decoration: BoxDecoration(
              color: Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Color(0xFFE2E8F0)),
            ),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search transactions...',
                hintStyle: TextStyle(color: Color(0xFF64748B)),
                prefixIcon: Icon(
                  Icons.search,
                  color: Color(0xFF64748B),
                  size: 20,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: isSmallScreen ? 12.0 : 16.0,
                ),
              ),
              onChanged: (value) => setState(() {}),
            ),
          ),

          SizedBox(height: isSmallScreen ? 12.0 : 16.0),

          // Modern Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children:
                  ['All', 'Won', 'Lost', 'Deposits', 'Withdrawals']
                      .map(
                        (filter) => Padding(
                          padding: EdgeInsets.only(
                            right: isSmallScreen ? 8.0 : 12.0,
                          ),
                          child: _buildFilterChip(filter, context),
                        ),
                      )
                      .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String filter, BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 375;
    bool isSelected = selectedFilter == filter;

    return GestureDetector(
      onTap: () => setState(() => selectedFilter = filter),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 16 : 20,
          vertical: isSmallScreen ? 8 : 12,
        ),
        decoration: BoxDecoration(
          gradient:
              isSelected
                  ? LinearGradient(
                    colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
                  )
                  : null,
          color: isSelected ? null : Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected ? Colors.transparent : Color(0xFFE2E8F0),
          ),
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: Color(0xFF3B82F6).withOpacity(0.25),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ]
                  : null,
        ),
        child: Text(
          filter,
          style: TextStyle(
            color: isSelected ? Colors.white : Color(0xFF475569),
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            fontSize: isSmallScreen ? 12 : 13,
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
    bool isWhite,
    BuildContext context, {
    bool isNetPL = false,
  }) {
    final isSmallScreen = MediaQuery.of(context).size.width < 375;
    double netValue = totalWinnings - totalBetAmount;

    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
      decoration: BoxDecoration(
        color:
            isWhite ? Colors.white.withOpacity(0.15) : color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border:
            isWhite ? Border.all(color: Colors.white.withOpacity(0.2)) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color:
                    isWhite
                        ? Colors.white
                        : (isNetPL && netValue < 0 ? Colors.red : color),
                size: isSmallScreen ? 16 : 20,
              ),
              SizedBox(width: isSmallScreen ? 4 : 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 10 : 12,
                    color:
                        isWhite
                            ? Colors.white.withOpacity(0.8)
                            : Color(0xFF64748B),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: isSmallScreen ? 4 : 8),
          Text(
            value,
            style: TextStyle(
              fontSize: isSmallScreen ? 16 : 18,
              fontWeight: FontWeight.w700,
              color:
                  isWhite
                      ? Colors.white
                      : (isNetPL && netValue < 0
                          ? Colors.red
                          : Color(0xFF1E293B)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(
    Transaction transaction,
    int index,
    BuildContext context,
  ) {
    final isSmallScreen = MediaQuery.of(context).size.width < 375;

    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 12 : 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Enhanced Transaction Icon
          Container(
            width: isSmallScreen ? 40 : 48,
            height: isSmallScreen ? 40 : 48,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _getTransactionColor(transaction.type).withOpacity(0.8),
                  _getTransactionColor(transaction.type),
                ],
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: _getTransactionColor(
                    transaction.type,
                  ).withOpacity(0.25),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              _getTransactionIcon(transaction.type),
              color: Colors.white,
              size: isSmallScreen ? 18 : 22,
            ),
          ),

          SizedBox(width: isSmallScreen ? 12 : 16),

          // Transaction Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.game,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: isSmallScreen ? 14 : 15,
                    color: Color(0xFF1E293B),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    Text(
                      transaction.type,
                      style: TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: isSmallScreen ? 11 : 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Color(0xFF94A3B8),
                        shape: BoxShape.circle,
                      ),
                    ),
                    Text(
                      '${transaction.date} • ${transaction.time}',
                      style: TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: isSmallScreen ? 11 : 12,
                      ),
                    ),
                  ],
                ),
                if (transaction.winAmount > 0) ...[
                  SizedBox(height: 4),
                  Text(
                    '+₹${transaction.winAmount} won',
                    style: TextStyle(
                      color: Color(0xFF10B981),
                      fontSize: isSmallScreen ? 11 : 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Amount and Status
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${transaction.amount >= 0 ? '+' : ''}₹${transaction.amount.abs()}',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: isSmallScreen ? 14 : 16,
                  color:
                      transaction.amount >= 0
                          ? Color(0xFF10B981)
                          : Color(0xFFEF4444),
                ),
              ),
              SizedBox(height: isSmallScreen ? 4 : 6),
              Wrap(
                spacing: isSmallScreen ? 4 : 8,
                runSpacing: isSmallScreen ? 4 : 0,
                alignment: WrapAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isSmallScreen ? 8 : 10,
                      vertical: isSmallScreen ? 2 : 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(
                        transaction.status,
                      ).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      transaction.status,
                      style: TextStyle(
                        color: _getStatusColor(transaction.status),
                        fontSize: isSmallScreen ? 9 : 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (transaction.result != 'Success' &&
                      transaction.result != 'Processing') ...[
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: isSmallScreen ? 6 : 8,
                        vertical: isSmallScreen ? 2 : 2,
                      ),
                      decoration: BoxDecoration(
                        color: _getResultColor(
                          transaction.result,
                        ).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        transaction.result,
                        style: TextStyle(
                          color: _getResultColor(transaction.result),
                          fontSize: isSmallScreen ? 9 : 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getTransactionIcon(String type) {
    switch (type) {
      case 'Contest Entry':
        return Icons.sports_cricket;
      case 'Wallet Add':
        return Icons.add_circle;
      case 'Withdrawal':
        return Icons.remove_circle;
      case 'Bonus Added':
        return Icons.card_giftcard;
      default:
        return Icons.receipt;
    }
  }

  Color _getTransactionColor(String type) {
    switch (type) {
      case 'Contest Entry':
        return Color(0xFF3B82F6);
      case 'Wallet Add':
        return Color(0xFF10B981);
      case 'Withdrawal':
        return Color(0xFFF59E0B);
      case 'Bonus Added':
        return Color(0xFF8B5CF6);
      default:
        return Color(0xFF6B7280);
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Completed':
        return Color(0xFF10B981);
      case 'Pending':
        return Color(0xFFF59E0B);
      case 'Failed':
        return Color(0xFFEF4444);
      default:
        return Color(0xFF6B7280);
    }
  }

  Color _getResultColor(String result) {
    switch (result) {
      case 'Won':
        return Color(0xFF10B981);
      case 'Lost':
        return Color(0xFFEF4444);
      case 'Processing':
        return Color(0xFFF59E0B);
      default:
        return Color(0xFF6B7280);
    }
  }
}

class Transaction {
  final int id;
  final String type;
  final String game;
  final double amount;
  final String status;
  final String date;
  final String time;
  final String result;
  final double winAmount;

  Transaction({
    required this.id,
    required this.type,
    required this.game,
    required this.amount,
    required this.status,
    required this.date,
    required this.time,
    required this.result,
    required this.winAmount,
  });
}
