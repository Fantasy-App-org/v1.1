import 'package:fantasy/drawe_pages/about_us.dart';
import 'package:fantasy/drawe_pages/profile.dart';
import 'package:fantasy/body/refral.dart';
import 'package:fantasy/body/tree.dart';
import 'package:fantasy/body/wallet.dart';
import 'package:fantasy/model/fixture.dart';
import 'package:fantasy/service/fixture_service.dart';
import 'package:fantasy/service/user_service.dart';
import 'package:fantasy/drawe_pages/fantasy point system.dart';
import 'package:fantasy/drawe_pages/transection_history.dart';
import 'package:fantasy/drawe_pages/FAQ.dart';
import 'package:fantasy/drawe_pages/Legality_pages.dart';
import 'package:fantasy/drawe_pages/how_to_play.dart';
import 'package:fantasy/team_creation/contest_all_pages.dart';
import 'package:fantasy/team_creation/creat team.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'login.dart';
import 'mygame.dart';
import 'package:fantasy/config/debug_config.dart';

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

  // API Integration variables
  List<FixtureModel> _fixtures = [];
  List<FixtureModel> _liveMatches = [];
  List<FixtureModel> _upcomingMatches = [];
  bool _isLoading = true;
  String? _errorMessage;
  int _currentPage = 1;
  bool _isAuthenticated = false;

  // Dynamic data variables
  int _notificationCount = 0;
  double _walletBalance = 0.0;
  Map<String, dynamic> _userStats = {
    'matches': 0,
    'wins': 0,
    'winRate': 0.0,
    'totalWon': 0.0,
    'contestsJoined': 0,
    'bestRank': 0,
  };
  String _appVersion = '';
  String _referralBonus = '';
  bool _isPremiumUser = false;
  String _userName = 'Guest User';

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
      DebugConfig.debugPrint('Initializing app...');

      // Check if we should use mock authentication
      if (DebugConfig.isDebugMode && DebugConfig.isDesktop) {
        DebugConfig.debugPrint('Using mock authentication for desktop debugging');
        _isAuthenticated = true;
        await DebugConfig.mockDelay();

        await Future.wait([
          _loadFixtures(),
          _loadUserData(),
          _loadAppConfig(),
        ]);
        return;
      }

      // Original authentication logic for mobile/production
      if (DebugConfig.enableAuthentication) {
        final userService = UserService();
        await userService.initialize();
        _isAuthenticated = await userService.checkLoginStatus();

        if (_isAuthenticated) {
          await Future.wait([
            _loadFixtures(),
            _loadUserData(),
            _loadAppConfig(),
          ]);
        } else {
          _handleAuthenticationRequired();
        }
      } else {
        throw Exception('Authentication disabled in debug mode');
      }
    } catch (e) {
      DebugConfig.debugPrint('App initialization error: $e');
      setState(() {
        _errorMessage = 'Failed to initialize app: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _loadUserData() async {
    try {
      if (DebugConfig.isDebugMode && DebugConfig.isDesktop) {
        DebugConfig.debugPrint('Loading mock user data');
        final userData = DebugConfig.mockUserData;

        setState(() {
          _userName = userData['name'] ?? 'Debug User';
          _walletBalance = double.tryParse(userData['wallet_balance']?.toString() ?? '0') ?? 1250.50;
          _notificationCount = int.tryParse(userData['notification_count']?.toString() ?? '0') ?? 3;
          _isPremiumUser = userData['is_premium'] ?? false;

          _userStats = {
            'matches': userData['total_matches'] ?? 45,
            'wins': userData['total_wins'] ?? 12,
            'winRate': userData['win_rate'] ?? 26.7,
            'totalWon': double.tryParse(userData['total_earnings']?.toString() ?? '0') ?? 5420.75,
            'contestsJoined': userData['contests_joined'] ?? 78,
            'bestRank': userData['best_rank'] ?? 3,
          };
        });
        return;
      }
      final userService = UserService();
      if (userService.isLoggedIn && userService.userData != null) {
        final userData = userService.userData!;

        setState(() {
          _userName = userData['name'] ?? userData['username'] ?? userData['mobile_number'] ?? userData['email'] ?? 'User';
          _walletBalance = double.tryParse(userData['wallet_balance']?.toString() ?? '0') ?? 0.0;
          _notificationCount = int.tryParse(userData['notification_count']?.toString() ?? '0') ?? 0;
          _isPremiumUser = userData['is_premium'] ?? false;

          _userStats = {
            'matches': userData['total_matches'] ?? 0,
            'wins': userData['total_wins'] ?? 0,
            'winRate': userData['win_rate'] ?? 0.0,
            'totalWon': double.tryParse(userData['total_earnings']?.toString() ?? '0') ?? 0.0,
            'contestsJoined': userData['contests_joined'] ?? 0,
            'bestRank': userData['best_rank'] ?? 0,
          };
        });
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  Future<void> _loadAppConfig() async {
    try {
      setState(() {
        _appVersion = 'v1.2.0';
        _referralBonus = '₹150';
      });
    } catch (e) {
      print('Error loading app config: $e');
    }
  }

  void _handleAuthenticationRequired() {
    setState(() {
      _isLoading = false;
      _errorMessage = 'Please login to continue';
    });

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

      if (DebugConfig.isDebugMode && DebugConfig.isDesktop) {
        DebugConfig.debugPrint('Loading mock fixtures data');
        await DebugConfig.mockDelay();

        // Convert mock data to FixtureModel objects
        _fixtures = DebugConfig.mockFixtures.map((data) => FixtureModel.fromJson(data)).toList();
        _liveMatches = _fixtures.where((f) => f.status == 'live').toList();
        _upcomingMatches = _fixtures.where((f) => f.status == 'upcoming').toList();

        setState(() {
          _isLoading = false;
        });

        DebugConfig.debugPrint('Mock fixtures loaded: ${_fixtures.length} total, ${_liveMatches.length} live, ${_upcomingMatches.length} upcoming');
        return;
      }

      // Only make real API calls if enabled
      if (!DebugConfig.enableApiCalls) {
        throw Exception('API calls disabled in debug mode');
      }

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

  Future<void> _handleLogout() async {
    try {
      final userService = UserService();
      await userService.logout();

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const Dream11LoginPage(),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logout failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _activateFixture(int fixtureId) async {
    if (!DebugConfig.enableApiCalls) {
      DebugConfig.debugPrint('Mock fixture activation for ID: $fixtureId');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Mock fixture activated (debug mode)'),
          backgroundColor: Colors.green,
        ),
      );
      return;
    }
    try {
      final success = await FixtureService.activateFixture(fixtureId);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fixture activated successfully'),
            backgroundColor: Colors.green,
          ),
        );
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

  // Handle upcoming match tap - Enhanced from second file
  void _handleUpcomingMatchTap(String team1, String team2, String matchId) {
    // Navigate to team creation page
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FantasyCricketPage()),
    );
  }

  Future<void> _testApiConnection() async {
    if (!DebugConfig.enableNetworkFeatures) {
      _showTestResult('⚠️ Network features disabled in debug mode.\n\nThis is expected behavior when running on desktop during development.');
      return;
    }

    final userService = UserService();

    print('🧪 Testing API connection...');
    print('Auth status: ${userService.getAuthStatus()}');

    try {
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
                'STAR 25 PRO',
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
                if (_notificationCount > 0)
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
                        _notificationCount > 99 ? '99+' : _notificationCount.toString(),
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
              'Loading your dashboard...',
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
                  : 'Error loading data',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                  _errorMessage!.contains('Authentication required') || _errorMessage!.contains('Please login')
                      ? 'Please login to access your dashboard'
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
                backgroundColor: Color(0xFF3B82F6),
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
      onRefresh: () async {
        await Future.wait([
          _loadFixtures(),
          _loadUserData(),
        ]);
      },
      child: SingleChildScrollView(
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
                          'Welcome Back, ${_userName.split(' ').first}! 👋',
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
                    '🏆 Join upcoming matches and win big!',
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
                  '₹${_walletBalance.toStringAsFixed(2)}',
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
        if (_liveMatches.isEmpty && !_isLoading)
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            padding: EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Color(0xFFF1F5F9)),
            ),
            child: Center(
              child: Column(
                children: [
                  Icon(Icons.sports_cricket, size: 48, color: Color(0xFF64748B)),
                  SizedBox(height: 16),
                  Text(
                    'No live matches',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF64748B),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          )
        else if (_liveMatches.isNotEmpty)
          SizedBox(
            height: screenHeight * 0.25,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 14),
              itemCount: _liveMatches.length,
              itemBuilder: (context, index) {
                final match = _liveMatches[index];
                return Container(
                  width: screenWidth * 0.75,
                  margin: EdgeInsets.only(right: 16),
                  child: _buildLiveMatchCard(
                    team1: match.teamA,
                    team2: match.teamB,
                    team1Short: match.teamAShort,
                    team2Short: match.teamBShort,
                    score1: 'Live',
                    score2: 'Live',
                    overs1: '',
                    overs2: '',
                    status: match.matchTitle,
                  ),
                );
              },
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
                  'Cricket Match',
                  style: TextStyle(
                    color: Color(0xFF059669),
                    fontSize: screenWidth * 0.03,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.04),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
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
                            if (overs1.isNotEmpty)
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
                            if (overs2.isNotEmpty)
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
        if (_upcomingMatches.isEmpty && !_isLoading)
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            padding: EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Color(0xFFF1F5F9)),
            ),
            child: Center(
              child: Column(
                children: [
                  Icon(Icons.schedule, size: 48, color: Color(0xFF64748B)),
                  SizedBox(height: 16),
                  Text(
                    'No upcoming matches',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF64748B),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          )
        else if (_upcomingMatches.isNotEmpty)
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 20),
            itemCount: _upcomingMatches.take(3).length,
            itemBuilder: (context, index) {
              final match = _upcomingMatches[index];
              final timeLeft = FixtureService.formatTimeLeft(match.matchDate);
              return GestureDetector(
                onTap: () => _handleUpcomingMatchTap(
                  match.teamA,
                  match.teamB,
                  'match_${match.id}',
                ),
                child: _buildUpcomingMatchCard(
                  team1: match.teamA,
                  team2: match.teamB,
                  team1Short: match.teamAShort,
                  team2Short: match.teamBShort,
                  time: timeLeft,
                  contests: '${match.totalContest} Contests',
                  prize: match.matchContest,
                  team1Color: Color(0xFF3B82F6),
                  team2Color: Color(0xFFEF4444),
                  match: match,
                ),
              );
            },
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
    required FixtureModel match,
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
                      match.matchType,
                      style: TextStyle(
                        color: Color(0xFF3B82F6),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Cricket Match',
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
                GestureDetector(
                  onTap: match.lineupOut ? () => _activateFixture(match.id) : null,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: match.lineupOut
                          ? LinearGradient(colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)])
                          : null,
                      color: match.lineupOut ? null : Color(0xFF64748B),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      match.lineupOut ? contests : 'Lineup Pending',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
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
                  _userStats['contestsJoined'].toString(),
                  Icons.emoji_events_rounded,
                  Color(0xFF3B82F6),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Total Winnings',
                  '₹${_userStats['totalWon'].toStringAsFixed(0)}',
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
                  '${_userStats['winRate'].toStringAsFixed(1)}%',
                  Icons.trending_up_rounded,
                  Color(0xFFF59E0B),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Best Rank',
                  _userStats['bestRank'] > 0 ? '#${_userStats['bestRank']}' : 'N/A',
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

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
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

  Widget _buildSectionHeader(String title, String actionText, VoidCallback onTap) {
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
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
            child: Container(
              height: 280,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF667eea),
                    Color(0xFF764ba2),
                    Color(0xFF667eea),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0.0, 0.5, 1.0],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: -50,
                    right: -50,
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 30,
                    right: 20,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.05),
                      ),
                    ),
                  ),
                  SafeArea(
                    child: Padding(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      blurRadius: 15,
                                      offset: Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: CircleAvatar(
                                  radius: 35,
                                  backgroundColor: Colors.white,
                                  child: CircleAvatar(
                                    radius: 32,
                                    backgroundColor: Color(0xFF4F46E5),
                                    child: Text(
                                      _userName.isNotEmpty ? _userName.substring(0, 1).toUpperCase() : 'U',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              if (_isPremiumUser)
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [Colors.amber[600]!, Colors.amber[800]!],
                                      ),
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white, width: 2),
                                    ),
                                    child: Icon(Icons.star, size: 12, color: Colors.white),
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Welcome $_userName!',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            _isPremiumUser ? 'Premium Player' : 'Fantasy Cricket Player',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 8),
                          if (_isPremiumUser)
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.amber.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.amber.withOpacity(0.5),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 14,
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    'Pro Player',
                                    style: TextStyle(
                                      color: Colors.amber,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          SizedBox(height: 12),
                          Row(
                            children: [
                              Text(
                                'Tap to view profile',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 12,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              SizedBox(width: 6),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white.withOpacity(0.7),
                                size: 12,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
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
                _buildDrawerItem(Icons.share_rounded, 'Referral', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ReferralScreen()),
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
                _buildDrawerItem(Icons.help_outline_rounded, 'How To Play', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HowToPlayPage(),
                    ),
                  );
                }),
                _buildDrawerItem(Icons.info_rounded, 'About us', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AboutUsPage(),
                    ),
                  );
                }),
                _buildDrawerItem(Icons.gavel_rounded, 'Legality', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LegalityPage(),
                    ),
                  );
                }),
                _buildDrawerItem(Icons.question_answer_rounded, 'FAQ', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Start25ProFAQPage(),
                    ),
                  );
                }),
                Divider(height: 32),
                _buildDrawerItem(Icons.logout_rounded, 'Logout', () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Logout'),
                        content: Text('Are you sure you want to logout?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              _handleLogout();
                            },
                            child: Text(
                              'Logout',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      );
                    },
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
          color: isDestructive
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
          gradient: isSelected
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

// Placeholder classes for navigation
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