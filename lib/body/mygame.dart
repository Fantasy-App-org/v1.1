import 'package:flutter/material.dart';
import 'package:fantasy/model/fixture.dart';
import 'package:fantasy/service/fixture_service.dart';
import 'package:fantasy/service/user_service.dart';
import 'package:http/http.dart' as http;
import 'package:fantasy/auth/login.dart';

import 'package:fantasy/body/completed_match_details.dart';

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
  List<FixtureModel> _myUpcomingMatches = [];
  List<FixtureModel> _myLiveMatches = [];

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

        _isLoading = false;
      });

      print('Successfully loaded matches');
      print('My Upcoming: ${_myUpcomingMatches.length}');
      print('My Live: ${_myLiveMatches.length}');

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'My Matches',
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
            'Loading your matches...',
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

  Widget _buildApiMatchCard({
    required FixtureModel match,
    required double screenWidth,
    required bool isTablet,
    bool isUpcoming = false,
    bool isLive = false,
  }) {
    Color statusColor = Colors.blue;
    String statusText = 'Upcoming';
    IconData statusIcon = Icons.schedule;

    if (isLive) {
      statusColor = Colors.red;
      statusText = 'LIVE';
      statusIcon = Icons.circle;
    }

    final timeLeft = isUpcoming ? FixtureService.formatTimeLeft(match.matchDate) : statusText;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header with gradient background
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [statusColor.withOpacity(0.1), Colors.white],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
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
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        match.matchTitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [statusColor.withOpacity(0.8), statusColor],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: statusColor.withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
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
                        style: const TextStyle(
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
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [Colors.blue[100]!, Colors.blue[50]!],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.2),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.transparent,
                          child: Text(
                            match.teamAShort,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        match.teamA,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
                    'VS',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [Colors.orange[100]!, Colors.orange[50]!],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.orange.withOpacity(0.2),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.transparent,
                          child: Text(
                            match.teamBShort,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.orange,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        match.teamB,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
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
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.grey[50]!, Colors.grey[100]!],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
              border: Border(top: BorderSide(color: Colors.grey[300]!)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    Icon(Icons.emoji_events, size: 16, color: Colors.amber[600]),
                    const SizedBox(width: 4),
                    Text(
                      '${match.totalContest} Contests',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 1,
                  height: 20,
                  color: Colors.grey[300],
                ),
                Row(
                  children: [
                    Icon(Icons.groups, size: 16, color: Colors.green[600]),
                    const SizedBox(width: 4),
                    Text(
                      'My Teams: 2',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ],
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
        title = 'No live matches';
        subtitle = 'Check back when matches are live';
        break;
      default:
        title = 'You haven\'t joined any upcoming matches!';
        subtitle = 'Find any upcoming matches to join and start winning.';
        break;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 70),
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
      ),
    );
  }
}