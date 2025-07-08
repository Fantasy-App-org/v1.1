// lib/team_creation/contest_all_pages.dart
import 'package:flutter/material.dart';
import '../model/fixture.dart';
import '../model/contest.dart';
import '../model/joined_contest.dart';
import '../model/user_team.dart';
import '../service/contest_service.dart';
import '../service/team_service.dart';
import '../service/user_service.dart';
import '../auth/login.dart';
import 'package:fantasy/team_creation/create_team.dart';

class ContestAllPage extends StatefulWidget {
  final FixtureModel fixture;

  const ContestAllPage({
    Key? key,
    required this.fixture,
  }) : super(key: key);

  @override
  State<ContestAllPage> createState() => _ContestAllPageState();
}

class _ContestAllPageState extends State<ContestAllPage> with TickerProviderStateMixin {
  late TabController _tabController;

  // Services
  final ContestService _contestService = ContestService();
  final TeamService _teamService = TeamService();
  final UserService _userService = UserService();

  // State management
  List<Contest> _contests = [];
  List<JoinedContest> _joinedContests = [];
  List<UserTeam> _userTeams = [];
  bool _isLoading = true;
  String? _errorMessage;
  bool _isAuthenticated = false;

  // Filter states
  String _selectedFilter = 'All';
  final List<String> _filterOptions = ['All', 'Entry', 'Prize Pool', 'Spots', 'Winners'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _initializeContests();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _initializeContests() async {
    try {
      await _userService.initialize();
      _isAuthenticated = await _userService.checkLoginStatus();

      if (_isAuthenticated) {
        await _loadContestData();
      } else {
        _handleAuthenticationRequired();
      }
    } catch (e) {
      print('Contest initialization error: $e');
      setState(() {
        _errorMessage = 'Failed to initialize: $e';
        _isLoading = false;
      });
    }
  }

  void _handleAuthenticationRequired() {
    setState(() {
      _isLoading = false;
      _errorMessage = 'Please login to view contests';
    });
  }

  Future<void> _loadContestData() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final matchId = widget.fixture.id;
      final seriesId = widget.fixture.seriesId;

      print('Loading contest data for match ID: $matchId, series ID: $seriesId');

      await Future.wait([
        _loadContests(matchId),
        _loadJoinedContests(matchId),
        _loadUserTeams(matchId, seriesId),
      ]);

      setState(() {
        _isLoading = false;
      });

      print('Successfully loaded all contest data');
    } catch (e) {
      print('Error loading contest data: $e');
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

  Future<void> _loadContests(int matchId) async {
    try {
      final contests = await _contestService.getContestsForMatch(matchId);
      setState(() {
        _contests = contests;
      });
    } catch (e) {
      print('Error loading contests: $e');
      throw e;
    }
  }

  Future<void> _loadJoinedContests(int matchId) async {
    try {
      final joinedContests = await _contestService.getJoinedContestsForMatch(matchId: matchId);
      setState(() {
        _joinedContests = joinedContests;
      });
    } catch (e) {
      print('Error loading joined contests: $e');
      throw e;
    }
  }

  Future<void> _loadUserTeams(int matchId, int seriesId) async {
    try {
      final userTeams = await _teamService.getUserTeamsForMatch(
        matchId: matchId,
        seriesId: seriesId,
        contestId: "",
      );
      setState(() {
        _userTeams = userTeams;
      });
      print('Loaded ${_userTeams.length} user teams');
    } catch (e) {
      print('Error loading user teams: $e');
      throw e;
    }
  }

  Future<void> _refreshData() async {
    await _loadContestData();
  }

  void _navigateToCreateTeam() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateTeamPage(fixture: widget.fixture),
      ),
    ).then((_) {
      _refreshData();
    });
  }

  void _navigateToLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Dream11LoginPage(),
      ),
    ).then((_) {
      _initializeContests();
    });
  }

  // Enhanced join contest with team selection
  void _joinContest(Contest contest) {
    if (_userTeams.isEmpty) {
      // No teams available, navigate to create team
      _showCreateTeamDialog(contest);
    } else {
      // Show team selection dialog
      _showTeamSelectionDialog(contest);
    }
  }

  void _showCreateTeamDialog(Contest contest) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF1A1A1A),
          title: Text(
            'No Teams Available',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: Text(
            'You need to create a team before joining this contest. Would you like to create a team now?',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _navigateToCreateTeam();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF22C55E),
              ),
              child: Text('Create Team', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showTeamSelectionDialog(Contest contest) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF1A1A1A),
          title: Text(
            'Select Team',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: Container(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Choose a team to join the contest:',
                  style: TextStyle(color: Colors.white70),
                ),
                SizedBox(height: 16),
                Container(
                  height: 300,
                  child: ListView.builder(
                    itemCount: _userTeams.length,
                    itemBuilder: (context, index) {
                      final team = _userTeams[index];
                      return _buildTeamSelectionCard(team, contest);
                    },
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _navigateToCreateTeam();
                  },
                  icon: Icon(Icons.add, color: Colors.white),
                  label: Text('Create New Team', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF22C55E),
                    minimumSize: Size(double.infinity, 45),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTeamSelectionCard(UserTeam team, Contest contest) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          colors: [Color(0xFF2A2A2A), Color(0xFF1E1E1E)],
        ),
        border: Border.all(color: Colors.grey[700]!, width: 1),
      ),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Color(0xFF22C55E),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.sports_cricket, color: Colors.white, size: 20),
        ),
        title: Text(
          team.teamName?.toString() ?? 'Team ${_userTeams.indexOf(team) + 1}',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'C: ${team.captain?.toString() ?? 'N/A'} | VC: ${team.viceCaptain?.toString() ?? 'N/A'}',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
            Text(
              '${team.teamAName}: ${team.teamACount ?? 0} | ${team.teamBName}: ${team.teamBCount ?? 0}',
              style: TextStyle(color: Colors.white60, fontSize: 11),
            ),
          ],
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 16),
        onTap: () {
          Navigator.of(context).pop();
          _confirmJoinContest(contest, team);
        },
      ),
    );
  }

  void _confirmJoinContest(Contest contest, UserTeam team) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF1A1A1A),
          title: Text(
            'Confirm Join Contest',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Contest: ${contest.categoryTitle ?? 'Contest'}',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
              Text(
                'Entry Fee: ₹${contest.entryFee ?? 0}',
                style: TextStyle(color: Colors.white70),
              ),
              Text(
                'Prize Pool: ₹${contest.prizeMoney ?? 0}',
                style: TextStyle(color: Colors.white70),
              ),
              SizedBox(height: 12),
              Text(
                'Selected Team: ${team.teamName?.toString() ?? 'Team ${_userTeams.indexOf(team) + 1}'}',
                style: TextStyle(color: Color(0xFF22C55E), fontWeight: FontWeight.w600),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _processJoinContest(contest, team);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF22C55E),
              ),
              child: Text('Join Contest', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _processJoinContest(Contest contest, UserTeam team) {
    // TODO: Implement actual contest joining logic with the selected team
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Joined contest "${contest.categoryTitle}" with team "${team.teamName?.toString() ?? 'Team ${_userTeams.indexOf(team) + 1}'}"',
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ),
    );

    // Refresh data to update joined contests
    _refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Color(0xFF16213E),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${widget.fixture.teamAShort} vs ${widget.fixture.teamBShort}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              widget.fixture.matchTitle,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          if (_isAuthenticated)
            Container(
              margin: EdgeInsets.only(right: 16),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white30, width: 1),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.account_balance_wallet, color: Colors.white, size: 16),
                  SizedBox(width: 6),
                  Text('₹0', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
                  SizedBox(width: 8),
                  GestureDetector(
                    onTap: _refreshData,
                    child: Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.white30,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Icon(Icons.refresh, color: Colors.white, size: 14),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: Color(0xFF3730A3),
              unselectedLabelColor: Colors.grey[600],
              indicatorColor: Color(0xFF3730A3),
              indicatorWeight: 3,
              labelStyle: TextStyle(fontWeight: FontWeight.bold),
              tabs: [
                Tab(text: 'Contests (${_contests.length})'),
                Tab(text: 'My Teams (${_userTeams.length})'),
                Tab(text: 'My Contests (${_joinedContests.length})'),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? _buildLoadingState()
                : _errorMessage != null
                ? _buildErrorState()
                : TabBarView(
              controller: _tabController,
              children: [
                _buildContestsTab(),
                _buildMyTeamsTab(),
                _buildMyContestsTab(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _isAuthenticated
          ? Container(
        color: Color(0xFF1a1a1a),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => _tabController.animateTo(0),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[800],
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.emoji_events, size: 20),
                    SizedBox(width: 8),
                    Text('CONTESTS', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: _navigateToCreateTeam,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF22C55E),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, size: 20),
                    SizedBox(width: 8),
                    Text('CREATE TEAM', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ],
        ),
      )
          : null,
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF22C55E)),
          ),
          SizedBox(height: 16),
          Text(
            'Loading contests...',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.grey[400],
            ),
            SizedBox(height: 16),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
            SizedBox(height: 24),
            if (_errorMessage!.contains('login'))
              ElevatedButton(
                onPressed: _navigateToLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF22C55E),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text('Login'),
              )
            else
              ElevatedButton(
                onPressed: _refreshData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF22C55E),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text('Retry'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildContestsTab() {
    return Column(
      children: [
        _buildFilterSection(),
        Expanded(
          child: _contests.isEmpty
              ? _buildEmptyContestsState()
              : ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: _contests.length,
            itemBuilder: (context, index) {
              final contest = _contests[index];
              return _buildContestCard(contest);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMyTeamsTab() {
    return Column(
      children: [
        Expanded(
          child: _userTeams.isEmpty
              ? _buildEmptyTeamsState()
              : ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: _userTeams.length,
            itemBuilder: (context, index) {
              final team = _userTeams[index];
              return _buildUserTeamCard(team);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMyContestsTab() {
    return Column(
      children: [
        Expanded(
          child: _joinedContests.isEmpty
              ? _buildEmptyJoinedContestsState()
              : ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: _joinedContests.length,
            itemBuilder: (context, index) {
              final contest = _joinedContests[index];
              return _buildJoinedContestCard(contest);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFilterSection() {
    return Container(
      padding: EdgeInsets.all(16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            ..._filterOptions.map((filter) {
              return Padding(
                padding: EdgeInsets.only(right: 8),
                child: _buildFilterChip(filter, _selectedFilter == filter),
              );
            }).toList(),
            SizedBox(width: 8),
            Icon(Icons.filter_list, color: Colors.grey[600]),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = label;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFF22C55E) : Colors.grey[200],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[700],
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildContestCard(Contest contest) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row with guaranteed badge and entry fee
            Row(
              children: [
                if (contest.isGuaranteed) ...[
                  Icon(Icons.verified, color: Colors.green, size: 16),
                  SizedBox(width: 4),
                  Text(
                    'Guaranteed Prize Pool',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
                Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Color(0xFF22C55E),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '₹${contest.entryFee ?? 0}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),

            // Prize pool
            Text(
              '₹${contest.prizeMoney ?? 0}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8),

            // Spots information
            Row(
              children: [
                Text(
                  contest.spotsLeft > 0 && contest.spotsLeft < 10
                      ? '${contest.spotsLeft} spots left'
                      : contest.spotsLeft <= 0
                      ? 'Contest Full'
                      : '${contest.spotsLeft} Left',
                  style: TextStyle(
                    color: contest.spotsLeft > 0 && contest.spotsLeft < 10
                        ? Colors.red
                        : contest.spotsLeft <= 0
                        ? Colors.grey[600]
                        : Colors.red,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Spacer(),
                Text(
                  '${contest.totalTeams ?? 0} Spots',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),

            // Progress bar
            Container(
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: LinearProgressIndicator(
                  value: contest.fillPercentage,
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    contest.fillPercentage > 0.8 ? Colors.red : Colors.green,
                  ),
                ),
              ),
            ),
            SizedBox(height: 12),

            // Bottom row with icons and info
            Row(
              children: [
                Icon(Icons.emoji_events, color: Colors.orange, size: 16),
                SizedBox(width: 4),
                Text(
                  '₹${((contest.prizeMoney ?? 0) ~/ (contest.totalWinners ?? 1))}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 16),
                Icon(Icons.people, color: Colors.green, size: 16),
                SizedBox(width: 4),
                Text(
                  '${contest.totalWinners ?? 0} Winners',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (contest.isPaidContest) ...[
                  SizedBox(width: 16),
                  Icon(Icons.person, color: Colors.blue, size: 16),
                  SizedBox(width: 4),
                  Text(
                    'Paid',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
                Spacer(),
                // Join button
                Container(
                  decoration: BoxDecoration(
                    color: contest.spotsLeft > 0 ? Color(0xFF22C55E) : Colors.grey[400],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: TextButton(
                    onPressed: contest.spotsLeft > 0 ? () => _joinContest(contest) : null,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      minimumSize: Size(0, 0),
                    ),
                    child: Text(
                      contest.spotsLeft > 0 ? 'Join' : 'Full',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserTeamCard(UserTeam team) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color(0xFF22C55E),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.sports_cricket,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        team.teamName?.toString() ?? 'Team ${_userTeams.indexOf(team) + 1}',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Created Team',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey[400],
                  size: 16,
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        '${team.teamACount ?? 0}',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        team.teamAName?.toString() ?? 'Team A',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 1,
                  height: 25,
                  color: Colors.grey[300],
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        '${team.teamBCount ?? 0}',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        team.teamBName?.toString() ?? 'Team B',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'C',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            team.captain?.toString() ?? 'N/A',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'VC',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            team.viceCaptain?.toString() ?? 'N/A',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyTeamsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.sports_cricket,
            size: 80,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            "You haven't created a team yet!",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'The first step to winning starts here.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: _navigateToCreateTeam,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF22C55E),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add, size: 20),
                SizedBox(width: 8),
                Text(
                  'CREATE A TEAM',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyContestsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.emoji_events_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            'No contests available',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Contests will be available closer to the match.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyJoinedContestsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.sports_cricket,
            size: 80,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            "You haven't joined a contest yet!",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Find a contest to join and start winning',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => _tabController.animateTo(0),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF22C55E),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'JOIN A CONTEST',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJoinedContestCard(JoinedContest contest) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Color(0xFF22C55E), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.check_circle, color: Color(0xFF22C55E), size: 16),
              SizedBox(width: 4),
              Text(
                'Joined',
                style: TextStyle(
                  color: Color(0xFF22C55E),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Spacer(),
              Text(
                '₹${contest.entryFee ?? 0}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Text(
                '₹${contest.prizeMoney ?? 0}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              Text(
                '${contest.teamsJoined ?? 0}/${contest.totalTeams ?? 0} spots',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          LinearProgressIndicator(
            value: (contest.teamsJoined ?? 0) / (contest.totalTeams ?? 1),
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF22C55E)),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.emoji_events, color: Colors.orange, size: 16),
              SizedBox(width: 4),
              Text(
                '₹${(contest.prizeMoney ?? 0) ~/ (contest.totalWinners ?? 1)}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 16),
              Icon(Icons.people, color: Colors.green, size: 16),
              SizedBox(width: 4),
              Text(
                '${contest.totalWinners ?? 0} Winners',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}