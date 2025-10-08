// pages/transaction_history_page.dart
import 'package:flutter/material.dart';
import 'package:fantasy/model/transaction_model.dart';
import 'package:fantasy/service/transaction_service.dart';

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

  // API related variables
  List<Transaction> allTransactions = []; // Store ALL loaded transactions
  List<Transaction> currentPageTransactions = []; // Current page display
  Set<int> loadedPages = {}; // Track which pages we've loaded
  bool isLoading = true;
  String errorMessage = '';
  int currentPage = 1;
  int totalPages = 1;
  int totalTransactions = 0;
  ScrollController _scrollController = ScrollController();

  // --- Formatter: show values as points (UI-only change) ---
  String _formatPts(num v) => '${v.toStringAsFixed(0)} pts';

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

    _loadTransactions();
    _animationController.forward();
  }

  Future<void> _loadTransactions({bool refresh = false}) async {
    if (refresh) {
      setState(() {
        currentPage = 1;
        allTransactions.clear();
        currentPageTransactions.clear();
        loadedPages.clear();
        isLoading = true;
        errorMessage = '';
        totalTransactions = 0;
      });
    } else {
      setState(() {
        isLoading = true;
      });
    }

    try {
      final response = await TransactionService.getTransactionHistory(
        page: currentPage,
      );

      if (response.status) {
        setState(() {
          // Set current page transactions for display
          currentPageTransactions = response.data.transactions;

          // Add to all transactions if this page hasn't been loaded before
          if (!loadedPages.contains(currentPage)) {
            allTransactions.addAll(response.data.transactions);
            loadedPages.add(currentPage);
          }

          totalPages = response.data.totalPages;
          totalTransactions = totalPages * 20; // Assuming 20 per page
          isLoading = false;
          errorMessage = '';
        });
      } else {
        setState(() {
          errorMessage = response.message;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load transactions: $e';
        isLoading = false;
      });
    }
  }

  void _goToPage(int page) {
    if (page >= 1 && page <= totalPages && page != currentPage) {
      setState(() {
        currentPage = page;
      });
      _loadTransactions();
    }
  }

  Future<void> _searchTransactions() async {
    if (searchController.text.isEmpty) {
      await _loadTransactions(refresh: true);
      return;
    }

    setState(() {
      isLoading = true;
      currentPage = 1;
      allTransactions.clear();
      currentPageTransactions.clear();
      loadedPages.clear();
      totalTransactions = 0;
    });

    try {
      final response = await TransactionService.searchTransactions(
        query: searchController.text,
        page: currentPage,
      );

      if (response.status) {
        setState(() {
          currentPageTransactions = response.data.transactions;
          allTransactions = response.data.transactions; // For search, reset all transactions
          loadedPages.add(currentPage);
          totalPages = response.data.totalPages;
          totalTransactions = totalPages * 20; // Approximate
          isLoading = false;
          errorMessage = '';
        });
      } else {
        setState(() {
          errorMessage = response.message;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to search transactions: $e';
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Portfolio calculations work on ALL loaded transactions (accumulated data)
  double get totalBetAmount {
    return allTransactions
        .where((t) => t.type == 'Contest Entry' && t.amount < 0)
        .fold(0.0, (sum, t) => sum + t.amount.abs());
  }

  double get totalWinnings {
    return allTransactions
        .where((t) => t.amount > 0)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  // Filtered transactions for display (only current page)
  List<Transaction> get filteredTransactions {
    List<Transaction> filtered = currentPageTransactions;

    if (selectedFilter != 'All') {
      filtered = filtered.where((transaction) {
        switch (selectedFilter) {
          case 'Won':
            return transaction.txnType.contains('Won');
          case 'Deposited':
            return transaction.txnType.contains('Joined') || transaction.amount < 0;
          case 'Refunded':
            return transaction.txnType.contains('Refunded');
          default:
            return true;
        }
      }).toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 375;

    return Scaffold(
      backgroundColor: Color(0xFFF8FAFC),
      body: RefreshIndicator(
        onRefresh: () => _loadTransactions(refresh: true),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              expandedHeight: isSmallScreen ? 100 : 120,
              floating: false,
              pinned: true,
              backgroundColor: Colors.white,
              foregroundColor: Color(0xFF1E293B),
              elevation: 0,
              iconTheme: IconThemeData(
                color: Colors.black,
                size: 24,
              ),
              actionsIconTheme: IconThemeData(
                color: Colors.black,
                size: 24,
              ),
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

                    // Stats Section
                    Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: isSmallScreen ? 12 : 20,
                      ),
                      child: _buildStatsSection(context),
                    ),

                    SizedBox(height: isSmallScreen ? 16 : 24),

                    // Search and Filter Section
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

            // Transaction List or Loading/Error States
            _buildTransactionList(isSmallScreen),

            // Pagination Section
            SliverToBoxAdapter(
              child: _buildPagination(isSmallScreen),
            ),

            SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionList(bool isSmallScreen) {
    if (isLoading) {
      return SliverToBoxAdapter(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: isSmallScreen ? 12 : 20),
          padding: EdgeInsets.all(40),
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
          child: Center(
            child: Column(
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3B82F6)),
                ),
                SizedBox(height: 16),
                Text(
                  'Loading transactions...',
                  style: TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (errorMessage.isNotEmpty) {
      return SliverToBoxAdapter(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: isSmallScreen ? 12 : 20),
          padding: EdgeInsets.all(40),
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
          child: Center(
            child: Column(
              children: [
                Icon(
                  Icons.error_outline,
                  color: Color(0xFFEF4444),
                  size: 48,
                ),
                SizedBox(height: 16),
                Text(
                  'Error',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  errorMessage,
                  style: TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _loadTransactions(refresh: true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF3B82F6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text('Retry', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return SliverToBoxAdapter(
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
                    'Transaction History',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 16 : 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
            if (filteredTransactions.isEmpty)
              Padding(
                padding: EdgeInsets.all(40),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.receipt_long,
                        color: Color(0xFF94A3B8),
                        size: 48,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No transactions found',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF64748B),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Try adjusting your filters or search terms',
                        style: TextStyle(
                          color: Color(0xFF94A3B8),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: filteredTransactions.length,
                separatorBuilder: (context, index) => Container(
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
    );
  }

  Widget _buildPagination(bool isSmallScreen) {
    if (totalPages <= 1) return SizedBox.shrink();

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 12 : 20,
        vertical: 20,
      ),
      padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
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
          // Page info and accumulated data indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Page $currentPage of $totalPages',
                style: TextStyle(
                  fontSize: isSmallScreen ? 14 : 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF475569),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Color(0xFF3B82F6).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${allTransactions.length} total loaded',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF3B82F6),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),

          // Pagination controls - Fixed overflow
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Previous button
                _buildPaginationButton(
                  icon: Icons.chevron_left,
                  enabled: currentPage > 1,
                  onTap: () => _goToPage(currentPage - 1),
                  isSmallScreen: isSmallScreen,
                ),

                SizedBox(width: 12),

                // Page numbers
                ..._buildPageNumbers(isSmallScreen),

                SizedBox(width: 12),

                // Next button
                _buildPaginationButton(
                  icon: Icons.chevron_right,
                  enabled: currentPage < totalPages,
                  onTap: () => _goToPage(currentPage + 1),
                  isSmallScreen: isSmallScreen,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildPageNumbers(bool isSmallScreen) {
    List<Widget> pages = [];
    int start = (currentPage - 2).clamp(1, totalPages);
    int end = (currentPage + 2).clamp(1, totalPages);

    // Adjust range to show 5 pages when possible
    if (end - start < 4) {
      if (start == 1) {
        end = (start + 4).clamp(1, totalPages);
      } else if (end == totalPages) {
        start = (end - 4).clamp(1, totalPages);
      }
    }

    // First page + ellipsis
    if (start > 1) {
      pages.add(_buildPageNumberButton(1, isSmallScreen));
      if (start > 2) {
        pages.add(SizedBox(width: 8));
        pages.add(_buildEllipsis(isSmallScreen));
      }
      pages.add(SizedBox(width: 8));
    }

    // Page range
    for (int i = start; i <= end; i++) {
      pages.add(_buildPageNumberButton(i, isSmallScreen));
      if (i < end) pages.add(SizedBox(width: 8));
    }

    // Ellipsis + last page
    if (end < totalPages) {
      pages.add(SizedBox(width: 8));
      if (end < totalPages - 1) {
        pages.add(_buildEllipsis(isSmallScreen));
        pages.add(SizedBox(width: 8));
      }
      pages.add(_buildPageNumberButton(totalPages, isSmallScreen));
    }

    return pages;
  }

  Widget _buildPaginationButton({
    required IconData icon,
    required bool enabled,
    required VoidCallback onTap,
    required bool isSmallScreen,
  }) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: isSmallScreen ? 40 : 44,
        height: isSmallScreen ? 40 : 44,
        decoration: BoxDecoration(
          color: enabled ? Color(0xFF3B82F6) : Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(12),
          boxShadow: enabled ? [
            BoxShadow(
              color: Color(0xFF3B82F6).withOpacity(0.25),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ] : null,
        ),
        child: Icon(
          icon,
          color: enabled ? Colors.white : Color(0xFF94A3B8),
          size: isSmallScreen ? 20 : 24,
        ),
      ),
    );
  }

  Widget _buildPageNumberButton(int pageNumber, bool isSmallScreen) {
    bool isActive = pageNumber == currentPage;
    bool isLoaded = loadedPages.contains(pageNumber);

    return GestureDetector(
      onTap: () => _goToPage(pageNumber),
      child: Container(
        width: isSmallScreen ? 36 : 40,
        height: isSmallScreen ? 36 : 40,
        decoration: BoxDecoration(
          gradient: isActive ? LinearGradient(
            colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
          ) : null,
          color: isActive ? null : (isLoaded ? Color(0xFFE0F2FE) : Colors.transparent),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isActive ? Colors.transparent :
            isLoaded ? Color(0xFF3B82F6).withOpacity(0.3) : Color(0xFFE2E8F0),
          ),
          boxShadow: isActive ? [
            BoxShadow(
              color: Color(0xFF3B82F6).withOpacity(0.25),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ] : null,
        ),
        child: Center(
          child: Text(
            pageNumber.toString(),
            style: TextStyle(
              color: isActive ? Colors.white :
              isLoaded ? Color(0xFF3B82F6) : Color(0xFF475569),
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              fontSize: isSmallScreen ? 14 : 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEllipsis(bool isSmallScreen) {
    return Container(
      width: isSmallScreen ? 36 : 40,
      height: isSmallScreen ? 36 : 40,
      child: Center(
        child: Text(
          '...',
          style: TextStyle(
            color: Color(0xFF94A3B8),
            fontSize: isSmallScreen ? 14 : 16,
            fontWeight: FontWeight.w500,
          ),
        ),
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
              Spacer(),
              // Show loaded data indicator
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${loadedPages.length}/${totalPages} pages',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.w500,
                  ),
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
                  _formatPts(totalBetAmount),
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
                  _formatPts(totalWinnings),
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
            _formatPts(totalWinnings - totalBetAmount),
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

  // Keep all your existing UI methods unchanged
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
              onSubmitted: (value) => _searchTransactions(),
              onChanged: (value) {
                if (value.isEmpty) {
                  _loadTransactions(refresh: true);
                }
              },
            ),
          ),

          SizedBox(height: isSmallScreen ? 12.0 : 16.0),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['All', 'Won', 'Deposited', 'Refunded']
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

    // Get filter-specific colors
    Color getFilterColor(String filter) {
      switch (filter) {
        case 'Won':
          return Color(0xFF10B981); // Green
        case 'Deposited':
          return Color(0xFFEF4444); // Red
        case 'Refunded':
          return Color(0xFF3B82F6); // Blue
        default:
          return Color(0xFF3B82F6); // Default blue for "All"
      }
    }

    IconData? getFilterIcon(String filter) {
      switch (filter) {
        case 'Won':
          return Icons.trending_up;
        case 'Deposited':
          return Icons.remove_circle_outline;
        case 'Refunded':
          return Icons.undo;
        default:
          return null;
      }
    }

    return GestureDetector(
      onTap: () => setState(() => selectedFilter = filter),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 14 : 18,
          vertical: isSmallScreen ? 8 : 12,
        ),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
            colors: [
              getFilterColor(filter),
              getFilterColor(filter).withOpacity(0.8),
            ],
          )
              : null,
          color: isSelected ? null : Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected ? Colors.transparent : getFilterColor(filter).withOpacity(0.3),
          ),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: getFilterColor(filter).withOpacity(0.25),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (getFilterIcon(filter) != null) ...[
              Icon(
                getFilterIcon(filter),
                color: isSelected ? Colors.white : getFilterColor(filter),
                size: isSmallScreen ? 14 : 16,
              ),
              SizedBox(width: 6),
            ],
            Text(
              filter,
              style: TextStyle(
                color: isSelected ? Colors.white : getFilterColor(filter),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                fontSize: isSmallScreen ? 12 : 13,
              ),
            ),
          ],
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
        color: isWhite ? Colors.white.withOpacity(0.15) : color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: isWhite ? Border.all(color: Colors.white.withOpacity(0.2)) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: isWhite
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
                    color: isWhite
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
              color: isWhite
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

    // Amount text as points (keep sign semantics: + for positive; none for negative, like original)
    final String amountTxt =
        '${transaction.amount >= 0 ? '+' : ''}${_formatPts(transaction.amount.abs())}';

    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 12 : 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                  color: _getTransactionColor(transaction.type).withOpacity(0.25),
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
                      transaction.txnType, // unchanged (backend label)
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
                    '+${_formatPts(transaction.winAmount)} won',
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

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amountTxt,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: isSmallScreen ? 14 : 16,
                  color: transaction.amount >= 0
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
                      color: _getStatusColor(transaction.status).withOpacity(0.1),
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
                        color: _getResultColor(transaction.result).withOpacity(0.1),
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

  // Keep all your existing helper methods for colors and icons
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