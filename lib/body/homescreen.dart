// /body/homescreen.dart
import 'package:marquee/marquee.dart';
import 'package:fantasy/drawe_pages/about_us.dart';
import 'package:fantasy/drawe_pages/profile.dart';
import 'package:fantasy/body/refral.dart';
import 'package:fantasy/body/tree.dart';
import 'package:fantasy/body/wallet.dart';
import 'package:fantasy/model/fixture.dart';
import 'package:fantasy/service/fixture_service.dart';
import 'package:fantasy/service/user_service.dart';
import 'package:fantasy/drawe_pages/fantasy_point_system.dart';
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
import 'package:fantasy/service/team_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

// --- TOP-LEVEL WIDGET (outside any class) ---
class _SimpleAnimatedBanner extends StatefulWidget {
  final String title;
  final String subtitle;
  final String ctaText;
  final VoidCallback onTapCTA;
  final Widget? leading;
  final String? disclaimer;
  final bool disclaimerRed;

  const _SimpleAnimatedBanner({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.ctaText,
    required this.onTapCTA,
    this.leading,
    this.disclaimer,
    this.disclaimerRed = false,
  }) : super(key: key);

  @override
  State<_SimpleAnimatedBanner> createState() => _SimpleAnimatedBannerState();
}

class _SimpleAnimatedBannerState extends State<_SimpleAnimatedBanner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  static const List<Color> _colors = [
    Color(0xFF4F46E5),
    Color(0xFF7C3AED),
    Color(0xFF06B6D4),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Alignment _lerpAlign(double t, Alignment a, Alignment b) {
    return Alignment(a.x + (b.x - a.x) * t, a.y + (b.y - a.y) * t);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final t = Curves.easeInOut.transform(_controller.value);
            final begin = _lerpAlign(t, const Alignment(-1.2, -1.0), const Alignment(1.2, -1.0));
            final end   = _lerpAlign(t, const Alignment(1.2,  1.0), const Alignment(-1.2,  1.0));

            final blink = 0.65 + (0.35 * (0.5 - (t - 0.5).abs()) * 2);

            return Container(
              height: 130,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(begin: begin, end: end, colors: _colors),
                boxShadow: [
                  BoxShadow(
                    color: _colors[0].withOpacity(0.25),
                    blurRadius: 24,
                    spreadRadius: 1,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: IgnorePointer(
                      child: Opacity(
                        opacity: 0.15 + 0.1 * (0.5 - (t - 0.5).abs()) * 2,
                        child: const DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment(-1.0, -0.2),
                              end: Alignment(1.0, 0.2),
                              colors: [Colors.white24, Colors.transparent, Colors.white24],
                              stops: [0.0, 0.5, 1.0],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 44),
                    child: Row(
                      children: [
                        if (widget.leading != null) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.white.withOpacity(0.25)),
                            ),
                            child: widget.leading!,
                          ),
                          const SizedBox(width: 12),
                        ],
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                widget.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  height: 1.0,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                widget.subtitle,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.95),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Material(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          child: InkWell(
                            onTap: widget.onTapCTA,
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.play_arrow_rounded, size: 18, color: Color(0xFF1E293B)),
                                  const SizedBox(width: 6),
                                  Text(
                                    widget.ctaText,
                                    style: const TextStyle(
                                      color: Color(0xFF1E293B),
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  if (widget.disclaimer != null)
                    Positioned(
                      left: 12,
                      right: 12,
                      bottom: 10,
                      child: Container(
                        height: 32,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.grey.shade800,
                              Colors.grey.shade400,
                              Colors.amber.shade200,
                              Colors.grey.shade300,
                              Colors.grey.shade700,
                            ],
                            stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
                          ),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white.withOpacity(0.6), width: 1),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Marquee(
                          text: "Exclusively for entertainment use - You earn points, not real money",
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4F46E5),
                            letterSpacing: 0.5,
                          ),
                          velocity: 40.0,
                          blankSpace: 40.0,
                          pauseAfterRound: Duration(seconds: 1),
                          startPadding: 10.0,
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

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
  final TeamService _teamService = TeamService();
  List<FixtureModel> _liveMatches = [];
  List<FixtureModel> _fixtures = [];
  List<FixtureModel> _upcomingMatches = [];
  bool _isLoading = true;
  String? _errorMessage;
  int _currentPage = 1;
  bool _isAuthenticated = false;

  Map<int, int?> _lineupStatus = {};

  // Dynamic data variables
  int _notificationCount = 0;
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

  // ✅ Back button handler variables
  DateTime? _lastPressedAt;

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

  // ✅ Back button handler
  Future<bool> _onWillPop() async {
    // If user is not on home tab, go back to home tab
    if (_selectedIndex != 0) {
      setState(() {
        _selectedIndex = 0;
      });
      return false;
    }

    // Double tap to exit
    final now = DateTime.now();
    final maxDuration = const Duration(seconds: 2);
    final isWarning = _lastPressedAt == null ||
        now.difference(_lastPressedAt!) > maxDuration;

    if (isWarning) {
      _lastPressedAt = now;

      // Show snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: const [
              Icon(Icons.info_outline, color: Colors.white, size: 20),
              SizedBox(width: 12),
              Text(
                'Press back again to exit',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          duration: const Duration(seconds: 2),
          backgroundColor: const Color(0xFF334155),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
      return false;
    }

    // Exit the app
    SystemNavigator.pop();
    return true;
  }

  Future<void> _initializeApp() async {
    try {
      DebugConfig.debugPrint('Initializing app...');

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
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const Dream11LoginPage(),
        ),
            (route) => false,
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

        _fixtures = DebugConfig.mockFixtures.map((data) => FixtureModel.fromJson(data)).toList();
        _upcomingMatches = _fixtures.where((f) => f.status == 'upcoming').toList();

        _fetchLineupStatusForUpcomingMatches();

        final liveMatchesFromService = await _liveMatchService.getLiveMatches();
        _liveMatches = liveMatchesFromService;

        setState(() {
          _isLoading = false;
        });

        DebugConfig.debugPrint('Mock fixtures loaded: ${_fixtures.length} total, ${_liveMatches.length} live, ${_upcomingMatches.length} upcoming');
        return;
      }

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

      _fetchLineupStatusForUpcomingMatches();

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

  Future<void> _fetchLineupStatusForUpcomingMatches() async {
    if (_upcomingMatches.isEmpty) return;

    Map<int, int?> newLineupStatus = {};

    await Future.wait(_upcomingMatches.map((match) async {
      try {
        final lineup = await _teamService.getLineupForMatch(
          seriesId: match.seriesId,
          matchId: match.id,
        );
        newLineupStatus[match.id] = lineup;
      } catch (e) {
        print('Error fetching lineup for match ${match.id}: $e');
        newLineupStatus[match.id] = null;
      }
    }));

    if (mounted) {
      setState(() {
        _lineupStatus.addAll(newLineupStatus);
      });
    }
  }

  Future<void> _handleLogout() async {
    try {
      // Clear user service data
      final userService = UserService();
      await userService.logout();

      // Clear shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', false);
      await prefs.remove('authToken');
      await prefs.remove('userData');

      print('✅ Logout completed');

      if (!mounted) return;

      // Navigate to signup and remove all previous routes
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const Dream11LoginPage(),
        ),
            (route) => false,
      );
    } catch (e) {
      print('❌ Logout error: $e');

      if (!mounted) return;

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
        Uri.parse('http://13.60.210.139:3000/'),
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
        Uri.parse('http://13.60.210.139:3000/web-services/fixtures?page=1'),
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
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
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
      ),
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
            icon: const Icon(Icons.wallet_giftcard, color: Colors.white, size: 16),
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
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const Dream11LoginPage(),
                    ),
                        (route) => false,
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: _SimpleAnimatedBanner(
        title: "Build your Dream Team",
        subtitle: "Join upcoming matches and win big!",
        ctaText: "Explore Contests",
        onTapCTA: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MyMatchesScreen(
                initialTabIndex: 0,
                showAllMatches: true,
              ),
            ),
          );
        },
        leading: Row(
          children: [
            const Icon(Icons.sports_cricket, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(
              'Hi, ${_userName.split(' ').first} 👋',
              style: TextStyle(color: Colors.white.withOpacity(0.95), fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        disclaimer: "⚠️ Entertainment only — You earn points, not real money",
        disclaimerRed: false,
      ),
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
            MaterialPageRoute(
              builder: (context) => MyMatchesScreen(
                initialTabIndex: 1,
                showAllMatches: true,
              ),
            ),
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
            MaterialPageRoute(
              builder: (context) => MyMatchesScreen(
                initialTabIndex: 0,
                showAllMatches: true,
              ),
            ),
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
              final lineupValue = _lineupStatus[match.id];

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
                  lineupStatus: lineupValue,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Performance Stats',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _buildStatCardFancy(
                  title: 'Total Contests',
                  value: _userStats['contestsJoined'].toString(),
                  icon: Icons.sports_cricket,
                  gradient: const [Color(0xFF3B82F6), Color(0xFF2563EB)],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildStatCardFancy(
                  title: 'Winnings',
                  value: '₹${_userStats['totalWon'].toStringAsFixed(0)}',
                  icon: Icons.emoji_events,
                  gradient: const [Color(0xFF10B981), Color(0xFF059669)],
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: _buildStatCardFancy(
                  title: 'Win Rate',
                  value: '${_userStats['winRate'].toStringAsFixed(1)}%',
                  icon: Icons.trending_up,
                  gradient: const [Color(0xFFF59E0B), Color(0xFFD97706)],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildStatCardFancy(
                  title: 'Best Rank',
                  value: _userStats['bestRank'] > 0
                      ? '#${_userStats['bestRank']}'
                      : 'N/A',
                  icon: Icons.leaderboard,
                  gradient: const [Color(0xFF8B5CF6), Color(0xFF6D28D9)],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCardFancy({
    required String title,
    required String value,
    required IconData icon,
    required List<Color> gradient,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: gradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: gradient.last.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 1.0, end: 1.1),
            duration: const Duration(seconds: 1),
            curve: Curves.easeInOut,
            builder: (context, scale, child) => Transform.scale(
              scale: scale,
              child: child,
            ),
            onEnd: () => WidgetsBinding.instance.addPostFrameCallback((_) {}),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
    final size = MediaQuery.of(context).size;
    final cardWidth = size.width * 0.9;
    final cardPadding = size.width * 0.035;
    final teamBadgeSize = size.width * 0.16;
    final fontScale = size.width / 400;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: cardWidth,
      margin: EdgeInsets.only(bottom: size.height * 0.018),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F172A), Color(0xFF1E3A8A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.greenAccent.withOpacity(0.25),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: cardPadding, vertical: size.height * 0.012),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.15),
              borderRadius:
              const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.035,
                      vertical: size.height * 0.004),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: [Color(0xFFDC2626), Color(0xFFB91C1C)]),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.withOpacity(0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: size.width * 0.018,
                        height: size.width * 0.018,
                        decoration: const BoxDecoration(
                            color: Colors.white, shape: BoxShape.circle),
                      ),
                      SizedBox(width: size.width * 0.012),
                      Text(
                        'LIVE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11 * fontScale,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                Text(
                  format,
                  style: TextStyle(
                    color: const Color(0xFF10B981),
                    fontSize: 11 * fontScale,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.05, vertical: size.height * 0.018),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    child: _liveTeamScoreBadge(
                        short: team1Short,
                        full: team1,
                        flagUrl: team1Flag,
                        color: Colors.blueAccent,
                        size: teamBadgeSize,
                        score: score1,
                        overs: overs1)),

                Container(
                  margin: EdgeInsets.symmetric(horizontal: size.width * 0.04),
                  padding: EdgeInsets.all(size.width * 0.02),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    'VS',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 11 * fontScale,
                      color: Colors.white,
                    ),
                  ),
                ),

                Expanded(
                    child: _liveTeamScoreBadge(
                        short: team2Short,
                        full: team2,
                        flagUrl: team2Flag,
                        color: Colors.redAccent,
                        size: teamBadgeSize,
                        score: score2,
                        overs: overs2)),
              ],
            ),
          ),

          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.04, vertical: size.height * 0.012),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.12),
              borderRadius:
              const BorderRadius.vertical(bottom: Radius.circular(16)),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 12 * fontScale,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF34D399),
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _liveTeamScoreBadge({
    required String short,
    required String full,
    required Color color,
    required double size,
    required String score,
    required String overs,
    String? flagUrl,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: size,
          width: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(colors: [color.withOpacity(0.85), color]),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 6,
                offset: const Offset(0, 3),
              )
            ],
          ),
          child: flagUrl != null && flagUrl.isNotEmpty
              ? ClipOval(
            child: Image.network(flagUrl, fit: BoxFit.cover),
          )
              : Center(
            child: Text(
              short,
              style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),

        SizedBox(height: size * 0.12),

        Text(
          full,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.white70,
          ),
          overflow: TextOverflow.ellipsis,
        ),

        SizedBox(height: size * 0.08),

        Text(
          score,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),

        if (overs.isNotEmpty)
          Text(
            '($overs ov)',
            style: const TextStyle(
              fontSize: 11,
              color: Colors.white60,
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
    required FixtureModel match,
    int? lineupStatus,
  }) {
    final size = MediaQuery.of(context).size;
    final cardWidth = size.width * 0.9;   // ✅ shrink card width
    final cardPadding = size.width * 0.035;
    final teamBadgeSize = size.width * 0.16; // ✅ smaller badge
    final fontScale = size.width / 400;      // adjust text scale

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: cardWidth,
      margin: EdgeInsets.only(bottom: size.height * 0.018),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F172A), Color(0xFF1D4ED8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.25),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          // 🔵 TOP SECTION
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: cardPadding, vertical: size.height * 0.012),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.12),
              borderRadius:
              const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Match Info
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      match.matchType,
                      style: TextStyle(
                        color: const Color(0xFF60A5FA),
                        fontSize: 11 * fontScale,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: size.height * 0.004),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.025,
                          vertical: size.height * 0.004),
                      decoration: BoxDecoration(
                        color: lineupStatus == 1
                            ? const Color(0xFF10B981)
                            : Colors.orange.shade600,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        lineupStatus == 1 ? 'LINE-UP OUT' : 'UPCOMING',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9 * fontScale,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                // Countdown / Time
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.035,
                      vertical: size.height * 0.006),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.withOpacity(0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      )
                    ],
                  ),
                  child: Text(
                    time,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11 * fontScale,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ⚔️ MIDDLE SECTION
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.05, vertical: size.height * 0.018),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    child: _teamBadgeCompact(
                        team1Short, team1, team1Color, teamBadgeSize,
                        flagUrl: match.teamAFlag)),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: size.width * 0.04),
                  padding: EdgeInsets.all(size.width * 0.02),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    'VS',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 11 * fontScale,
                      color: Colors.white,
                    ),
                  ),
                ),
                Expanded(
                    child: _teamBadgeCompact(
                        team2Short, team2, team2Color, teamBadgeSize,
                        flagUrl: match.teamBFlag)),
              ],
            ),
          ),

          // 🔻BOTTOM SECTION
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.05, vertical: size.height * 0.014),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.12),
              borderRadius:
              const BorderRadius.vertical(bottom: Radius.circular(16)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Prize & Contest Info
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contests,
                      style: TextStyle(
                        fontSize: 12 * fontScale,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: size.height * 0.004),
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.8, end: 1.0),
                      duration: const Duration(seconds: 1),
                      curve: Curves.easeInOut,
                      builder: (context, scale, _) => Transform.scale(
                        scale: scale,
                        child: Text(
                          'Prize: $prize',
                          style: TextStyle(
                            fontSize: 12 * fontScale,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber.shade400,
                          ),
                        ),
                      ),
                      onEnd: () =>
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            setState(() {});
                          }),
                    ),
                  ],
                ),

                // Join Button
                InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.05,
                        vertical: size.height * 0.01),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
                      ),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blueAccent.withOpacity(0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Text(
                      'Join',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11 * fontScale,
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

  /// Compact team badge
  Widget _teamBadgeCompact(
      String short, String full, Color color, double size,
      {String? flagUrl}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: size,
          width: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(colors: [color.withOpacity(0.9), color]),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 6,
                offset: const Offset(0, 3),
              )
            ],
          ),
          child: flagUrl != null && flagUrl.isNotEmpty
              ? ClipOval(
            child: Image.network(flagUrl, fit: BoxFit.cover),
          )
              : Center(
            child: Text(
              short,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(height: size * 0.12),
        Text(
          full,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.white70,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
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