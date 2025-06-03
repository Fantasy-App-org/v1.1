import 'package:fantasy/drawe_pages/profile.dart';
import 'package:fantasy/body/refral.dart';
import 'package:fantasy/body/tree.dart';
import 'package:fantasy/body/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../drawe_pages/fantasy point system.dart';
import '../drawe_pages/transection_history.dart';
import 'login.dart';
import 'mygame.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xFFF8FAFC),
      appBar: _buildPremiumAppBar(),
      drawer: _buildPremiumDrawer(),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: IndexedStack(
          index: _selectedIndex,
          children: [
            _buildHomeScreen(),
            MyMatchesScreen(),
            EarningsDashboard(),
            ReferralScreen(),
          ],
        ),
      ),
      bottomNavigationBar: _buildPremiumBottomNav(),
    );
  }

  PreferredSizeWidget _buildPremiumAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      leading: Container(
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: IconButton(
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          icon: Icon(Icons.menu_rounded, color: Color(0xFF1E293B), size: 20),
        ),
      ),
      title: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.sports_cricket, color: Colors.white, size: 20),
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'FANTASY XI',
                style: TextStyle(
                  color: Color(0xFF0F172A),
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                'Cricket League',
                style: TextStyle(
                  color: Color(0xFF64748B),
                  fontWeight: FontWeight.w500,
                  fontSize: 10,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        Container(
          margin: EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  Icons.notifications_none_rounded,
                  color: Color(0xFF475569),
                  size: 22,
                ),
                Positioned(
                  right: -2,
                  top: -2,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    constraints: BoxConstraints(minWidth: 16, minHeight: 16),
                    child: Text(
                      '3',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            onPressed: () {},
          ),
        ),
        Container(
          margin: EdgeInsets.only(right: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF059669), Color(0xFF047857)],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: Icon(
              Icons.account_balance_wallet_rounded,
              color: Colors.white,
              size: 20,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const WalletScreen()),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHomeScreen() {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPremiumBanner(),
          _buildBalanceCard(),
          _buildQuickActions(),
          _buildLiveMatches(),
          _buildUpcomingMatches(),
          _buildPerformanceStats(),
          SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildPremiumBanner() {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1E40AF), Color(0xFF3730A3), Color(0xFF581C87)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF3730A3).withOpacity(0.3),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background Pattern
          Positioned(
            right: -50,
            top: -30,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),
          Positioned(
            right: 20,
            bottom: -20,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.03),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome Back! 👋',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Build Your\nDream Team',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                        ),
                      ),
                      child: Icon(
                        Icons.emoji_events_rounded,
                        color: Color(0xFFFBBF24),
                        size: 32,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  child: Text(
                    '🏆 Join upcoming IPL matches and win big!',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.95),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF1E293B).withOpacity(0.08),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
        border: Border.all(color: Color(0xFFF1F5F9)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF10B981), Color(0xFF059669)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.account_balance_wallet_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Balance',
                  style: TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '₹2,450.00',
                  style: TextStyle(
                    color: Color(0xFF0F172A),
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Color(0xFF10B981).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add_rounded, color: Color(0xFF10B981), size: 18),
                SizedBox(width: 4),
                Text(
                  'Add Money',
                  style: TextStyle(
                    color: Color(0xFF10B981),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    final actions = [
      {
        'title': 'Create Team',
        'icon': Icons.group_add_rounded,
        'color': Color(0xFF8B5CF6),
      },
      {
        'title': 'My Teams',
        'icon': Icons.people_rounded,
        'color': Color(0xFFf59E0B),
      },
      {
        'title': 'Contests',
        'icon': Icons.emoji_events_rounded,
        'color': Color(0xFFEF4444),
      },
      {
        'title': 'Leaderboard',
        'icon': Icons.trending_up_rounded,
        'color': Color(0xFF10B981),
      },
    ];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.8,
        ),
        itemCount: actions.length,
        itemBuilder: (context, index) {
          final action = actions[index];
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF1E293B).withOpacity(0.06),
                  blurRadius: 16,
                  offset: Offset(0, 2),
                ),
              ],
              border: Border.all(color: Color(0xFFF1F5F9)),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {},
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: (action['color'] as Color).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          action['icon'] as IconData,
                          color: action['color'] as Color,
                          size: 20,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          action['title'] as String,
                          style: TextStyle(
                            color: Color(0xFF1E293B),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLiveMatches() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        _buildSectionHeader('Live Matches', 'See All', () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AllLiveMatchesPage()),
          );
        }),
        SizedBox(
          height: screenHeight * 0.25, // 25% of screen height, responsive
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 14),
            itemCount: 3,
            itemBuilder:
                (context, index) => Container(
              width: screenWidth * 0.75, // 75% of screen width
              margin: EdgeInsets.only(right: 16),
              child: _buildLiveMatchCard(
                team1:
                index == 0
                    ? 'India'
                    : index == 1
                    ? 'England'
                    : 'South Africa',
                team2:
                index == 0
                    ? 'Australia'
                    : index == 1
                    ? 'Pakistan'
                    : 'New Zealand',
                team1Short:
                index == 0
                    ? 'IND'
                    : index == 1
                    ? 'ENG'
                    : 'SA',
                team2Short:
                index == 0
                    ? 'AUS'
                    : index == 1
                    ? 'PAK'
                    : 'NZ',
                score1:
                index == 0
                    ? '285/6'
                    : index == 1
                    ? '195/4'
                    : '220/5',
                score2:
                index == 0
                    ? '267/8'
                    : index == 1
                    ? '180/7'
                    : '205/9',
                overs1:
                index == 0
                    ? '(50.0)'
                    : index == 1
                    ? '(35.2)'
                    : '(45.3)',
                overs2:
                index == 0
                    ? '(48.4)'
                    : index == 1
                    ? '(40.0)'
                    : '(47.2)',
                status:
                index == 0
                    ? 'India won by 18 runs'
                    : index == 1
                    ? 'England won by 15 runs'
                    : 'SA won by 15 runs',
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLiveMatchCard({
    required String team1,
    required String team2,
    required String team1Short,
    required String team2Short,
    required String score1,
    required String score2,
    required String overs1,
    required String overs2,
    required String status,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: screenWidth * 0.75,
      height: screenHeight * 0.22, // Fixed height based on screen
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF1E293B).withOpacity(0.08),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: Color(0xFF10B981).withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          // Live Header - Fixed height
          Container(
            height: screenHeight * 0.05, // 5% of screen height
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.04,
              vertical: screenHeight * 0.01,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFDCFDF7), Color(0xFFF0FDF4)],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.025,
                    vertical: screenHeight * 0.005,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 6),
                      Text(
                        'LIVE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth * 0.028, // Responsive font size
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  'ODI Match',
                  style: TextStyle(
                    color: Color(0xFF059669),
                    fontSize: screenWidth * 0.03,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // Teams and Scores - Expanded to fill remaining space
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.04),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Teams Row
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              team1Short,
                              style: TextStyle(
                                fontSize: screenWidth * 0.04,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.008),
                            Text(
                              score1,
                              style: TextStyle(
                                fontSize: screenWidth * 0.045,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            Text(
                              overs1,
                              style: TextStyle(
                                fontSize: screenWidth * 0.03,
                                color: Color(0xFF64748B),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(screenWidth * 0.02),
                        decoration: BoxDecoration(
                          color: Color(0xFFF8FAFC),
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          'VS',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF64748B),
                            fontSize: screenWidth * 0.03,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              team2Short,
                              style: TextStyle(
                                fontSize: screenWidth * 0.04,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.008),
                            Text(
                              score2,
                              style: TextStyle(
                                fontSize: screenWidth * 0.045,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            Text(
                              overs2,
                              style: TextStyle(
                                fontSize: screenWidth * 0.03,
                                color: Color(0xFF64748B),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Status
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.03,
                      vertical: screenHeight * 0.01,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF10B981).withOpacity(0.1),
                          Color(0xFF059669).withOpacity(0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        fontSize: screenWidth * 0.03,
                        color: Color(0xFF059669),
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingMatches() {
    return Column(
      children: [
        _buildSectionHeader('Upcoming Matches', 'View All', () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AllUpcomingMatchesPage()),
          );
        }),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 20),
          itemCount: 2,
          itemBuilder:
              (context, index) => _buildUpcomingMatchCard(
            team1:
            index == 0
                ? 'Mumbai Indians'
                : 'Royal Challengers Bangalore',
            team2:
            index == 0
                ? 'Chennai Super Kings'
                : 'Kolkata Knight Riders',
            team1Short: index == 0 ? 'MI' : 'RCB',
            team2Short: index == 0 ? 'CSK' : 'KKR',
            time: index == 0 ? '2h 30m' : '1 Day 4h',
            contests: index == 0 ? '24 Contests' : '18 Contests',
            prize: index == 0 ? '₹5 Lakhs' : '₹10 Lakhs',
            team1Color: index == 0 ? Color(0xFF3B82F6) : Color(0xFFEF4444),
            team2Color: index == 0 ? Color(0xFFFBBF24) : Color(0xFF8B5CF6),
          ),
        ),
      ],
    );
  }

  Widget _buildUpcomingMatchCard({
    required String team1,
    required String team2,
    required String team1Short,
    required String team2Short,
    required String time,
    required String contests,
    required String prize,
    required Color team1Color,
    required Color team2Color,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF1E293B).withOpacity(0.08),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
        border: Border.all(color: Color(0xFFF1F5F9)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFF8FAFC), Colors.white],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'IPL 2024 • T20',
                      style: TextStyle(
                        color: Color(0xFF3B82F6),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Wankhede Stadium',
                      style: TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    time,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Teams
          Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [team1Color.withOpacity(0.8), team1Color],
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: team1Color.withOpacity(0.3),
                              blurRadius: 12,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            team1Short,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        team1,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E293B),
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),

                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color(0xFFF8FAFC),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    'VS',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF64748B),
                      fontSize: 11,
                    ),
                  ),
                ),

                Expanded(
                  child: Column(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [team2Color.withOpacity(0.8), team2Color],
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: team2Color.withOpacity(0.3),
                              blurRadius: 12,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            team2Short,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        team2,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E293B),
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Prize Section
          // Continuing from where the code was cut off...

          // Prize Section
          Container(
            margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFF8FAFC), Color(0xFFE2E8F0)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Prize Pool',
                      style: TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      prize,
                      style: TextStyle(
                        color: Color(0xFF059669),
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    contests,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceStats() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF1E293B).withOpacity(0.08),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
        border: Border.all(color: Color(0xFFF1F5F9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Your Performance',
                style: TextStyle(
                  color: Color(0xFF0F172A),
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Color(0xFF10B981).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'This Month',
                  style: TextStyle(
                    color: Color(0xFF10B981),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Contests Joined',
                  '12',
                  Icons.emoji_events_rounded,
                  Color(0xFF3B82F6),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Total Winnings',
                  '₹1,200',
                  Icons.account_balance_wallet_rounded,
                  Color(0xFF10B981),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Win Rate',
                  '68%',
                  Icons.trending_up_rounded,
                  Color(0xFFF59E0B),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Best Rank',
                  '#3',
                  Icons.military_tech_rounded,
                  Color(0xFF8B5CF6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String title,
      String value,
      IconData icon,
      Color color,
      ) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              color: Color(0xFF64748B),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: Color(0xFF0F172A),
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
      String title,
      String actionText,
      VoidCallback onTap,
      ) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Color(0xFF0F172A),
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          GestureDetector(
            onTap: onTap,
            child: Text(
              actionText,
              style: TextStyle(
                color: Color(0xFF3B82F6),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumDrawer() {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1E40AF), Color(0xFF3730A3)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white.withOpacity(0.2),
                      child: Icon(Icons.person, color: Colors.white, size: 32),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Welcome User!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Fantasy Cricket Player',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(Icons.person_rounded, 'Profile', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfilePage()),
                  );
                }),
                _buildDrawerItem(
                  Icons.account_balance_wallet_rounded,
                  'Wallet',
                      () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => WalletScreen()),
                    );
                  },
                ),
                _buildDrawerItem(
                  Icons.history_rounded,
                  'Transaction History',
                      () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TransactionHistoryPage(),
                      ),
                    );
                  },
                ),
                _buildDrawerItem(Icons.stars_rounded, 'Fantasy Points', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FantasyPointsPage(),
                    ),
                  );
                }),
                _buildDrawerItem(Icons.share_rounded, 'Referral', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ReferralScreen()),
                  );
                }),
                _buildDrawerItem(Icons.support_agent_rounded, 'Support', () {}),
                _buildDrawerItem(Icons.info_rounded, 'About', () {}),
                Divider(height: 32),
                _buildDrawerItem(Icons.logout_rounded, 'Logout', () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Dream11LoginPage()),
                  );
                }, isDestructive: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
      IconData icon,
      String title,
      VoidCallback onTap, {
        bool isDestructive = false,
      }) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color:
          isDestructive
              ? Color(0xFFEF4444).withOpacity(0.1)
              : Color(0xFF3B82F6).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: isDestructive ? Color(0xFFEF4444) : Color(0xFF3B82F6),
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive ? Color(0xFFEF4444) : Color(0xFF1E293B),
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 4),
    );
  }

  Widget _buildPremiumBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0xFF1E293B).withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home_rounded, 'Home', 0),
              _buildNavItem(Icons.sports_cricket_rounded, 'My Games', 1),
              _buildNavItem(Icons.trending_up_rounded, 'Earnings', 2),
              _buildNavItem(Icons.group_add_rounded, 'Refer', 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient:
          isSelected
              ? LinearGradient(
            colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
          )
              : null,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Color(0xFF64748B),
              size: 20,
            ),
            SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Color(0xFF64748B),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Placeholder classes for navigation - you'll need to create these screens
class AllLiveMatchesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('All Live Matches')),
      body: Center(child: Text('Live Matches Page')),
    );
  }
}

class AllUpcomingMatchesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('All Upcoming Matches')),
      body: Center(child: Text('Upcoming Matches Page')),
    );
  }
}