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
import 'package:fantasy/service/live_match_service.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:fantasy/auth/login.dart';
import 'mygame.dart';
import 'package:fantasy/config/debug_config.dart';
import 'package:fantasy/body/live_match_scorecard.dart';

// Helper function for flags
String _flagFor(String short) {
  switch (short.toUpperCase()) {
    case 'IND': return '🇮🇳';
    case 'AUS': return '🇦🇺';
    case 'ENG': return '🇬🇧';
    case 'PAK': return '🇵🇰';
    case 'SA':
    case 'RSA': return '🇿🇦';
    case 'NZ': return '🇳🇿';
    case 'BAN': return '🇧🇩';
    case 'SL': return '🇱🇰';
    case 'AFG': return '🇦🇫';
    case 'IRE': return '🇮🇪';
    case 'WI': return '🏴‍☠️';
    default: return '🏏';
  }
}

class TeamFlagWidget extends StatelessWidget {
  final String? flagUrl;
  final String teamShort;
  final double size;
  final Color fallbackColor;

  const TeamFlagWidget({
    Key? key,
    required this.flagUrl,
    required this.teamShort,
    required this.size,
    required this.fallbackColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: fallbackColor.withOpacity(0.3),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipOval(
        child: flagUrl != null && flagUrl!.isNotEmpty
            ? Image.network(
          flagUrl!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [fallbackColor.withOpacity(0.8), fallbackColor],
                ),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: SizedBox(
                  width: size * 0.4,
                  height: size * 0.4,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return _buildFallbackFlag();
          },
        )
            : _buildFallbackFlag(),
      ),
    );
  }

  Widget _buildFallbackFlag() {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [fallbackColor.withOpacity(0.8), fallbackColor],
        ),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          teamShort,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: Colors.white,
            fontSize: size * 0.25,
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late AnimationController _animationController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // API Integration variables
  final LiveMatchService _liveMatchService = LiveMatchService();
  List<FixtureModel> _liveMatches = [];
  List<FixtureModel> _fixtures = [];
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
      duration: Duration(milliseconds: 600),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic));
    _animationController.forward();
    _slideController.forward();
    _initializeApp();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _slideController.dispose();
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
        _upcomingMatches = _fixtures.where((f) => f.status == 'upcoming').toList();

        // Load live matches separately
        final liveMatchesFromService = await _liveMatchService.getLiveMatches();
        _liveMatches = liveMatchesFromService;

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
      _fixtures = fixtures;
      _upcomingMatches = FixtureService.filterUpcomingMatches(fixtures);

      // Load live matches separately
      final liveMatchesFromService = await _liveMatchService.getLiveMatches();
      _liveMatches = liveMatchesFromService;

      setState(() {
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

  void _navigateToContests(FixtureModel fixture) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ContestAllPage(fixture: fixture),
      ),
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
        Uri.parse('http://api.start25pro.com:3000/'),
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
        Uri.parse('http://api.start25pro.com:3000/web-services/fixtures?page=1'),
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
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: _buildPremiumAppBar(),
      drawer: _buildPremiumDrawer(),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: IndexedStack(
          index: _selectedIndex,
          children: [
            _buildHomeScreen(),
            MyMatchesScreen(),
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
        margin: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFFF1F5F9), Color(0xFFE2E8F0)]),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: IconButton(
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          icon: const Icon(Icons.menu_rounded, color: Color(0xFF1E293B), size: 18),
        ),
      ),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [BoxShadow(color: const Color(0xFF667eea).withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 2))],
            ),
            child: const Icon(Icons.sports_cricket, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text('STAR 25 PRO',
                  style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.w700, fontSize: 14, letterSpacing: 0.3)),
              Text('Cricket League',
                  style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.w400, fontSize: 8, letterSpacing: 0.2)),
            ],
          ),
        ],
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 6),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFFF1F5F9), Color(0xFFE2E8F0)]),
            borderRadius: BorderRadius.circular(10),
          ),
          child: IconButton(
            icon: Stack(clipBehavior: Clip.none, children: [
              const Icon(Icons.notifications_none_rounded, color: Color(0xFF475569), size: 18),
              if (_notificationCount > 0)
                Positioned(
                  right: -1,
                  top: -1,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFFEF4444), Color(0xFFDC2626)]),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: const BoxConstraints(minWidth: 12, minHeight: 12),
                    child: Text(_notificationCount > 99 ? '99+' : _notificationCount.toString(),
                        style: const TextStyle(color: Colors.white, fontSize: 7, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
                  ),
                ),
            ]),
            onPressed: () {},
          ),
        ),
        Container(
          margin: const EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFF059669), Color(0xFF047857)]),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [BoxShadow(color: const Color(0xFF059669).withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 2))],
          ),
          child: IconButton(
            icon: const Icon(Icons.account_balance_wallet_rounded, color: Colors.white, size: 16),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const WalletScreen()));
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
        physics: const BouncingScrollPhysics(),
        child: SlideTransition(
          position: _slideAnimation,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _buildPremiumBanner(),
            _buildBalanceCard(),
            _buildLiveMatches(),
            _buildUpcomingMatches(),
            _buildPerformanceStats(),
            const SizedBox(height: 80),
          ]),
        ),
      ),
    );
  }

  Widget _buildPremiumBanner() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF667eea), Color(0xFF764ba2), Color(0xFF667eea)], begin: Alignment.topLeft, end: Alignment.bottomRight, stops: [0.0, 0.5, 1.0]),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: const Color(0xFF667eea).withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Stack(children: [
        Positioned(
          right: -40,
          top: -25,
          child: Container(width: 120, height: 120, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.08))),
        ),
        Positioned(
          right: 15,
          bottom: -15,
          child: Container(width: 60, height: 60, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.05))),
        ),
        Positioned(
          left: -20,
          top: 20,
          child: Container(width: 40, height: 40, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.06))),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Welcome Back, ${_userName.split(' ').first}! 👋', style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 12, fontWeight: FontWeight.w400)),
                  const SizedBox(height: 6),
                  const Text('Build Your\nDream Team', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700, height: 1.1)),
                ]),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
                ),
                child: const Icon(Icons.emoji_events_rounded, color: Color(0xFFFBBF24), size: 24),
              ),
            ]),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.white.withOpacity(0.25))),
              child: Text('🏆 Join upcoming matches and win big!', style: TextStyle(color: Colors.white.withOpacity(0.95), fontSize: 11, fontWeight: FontWeight.w400)),
            ),
          ]),
        ),
      ]),
    );
  }

  Widget _buildBalanceCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: const Color(0xFF1E293B).withOpacity(0.06), blurRadius: 20, offset: const Offset(0, 4))],
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Row(children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFF10B981), Color(0xFF059669)]),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: const Color(0xFF10B981).withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 2))],
          ),
          child: const Icon(Icons.account_balance_wallet_rounded, color: Colors.white, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Total Balance', style: TextStyle(color: Color(0xFF64748B), fontSize: 11, fontWeight: FontWeight.w400)),
            const SizedBox(height: 2),
            Text('₹${_walletBalance.toStringAsFixed(2)}', style: const TextStyle(color: Color(0xFF0F172A), fontSize: 18, fontWeight: FontWeight.w700)),
          ]),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [const Color(0xFF10B981).withOpacity(0.1), const Color(0xFF059669).withOpacity(0.05)]),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFF10B981).withOpacity(0.2)),
          ),
          child: const Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.add_rounded, color: Color(0xFF10B981), size: 14),
            SizedBox(width: 4),
            Text('Add Money', style: TextStyle(color: Color(0xFF10B981), fontSize: 10, fontWeight: FontWeight.w600)),
          ]),
        ),
      ]),
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
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFF1F5F9)),
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
            height: screenHeight * 0.22,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _liveMatches.length,
              itemBuilder: (context, index) {
                final match = _liveMatches[index];
                return Container(
                  width: screenWidth * 0.80,
                  margin: const EdgeInsets.only(right: 12),
                  child: GestureDetector(
                    onTap: () {
                      // Navigate to live match scorecard
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LiveMatchScorecardPage(match: match),
                        ),
                      );
                    },
                    child: _buildLiveMatchCard(
                      team1: match.teamA,
                      team2: match.teamB,
                      team1Short: match.teamAShort,
                      team2Short: match.teamBShort,
                      team1Flag: match.teamAFlag,
                      team2Flag: match.teamBFlag,
                      score1: 'Live',
                      score2: 'Live',
                      overs1: '',
                      overs2: '',
                      status: match.matchTitle,
                      format: match.matchType,
                    ),
                  ),
                );
              },
            ),
          ),
      ],
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
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFF1F5F9)),
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
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _upcomingMatches.take(3).length,
            itemBuilder: (context, index) {
              final match = _upcomingMatches[index];
              final timeLeft = FixtureService.formatTimeLeft(match.matchDate);
              return GestureDetector(
                onTap: () => _navigateToContests(match),
                child: _buildUpcomingMatchCard(
                  team1: match.teamA,
                  team2: match.teamB,
                  team1Short: match.teamAShort,
                  team2Short: match.teamBShort,
                  time: timeLeft,
                  contests: '${match.totalContest} Contests',
                  prize: match.matchContest,
                  team1Color: index == 0 ? const Color(0xFF3B82F6) : const Color(0xFFEF4444),
                  team2Color: index == 0 ? const Color(0xFF8B5CF6) : const Color(0xFFFBBF24),
                  match: match,
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _buildPerformanceStats() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Performance Stats', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: _buildStatCard('Total Contests', _userStats['contestsJoined'].toString(), Icons.sports_cricket, const Color(0xFF3B82F6))),
          const SizedBox(width: 10),
          Expanded(child: _buildStatCard('Winnings', '₹${_userStats['totalWon'].toStringAsFixed(0)}', Icons.emoji_events, const Color(0xFF10B981))),
        ]),
        const SizedBox(height: 10),
        Row(children: [
          Expanded(child: _buildStatCard('Win Rate', '${_userStats['winRate'].toStringAsFixed(1)}%', Icons.trending_up, const Color(0xFFF59E0B))),
          const SizedBox(width: 10),
          Expanded(child: _buildStatCard('Best Rank', _userStats['bestRank'] > 0 ? '#${_userStats['bestRank']}' : 'N/A', Icons.leaderboard, const Color(0xFF8B5CF6))),
        ]),
      ]),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: const Color(0xFF1E293B).withOpacity(0.06), blurRadius: 15, offset: const Offset(0, 3))],
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: color, size: 16)),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
        const SizedBox(height: 2),
        Text(title, style: const TextStyle(fontSize: 10, color: Color(0xFF64748B), fontWeight: FontWeight.w400)),
      ]),
    );
  }

  Widget _buildSectionHeader(String title, String actionText, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
        GestureDetector(onTap: onTap, child: Text(actionText, style: const TextStyle(fontSize: 12, color: Color(0xFF3B82F6), fontWeight: FontWeight.w500))),
      ]),
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
    required String format,
    String? team1Flag,
    String? team2Flag,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: const Color(0xFF1E293B).withOpacity(0.06), blurRadius: 15, offset: const Offset(0, 4))],
        border: Border.all(color: const Color(0xFF10B981).withOpacity(0.3), width: 1),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [Color(0xFFDCFDF7), Color(0xFFF0FDF4)]),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
            ),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFFEF4444), Color(0xFFDC2626)]), borderRadius: BorderRadius.circular(12)),
                child: Row(mainAxisSize: MainAxisSize.min, children: const [
                  SizedBox(width: 4, height: 4, child: DecoratedBox(decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle))),
                  SizedBox(width: 4),
                  Text('LIVE', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w600)),
                ]),
              ),
              Text(format, style: const TextStyle(color: Color(0xFF059669), fontSize: 11, fontWeight: FontWeight.w600)),
            ]),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                Row(children: [
                  Expanded(child: _scoreBlock(team1Short, score1, overs1, team1Flag: team1Flag)),
                  const SizedBox(width: 12),
                  const Text('vs', style: TextStyle(color: Color(0xFF64748B))),
                  const SizedBox(width: 12),
                  Expanded(child: _scoreBlock(team2Short, score2, overs2, team2Flag: team2Flag, right: true)),
                ]),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(gradient: LinearGradient(colors: [const Color(0xFF10B981).withOpacity(0.1), const Color(0xFF059669).withOpacity(0.05)]), borderRadius: BorderRadius.circular(8)),
                  child: Text(status, style: const TextStyle(fontSize: 11, color: Color(0xFF059669), fontWeight: FontWeight.w600), textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _scoreBlock(String short, String score, String overs, {bool right = false, String? team1Flag, String? team2Flag}) {
    final align = right ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final teamFlag = right ? team2Flag : team1Flag;

    return Column(crossAxisAlignment: align, children: [
      // Use TeamFlagWidget instead of simple container with emoji
      TeamFlagWidget(
        flagUrl: teamFlag,
        teamShort: short,
        size: 40,
        fallbackColor: right ? const Color(0xFFEF4444) : const Color(0xFF3B82F6),
      ),
      const SizedBox(height: 6),
      Text(short, style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF0F172A), fontSize: 12)),
      const SizedBox(height: 4),
      Text(score, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF0F172A))),
      if (overs.isNotEmpty) Text('($overs ov)', style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
    ]);
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
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: const Color(0xFF1E293B).withOpacity(0.06), blurRadius: 15, offset: const Offset(0, 4))],
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [Color(0xFFF8FAFC), Colors.white]),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
            ),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(match.matchType, style: const TextStyle(color: Color(0xFF3B82F6), fontSize: 11, fontWeight: FontWeight.w600)),
                Text('Cricket Match', style: const TextStyle(color: Color(0xFF64748B), fontSize: 10)),
              ]),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFFF59E0B), Color(0xFFD97706)]), borderRadius: BorderRadius.circular(10)),
                child: Text(time, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
              ),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(children: [
              Expanded(child: _teamBadge(team1Short, team1, team1Color, flagUrl: match.teamAFlag)),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(color: Color(0xFFF8FAFC), shape: BoxShape.circle),
                child: const Text('VS', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF64748B), fontSize: 10)),
              ),
              Expanded(child: _teamBadge(team2Short, team2, team2Color, flagUrl: match.teamBFlag)),
            ]),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [Color(0xFFF8FAFC), Colors.white]),
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16)),
            ),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(contests, style: const TextStyle(color: Color(0xFF1E293B), fontSize: 12, fontWeight: FontWeight.w600)),
                Text('Prize Pool: $prize', style: const TextStyle(color: Color(0xFF10B981), fontSize: 11, fontWeight: FontWeight.w600)),
              ]),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)]),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [BoxShadow(color: const Color(0xFF3B82F6).withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 2))],
                ),
                child: const Text('Join Contest', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _teamBadge(String short, String name, Color color, {String? flagUrl}) {
    return Column(
      children: [
        TeamFlagWidget(
          flagUrl: flagUrl,
          teamShort: short,
          size: 44,
          fallbackColor: color,
        ),
        const SizedBox(height: 6),
        Text(name, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)), textAlign: TextAlign.center, maxLines: 2),
      ],
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
              Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
            },
            child: Container(
              height: 250,
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [Color(0xFF667eea), Color(0xFF764ba2), Color(0xFF667eea)], begin: Alignment.topLeft, end: Alignment.bottomRight, stops: [0.0, 0.5, 1.0]),
              ),
              child: Stack(children: [
                Positioned(top: -40, right: -40, child: Container(width: 120, height: 120, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.1)))),
                Positioned(top: 25, right: 15, child: Container(width: 60, height: 60, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.05)))),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.end, children: [
                      Container(
                        decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 6))]),
                        child: CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 26,
                            backgroundColor: const Color(0xFF4F46E5),
                            child: Text(
                              _userName.isNotEmpty ? _userName.substring(0, 1).toUpperCase() : 'U',
                              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(_userName,
                          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700, letterSpacing: 0.3)),
                      const SizedBox(height: 3),
                      Row(children: [
                        Icon(Icons.sports_cricket, color: Colors.white.withOpacity(0.9), size: 12),
                        const SizedBox(width: 4),
                        Text('Fantasy Cricket Player', style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 11, fontWeight: FontWeight.w400)),
                      ]),
                      const SizedBox(height: 6),
                      if (_isPremiumUser)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(color: Colors.amber.withOpacity(0.2), borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.amber.withOpacity(0.5), width: 1)),
                          child: Row(mainAxisSize: MainAxisSize.min, children: const [
                            Icon(Icons.star, color: Colors.amber, size: 10),
                            SizedBox(width: 3),
                            Text('Pro Player', style: TextStyle(color: Colors.amber, fontSize: 9, fontWeight: FontWeight.w500)),
                          ]),
                        ),
                      const SizedBox(height: 8),
                      Row(children: [
                        Text('Tap to view profile', style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 9, fontStyle: FontStyle.italic)),
                        const SizedBox(width: 4),
                        Icon(Icons.arrow_forward_ios, color: Colors.white.withOpacity(0.7), size: 10),
                      ]),
                    ]),
                  ),
                ),
              ]),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(Icons.person_rounded, 'Profile', () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
                }),
                _buildDrawerItem(Icons.share_rounded, 'Referral', () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ReferralScreen()));
                }),
                _buildDrawerItem(Icons.account_balance_wallet_rounded, 'Wallet', () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const WalletScreen()));
                }),
                _buildDrawerItem(Icons.history_rounded, 'Transaction History', () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => TransactionHistoryPage()));
                }),
                _buildDrawerItem(Icons.stars_rounded, 'Fantasy Points', () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => FantasyPointsPage()));
                }),
                _buildDrawerItem(Icons.help_outline_rounded, 'How To Play', () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => HowToPlayPage()));
                }),
                _buildDrawerItem(Icons.info_outline_rounded, 'About us', () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AboutUsPage()));
                }),
                _buildDrawerItem(Icons.gavel_rounded, 'Legality', () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LegalityPage()));
                }),
                _buildDrawerItem(Icons.quiz_rounded, 'FAQ', () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Start25ProFAQPage()));
                }),
                const Divider(height: 12),
                _buildDrawerItem(Icons.logout_rounded, 'Logout', () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        title: const Text('Logout', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                        content: const Text('Are you sure you want to logout?', style: TextStyle(fontSize: 14)),
                        actions: [
                          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel', style: TextStyle(fontSize: 12))),
                          TextButton(
                            onPressed: () async {
                              Navigator.of(context).pop();
                              _handleLogout();
                            },
                            child: const Text('Logout', style: TextStyle(color: Colors.red, fontSize: 12)),
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

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap, {bool isDestructive = false}) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: isDestructive ? const Color(0xFFEF4444).withOpacity(0.1) : const Color(0xFF3B82F6).withOpacity(0.1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, color: isDestructive ? const Color(0xFFEF4444) : const Color(0xFF3B82F6), size: 16),
      ),
      title: Text(title,
          style: TextStyle(color: isDestructive ? const Color(0xFFEF4444) : const Color(0xFF1E293B), fontWeight: FontWeight.w500, fontSize: 13)),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
    );
  }

  Widget _buildPremiumBottomNav() {
    return Container(
      decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: const Color(0xFF1E293B).withOpacity(0.08), blurRadius: 20, offset: const Offset(0, -4))]),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF3B82F6),
        unselectedItemColor: const Color(0xFF64748B),
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 10),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w400, fontSize: 9),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded, size: 20), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.sports_cricket, size: 20), label: 'My Games'),
          BottomNavigationBarItem(icon: Icon(Icons.share, size: 20), label: 'Refer'),
        ],
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