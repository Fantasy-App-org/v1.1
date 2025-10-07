// lib/team_creation/contest_all_pages.dart
import 'package:flutter/material.dart';
import '../model/fixture.dart';
import '../model/contest.dart';
import '../model/joined_contest.dart';
import '../model/user_team.dart';
import '../model/wallet_balance.dart';
import '../service/contest_service.dart';
import '../service/team_service.dart';
import '../service/user_service.dart';
import '../service/wallet_check_service.dart';
import '../service/join_contest_service.dart';
import '../auth/login.dart';
import 'package:fantasy/team_creation/create_team.dart';
import 'package:fantasy/body/contest_details_page.dart';
import '../team_creation/team_preview_page.dart';
import '../team_creation/team_details.dart';

class ContestAllPage extends StatefulWidget {
  final FixtureModel fixture;

  const ContestAllPage({
    super.key,
    required this.fixture,
  });

  @override
  State<ContestAllPage> createState() => _ContestAllPageState();
}

class _ContestAllPageState extends State<ContestAllPage> with TickerProviderStateMixin {
  late TabController _tabController;

  // Services
  final ContestService _contestService = ContestService();
  final TeamService _teamService = TeamService();
  final UserService _userService = UserService();
  final WalletCheckService _walletCheckService = WalletCheckService();
  final JoinContestService _joinContestService = JoinContestService();

  // State management
  List<Contest> _contests = [];
  List<JoinedContest> _joinedContests = [];
  List<UserTeam> _userTeams = [];
  bool _isLoading = true;
  String? _errorMessage;
  bool _isAuthenticated = false;

  // Filter states
  String _selectedFilter = 'All';
  final List<String> _filterOptions = [
    'All',
    'Entry',
    'Prize Pool',
    'Spots',
    'Winners'
  ];

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

  // NEW METHOD: Check if a team is already joined to a specific contest
  bool _isTeamAlreadyJoined(UserTeam team, Contest contest) {
    // Find the joined contest for this specific contest
    final joinedContest = _joinedContests.firstWhere(
          (jc) => jc.contestId == contest.contestId,
      orElse: () => JoinedContest(), // Return empty if not found
    );

    // If no joined contest found, team is not joined
    if (joinedContest.contestId == null) return false;

    // Check if any of the team details match this team
    if (joinedContest.myTeamsDetails != null) {
      return joinedContest.myTeamsDetails!.any((teamDetail) =>
      teamDetail.teamId?.toString() == team.teamId?.toString() ||
          (teamDetail.capName == team.captain && teamDetail.vcName == team.viceCaptain)
      );
    }

    return false;
  }

  // NEW METHOD: Get available teams for a contest (excluding already joined teams)
  List<UserTeam> _getAvailableTeamsForContest(Contest contest) {
    return _userTeams.where((team) => !_isTeamAlreadyJoined(team, contest)).toList();
  }

