import 'package:fantasy/drawe_pages/profile.dart';
import 'package:fantasy/body/refral.dart';
import 'package:fantasy/body/tree.dart';
import 'package:fantasy/body/wallet.dart';
import 'package:fantasy/model/fixture.dart'; // Your existing Fixture model
import 'package:fantasy/service/fixture_service.dart';
import 'package:fantasy/service/user_service.dart';
import 'package:fantasy/drawe_pages/fantasy point system.dart';
import 'package:fantasy/drawe_pages/transection_history.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
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

  // API Integration variables from first code
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
    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
    _initializeApp();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
    return 'Welcome User!';
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
        Uri.parse('http://13.232.147.237:3000/'),
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
        Uri.parse('http://13.232.147.237:3000/web-services/fixtures?page=1'),
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
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3B82F6)),
            ),
            SizedBox(height: 16),
            Text(
              'Loading fixtures...',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF64748B),
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
            _buildPremiumBanner(),
            _buildBalanceCard(),
            _buildQuickActions(),

            // Debug info (can be removed in production)
            if (true) // Set to false in production
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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

            _buildLiveMatches(),
            _buildUpcomingMatches(),
            _buildPerformanceStats(),
            SizedBox(height: 100),
          ],
        ),
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
                  '₹0.00',
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
          height: screenHeight * 0.25,
          child: _liveMatches.isNotEmpty
              ? ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 14),
            itemCount: _liveMatches.length,
            itemBuilder: (context, index) => Container(
              width: screenWidth * 0.75,
              margin: EdgeInsets.only(right: 16),
              child: _buildLiveMatchCardFromApi(_liveMatches[index]),
            ),
          )
              : ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 14),
            itemCount: 3,
            itemBuilder: (context, index) => Container(
              width: screenWidth * 0.75,
              margin: EdgeInsets.only(right: 16),
              child: _buildLiveMatchCard(
                team1: index == 0 ? 'India' : index == 1 ? 'England' : 'South Africa',
                team2: index == 0 ? 'Australia' : index == 1 ? 'Pakistan' : 'New Zealand',
                team1Short: index == 0 ? 'IND' : index == 1 ? 'ENG' : 'SA',
                team2Short: index == 0 ? 'AUS' : index == 1 ? 'PAK' : 'NZ',
                score1: index == 0 ? '285/6' : index == 1 ? '195/4' : '220/5',
                score2: index == 0 ? '267/8' : index == 1 ? '180/7' : '205/9',
                overs1: index == 0 ? '(50.0)' : index == 1 ? '(35.2)' : '(45.3)',
                overs2: index == 0 ? '(48.4)' : index == 1 ? '(40.0)' : '(47.2)',
                status: index == 0 ? 'India won by 18 runs' : index == 1 ? 'England won by 15 runs' : 'SA won by 15 runs',
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLiveMatchCardFromApi(FixtureModel match) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: screenWidth * 0.75,
      height: screenHeight * 0.22,
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
          // Live Header
          Container(
            height: screenHeight * 0.05,
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
                          fontSize: screenWidth * 0.028,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  match.matchType,
                  style: TextStyle(
                    color: Color(0xFF059669),
                    fontSize: screenWidth * 0.03,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // Teams and Scores
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
                              match.teamAShort,
                              style: TextStyle(
                                fontSize: screenWidth * 0.04,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.008),
                            Text(
                              'Live',
                              style: TextStyle(
                                fontSize: screenWidth * 0.045,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            Text(
                              'Playing',
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
                              match.teamBShort,
                              style: TextStyle(
                                fontSize: screenWidth * 0.04,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.008),
                            Text(
                              'Live',
                              style: TextStyle(
                                fontSize: screenWidth * 0.045,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            Text(
                              'Playing',
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
                      match.matchTitle,
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
      height: screenHeight * 0.22,
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
          // Live Header
          Container(
            height: screenHeight * 0.05,
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
                          fontSize: screenWidth * 0.028,
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

          // Teams and Scores
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
        _upcomingMatches.isNotEmpty
            ? ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 20),
          itemCount: _upcomingMatches.length,
          itemBuilder: (context, index) => _buildUpcomingMatchCardFromApi(_upcomingMatches[index]),
        )
            : ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 20),
          itemCount: 2,
          itemBuilder: (context, index) => _buildUpcomingMatchCard(
            team1: index == 0 ? 'Mumbai Indians' : 'Royal Challengers Bangalore',
            team2: index == 0 ? 'Chennai Super Kings' : 'Kolkata Knight Riders',
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

  Widget _buildUpcomingMatchCardFromApi(FixtureModel match) {
    final timeLeft = FixtureService.formatTimeLeft(match.matchDate);

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
                      '${match.matchType} • Cricket',
                      style: TextStyle(
                        color: Color(0xFF3B82F6),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      match.matchTitle,
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
                    timeLeft,
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
                            colors: [Colors.blue.withOpacity(0.8), Colors.blue],
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.3),
                              blurRadius: 12,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            match.teamAShort,
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
                        match.teamA,
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
                            colors: [Colors.red.withOpacity(0.8), Colors.red],
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.red.withOpacity(0.3),
                              blurRadius: 12,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            match.teamBShort,
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
                        match.teamB,
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
                      match.matchContest,
                      style: TextStyle(
                        color: Color(0xFF059669),
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: match.lineupOut ? () {
                    _activateFixture(match.id);
                  } : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: match.lineupOut ? Color(0xFF3B82F6) : Color(0xFF94A3B8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: Text(
                    match.lineupOut ? '${match.totalContest} Contests' : 'Lineup Pending',
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