import 'package:fantasy/body/profile.dart';
import 'package:fantasy/body/refral.dart';
import 'package:fantasy/body/tree.dart';
import 'package:fantasy/body/wallet.dart';
import 'package:fantasy/model/fixture.dart'; // Your existing Fixture model
import 'package:fantasy/service/fixture_service.dart';
import 'package:fantasy/service/user_service.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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

  // API Integration variables
  List<FixtureModel> _fixtures = [];
  List<FixtureModel> _liveMatches = [];
  List<FixtureModel> _upcomingMatches = [];
  bool _isLoading = true;
  String? _errorMessage;
  int _currentPage = 1;
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      // Initialize UserService first
      final userService = UserService();
      await userService.initialize();

      // Check authentication status
      _isAuthenticated = await userService.checkLoginStatus();

      if (_isAuthenticated) {
        print('User authenticated with token: ${userService.authToken != null ? userService.authToken!.substring(0, 20) + '...' : 'null'}');
        await _loadFixtures();
      } else {
        // Redirect to login if not authenticated
        _handleAuthenticationRequired();
      }
    } catch (e) {
      print('App initialization error: $e');
      setState(() {
        _errorMessage = 'Failed to initialize app: $e';
        _isLoading = false;
      });
    }
  }

  void _handleAuthenticationRequired() {
    setState(() {
      _isLoading = false;
      _errorMessage = 'Please login to continue';
    });

    // Navigate to login screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const Dream11LoginPage(),
        ),
      );
    });
  }

  Future<void> _loadFixtures() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      // Check authentication status before making API call
      final authStatus = FixtureService.getAuthStatus();
      print('Auth Status: $authStatus');

      if (FixtureService.needsAuthentication()) {
        throw Exception('Authentication required');
      }

      final fixtures = await FixtureService.getFixtures(page: _currentPage);

      setState(() {
        _fixtures = fixtures;
        _liveMatches = FixtureService.filterLiveMatches(fixtures);
        _upcomingMatches = FixtureService.filterUpcomingMatches(fixtures);
        _isLoading = false;
      });

      print('Successfully loaded ${fixtures.length} fixtures');
      print('Live matches: ${_liveMatches.length}');
      print('Upcoming matches: ${_upcomingMatches.length}');

    } catch (e) {
      print('Error loading fixtures: $e');
      setState(() {
        _isLoading = false;
      });

      // Handle authentication errors
      if (e.toString().contains('Authentication required') ||
          e.toString().contains('Authentication failed') ||
          e.toString().contains('401')) {
        _handleAuthenticationRequired();
      } else {
        setState(() {
          _errorMessage = e.toString();
        });
      }
    }
  }

  String _getUserDisplayName() {
    final userService = UserService();
    if (userService.isLoggedIn && userService.userData != null) {
      final userData = userService.userData!;
      return userData['name'] ?? userData['username'] ?? userData['mobile_number'] ?? userData['email'] ?? 'User';
    }
    return 'Guest User';
  }

  Future<void> _handleLogout() async {
    try {
      final userService = UserService();
      await userService.logout();

      // Navigate to login screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const Dream11LoginPage(),
        ),
      );
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logout failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Method to handle fixture activation
  Future<void> _activateFixture(int fixtureId) async {
    try {
      final success = await FixtureService.activateFixture(fixtureId);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fixture activated successfully'),
            backgroundColor: Colors.green,
          ),
        );
        // Reload fixtures to get updated data
        _loadFixtures();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to activate fixture'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('Error activating fixture: $e');
      if (e.toString().contains('Authentication required') ||
          e.toString().contains('Authentication failed')) {
        _handleAuthenticationRequired();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // API connection test method
  Future<void> _testApiConnection() async {
    final userService = UserService();

    print('🧪 Testing API connection...');
    print('Auth status: ${userService.getAuthStatus()}');

    try {
      // Test 1: Check if server is reachable
      print('📡 Testing server connectivity...');
      final pingResponse = await http.get(
        Uri.parse('http://localhost:3000/'),
      ).timeout(Duration(seconds: 5));

      print('✅ Server reachable: ${pingResponse.statusCode}');
    } catch (e) {
      print('❌ Server NOT reachable: $e');
      _showTestResult('Server is not running or not accessible');
      return;
    }

    try {
      // Test 2: Test API with your token
      print('🔑 Testing API with auth token...');
      final token = userService.authToken;

      if (token == null) {
        _showTestResult('No auth token available');
        return;
      }

      print('Token length: ${token.length}');
      print('Token preview: ${token.substring(0, 30)}...');

      final response = await http.get(
        Uri.parse('http://localhost:3000/web-services/fixtures?page=1'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(Duration(seconds: 10));

      print('📥 API Response: ${response.statusCode}');
      print('📥 Response body: ${response.body.substring(0, 100)}...');

      if (response.statusCode == 200) {
        _showTestResult('✅ API working perfectly! The issue was CORS.');
      } else {
        _showTestResult('❌ API returned ${response.statusCode}: ${response.body}');
      }

    } catch (e) {
      print('❌ API Test failed: $e');

      if (e.toString().contains('XMLHttpRequest') || e.toString().contains('CORS')) {
        _showTestResult('❌ CORS Error: Please configure CORS on your server.\n\nAdd this to your Node.js server:\n\nconst cors = require(\'cors\');\napp.use(cors());');
      } else {
        _showTestResult('❌ Network Error: $e');
      }
    }
  }

  void _showTestResult(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('API Test Result'),
        content: SingleChildScrollView(
          child: Text(message),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

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
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1E3A8A)),
            ),
            SizedBox(height: 16),
            Text(
              'Loading fixtures...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
                _errorMessage!.contains('Authentication required') || _errorMessage!.contains('Please login')
                    ? Icons.login
                    : Icons.error_outline,
                size: 64,
                color: _errorMessage!.contains('Authentication required') || _errorMessage!.contains('Please login')
                    ? Colors.blue[400]
                    : Colors.red[400]
            ),
            SizedBox(height: 16),
            Text(
              _errorMessage!.contains('Authentication required') || _errorMessage!.contains('Please login')
                  ? 'Login Required'
                  : 'Error loading matches',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                  _errorMessage!.contains('Authentication required') || _errorMessage!.contains('Please login')
                      ? 'Please login to view cricket matches'
                      : _errorMessage!,
                  textAlign: TextAlign.center
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_errorMessage!.contains('Authentication required') || _errorMessage!.contains('Please login')) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const Dream11LoginPage(),
                    ),
                  );
                } else {
                  _loadFixtures();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _errorMessage!.contains('Authentication required') || _errorMessage!.contains('Please login')
                    ? Color(0xFF3B82F6)
                    : Colors.grey[600],
              ),
              child: Text(
                _errorMessage!.contains('Authentication required') || _errorMessage!.contains('Please login')
                    ? 'Go to Login'
                    : 'Retry',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: _testApiConnection,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: Text('Test API Connection', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadFixtures,
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Debug info (can be removed in production)
            if (true) // Set to false in production
              Container(
                margin: EdgeInsets.all(screenWidth * 0.04),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Debug Info:',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                    Text('Auth Status: ${FixtureService.getAuthStatus()}', style: TextStyle(fontSize: 10)),
                    Text('Fixtures Count: ${_fixtures.length}', style: TextStyle(fontSize: 10)),
                    Text('Live: ${_liveMatches.length}, Upcoming: ${_upcomingMatches.length}', style: TextStyle(fontSize: 10)),
                  ],
                ),
              ),

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

            // Live Matches Section - Show API data if available, fallback to static data
            if (_liveMatches.isNotEmpty) ...[
              _buildSectionHeader('LIVE MATCHES', screenWidth, isTablet),
              ..._liveMatches.map((match) => _buildLiveMatchCardFromApi(match, screenWidth, isTablet)),
            ] else if (_fixtures.isEmpty && !_isLoading) ...[
              // Fallback to static data if no API data available
              _buildSectionHeader('LIVE MATCHES', screenWidth, isTablet),
              _buildStaticLiveMatchCard(screenWidth, isTablet),
            ],

            // Upcoming Matches Section - Show API data if available, fallback to static data
            _buildSectionHeader('UPCOMING MATCHES', screenWidth, isTablet),
            if (_upcomingMatches.isEmpty && _fixtures.isEmpty && !_isLoading) ...[
              // Fallback to static data if no API data available
              _buildStaticUpcomingMatchCard(screenWidth, isTablet, 'Mumbai Indians', 'MI', Colors.blue[800], 'Chennai Super Kings', 'CSK', Colors.yellow[700], 'IPL 2025', '2h 30m', '24 Contests', '₹5 Lakhs'),
              _buildStaticUpcomingMatchCard(screenWidth, isTablet, 'India', 'IND', Colors.blue[900], 'England', 'ENG', Colors.red[700], 'Test Match - Day 1', '1 Day', '18 Contests', '₹10 Lakhs'),
            ] else if (_upcomingMatches.isEmpty)
              Container(
                margin: EdgeInsets.all(screenWidth * 0.04),
                padding: EdgeInsets.all(screenWidth * 0.08),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.sports_cricket, size: 48, color: Colors.grey[400]),
                      SizedBox(height: 16),
                      Text(
                        'No upcoming matches',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              ..._upcomingMatches.map((match) => _buildUpcomingMatchCardFromApi(match, screenWidth, isTablet)),

            // Quick Stats
            _buildQuickStats(screenWidth, screenHeight, isTablet),

            SizedBox(height: screenHeight * 0.02),
          ],
        ),
      ),
    );
  }

  // Static fallback live match card
  Widget _buildStaticLiveMatchCard(double screenWidth, bool isTablet) {
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
                    'ODI - 3rd Match',
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
              _buildTeamScore('India', '🇮🇳', '285/6', screenWidth, isTablet),
              Text(
                'VS',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isTablet ? 18 : 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              _buildTeamScore('Australia', '🇦🇺', '267/8', screenWidth, isTablet),
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
              'India won by 18 runs',
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

  // Static fallback upcoming match card
  Widget _buildStaticUpcomingMatchCard(
      double screenWidth,
      bool isTablet,
      String team1,
      String team1Logo,
      Color? team1Color,
      String team2,
      String team2Logo,
      Color? team2Color,
      String matchType,
      String timeLeft,
      String contestCount,
      String prizeMoney
      ) {
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
                      color: Colors.white,
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

  Widget _buildLiveMatchCardFromApi(FixtureModel match, double screenWidth, bool isTablet) {
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
                    match.matchType,
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
              _buildApiTeamScore(
                match.teamA,
                match.teamAFlag ?? FixtureService.getTeamFlag(match.teamA),
                'Live',
                screenWidth,
                isTablet,
              ),
              Text(
                'VS',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isTablet ? 18 : 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              _buildApiTeamScore(
                match.teamB,
                match.teamBFlag ?? FixtureService.getTeamFlag(match.teamB),
                'Live',
                screenWidth,
                isTablet,
              ),
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
              match.matchTitle,
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

  Widget _buildUpcomingMatchCardFromApi(FixtureModel match, double screenWidth, bool isTablet) {
    final timeLeft = FixtureService.formatTimeLeft(match.matchDate);

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
                Expanded(
                  child: Text(
                    match.matchType,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: isTablet ? 14 : 12,
                      fontWeight: FontWeight.w600,
                    ),
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
                _buildApiTeamLogo(
                    match.teamA,
                    match.teamAShort,
                    Colors.blue[800],
                    screenWidth,
                    isTablet
                ),
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
                _buildApiTeamLogo(
                    match.teamB,
                    match.teamBShort,
                    Colors.red[800],
                    screenWidth,
                    isTablet
                ),
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
                          match.matchContest,
                          style: TextStyle(
                            color: Colors.grey[900],
                            fontSize: isTablet ? 16 : 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${match.totalContest} Contests',
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
                  onPressed: match.lineupOut ? () {
                    // Navigate to contest selection or activate fixture
                    _activateFixture(match.id);
                  } : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: match.lineupOut ? Color(0xFF3B82F6) : Colors.grey[400],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.04,
                      vertical: screenWidth * 0.025,
                    ),
                  ),
                  child: Text(
                    match.lineupOut ? 'JOIN NOW' : 'LINEUP PENDING',
                    style: TextStyle(
                      fontSize: isTablet ? 14 : 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
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

  Widget _buildApiTeamScore(String team, String flag, String score, double screenWidth, bool isTablet) {
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

  Widget _buildApiTeamLogo(String team, String logo, Color? color, double screenWidth, bool isTablet) {
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
                    // Profile Picture with Tap Gesture
                    GestureDetector(
                      onTap: () {
                        // Navigate to profile page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfilePage(),
                          ),
                        );
                      },
                      child: Stack(
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
                    ),
                    SizedBox(height: screenHeight * 0.015),
                    // User Name - Use dynamic name
                    Text(
                      _getUserDisplayName(),
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
                  onTap: _handleLogout,
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