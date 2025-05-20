
import 'package:fantasy/body/refral.dart';
import 'package:fantasy/body/tree.dart';
import 'package:fantasy/body/wallet.dart';
import 'package:flutter/material.dart';
import 'login.dart';
import 'mygame.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenHeight = screenSize.height;
    final double screenWidth = screenSize.width;
    final bool isTablet = screenWidth > 600;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[50],
      appBar: _buildPremiumAppBar(screenWidth, isTablet),
      drawer: _buildDrawer(),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildCricketHomeScreen(screenHeight, screenWidth, isTablet),
          MyMatchesScreen(),
          EarningsDashboard(),
          ReferralScreen(),
          _buildGamesScreen(),
        ],
      ),
      bottomNavigationBar: _buildPremiumBottomNav(isTablet),
    );
  }

  AppBar _buildPremiumAppBar(double screenWidth, bool isTablet) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: GestureDetector(
        onTap: () => _scaffoldKey.currentState?.openDrawer(),
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.02),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF1E3A8A).withOpacity(0.3),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Icon(Icons.menu, color: Colors.white, size: isTablet ? 26 : 22),
          ),
        ),
      ),
      title: Row(
        children: [
          Image.asset(
            'assets/images/app_logo.png',
            height: isTablet ? 28 : 24,
            errorBuilder: (context, error, stackTrace) {
              return Row(
                children: [
                  Icon(Icons.sports_cricket, color: Color(0xFF1E3A8A), size: isTablet ? 24 : 20),
                  SizedBox(width: 8),
                  Text(
                    'FANTASY',
                    style: TextStyle(
                      color: Color(0xFF1E3A8A),
                      fontWeight: FontWeight.bold,
                      fontSize: isTablet ? 18 : 16,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      actions: [
        Stack(
          alignment: Alignment.topRight,
          children: [
            IconButton(
              icon: Container(
                padding: EdgeInsets.all(screenWidth * 0.015),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.notifications_outlined,
                  color: Colors.grey[700],
                  size: isTablet ? 24 : 22,
                ),
              ),
              onPressed: () {},
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.red[600],
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                constraints: BoxConstraints(
                  minWidth: 18,
                  minHeight: 18,
                ),
                child: Center(
                  child: Text(
                    '4',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(right: screenWidth * 0.04),
          child: IconButton(
            icon: Container(
              padding: EdgeInsets.all(screenWidth * 0.015),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green[600]!, Colors.green[700]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.account_balance_wallet_outlined,
                color: Colors.white,
                size: isTablet ? 24 : 22,
              ),
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

  Widget _buildCricketHomeScreen(double screenHeight, double screenWidth, bool isTablet) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Premium Cricket Banner
          Container(
            height: screenHeight * 0.18,
            width: double.infinity,
            margin: EdgeInsets.all(screenWidth * 0.04),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.3),
                  blurRadius: 15,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Cricket illustration
                Positioned(
                  right: -20,
                  bottom: -20,
                  child: Transform.rotate(
                    angle: -0.2,
                    child: Icon(
                      Icons.sports_cricket,
                      size: screenWidth * 0.3,
                      color: Colors.white.withOpacity(0.1),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(screenWidth * 0.04),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'CRICKET FANTASY',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isTablet ? 14 : 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 2,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Text(
                        'Play & Win Big',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isTablet ? 28 : 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Text(
                        'Join the ultimate cricket fantasy experience',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: isTablet ? 16 : 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Contest Categories
          _buildContestCategories(screenWidth, isTablet),

          // Live Matches Section
          _buildSectionHeader('LIVE MATCHES', screenWidth, isTablet),
          _buildLiveMatchCard(
            team1: 'India',
            team1Flag: '🇮🇳',
            team1Score: '285/6',
            team2: 'Australia',
            team2Flag: '🇦🇺',
            team2Score: '267/8',
            matchType: 'ODI - 3rd Match',
            status: 'India won by 18 runs',
            screenWidth: screenWidth,
            isTablet: isTablet,
          ),

          // Upcoming Matches Section
          _buildSectionHeader('UPCOMING MATCHES', screenWidth, isTablet),
          _buildUpcomingMatchCard(
            team1: 'Mumbai Indians',
            team1Logo: 'MI',
            team1Color: Colors.blue[800],
            team2: 'Chennai Super Kings',
            team2Logo: 'CSK',
            team2Color: Colors.yellow[700],
            matchType: 'IPL 2025',
            timeLeft: '2h 30m',
            contestCount: '24 Contests',
            prizeMoney: '₹5 Lakhs',
            screenWidth: screenWidth,
            isTablet: isTablet,
          ),
          _buildUpcomingMatchCard(
            team1: 'India',
            team1Logo: 'IND',
            team1Color: Colors.blue[900],
            team2: 'England',
            team2Logo: 'ENG',
            team2Color: Colors.red[700],
            matchType: 'Test Match - Day 1',
            timeLeft: '1 Day',
            contestCount: '18 Contests',
            prizeMoney: '₹10 Lakhs',
            screenWidth: screenWidth,
            isTablet: isTablet,
          ),

          // Quick Stats
          _buildQuickStats(screenWidth, screenHeight, isTablet),

          SizedBox(height: screenHeight * 0.02),
        ],
      ),
    );
  }

  Widget _buildContestCategories(double screenWidth, bool isTablet) {
    final categories = [
      {'icon': Icons.flash_on, 'title': 'Quick', 'color': Colors.orange},
      {'icon': Icons.emoji_events, 'title': 'Mega', 'color': Colors.amber},
      {'icon': Icons.star, 'title': 'Premium', 'color': Colors.purple},
      {'icon': Icons.group, 'title': 'Head2Head', 'color': Colors.blue},
    ];

    return Container(
      height: isTablet ? 100 : 90,
      margin: EdgeInsets.symmetric(vertical: screenWidth * 0.02),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return Container(
            width: screenWidth * 0.22,
            margin: EdgeInsets.only(right: screenWidth * 0.03),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(screenWidth * 0.025),
                  decoration: BoxDecoration(
                    color: (category['color'] as Color).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    category['icon'] as IconData,
                    color: category['color'] as Color,
                    size: isTablet ? 28 : 24,
                  ),
                ),
                SizedBox(height: screenWidth * 0.02),
                Text(
                  category['title'] as String,
                  style: TextStyle(
                    fontSize: isTablet ? 14 : 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title, double screenWidth, bool isTablet) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: screenWidth * 0.03,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.grey[800],
              fontSize: isTablet ? 18 : 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          Text(
            'View All',
            style: TextStyle(
              color: Color(0xFF3B82F6),
              fontSize: isTablet ? 14 : 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveMatchCard({
    required String team1,
    required String team1Flag,
    required String team1Score,
    required String team2,
    required String team2Flag,
    required String team2Score,
    required String matchType,
    required String status,
    required double screenWidth,
    required bool isTablet,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: screenWidth * 0.02),
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green[700]!, Colors.green[900]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.3),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.circle, size: 8, color: Colors.white),
                        SizedBox(width: 4),
                        Text(
                          'LIVE',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isTablet ? 12 : 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    matchType,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: isTablet ? 14 : 12,
                    ),
                  ),
                ],
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 16),
            ],
          ),
          SizedBox(height: screenWidth * 0.04),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildTeamScore(team1, team1Flag, team1Score, screenWidth, isTablet),
              Text(
                'VS',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isTablet ? 18 : 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              _buildTeamScore(team2, team2Flag, team2Score, screenWidth, isTablet),
            ],
          ),
          SizedBox(height: screenWidth * 0.04),
          Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: Colors.white,
                fontSize: isTablet ? 14 : 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamScore(String team, String flag, String score, double screenWidth, bool isTablet) {
    return Column(
      children: [
        Text(
          flag,
          style: TextStyle(fontSize: isTablet ? 36 : 32),
        ),
        SizedBox(height: 4),
        Text(
          team,
          style: TextStyle(
            color: Colors.white,
            fontSize: isTablet ? 16 : 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          score,
          style: TextStyle(
            color: Colors.white,
            fontSize: isTablet ? 20 : 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildUpcomingMatchCard({
    required String team1,
    required String team1Logo,
    required Color? team1Color,
    required String team2,
    required String team2Logo,
    required Color? team2Color,
    required String matchType,
    required String timeLeft,
    required String contestCount,
    required String prizeMoney,
    required double screenWidth,
    required bool isTablet,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: screenWidth * 0.02),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          // Match Type Header
          Container(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: screenWidth * 0.03),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  matchType,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: isTablet ? 14 : 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.red[200]!),
                  ),
                  child: Text(
                    timeLeft,
                    style: TextStyle(
                      color: Colors.red[700],
                      fontSize: isTablet ? 12 : 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Teams
          Padding(
            padding: EdgeInsets.all(screenWidth * 0.04),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTeamLogo(team1, team1Logo, team1Color, screenWidth, isTablet),
                Column(
                  children: [
                    Text(
                      'VS',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: isTablet ? 16 : 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Icon(Icons.sports_cricket, color: Colors.grey[400], size: 20),
                  ],
                ),
                _buildTeamLogo(team2, team2Logo, team2Color, screenWidth, isTablet),
              ],
            ),
          ),

          // Contest Info
          Container(
            padding: EdgeInsets.all(screenWidth * 0.04),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.emoji_events, color: Colors.amber[700], size: isTablet ? 20 : 18),
                    SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          prizeMoney,
                          style: TextStyle(
                            color: Colors.grey[900],
                            fontSize: isTablet ? 16 : 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          contestCount,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: isTablet ? 12 : 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF3B82F6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.04,
                      vertical: screenWidth * 0.025,
                    ),
                  ),
                  child: Text(
                    'JOIN NOW',
                    style: TextStyle(
                      fontSize: isTablet ? 14 : 12,
                      fontWeight: FontWeight.bold,
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

  Widget _buildTeamLogo(String team, String logo, Color? color, double screenWidth, bool isTablet) {
    return Column(
      children: [
        Container(
          width: isTablet ? 80 : 70,
          height: isTablet ? 80 : 70,
          decoration: BoxDecoration(
            color: color?.withOpacity(0.1) ?? Colors.grey[100],
            shape: BoxShape.circle,
            border: Border.all(color: color ?? Colors.grey[300]!, width: 2),
          ),
          child: Center(
            child: Text(
              logo,
              style: TextStyle(
                color: color ?? Colors.grey[700],
                fontSize: isTablet ? 28 : 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(
          team,
          style: TextStyle(
            color: Colors.grey[800],
            fontSize: isTablet ? 14 : 12,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildQuickStats(double screenWidth, double screenHeight, bool isTablet) {
    return Container(
      margin: EdgeInsets.all(screenWidth * 0.04),
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'YOUR STATS',
            style: TextStyle(
              color: Colors.grey[800],
              fontSize: isTablet ? 16 : 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: screenHeight * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('Matches', '0', Icons.sports_cricket, Colors.blue, screenWidth, isTablet),
              _buildStatItem('Wins', '0', Icons.emoji_events, Colors.amber, screenWidth, isTablet),
              _buildStatItem('Win Rate', '0%', Icons.trending_up, Colors.green, screenWidth, isTablet),
              _buildStatItem('Total Won', '₹0', Icons.currency_rupee, Colors.purple, screenWidth, isTablet),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color, double screenWidth, bool isTablet) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(screenWidth * 0.025),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: isTablet ? 24 : 20),
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: isTablet ? 18 : 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey[900],
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: isTablet ? 12 : 11,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildPremiumBottomNav(bool isTablet) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Color(0xFF3B82F6),
        unselectedItemColor: Colors.grey[500],
        selectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: isTablet ? 12 : 11,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: isTablet ? 12 : 11,
        ),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Color(0xFF3B82F6).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.home, size: isTablet ? 24 : 22),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events_outlined),
            activeIcon: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Color(0xFF3B82F6).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.emoji_events, size: isTablet ? 24 : 22),
            ),
            label: 'My Matches',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard_outlined),
            activeIcon: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Color(0xFF3B82F6).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.card_giftcard, size: isTablet ? 24 : 22),
            ),
            label: 'Rewards',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            activeIcon: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Color(0xFF3B82F6).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.people, size: isTablet ? 24 : 22),
            ),
            label: 'Refer & Win',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_outlined),
            activeIcon: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Color(0xFF3B82F6).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.grid_view, size: isTablet ? 24 : 22),
            ),
            label: 'Games',
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;
    final bool isTablet = screenWidth > 600;

    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          // Profile Header with Premium Gradient
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1E3A8A), Color(0xFF1E293B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(screenWidth * 0.04),
                child: Column(
                  children: [
                    // Profile Picture
                    Stack(
                      children: [
                        Container(
                          width: isTablet ? 90 : 80,
                          height: isTablet ? 90 : 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white.withOpacity(0.3), width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 15,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.person,
                              size: isTablet ? 50 : 40,
                              color: Color(0xFF1E3A8A),
                            ),
                          ),
                        ),
                        // Premium Badge
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.amber[600]!, Colors.amber[800]!],
                              ),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: Icon(
                              Icons.star,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.015),
                    // User Name
                    Text(
                      'pll3mu1',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isTablet ? 22 : 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.005),
                    // User Status
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.04,
                        vertical: screenHeight * 0.008,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withOpacity(0.2)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.diamond_outlined,
                            color: Colors.amber[300],
                            size: isTablet ? 18 : 16,
                          ),
                          SizedBox(width: screenWidth * 0.02),
                          Text(
                            'Premium Member',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isTablet ? 14 : 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Wallet Card
          Container(
            margin: EdgeInsets.all(screenWidth * 0.04),
            padding: EdgeInsets.all(screenWidth * 0.04),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF312E81), Color(0xFF1E293B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF312E81).withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Wallet Balance',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: isTablet ? 14 : 12,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '₹ 0.00',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isTablet ? 24 : 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.add_circle_outline,
                    color: Colors.white,
                    size: isTablet ? 28 : 24,
                  ),
                ),
              ],
            ),
          ),

          // Menu Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04,
              ),
              children: [
                _buildDrawerMenuItem(
                  icon: Icons.person_outline,
                  title: 'My Profile',
                  onTap: () {},
                  screenWidth: screenWidth,
                  isTablet: isTablet,
                ),
                _buildDrawerMenuItem(
                  icon: Icons.emoji_events_outlined,
                  title: 'My Contests',
                  onTap: () {},
                  screenWidth: screenWidth,
                  isTablet: isTablet,
                ),

                Divider(height: 1, color: Colors.grey[200]),

                _buildDrawerMenuItem(
                  icon: Icons.card_giftcard_outlined,
                  title: 'Refer & Earn',
                  subtitle: 'Get ₹100 per referral',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ReferralScreen(),
                      ),
                    );
                  },
                  screenWidth: screenWidth,
                  isTablet: isTablet,
                  hasHighlight: true,
                ),
                _buildDrawerMenuItem(
                  icon: Icons.receipt_long_outlined,
                  title: 'Transaction History',
                  onTap: () {},
                  screenWidth: screenWidth,
                  isTablet: isTablet,
                ),

                Divider(height: 1, color: Colors.grey[200]),

                _buildDrawerMenuItem(
                  icon: Icons.sports_cricket_outlined,
                  title: 'Fantasy Point System',
                  onTap: () {},
                  screenWidth: screenWidth,
                  isTablet: isTablet,
                ),
                _buildDrawerMenuItem(
                  icon: Icons.play_circle_outline,
                  title: 'How to Play',
                  onTap: () {},
                  screenWidth: screenWidth,
                  isTablet: isTablet,
                ),

                Divider(height: 1, color: Colors.grey[200]),

                _buildDrawerMenuItem(
                  icon: Icons.headset_mic_outlined,
                  title: 'Help & Support',
                  onTap: () {},
                  screenWidth: screenWidth,
                  isTablet: isTablet,
                ),
                _buildDrawerMenuItem(
                  icon: Icons.shield_outlined,
                  title: 'Responsible Play',
                  onTap: () {},
                  screenWidth: screenWidth,
                  isTablet: isTablet,
                ),
                _buildDrawerMenuItem(
                  icon: Icons.info_outline,
                  title: 'About Us',
                  onTap: () {},
                  screenWidth: screenWidth,
                  isTablet: isTablet,
                ),
                _buildDrawerMenuItem(
                  icon: Icons.description_outlined,
                  title: 'Terms & Conditions',
                  onTap: () {},
                  screenWidth: screenWidth,
                  isTablet: isTablet,
                ),

                SizedBox(height: screenHeight * 0.03),

                // Settings and Logout
                _buildDrawerMenuItem(
                  icon: Icons.settings_outlined,
                  title: 'Settings',
                  onTap: () {},
                  screenWidth: screenWidth,
                  isTablet: isTablet,
                ),
                _buildDrawerMenuItem(
                  icon: Icons.logout,
                  title: 'Logout',
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const Dream11LoginPage(),
                      ),
                    );
                  },
                  screenWidth: screenWidth,
                  isTablet: isTablet,
                  isLogout: true,
                ),

                SizedBox(height: screenHeight * 0.02),
              ],
            ),
          ),

          // Footer
          Container(
            padding: EdgeInsets.all(screenWidth * 0.04),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              border: Border(
                top: BorderSide(color: Colors.grey[200]!),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.sports_cricket,
                  color: Color(0xFF1E3A8A),
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  'Fantasy Cricket',
                  style: TextStyle(
                    color: Color(0xFF1E3A8A),
                    fontSize: isTablet ? 14 : 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  width: 1,
                  height: 16,
                  color: Colors.grey[300],
                ),
                SizedBox(width: 8),
                Text(
                  'v1.0.0',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: isTablet ? 12 : 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerMenuItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    required double screenWidth,
    required bool isTablet,
    bool hasHighlight = false,
    bool isLogout = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.02,
            vertical: screenWidth * 0.035,
          ),
          decoration: BoxDecoration(
            color: hasHighlight ? Color(0xFFEFF6FF) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Container(
                width: isTablet ? 42 : 38,
                height: isTablet ? 42 : 38,
                decoration: BoxDecoration(
                  gradient: hasHighlight
                      ? LinearGradient(
                    colors: [Color(0xFF3B82F6), Color(0xFF1E40AF)],
                  )
                      : null,
                  color: !hasHighlight ? (isLogout ? Colors.red[50] : Colors.grey[100]) : null,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: hasHighlight
                      ? Colors.white
                      : (isLogout ? Colors.red[600] : Color(0xFF475569)),
                  size: isTablet ? 22 : 20,
                ),
              ),
              SizedBox(width: screenWidth * 0.04),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: isLogout ? Colors.red[600] : Colors.black87,
                        fontSize: isTablet ? 16 : 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (subtitle != null) ...[
                      SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: hasHighlight ? Color(0xFF3B82F6) : Colors.grey[600],
                          fontSize: isTablet ? 12 : 11,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Colors.grey[400],
                size: isTablet ? 22 : 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGamesScreen() {
    return const Center(
      child: Text(
        'Games Screen',
        style: TextStyle(color: Colors.black87, fontSize: 24),
      ),
    );
  }
}