  // NEW METHOD: Get already joined teams for a contest
  List<UserTeam> _getJoinedTeamsForContest(Contest contest) {
    return _userTeams.where((team) => _isTeamAlreadyJoined(team, contest)).toList();
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

      await Future.wait([
        _loadContests(matchId),
        _loadJoinedContests(matchId),
        _loadUserTeams(matchId, seriesId),
      ]);

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
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
        _contests = contests ?? []; // Ensure contests is never null
      });

      // Show popup if no contests are available
      if (_contests.isEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showNoContestsAvailableDialog();
        });
      }
    } catch (e) {
      // Log the actual error for debugging
      print('Contest loading error: $e');

      // Instead of showing technical error, show user-friendly message
      setState(() {
        _contests = [];
      });

      // Show popup for no contests
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showNoContestsAvailableDialog();
      });
    }
  }
  Future<void> _loadJoinedContests(int matchId) async {
    try {
      final joinedContests = await _contestService.getJoinedContestsForMatch(
        matchId: matchId,
      );
      setState(() {
        _joinedContests = joinedContests;
      });
    } catch (e) {
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
    } catch (e) {
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

  void _navigateToCopyTeam(UserTeam teamToCopy) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateTeamPage(
          fixture: widget.fixture,
          teamToCopy: teamToCopy, // Pass the team to copy
        ),
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

  void _joinContest(Contest contest) {
    // UPDATED: Check available teams first
    final availableTeams = _getAvailableTeamsForContest(contest);

    if (availableTeams.isEmpty) {
      _showNoTeamsAvailableDialog(contest);
    } else {
      _showMultiTeamSelectionDialog(contest);
    }
  }

  void _showNoContestsAvailableDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF1A1A1A),
                  const Color(0xFF2A2A2A),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFF22C55E).withValues(alpha: 0.3),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.5),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Animated cricket icon
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFF22C55E).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(
                      color: const Color(0xFF22C55E).withValues(alpha: 0.3),
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.sports_cricket,
                    size: 40,
                    color: Color(0xFF22C55E),
                  ),
                ),

                const SizedBox(height: 20),

                // Title
                const Text(
                  'Contests Coming Soon!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 12),

                // Subtitle
                Text(
                  'Stay tuned for upcoming contests',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),

                // Match info
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF22C55E).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${widget.fixture.teamAShort} vs ${widget.fixture.teamBShort}',
                    style: const TextStyle(
                      color: Color(0xFF22C55E),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Description
                Text(
                  'Contests will be available closer to the match time. Check back soon!',
                  style: TextStyle(
                    color: Colors.grey[300],
                    fontSize: 14,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 24),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                          'Okay',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _refreshData(); // Refresh to check for new contests
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF22C55E),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.refresh, size: 18),
                            SizedBox(width: 8),
                            Text(
                              'Refresh',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  // NEW METHOD: Show dialog when no teams are available
  void _showNoTeamsAvailableDialog(Contest contest) {
    final joinedTeams = _getJoinedTeamsForContest(contest);
    final hasTeams = _userTeams.isNotEmpty;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.info_outline, color: Colors.orange, size: 24),
              const SizedBox(width: 8),
              Text(
                hasTeams ? 'All Teams Already Joined' : 'No Teams Available',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                hasTeams
                    ? 'All your teams are already joined to this contest. You cannot join the same team to a contest multiple times.'
                    : 'You need to create a team before joining this contest.',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),

              if (hasTeams && joinedTeams.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  'Teams already in this contest:',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2A2A),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: joinedTeams.map((team) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          Icon(Icons.check_circle, color: Color(0xFF22C55E), size: 16),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Team ${team.teamName ?? 'Unknown'}',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )).toList(),
                  ),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _navigateToCreateTeam();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF22C55E),
              ),
              child: Text(
                hasTeams ? 'CREATE NEW TEAM' : 'CREATE TEAM',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showMultiTeamSelectionDialog(Contest contest) {
    // UPDATED: Get only available teams (not already joined)
    final availableTeams = _getAvailableTeamsForContest(contest);
    final joinedTeams = _getJoinedTeamsForContest(contest);

    // Track selected teams
    List<UserTeam> selectedTeams = [];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final totalCost = (contest.entryFee ?? 0) * selectedTeams.length;

            return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.all(16),
              child: Container(
                width: double.maxFinite,
                height: MediaQuery.of(context).size.height * 0.8,
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF22C55E),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.sports_cricket,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Select Teams',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                // UPDATED: Show availability info
                                Text(
                                  '${availableTeams.length} available${joinedTeams.isNotEmpty ? ' • ${joinedTeams.length} already joined' : ''}',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: const Color(0xFF22C55E),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Center(
                              child: Text(
                                '${selectedTeams.length}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Cost Summary
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A2A2A),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFF22C55E).withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Entry Fee: Pts${contest.entryFee ?? 0} × ${selectedTeams.length}',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Total Cost: Pts$totalCost',
                                    style: const TextStyle(
                                      color: Color(0xFF22C55E),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedTeams.clear();
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.withValues(alpha: 0.2),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: const Text(
                                        'Clear All',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        // UPDATED: Select all available teams only
                                        selectedTeams = List.from(availableTeams);
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF22C55E).withValues(alpha: 0.2),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: const Text(
                                        'Select All',
                                        style: TextStyle(
                                          color: Color(0xFF22C55E),
                                          fontSize: 11,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // UPDATED: Show already joined teams first (if any), then available teams
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: joinedTeams.length + availableTeams.length,
                        itemBuilder: (context, index) {
                          final bool isJoinedSection = index < joinedTeams.length;

                          if (isJoinedSection) {
                            // Show already joined teams (non-selectable)
                            final team = joinedTeams[index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: Colors.grey.withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.grey.withValues(alpha: 0.5),
                                  width: 1,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    // Already joined badge
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: const Center(
                                        child: Icon(
                                          Icons.check_circle,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                    ),

                                    const SizedBox(width: 16),

                                    // Team Details
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Team ${team.teamName ?? 'Unknown'}',
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'C: ${team.captain ?? 'Unknown'}',
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12,
                                            ),
                                          ),
                                          Text(
                                            'VC: ${team.viceCaptain ?? 'Unknown'}',
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Already joined indicator
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.withValues(alpha: 0.5),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: const Text(
                                        'ALREADY JOINED',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            // Show available teams (selectable)
                            final team = availableTeams[index - joinedTeams.length];
                            final isSelected = selectedTeams.contains(team);
                            final teamIndex = index - joinedTeams.length + 1;

                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: const Color(0xFF2A2A2A),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected
                                      ? const Color(0xFF22C55E)
                                      : Colors.grey.withValues(alpha: 0.3),
                                  width: isSelected ? 2 : 1,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    // Number Badge
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? const Color(0xFF22C55E)
                                            : Colors.grey,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Center(
                                        child: isSelected
                                            ? const Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 20,
                                        )
                                            : Text(
                                          '$teamIndex',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),

                                    const SizedBox(width: 16),

                                    // Team Details
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Team ${team.teamName ?? 'Unknown'}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'C: ${team.captain ?? 'Unknown'}',
                                            style: const TextStyle(
                                              color: Colors.white70,
                                              fontSize: 12,
                                            ),
                                          ),
                                          Text(
                                            'VC: ${team.viceCaptain ?? 'Unknown'}',
                                            style: const TextStyle(
                                              color: Colors.white70,
                                              fontSize: 12,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '${team.teamAName ?? 'ZIM'}: ${team.teamACount ?? 0} | ${team.teamBName ?? 'SL'}: ${team.teamBCount ?? 0}',
                                            style: const TextStyle(
                                              color: Colors.white60,
                                              fontSize: 11,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Select Button
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (isSelected) {
                                            selectedTeams.remove(team);
                                          } else {
                                            selectedTeams.add(team);
                                          }
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 8),
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? const Color(0xFF22C55E)
                                              : Colors.grey.withValues(alpha: 0.3),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          isSelected ? 'SELECTED' : 'SELECT',
                                          style: TextStyle(
                                            color: isSelected ? Colors.white : Colors.grey,
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),

                    // Bottom Buttons
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                              child: const Text(
                                'Cancel',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            flex: 2,
                            child: ElevatedButton(
                              onPressed: selectedTeams.isEmpty
                                  ? null
                                  : () {
                                Navigator.of(context).pop();
                                _confirmJoinMultipleContests(contest, selectedTeams);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: selectedTeams.isEmpty
                                    ? Colors.grey[600]
                                    : const Color(0xFF22C55E),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                selectedTeams.isEmpty
                                    ? 'SELECT TEAMS'
                                    : 'JOIN WITH ${selectedTeams.length} TEAM${selectedTeams.length == 1 ? '' : 'S'}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _confirmJoinMultipleContests(Contest contest, List<UserTeam> selectedTeams) async {
    final totalCost = (contest.entryFee ?? 0).toDouble() * selectedTeams.length;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
          content: const Row(
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF22C55E)),
              ),
              SizedBox(width: 20),
              Text(
                'Checking balance...',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        );
      },
    );

    try {
      final walletBalance = await _walletCheckService.getWalletBalance(
        entryFee: totalCost.toString(),
        contestId: (contest.contestId ?? 0).toString(),
      );

      Navigator.of(context).pop();
      _showMultiTeamBalanceConfirmationDialog(contest, selectedTeams, walletBalance, totalCost);
    } catch (e) {
      Navigator.of(context).pop();
      _showErrorDialog('Failed to fetch balance information: ${e.toString()}');
    }
  }

  void _showMultiTeamBalanceConfirmationDialog(Contest contest, List<UserTeam> selectedTeams, WalletBalance balance, double totalCost) {
    final hasSufficientBalance = balance.isSufficientForEntry(totalCost);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: hasSufficientBalance ? const Color(0xFF22C55E) : Colors.red,
              width: 2,
            ),
          ),
          title: Row(
            children: [
              Icon(
                hasSufficientBalance ? Icons.account_balance_wallet : Icons.warning,
                color: hasSufficientBalance ? const Color(0xFF22C55E) : Colors.red,
                size: 24,
              ),
              const SizedBox(width: 8),
              const Text(
                'MULTI-TEAM CONFIRMATION',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          content: Container(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Wallet Balance Section
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2A2A),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[700]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Available Balance: ${balance.formattedTotalAmount}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Entry Fee per team',
                            style: const TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                          Text(
                            'Pts${contest.entryFee?.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Number of teams',
                            style: const TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                          Text(
                            '${selectedTeams.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Divider(color: Colors.grey[600], height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total to Pay',
                            style: TextStyle(
                              color: Color(0xFF22C55E),
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Pts${totalCost.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Color(0xFF22C55E),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Contest Details Section
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2A2A),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Contest: ${contest.categoryTitle ?? 'Contest'}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Prize Pool: Pts${contest.prizeMoney ?? 0}',
                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Selected Teams: ${selectedTeams.length}',
                        style: const TextStyle(
                          color: Color(0xFF22C55E),
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Selected Teams List
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2A2A),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Teams joining:',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 120,
                        child: ListView.builder(
                          itemCount: selectedTeams.length,
                          itemBuilder: (context, index) {
                            final team = selectedTeams[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Row(
                                children: [
                                  Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: Color(0xFF22C55E),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${index + 1}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Team ${team.teamName ?? 'Unknown'}',
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'Pts${contest.entryFee?.toStringAsFixed(0)}',
                                    style: const TextStyle(
                                      color: Color(0xFF22C55E),
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                if (!hasSufficientBalance) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red, width: 1),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error, color: Colors.red, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Insufficient balance! You need Pts${(totalCost - balance.totalAmount).toStringAsFixed(2)} more.',
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 12),
                Text(
                  'By joining this contest with multiple teams, you accept Fantasy T&C and confirm that you are not a resident of Assam, Odisha, Telegana, Nagaland or Sikkim.',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: hasSufficientBalance
                  ? () {
                Navigator.of(context).pop();
                _processJoinMultipleContests(contest, selectedTeams);
              }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: hasSufficientBalance
                    ? const Color(0xFF22C55E)
                    : Colors.grey[600],
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                hasSufficientBalance
                    ? 'JOIN WITH ${selectedTeams.length} TEAMS'
                    : 'INSUFFICIENT BALANCE',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // NEW METHOD: Process multiple team joins
  void _processJoinMultipleContests(Contest contest, List<UserTeam> selectedTeams) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF22C55E)),
              ),
              const SizedBox(height: 16),
              Text(
                'Joining contest with ${selectedTeams.length} teams...',
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                'Please wait...',
                style: TextStyle(color: Colors.grey[400], fontSize: 12),
              ),
            ],
          ),
        );
      },
    );

    try {
      // Join each team individually to the contest
      List<String> successfulJoins = [];
      List<String> failedJoins = [];

      for (int i = 0; i < selectedTeams.length; i++) {
        final team = selectedTeams[i];

        try {
          final result = await _joinContestService.joinContest(
            fixture: widget.fixture,
            contest: contest,
            team: team,
          );

          if (_joinContestService.isJoinSuccessful(result)) {
            successfulJoins.add('Team ${team.teamName ?? 'Unknown'}');
          } else {
            failedJoins.add('Team ${team.teamName ?? 'Unknown'}: ${_joinContestService.getErrorMessage(result)}');
          }
        } catch (e) {
          failedJoins.add('Team ${team.teamName ?? 'Unknown'}: ${e.toString()}');
        }
      }

      Navigator.of(context).pop(); // Close loading dialog

      // Show results dialog
      _showMultiJoinResultsDialog(contest, selectedTeams, successfulJoins, failedJoins);

      // Refresh data if any joins were successful
      if (successfulJoins.isNotEmpty) {
        _refreshData();
      }

    } catch (e) {
      Navigator.of(context).pop();
      _showErrorDialog('Failed to join contest: ${e.toString()}');
    }
  }

  // NEW METHOD: Show multi-join results
  void _showMultiJoinResultsDialog(Contest contest, List<UserTeam> selectedTeams, List<String> successfulJoins, List<String> failedJoins) {
    final allSuccessful = failedJoins.isEmpty;
    final allFailed = successfulJoins.isEmpty;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: allSuccessful
                  ? const Color(0xFF22C55E)
                  : allFailed
                  ? Colors.red
                  : Colors.orange,
              width: 2,
            ),
          ),
          title: Row(
            children: [
              Icon(
                allSuccessful
                    ? Icons.check_circle
                    : allFailed
                    ? Icons.error
                    : Icons.warning,
                color: allSuccessful
                    ? const Color(0xFF22C55E)
                    : allFailed
                    ? Colors.red
                    : Colors.orange,
                size: 24,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  allSuccessful
                      ? 'All Teams Joined!'
                      : allFailed
                      ? 'Join Failed'
                      : 'Partial Success',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
          content: Container(
            width: double.maxFinite,
            constraints: const BoxConstraints(maxHeight: 400),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Summary
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2A2A),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Contest: ${contest.categoryTitle ?? 'Contest'}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Teams Selected:',
                              style: TextStyle(color: Colors.grey[400], fontSize: 12),
                            ),
                            Text(
                              '${selectedTeams.length}',
                              style: const TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Successfully Joined:',
                              style: TextStyle(color: Colors.grey[400], fontSize: 12),
                            ),
                            Text(
                              '${successfulJoins.length}',
                              style: const TextStyle(color: Color(0xFF22C55E), fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        if (failedJoins.isNotEmpty)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Failed:',
                                style: TextStyle(color: Colors.grey[400], fontSize: 12),
                              ),
                              Text(
                                '${failedJoins.length}',
                                style: const TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Successful joins
                  if (successfulJoins.isNotEmpty) ...[
                    Text(
                      'Successfully Joined (${successfulJoins.length}):',
                      style: const TextStyle(
                        color: Color(0xFF22C55E),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Color(0xFF22C55E).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Color(0xFF22C55E).withValues(alpha: 0.3)),
                      ),
                      child: Column(
                        children: successfulJoins.map((teamName) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            children: [
                              Icon(Icons.check_circle, color: Color(0xFF22C55E), size: 16),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  teamName,
                                  style: const TextStyle(color: Colors.white, fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        )).toList(),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Failed joins
                  if (failedJoins.isNotEmpty) ...[
                    Text(
                      'Failed to Join (${failedJoins.length}):',
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                      ),
                      child: Column(
                        children: failedJoins.map((error) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.error, color: Colors.red, size: 16),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  error,
                                  style: const TextStyle(color: Colors.white, fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        )).toList(),
                      ),
                    ),
                  ],

                  if (successfulJoins.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.blue, size: 16),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'You can view your joined teams in the "My Contests" tab.',
                              style: const TextStyle(
                                color: Colors.blue,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          actions: [
            if (allSuccessful)
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _tabController.animateTo(2); // Go to My Contests tab
                },
                child: const Text(
                  'View My Contests',
                  style: TextStyle(color: Color(0xFF22C55E)),
                ),
              ),

            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF22C55E),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: const Text(
                'OK',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showCreateTeamDialog(Contest contest) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
          title: const Text(
            'No Teams Available',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'You need to create a team before joining this contest. Would you like to create a team now?',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _navigateToCreateTeam();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF22C55E),
              ),
              child: const Text(
                  'Create Team', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showTeamSelectionDialog(Contest contest) {
    // UPDATED: Use available teams only
    final availableTeams = _getAvailableTeamsForContest(contest);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
          title: const Text(
            'Select Team',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: Container(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Choose a team to join the contest:',
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 16),
                Container(
                  height: 300,
                  child: ListView.builder(
                    itemCount: availableTeams.length,
                    itemBuilder: (context, index) {
                      final team = availableTeams[index];
                      return _buildTeamSelectionCard(team, contest);
                    },
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _navigateToCreateTeam();
                  },
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text(
                      'Create New Team', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF22C55E),
                    minimumSize: const Size(double.infinity, 45),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTeamSelectionCard(UserTeam team, Contest contest) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: const LinearGradient(
          colors: [Color(0xFF2A2A2A), Color(0xFF1E1E1E)],
        ),
        border: Border.all(color: Colors.grey[700]!, width: 1),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF22C55E),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
              Icons.sports_cricket, color: Colors.white, size: 20),
        ),
        title: Text(
          'Team ${team.teamName ?? 'Unknown'}',
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'C: ${team.captain ?? 'N/A'} | VC: ${team.viceCaptain ?? 'N/A'}',
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
            Text(
              '${team.teamAName ?? 'Team A'}: ${team.teamACount ?? 0} | ${team
                  .teamBName ?? 'Team B'}: ${team.teamBCount ?? 0}',
              style: const TextStyle(color: Colors.white60, fontSize: 11),
            ),
          ],
        ),
        trailing: const Icon(
            Icons.arrow_forward_ios, color: Colors.white70, size: 16),
        onTap: () {
          Navigator.of(context).pop();
          _confirmJoinContest(contest, team);
        },
      ),
    );
  }

  void _confirmJoinContest(Contest contest, UserTeam team) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
          content: const Row(
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF22C55E)),
              ),
              SizedBox(width: 20),
              Text(
                'Checking balance...',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        );
      },
    );

    try {
      final walletBalance = await _walletCheckService.getWalletBalance(
        entryFee: (contest.entryFee ?? 0).toString(),
        contestId: (contest.contestId ?? 0).toString(),
      );

      Navigator.of(context).pop();
      _showBalanceConfirmationDialog(contest, team, walletBalance);
    } catch (e) {
      Navigator.of(context).pop();
      _showErrorDialog('Failed to fetch balance information: ${e.toString()}');
    }
  }

  void _showBalanceConfirmationDialog(Contest contest, UserTeam team,
      WalletBalance balance) {
    final entryFee = contest.entryFee?.toDouble() ?? 0.0;
    final hasSufficientBalance = balance.isSufficientForEntry(entryFee);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: hasSufficientBalance ? const Color(0xFF22C55E) : Colors
                  .red,
              width: 2,
            ),
          ),
          title: Row(
            children: [
              Icon(
                hasSufficientBalance ? Icons.account_balance_wallet : Icons
                    .warning,
                color: hasSufficientBalance ? const Color(0xFF22C55E) : Colors
                    .red,
                size: 24,
              ),
              const SizedBox(width: 8),
              const Text(
                'CONFIRMATION',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          content: Container(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2A2A),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[700]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Unutilized balance + Winnings= ${balance
                            .formattedTotalAmount}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Entry',
                            style: TextStyle(
                                color: Colors.white70, fontSize: 12),
                          ),
                          Text(
                            'Pts${entryFee.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Divider(color: Colors.grey[600], height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'To Pay',
                            style: TextStyle(
                              color: Color(0xFF22C55E),
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Pts${entryFee.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Color(0xFF22C55E),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2A2A),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Contest: ${contest.categoryTitle ?? 'Contest'}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Prize Pool: Pts${contest.prizeMoney ?? 0}',
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 12),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Selected Team: Team ${team.teamName ?? 'Unknown'}',
                        style: const TextStyle(
                          color: Color(0xFF22C55E),
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                if (!hasSufficientBalance) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red, width: 1),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error, color: Colors.red, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Insufficient balance! You need Pts${(entryFee -
                                balance.totalAmount).toStringAsFixed(2)} more.',
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 12),
                Text(
                  'By joining this contest, you accept Fantasy T&C and confirm that you are not a resident of Assam,Odisha, Telegana, Nagaland or Sikkim.',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: hasSufficientBalance
                  ? () {
                Navigator.of(context).pop();
                _processJoinContest(contest, team);
              }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: hasSufficientBalance
                    ? const Color(0xFF22C55E)
                    : Colors.grey[600],
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                hasSufficientBalance ? 'JOIN CONTEST' : 'INSUFFICIENT BALANCE',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
          title: const Row(
            children: [
              Icon(Icons.error, color: Colors.red, size: 24),
              SizedBox(width: 8),
              Text(
                'Error',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: Text(
            message,
            style: const TextStyle(color: Colors.white70),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF22C55E),
              ),
              child: const Text('OK', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _processJoinContest(Contest contest, UserTeam team) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
          content: const Row(
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF22C55E)),
              ),
              SizedBox(width: 20),
              Text(
                'Joining contest...',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        );
      },
    );

    try {
      final result = await _joinContestService.joinContest(
        fixture: widget.fixture,
        contest: contest,
        team: team,
      );

      Navigator.of(context).pop();

      if (_joinContestService.isJoinSuccessful(result)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_joinContestService.getSuccessMessage(result)),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
        _refreshData();
      } else {
        _showErrorDialog(_joinContestService.getErrorMessage(result));
      }
    } catch (e) {
      Navigator.of(context).pop();
      _showErrorDialog('Failed to join contest: ${e.toString()}');
    }
  }

  void _showCopyTeamConfirmation(UserTeam teamToCopy) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.copy, color: const Color(0xFF22C55E), size: 24),
              const SizedBox(width: 8),
              const Text(
                'Copy Team',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create a new team with the same players as Team ${teamToCopy.teamName}?',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A2A),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[700]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Team ${teamToCopy.teamName}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'C: ${teamToCopy.captain} | VC: ${teamToCopy.viceCaptain}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${teamToCopy.teamAName}: ${teamToCopy.teamACount} | ${teamToCopy.teamBName}: ${teamToCopy.teamBCount}',
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: const Text(
                        'You can select different Captain and Vice Captain in the new team.',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _navigateToCopyTeam(teamToCopy);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF22C55E),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'COPY TEAM',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color(0xFF16213E),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${widget.fixture.teamAShort} vs ${widget.fixture.teamBShort}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              widget.fixture.matchTitle,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          if (_isAuthenticated)
            Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.24),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3), width: 1),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.account_balance_wallet, color: Colors.white,
                      size: 16),
                  const SizedBox(width: 6),
                  const Text('Pts0', style: TextStyle(color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500)),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _refreshData,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Icon(
                          Icons.refresh, color: Colors.white, size: 14),
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
              labelColor: const Color(0xFF3730A3),
              unselectedLabelColor: Colors.grey[600],
              indicatorColor: const Color(0xFF3730A3),
              indicatorWeight: 3,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold),
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
        color: const Color(0xFF1a1a1a),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => _tabController.animateTo(0),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[800],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.emoji_events, size: 20),
                    SizedBox(width: 8),
                    Text('CONTESTS',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: _navigateToCreateTeam,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF22C55E),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, size: 20),
                    SizedBox(width: 8),
                    Text('CREATE TEAM',
                        style: TextStyle(fontWeight: FontWeight.bold)),
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
    return const Center(
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
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    // Don't show technical errors to users - show friendly message instead
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                  color: Colors.orange.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.schedule,
                size: 50,
                color: Colors.orange,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Contests Not Available Yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 12),

            Text(
              'Contests will be available closer to the match. Please check back later!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
                height: 1.4,
              ),
            ),

            const SizedBox(height: 24),

            if (_errorMessage != null && _errorMessage!.contains('login'))
              ElevatedButton.icon(
                onPressed: _navigateToLogin,
                icon: const Icon(Icons.login, size: 20),
                label: const Text('Login'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF22C55E),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              )
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: _refreshData,
                    icon: const Icon(Icons.refresh, size: 20),
                    label: const Text('Refresh'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF22C55E),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  TextButton.icon(
                    onPressed: () => _tabController.animateTo(1),
                    icon: const Icon(Icons.add, size: 20),
                    label: const Text('Create Team'),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF22C55E),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                  ),
                ],
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
            padding: const EdgeInsets.all(16),
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
        if (_userTeams.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'You have ${_userTeams.length} team${_userTeams.length == 1
                  ? ''
                  : 's'}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        Expanded(
          child: _userTeams.isEmpty
              ? _buildEmptyTeamsState()
              : ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: _userTeams.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
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
        if (_joinedContests.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.emoji_events, color: Colors.orange, size: 20),
                const SizedBox(width: 8),
                Text(
                  'You have joined ${_joinedContests.length} contest${_joinedContests.length == 1 ? '' : 's'}',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        Expanded(
          child: _joinedContests.isEmpty
              ? _buildEmptyJoinedContestsState()
              : ListView.builder(
            padding: const EdgeInsets.all(16),
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
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            ..._filterOptions.map((filter) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _buildFilterChip(filter, _selectedFilter == filter),
              );
            }),
            const SizedBox(width: 8),
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF22C55E) : Colors.grey[200],
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
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ContestDetailPage(
                  fixture: widget.fixture,
                  contestId: contest.contestId ?? 0,
                ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (contest.isGuaranteed) ...[
                    const Icon(Icons.verified, color: Colors.green, size: 16),
                    const SizedBox(width: 4),
                    const Text(
                      'Guaranteed Prize Pool',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF22C55E),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Pts${contest.entryFee ?? 0}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              Row(
                children: [
                  Text(
                    'Pts${contest.prizeMoney ?? 0}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.info_outline,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Tap for details',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

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
                  const Spacer(),
                  Text(
                    '${contest.totalTeams ?? 0} Spots',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

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
              const SizedBox(height: 12),

              Row(
                children: [
                  const Icon(
                      Icons.emoji_events, color: Colors.orange, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    'Pts${((contest.prizeMoney ?? 0) ~/
                        (contest.totalWinners ?? 1))}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Icon(Icons.people, color: Colors.green, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    '${contest.totalWinners ?? 0} Winners',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (contest.isPaidContest) ...[
                    const SizedBox(width: 16),
                    const Icon(Icons.person, color: Colors.blue, size: 16),
                    const SizedBox(width: 4),
                    const Text(
                      'Paid',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                  const Spacer(),
                  GestureDetector(
                    onTap: contest.spotsLeft > 0
                        ? () {
                      return;
                    }
                        : null,
                    child: Container(
                      decoration: BoxDecoration(
                        color: contest.spotsLeft > 0
                            ? const Color(0xFF22C55E)
                            : Colors.grey[400],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: TextButton(
                        onPressed: contest.spotsLeft > 0
                            ? () => _joinContest(contest)
                            : null,
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 16,
                              vertical: 8),
                          minimumSize: const Size(0, 0),
                        ),
                        child: Text(
                          contest.spotsLeft > 0 ? 'Join' : 'Full',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserTeamCard(UserTeam team) {
    return GestureDetector(
      onTap: () => _navigateToFullTeamDetails(team),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              spreadRadius: 1,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF22C55E),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.sports_cricket,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Team ${team.teamName ?? 'Unknown'}',
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'Created Team',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Copy Team Button
                  Container(
                    margin: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => _showCopyTeamConfirmation(team),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.orange.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.orange.withValues(alpha: 0.3),
                          ),
                        ),
                        child: const Icon(
                          Icons.copy,
                          color: Colors.orange,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey[400],
                    size: 16,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          '${team.teamACount ?? 0}',
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          team.teamAName ?? 'Team A',
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
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          team.teamBName ?? 'Team B',
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
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
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
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'C',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              team.captain ?? 'N/A',
                              style: const TextStyle(
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
                    const SizedBox(width: 16),
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'VC',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              team.viceCaptain ?? 'N/A',
                              style: const TextStyle(
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
          const SizedBox(height: 16),
          Text(
            "You haven't created a team yet!",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'The first step to winning starts here.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _navigateToCreateTeam,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF22C55E),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Row(
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
          // Animated container
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF22C55E).withValues(alpha: 0.1),
                  const Color(0xFF22C55E).withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(60),
              border: Border.all(
                color: const Color(0xFF22C55E).withValues(alpha: 0.2),
                width: 2,
              ),
            ),
            child: const Icon(
              Icons.schedule,
              size: 60,
              color: Color(0xFF22C55E),
            ),
          ),

          const SizedBox(height: 24),

          const Text(
            'Contests Coming Soon',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            'Contests will be available closer to match time',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 8),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF22C55E).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${widget.fixture.teamAShort} vs ${widget.fixture.teamBShort}',
              style: const TextStyle(
                color: Color(0xFF22C55E),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(height: 32),

          ElevatedButton.icon(
            onPressed: _refreshData,
            icon: const Icon(Icons.refresh, size: 20),
            label: const Text(
              'Check Again',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF22C55E),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
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
          const SizedBox(height: 16),
          Text(
            "You haven't joined a contest yet!",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Join contests to see your team performance',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => _tabController.animateTo(0),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF22C55E),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'JOIN A CONTEST',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJoinedContestCard(JoinedContest contest) {
    final teamCount = contest.myTeamsDetails?.length ?? 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            Colors.grey[50]!,
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.15),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: const Color(0xFF22C55E).withValues(alpha: 0.3), width: 1.5),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            if (teamCount > 1) {
              _showMultipleTeamSelectionDialog(contest);
            } else if (teamCount == 1) {
              UserTeam? correspondingTeam = _findCorrespondingTeam(contest);
              if (correspondingTeam != null) {
                _showTeamPreviewDialog(correspondingTeam);
              } else {
                _showErrorDialog('No corresponding team found for this contest');
              }
            } else {
              _showErrorDialog('No teams found in this contest');
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF22C55E),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.check_circle, color: Colors.white, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            'JOINED',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Pts${contest.entryFee ?? 0}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Contest Name and Prize
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            contest.contestName ?? 'Contest ${contest.contestId}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.emoji_events, color: Colors.orange, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                'Prize Pool: Pts${contest.prizeMoney ?? 0}',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '$teamCount Team${teamCount == 1 ? '' : 's'}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF22C55E),
                          ),
                        ),
                        Text(
                          'Entered',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Progress Bar
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${contest.teamsJoined ?? 0} teams joined',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          '${contest.totalTeams ?? 0} spots',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: (contest.teamsJoined ?? 0) / (contest.totalTeams ?? 1),
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(
                            (contest.teamsJoined ?? 0) / (contest.totalTeams ?? 1) > 0.8
                                ? Colors.orange
                                : const Color(0xFF22C55E)
                        ),
                        minHeight: 6,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Bottom Row with Switch Team button
                Row(
                  children: [
                    Icon(Icons.people, color: Colors.blue, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '${contest.totalWinners ?? 0} Winners',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    const Spacer(),
                    // Switch Team button - only show if user has more than one team
                    if (_userTeams.length > 1 && teamCount == 1) ...[
                      GestureDetector(
                        onTap: () {
                          if (contest.myTeamsDetails != null && contest.myTeamsDetails!.isNotEmpty) {
                            _showSwitchTeamDialog(contest, contest.myTeamsDetails!.first);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.orange.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.orange.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.swap_horiz, color: Colors.orange, size: 14),
                              const SizedBox(width: 4),
                              Text(
                                'Switch',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF22C55E).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFF22C55E).withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.visibility, color: Color(0xFF22C55E), size: 14),
                          const SizedBox(width: 4),
                          Text(
                            'View',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF22C55E),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  UserTeam? _findTeamByDetails(MyTeamDetails teamDetail) {
    print('\nFound team by details:');
    print('Looking for Team ID: ${teamDetail.teamId}');
    print('Available user teams: ${_userTeams.length}');

    for (UserTeam userTeam in _userTeams) {
      print('Checking user team: ${userTeam.teamName}, ID: ${userTeam.teamId}');

      // Match by team ID (convert both to string for comparison)
      if (userTeam.teamId?.toString() == teamDetail.teamId?.toString()) {
        print('✅ Found matching team by ID: ${userTeam.teamName}');
        return userTeam;
      }

      // Match by captain and VC names
      if (userTeam.captain?.toString() == teamDetail.capName?.toString() &&
          userTeam.viceCaptain?.toString() == teamDetail.vcName?.toString()) {
        print('✅ Found matching team by Captain/VC: ${userTeam.teamName}');
        return userTeam;
      }
    }

    print('❌ No matching team found');
    return null;
  }

  UserTeam? _findCorrespondingTeam(JoinedContest contest) {
    print('\nFINDING CORRESPONDING TEAM');
    print('Contest teams: ${contest.myTeamsDetails?.length ?? 0}');
    print('Available user teams: ${_userTeams.length}');

    if (contest.myTeamsDetails == null || contest.myTeamsDetails!.isEmpty) {
      print('❌ No myTeamsDetails in contest');
      return _userTeams.isNotEmpty ? _userTeams.first : null;
    }

    // Try to match the first team detail (you might want to show all teams later)
    final contestTeamDetail = contest.myTeamsDetails!.first;
    print('Looking for team: ${contestTeamDetail.teamName}');
    print('Team ID: ${contestTeamDetail.teamId}');
    print('Captain: ${contestTeamDetail.capName}');

    // Match by team ID (convert both to string for comparison)
    for (UserTeam userTeam in _userTeams) {
      if (userTeam.teamId?.toString() == contestTeamDetail.teamId?.toString()) {
        print('✅ Found matching team by ID: ${userTeam.teamName}');
        return userTeam;
      }
    }

    // Match by captain and VC
    for (UserTeam userTeam in _userTeams) {
      if (userTeam.captain?.toString() == contestTeamDetail.capName?.toString() &&
          userTeam.viceCaptain?.toString() == contestTeamDetail.vcName?.toString()) {
        print('✅ Found matching team by Captain/VC: ${userTeam.teamName}');
        return userTeam;
      }
    }

    print('⚠️ No exact match found, returning first available team');
    return _userTeams.isNotEmpty ? _userTeams.first : null;
  }

  void _showMultipleTeamSelectionDialog(JoinedContest contest) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.sports_cricket, color: Color(0xFF22C55E), size: 24),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Your Teams in Contest',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Color(0xFF22C55E),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${contest.myTeamsDetails?.length ?? 0}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          content: Container(
            width: double.maxFinite,
            height: 400,
            child: ListView.builder(
              itemCount: contest.myTeamsDetails?.length ?? 0,
              itemBuilder: (context, index) {
                final teamDetail = contest.myTeamsDetails![index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Color(0xFF2A2A2A),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Color(0xFF22C55E).withValues(alpha: 0.3),
                    ),
                  ),
                  child: ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Color(0xFF22C55E),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      teamDetail.teamNameString,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'C: ${teamDetail.capName ?? 'Unknown'} | VC: ${teamDetail.vcName ?? 'Unknown'}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.orange, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              '${teamDetail.points ?? 0} pts',
                              style: const TextStyle(
                                color: Colors.green,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (teamDetail.rank != null && teamDetail.rank! > 0) ...[
                              const SizedBox(width: 12),
                              Icon(Icons.trending_up, color: Colors.blue, size: 14),
                              const SizedBox(width: 4),
                              Text(
                                'Rank ${teamDetail.rank}',
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                    trailing: PopupMenuButton<String>(
                      color: Color(0xFF2A2A2A),
                      icon: Icon(Icons.more_vert, color: Color(0xFF22C55E)),
                      onSelected: (value) {
                        Navigator.of(context).pop();
                        if (value == 'view') {
                          UserTeam? userTeam = _findTeamByDetails(teamDetail);
                          if (userTeam != null) {
                            _showTeamPreviewDialog(userTeam);
                          } else {
                            _showErrorDialog('Could not find corresponding team details');
                          }
                        } else if (value == 'switch') {
                          _showSwitchTeamDialog(contest, teamDetail);
                        }
                      },
                      itemBuilder: (BuildContext context) => [
                        PopupMenuItem<String>(
                          value: 'view',
                          child: Row(
                            children: [
                              Icon(Icons.visibility, color: Colors.white, size: 18),
                              const SizedBox(width: 8),
                              Text(
                                'View Team',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'switch',
                          child: Row(
                            children: [
                              Icon(Icons.swap_horiz, color: Color(0xFF22C55E), size: 18),
                              const SizedBox(width: 8),
                              Text(
                                'Switch Team',
                                style: TextStyle(color: Color(0xFF22C55E)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Close',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showTeamPreviewDialog(UserTeam team) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            constraints: const BoxConstraints(maxHeight: 600),
            child: JoinedTeamPreview(
              team: team,
              teamAShort: widget.fixture.teamAShort,
              teamBShort: widget.fixture.teamBShort,
              onTap: () {
                Navigator.of(context).pop();
                _navigateToFullTeamDetails(team);
              },
            ),
          ),
        );
      },
    );
  }

  void _navigateToFullTeamDetails(UserTeam team) async {
    if (team.teamId == null) {
      _showErrorDialog('Team ID is not available');
      return;
    }

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF22C55E)),
              ),
              const SizedBox(height: 16),
              const Text(
                'Loading team details...',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        );
      },
    );

    try {
      final teamIdString = team.teamId.toString();

      final detailedTeam = await _teamService.getUserTeamById(
        teamId: teamIdString,
        seriesId: widget.fixture.seriesId,
      );

      // Close loading dialog
      Navigator.of(context).pop();

      // Navigate to full team details with fixture parameter
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FullTeamDetailsPage(
            team: detailedTeam,
            teamAShort: widget.fixture.teamAShort,
            teamBShort: widget.fixture.teamBShort,
            fixture: widget.fixture, // Pass fixture for edit functionality
          ),
        ),
      ).then((result) {
        // Refresh data if team was edited
        if (result == true) {
          _refreshData();
        }
      });
    } catch (e) {
      // Close loading dialog
      Navigator.of(context).pop();

      _showErrorDialog('Failed to load team details: ${e.toString()}');
    }
  }

  void _showSwitchTeamDialog(JoinedContest contest, MyTeamDetails currentTeamDetail) {
    // Get available teams (exclude teams already used in this contest)
    final availableTeams = _userTeams.where((team) {
      // Check if this team is already used in the contest
      final isAlreadyUsed = contest.myTeamsDetails?.any((detail) =>
      detail.teamId?.toString() == team.teamId?.toString()) ?? false;
      return !isAlreadyUsed;
    }).toList();

    if (availableTeams.isEmpty) {
      _showErrorDialog('No other teams available for switching. Create a new team to switch.');
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.swap_horiz, color: Color(0xFF22C55E), size: 24),
              const SizedBox(width: 8),
              Text(
                'Switch Team',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Container(
            width: double.maxFinite,
            height: 400,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Current team info
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.remove_circle_outline, color: Colors.red, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Current: ${currentTeamDetail.teamNameString}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              'C: ${currentTeamDetail.capName} | VC: ${currentTeamDetail.vcName}',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                Text(
                  'Select new team:',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),

                // Available teams list
                Expanded(
                  child: ListView.builder(
                    itemCount: availableTeams.length,
                    itemBuilder: (context, index) {
                      final team = availableTeams[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Color(0xFF2A2A2A),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Color(0xFF22C55E).withValues(alpha: 0.3),
                          ),
                        ),
                        child: ListTile(
                          leading: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Color(0xFF22C55E),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text(
                                '${index + 1}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          title: Text(
                            'Team ${team.teamName ?? 'Unknown'}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'C: ${team.captain ?? 'Unknown'} | VC: ${team.viceCaptain ?? 'Unknown'}',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${team.teamAName ?? 'Team A'}: ${team.teamACount ?? 0} | ${team.teamBName ?? 'Team B'}: ${team.teamBCount ?? 0}',
                                style: const TextStyle(
                                  color: Colors.white60,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Color(0xFF22C55E),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'SELECT',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          onTap: () {
                            Navigator.of(context).pop();
                            _confirmSwitchTeam(contest, currentTeamDetail, team);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        );
      },
    );
  }

  void _confirmSwitchTeam(JoinedContest contest, MyTeamDetails currentTeamDetail, UserTeam newTeam) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.warning, color: Colors.orange, size: 24),
              const SizedBox(width: 8),
              Text(
                'Confirm Switch',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Are you sure you want to switch teams in this contest?',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),

              // Current team
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.remove, color: Colors.red, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          'FROM:',
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      currentTeamDetail.teamNameString,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'C: ${currentTeamDetail.capName} | VC: ${currentTeamDetail.vcName}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // New team
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Color(0xFF22C55E).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Color(0xFF22C55E).withValues(alpha: 0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.add, color: Color(0xFF22C55E), size: 16),
                        const SizedBox(width: 4),
                        Text(
                          'TO:',
                          style: const TextStyle(
                            color: Color(0xFF22C55E),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Team ${newTeam.teamName ?? 'Unknown'}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'C: ${newTeam.captain} | VC: ${newTeam.viceCaptain}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _processSwitchTeam(contest, currentTeamDetail, newTeam);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF22C55E),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: const Text(
                'SWITCH TEAM',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _processSwitchTeam(JoinedContest contest, MyTeamDetails currentTeamDetail, UserTeam newTeam) async {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1A1A),
          content: Row(
            children: [
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF22C55E)),
              ),
              const SizedBox(width: 20),
              const Text(
                'Switching team...',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        );
      },
    );

    try {
      final success = await _teamService.switchTeam(
        matchId: widget.fixture.id,
        contestId: contest.contestId ?? 0,
        oldTeamId: int.tryParse(currentTeamDetail.teamId?.toString() ?? '0') ?? 0,
        newTeamId: newTeam.teamId ?? 0,
      );

      // Close loading dialog
      Navigator.of(context).pop();

      if (success) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Team switched successfully!'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );

        // Refresh data
        await _refreshData();
      } else {
        _showErrorDialog('Failed to switch team. Please try again.');
      }
    } catch (e) {
      // Close loading dialog
      Navigator.of(context).pop();
      _showErrorDialog('Failed to switch team: ${e.toString()}');
    }
  }

}