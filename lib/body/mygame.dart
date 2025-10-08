// /body/mygame.dart
import 'package:flutter/material.dart';
import 'package:fantasy/model/fixture.dart';
import 'package:fantasy/service/fixture_service.dart';
import 'package:fantasy/service/user_service.dart';
import 'package:fantasy/service/live_match_service.dart';
import 'package:fantasy/service/team_service.dart';
import 'package:http/http.dart' as http;
import 'package:fantasy/auth/login.dart';
import 'package:fantasy/body/completed_match_details.dart';
import 'package:fantasy/body/live_match_scorecard.dart';
import 'package:fantasy/team_creation/contest_all_pages.dart';
import 'package:fantasy/config/debug_config.dart';

// Team Flag Widget (copied from homescreen.dart)
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

class MyMatchesScreen extends StatefulWidget {
  final int? initialTabIndex;
  final bool showAllMatches;

  const MyMatchesScreen({
    Key? key,
    this.initialTabIndex,
    this.showAllMatches = false,
  }) : super(key: key);

  @override
  State<MyMatchesScreen> createState() => _MyMatchesScreenState();
}

class _MyMatchesScreenState extends State<MyMatchesScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  // API Integration variables
  final LiveMatchService _liveMatchService = LiveMatchService();
  final TeamService _teamService = TeamService();
  List<FixtureModel> _allFixtures = [];
  List<FixtureModel> _allLiveMatches = [];
  List<FixtureModel> _allUpcomingMatches = [];
  List<FixtureModel> _upcomingMatches = [];
  List<FixtureModel> _liveMatches = [];
  List<FixtureModel> _myUpcomingMatches = [];
  List<FixtureModel> _myLiveMatches = [];

  bool _isLoading = true;
  String? _errorMessage;
  int _currentPage = 1;
  bool _isAuthenticated = false;

  // Lineup status tracking
  Map<int, int?> _lineupStatus = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: widget.initialTabIndex ?? 0,
    );
    _initializeMatches();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _initializeMatches() async {
    try {
      // Check authentication status
      final userService = UserService();
      await userService.initialize();
      _isAuthenticated = await userService.checkLoginStatus();

      if (_isAuthenticated) {
        await _loadMatches();
      } else {
        _handleAuthenticationRequired();
      }
    } catch (e) {
      print('MyMatches initialization error: $e');
      setState(() {
        _errorMessage = 'Failed to initialize: $e';
        _isLoading = false;
      });
    }
  }

  void _handleAuthenticationRequired() {
    setState(() {
      _isLoading = false;
      _errorMessage = 'Please login to view your matches';
    });
  }

  Future<void> _loadMatches() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      if (DebugConfig.isDebugMode && DebugConfig.isDesktop) {
        DebugConfig.debugPrint('Loading mock matches data for MyMatches');
        await DebugConfig.mockDelay();

        // Convert mock data to FixtureModel objects
        _allFixtures = DebugConfig.mockFixtures.map((data) => FixtureModel.fromJson(data)).toList();
        _allUpcomingMatches = _allFixtures.where((f) => f.status == 'upcoming').toList();

        // Load live matches separately
        final liveMatchesFromService = await _liveMatchService.getLiveMatches();
        _allLiveMatches = liveMatchesFromService;

        // Set all matches for "show all" mode, or subset for "my matches" mode
        if (widget.showAllMatches) {
          _upcomingMatches = _allUpcomingMatches;
          _liveMatches = _allLiveMatches;
        } else {
          // For demo purposes, assume some matches are "my matches"
          // Show all live matches in "My Matches" too, since users want to see all live games
          _myUpcomingMatches = _allUpcomingMatches.take(2).toList();
          _myLiveMatches = _allLiveMatches; // Show all live matches
        }

        // Fetch lineup status for upcoming matches
        _fetchLineupStatusForUpcomingMatches();

        setState(() {
          _isLoading = false;
        });

        DebugConfig.debugPrint('Mock matches loaded: ${_allFixtures.length} total, ${_allLiveMatches.length} live, ${_allUpcomingMatches.length} upcoming');
        return;
      }

      // Only make real API calls if enabled
      if (!DebugConfig.enableApiCalls) {
        throw Exception('API calls disabled in debug mode');
      }

      // Check authentication status before making API call
      if (FixtureService.needsAuthentication()) {
        throw Exception('Authentication required');
      }

      // Load all fixtures
      final fixtures = await FixtureService.getFixtures(page: _currentPage);
      _allFixtures = fixtures;
      _allUpcomingMatches = FixtureService.filterUpcomingMatches(fixtures);

      // Load live matches separately
      final liveMatchesFromService = await _liveMatchService.getLiveMatches();
      _allLiveMatches = liveMatchesFromService;

      // Set matches based on mode
      if (widget.showAllMatches) {
        _upcomingMatches = _allUpcomingMatches;
        _liveMatches = _allLiveMatches;
      } else {
        // For demo purposes, assume some matches are "my matches"
        _myUpcomingMatches = _allUpcomingMatches.take(2).toList();
        _myLiveMatches = _allLiveMatches;
      }

      // Fetch lineup status for upcoming matches
      _fetchLineupStatusForUpcomingMatches();

      setState(() {
        _isLoading = false;
      });

      print('Successfully loaded matches');
      print('All Live: ${_allLiveMatches.length}');
      print('All Upcoming: ${_allUpcomingMatches.length}');

    } catch (e) {
      print('Error loading matches: $e');
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

  Future<void> _fetchLineupStatusForUpcomingMatches() async {
    final matchesToCheck = widget.showAllMatches ? _allUpcomingMatches : _myUpcomingMatches;
    if (matchesToCheck.isEmpty) return;

    Map<int, int?> newLineupStatus = {};

    // Use Future.wait for concurrent API calls
    await Future.wait(matchesToCheck.map((match) async {
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

  void _navigateToContests(FixtureModel fixture) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ContestAllPage(fixture: fixture),
      ),
    );
  }

  // API connection test method (keeping from original)
  Future<void> _testApiConnection() async {
    final userService = UserService();

    print('🧪 Testing API connection from MyMatches...');

    try {
      // Test server connectivity
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
      // Test API with auth token
      final token = userService.authToken;

      if (token == null) {
        _showTestResult('No auth token available');
        return;
      }

      final response = await http.get(
        Uri.parse('http://13.232.147.237:3000/web-services/fixtures?page=1'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        _showTestResult('✅ API working perfectly!');
      } else {
        _showTestResult('❌ API returned ${response.statusCode}: ${response.body}');
      }

    } catch (e) {
      print('❌ API Test failed: $e');
      _showTestResult('❌ Network Error: $e');
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
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;
    final bool isTablet = screenWidth > 600;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          widget.showAllMatches ? 'All Matches' : 'My Matches',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.blue,
          indicatorWeight: 3,
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey,
          labelStyle: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
          unselectedLabelStyle: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
          tabs: [
            Tab(text: 'Upcoming'),
            Tab(text: 'Live'),
            Tab(text: 'Completed'),
          ],
        ),
      ),
      body: _isLoading ? _buildLoadingState() : _errorMessage != null ? _buildErrorState() : _buildContent(screenWidth, screenHeight, isTablet),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
          SizedBox(height: 16),
          Text(
            'Loading matches...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _errorMessage!.contains('Please login') ? Icons.login : Icons.error_outline,
            size: 64,
            color: _errorMessage!.contains('Please login') ? Colors.blue[400] : Colors.red[400],
          ),
          SizedBox(height: 16),
          Text(
            _errorMessage!.contains('Please login') ? 'Login Required' : 'Error Loading Matches',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              if (_errorMessage!.contains('Please login')) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const Dream11LoginPage()),
                );
              } else {
                _loadMatches();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
            ),
            child: Text(
              _errorMessage!.contains('Please login') ? 'Go to Login' : 'Retry',
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

  Widget _buildContent(double screenWidth, double screenHeight, bool isTablet) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          image: AssetImage('assets/images/no_upcoming_fixtures_found.png'),
          fit: BoxFit.contain,
          alignment: Alignment.center,
          opacity: 0.3,
        ),
      ),
      child: RefreshIndicator(
        onRefresh: _loadMatches,
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildUpcomingContent(screenWidth, screenHeight, isTablet),
            _buildLiveContent(screenWidth, screenHeight, isTablet),
            const CompletedMatchesPage(),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingContent(double screenWidth, double screenHeight, bool isTablet) {
    final matchesToShow = widget.showAllMatches ? _allUpcomingMatches : _myUpcomingMatches;

    if (matchesToShow.isEmpty) {
      return _buildEmptyState(screenWidth, screenHeight, isTablet, 'Upcoming');
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: matchesToShow.length,
      itemBuilder: (context, index) {
        final match = matchesToShow[index];
        final lineupValue = _lineupStatus[match.id];

        return Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: GestureDetector(
            onTap: () => _navigateToContests(match),
            child: _buildEnhancedUpcomingMatchCard(
              match: match,
              screenWidth: screenWidth,
              isTablet: isTablet,
              lineupStatus: lineupValue,
            ),
          ),
        );
      },
    );
  }

  Widget _buildLiveContent(double screenWidth, double screenHeight, bool isTablet) {
    final matchesToShow = widget.showAllMatches ? _allLiveMatches : _myLiveMatches;

    if (matchesToShow.isEmpty) {
      return _buildEmptyState(screenWidth, screenHeight, isTablet, 'Live');
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: matchesToShow.length,
      itemBuilder: (context, index) {
        final match = matchesToShow[index];
        return Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LiveMatchScorecardPage(match: match),
                ),
              );
            },
            child: _buildEnhancedLiveMatchCard(
              match: match,
              screenWidth: screenWidth,
              isTablet: isTablet,
            ),
          ),
        );
      },
    );
  }

  Widget _buildEnhancedLiveMatchCard({
    required FixtureModel match,
    required double screenWidth,
    required bool isTablet,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF10B981).withOpacity(0.3), width: 2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF10B981).withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [Color(0xFFDCFDF7), Color(0xFFF0FDF4)]),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        match.matchType,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        match.matchTitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFFEF4444), Color(0xFFDC2626)]),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFEF4444).withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      SizedBox(
                        width: 8,
                        height: 8,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      SizedBox(width: 6),
                      Text(
                        'LIVE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Teams section
          Container(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      TeamFlagWidget(
                        flagUrl: match.teamAFlag,
                        teamShort: match.teamAShort,
                        size: 60,
                        fallbackColor: const Color(0xFF3B82F6),
                      ),
                      SizedBox(height: 12),
                      Text(
                        match.teamA,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3B82F6).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Live Score',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF3B82F6),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
                    'VS',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      TeamFlagWidget(
                        flagUrl: match.teamBFlag,
                        teamShort: match.teamBShort,
                        size: 60,
                        fallbackColor: const Color(0xFFEF4444),
                      ),
                      SizedBox(height: 12),
                      Text(
                        match.teamB,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEF4444).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Live Score',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFEF4444),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Action section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.grey[50]!, Colors.grey[100]!],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    Icon(Icons.emoji_events, size: 20, color: Colors.amber[600]),
                    const SizedBox(width: 6),
                    Text(
                      '${match.totalContest} Contests',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFF10B981), Color(0xFF059669)]),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF10B981).withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Text(
                    'View Live',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
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

  Widget _buildEnhancedUpcomingMatchCard({
    required FixtureModel match,
    required double screenWidth,
    required bool isTablet,
    int? lineupStatus,
  }) {
    final timeLeft = FixtureService.formatTimeLeft(match.matchDate);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [const Color(0xFF3B82F6).withOpacity(0.1), Colors.white],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        match.matchType,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        match.matchTitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (lineupStatus == 1) ...[
                        SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Lineup Out',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFFF59E0B), Color(0xFFD97706)]),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFF59E0B).withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    timeLeft,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Teams section
          Container(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      TeamFlagWidget(
                        flagUrl: match.teamAFlag,
                        teamShort: match.teamAShort,
                        size: 60,
                        fallbackColor: const Color(0xFF3B82F6),
                      ),
                      SizedBox(height: 12),
                      Text(
                        match.teamA,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
                    'VS',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      TeamFlagWidget(
                        flagUrl: match.teamBFlag,
                        teamShort: match.teamBShort,
                        size: 60,
                        fallbackColor: const Color(0xFFEF4444),
                      ),
                      SizedBox(height: 12),
                      Text(
                        match.teamB,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Stats and action section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.grey[50]!, Colors.grey[100]!],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.emoji_events, size: 18, color: Colors.amber[600]),
                            const SizedBox(width: 4),
                            Text(
                              '${match.totalContest}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const Text(
                          'Contests',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 1,
                      height: 30,
                      color: Colors.grey[300],
                    ),
                    Column(
                      children: [
                        Text(
                          match.matchContest,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF10B981),
                          ),
                        ),
                        const Text(
                          'Prize Pool',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)]),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF3B82F6).withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Text(
                    'Join Contest',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(double screenWidth, double screenHeight, bool isTablet, String type) {
    String title = '';
    String subtitle = '';

    switch (type) {
      case 'Live':
        title = widget.showAllMatches ? 'No live matches' : 'No live matches';
        subtitle = widget.showAllMatches ? 'Check back when matches are live' : 'Join live matches to track here';
        break;
      default:
        title = widget.showAllMatches ? 'No upcoming matches available' : 'You haven\'t joined any upcoming matches!';
        subtitle = widget.showAllMatches ? 'New matches will appear here soon' : 'Find any upcoming matches to join and start winning.';
        break;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 70),
          Icon(
            type == 'Live' ? Icons.sports_cricket : Icons.schedule,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          if (!widget.showAllMatches) ...[
            const SizedBox(height: 32),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue[400]!, Colors.blue[600]!],
                ),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextButton(
                onPressed: () {
                  // Navigate back to home screen
                  DefaultTabController.of(context)?.animateTo(0);
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.search, color: Colors.white, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'VIEW MATCHES',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}