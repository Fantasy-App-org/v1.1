import 'package:flutter/material.dart';
import 'package:fantasy/model/fixture.dart';
import 'package:fantasy/service/fixture_service.dart';
import 'package:fantasy/service/user_service.dart';
import 'package:http/http.dart' as http;
import 'login.dart';

class MyMatchesScreen extends StatefulWidget {
  const MyMatchesScreen({Key? key}) : super(key: key);

  @override
  State<MyMatchesScreen> createState() => _MyMatchesScreenState();
}

class _MyMatchesScreenState extends State<MyMatchesScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  // API Integration variables
  List<FixtureModel> _allFixtures = [];
  List<FixtureModel> _upcomingMatches = [];
  List<FixtureModel> _liveMatches = [];
  List<FixtureModel> _completedMatches = [];
  List<FixtureModel> _myUpcomingMatches = [];
  List<FixtureModel> _myLiveMatches = [];
  List<FixtureModel> _myCompletedMatches = [];

  bool _isLoading = true;
  String? _errorMessage;
  int _currentPage = 1;
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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

      // Check authentication status before making API call
      if (FixtureService.needsAuthentication()) {
        throw Exception('Authentication required');
      }

      // Load all fixtures
      final fixtures = await FixtureService.getFixtures(page: _currentPage);

      setState(() {
        _allFixtures = fixtures;
        _upcomingMatches = FixtureService.filterUpcomingMatches(fixtures);
        _liveMatches = FixtureService.filterLiveMatches(fixtures);

        // For demo purposes, assume some matches are "my matches"
        // In real implementation, you'd have user's joined matches
        _myUpcomingMatches = _upcomingMatches.take(2).toList();
        _myLiveMatches = _liveMatches.take(1).toList();
        _myCompletedMatches = _completedMatches.take(3).toList();

        _isLoading = false;
      });

      print('Successfully loaded matches');
      print('My Upcoming: ${_myUpcomingMatches.length}');
      print('My Live: ${_myLiveMatches.length}');
      print('My Completed: ${_myCompletedMatches.length}');

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

  // API connection test method
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
      backgroundColor: Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'My Matches',
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Color(0xFF3B82F6),
          indicatorWeight: 3,
          labelColor: Color(0xFF3B82F6),
          unselectedLabelColor: Color(0xFF64748B),
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
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3B82F6)),
          ),
          SizedBox(height: 16),
          Text(
            'Loading your matches...',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF64748B),
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
              style: TextStyle(color: Color(0xFF64748B)),
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
              backgroundColor: Color(0xFF3B82F6),
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
      decoration: BoxDecoration(
        color: Color(0xFFF8FAFC),
        image: DecorationImage(
          image: AssetImage('assets/images/no_upcoming_fixtures_found.png'),
          fit: BoxFit.contain,
          alignment: Alignment.center,
          opacity: 0.1,
        ),
      ),
      child: RefreshIndicator(
        onRefresh: _loadMatches,
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildUpcomingContent(screenWidth, screenHeight, isTablet),
            _buildLiveContent(screenWidth, screenHeight, isTablet),
            _buildCompletedContent(screenWidth, screenHeight, isTablet),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingContent(double screenWidth, double screenHeight, bool isTablet) {
    if (_myUpcomingMatches.isEmpty) {
      return _buildEmptyState(screenWidth, screenHeight, isTablet, 'Upcoming');
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: _myUpcomingMatches.length,
      itemBuilder: (context, index) {
        final match = _myUpcomingMatches[index];
        return Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: _buildApiMatchCard(
            match: match,
            screenWidth: screenWidth,
            isTablet: isTablet,
            isUpcoming: true,
          ),
        );
      },
    );
  }

  Widget _buildLiveContent(double screenWidth, double screenHeight, bool isTablet) {
    if (_myLiveMatches.isEmpty) {
      return _buildEmptyState(screenWidth, screenHeight, isTablet, 'Live');
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: _myLiveMatches.length,
      itemBuilder: (context, index) {
        final match = _myLiveMatches[index];
        return Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: _buildApiMatchCard(
            match: match,
            screenWidth: screenWidth,
            isTablet: isTablet,
            isLive: true,
          ),
        );
      },
    );
  }

  Widget _buildCompletedContent(double screenWidth, double screenHeight, bool isTablet) {
    if (_myCompletedMatches.isEmpty) {
      return _buildEmptyState(screenWidth, screenHeight, isTablet, 'Completed');
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: _myCompletedMatches.length,
      itemBuilder: (context, index) {
        final match = _myCompletedMatches[index];
        return Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: _buildApiMatchCard(
            match: match,
            screenWidth: screenWidth,
            isTablet: isTablet,
            isCompleted: true,
          ),
        );
      },
    );
  }

  Widget _buildApiMatchCard({
    required FixtureModel match,
    required double screenWidth,
    required bool isTablet,
    bool isUpcoming = false,
    bool isLive = false,
    bool isCompleted = false,
  }) {
    Color statusColor = Colors.blue;
    String statusText = 'Upcoming';
    IconData statusIcon = Icons.schedule;

    if (isLive) {
      statusColor = Colors.red;
      statusText = 'LIVE';
      statusIcon = Icons.circle;
    } else if (isCompleted) {
      statusColor = Colors.green;
      statusText = 'Completed';
      statusIcon = Icons.check_circle;
    }

    final timeLeft = isUpcoming ? FixtureService.formatTimeLeft(match.matchDate) : statusText;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFFF1F5F9)),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF1E293B).withOpacity(0.08),
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header with gradient background
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [statusColor.withOpacity(0.1), Colors.white],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9))),
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
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        match.matchTitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF64748B),
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [statusColor.withOpacity(0.8), statusColor],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: statusColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isLive) ...[
                        Icon(statusIcon, size: 12, color: Colors.white),
                        SizedBox(width: 4),
                      ],
                      Text(
                        timeLeft,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
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
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        match.teamA,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E293B),
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Color(0xFFF8FAFC),
                    shape: BoxShape.circle,
                    border: Border.all(color: Color(0xFFE2E8F0)),
                  ),
                  child: Text(
                    'VS',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF64748B),
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
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        match.teamB,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E293B),
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Stats section
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFF8FAFC), Color(0xFFE2E8F0)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              border: Border(top: BorderSide(color: Color(0xFFF1F5F9))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    Icon(Icons.emoji_events_rounded, size: 16, color: Color(0xFFF59E0B)),
                    SizedBox(width: 4),
                    Text(
                      '${match.totalContest} Contests',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 1,
                  height: 20,
                  color: Color(0xFFE2E8F0),
                ),
                Row(
                  children: [
                    Icon(Icons.people_rounded, size: 16, color: Color(0xFF10B981)),
                    SizedBox(width: 4),
                    Text(
                      'My Teams: 2', // This would come from user data
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                  ],
                ),
                if (isCompleted) ...[
                  Container(
                    width: 1,
                    height: 20,
                    color: Color(0xFFE2E8F0),
                  ),
                  Row(
                    children: [
                      Icon(Icons.star_rounded, size: 16, color: Color(0xFF8B5CF6)),
                      SizedBox(width: 4),
                      Text(
                        'Rank: #45', // This would come from user data
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    ],
                  ),
                ],
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
    IconData icon = Icons.sports_cricket;

    switch (type) {
      case 'Live':
        title = 'No live matches';
        subtitle = 'Check back when matches are live';
        icon = Icons.live_tv;
        break;
      case 'Completed':
        title = 'No completed matches';
        subtitle = 'Your completed matches will appear here';
        icon = Icons.history;
        break;
      default:
        title = 'You haven\'t joined any upcoming matches!';
        subtitle = 'Find any upcoming matches to join and start winning.';
        icon = Icons.schedule;
        break;
    }

    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: screenHeight * 0.1),
              Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF3B82F6).withOpacity(0.1), Color(0xFF1D4ED8).withOpacity(0.05)],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 64,
                  color: Color(0xFF3B82F6),
                ),
              ),
              SizedBox(height: 24),
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F172A),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF64748B),
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 32),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF3B82F6).withOpacity(0.3),
                      blurRadius: 12,
                      offset: Offset(0, 4),
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
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
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
          ),
        ),
      ),
    );
  }
}