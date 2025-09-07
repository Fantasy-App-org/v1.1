// lib/pages/live_match_scorecard.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:fantasy/model/fixture.dart';
import 'package:fantasy/model/scorecard_model.dart';
import 'package:fantasy/api/contest_api.dart';
import 'package:fantasy/api/contest_match_api.dart';
import 'package:fantasy/api/leaderboard_api.dart';
import 'package:fantasy/config/debug_config.dart';
import 'package:fantasy/widgets/match_header_widget.dart';
import 'package:fantasy/widgets/live_score_widget.dart';
import 'package:fantasy/widgets/player_stats_widget.dart';
import 'package:fantasy/widgets/scorecard_tabs_widget.dart';
import 'package:fantasy/body/leaderboard.dart';

class LiveMatchScorecardPage extends StatefulWidget {
  final FixtureModel match;
  final String? contestId; // Optional contest ID for player stats

  const LiveMatchScorecardPage({
    Key? key,
    required this.match,
    this.contestId,
  }) : super(key: key);

  @override
  State<LiveMatchScorecardPage> createState() => _LiveMatchScorecardPageState();
}

class _LiveMatchScorecardPageState extends State<LiveMatchScorecardPage>
    with TickerProviderStateMixin {
  ScorecardModel? _scorecard;
  Map<String, dynamic>? _fullScorecardData;
  Map<String, dynamic>? _playerStatsData;
  List<Map<String, dynamic>> _userTeams = [];
  int? _contestId;
  bool _isLoading = true;
  bool _isLoadingUserTeams = false;
  String? _errorMessage;
  Timer? _refreshTimer;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late TabController _tabController;

  // Track which detailed view is currently shown
  bool _showingDetailedView = false;
  String _currentDetailView = 'main'; // 'main', 'scorecard', 'stats'

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _tabController = TabController(length: 4, vsync: this);
    _initializeData();
    _startAutoRefresh();
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _pulseController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _setupAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  Future<void> _initializeData() async {
    await _getContestId();
    await _loadScorecard();
    if (_contestId != null) {
      await _loadUserTeams();
    }
  }

  Future<void> _getContestId() async {
    try {
      if (widget.contestId != null) {
        _contestId = widget.contestId as int?;
        return;
      }

      DebugConfig.debugPrint('Fetching contest ID for match: ${widget.match.id}');
      final contestId = await ContestApi.getContestIdByMatchId(widget.match.id);

      if (contestId != null) {
        setState(() {
          _contestId = contestId;
        });
        DebugConfig.debugPrint('Contest ID found: $contestId');
      } else {
        DebugConfig.debugPrint('No contest ID found for match: ${widget.match.id}');
      }
    } catch (e) {
      DebugConfig.debugPrint('Error getting contest ID: $e');
    }
  }

  Future<void> _loadUserTeams() async {
    if (_contestId == null) return;

    try {
      setState(() {
        _isLoadingUserTeams = true;
      });

      DebugConfig.debugPrint('Loading user teams for match: ${widget.match.id}, contest: $_contestId');

      final response = await LeaderboardApi.getUserTeamsSummary(
        matchId: widget.match.id.toString(),
        contestId: _contestId.toString(),
      );

      if (response['status'] == true && mounted) {
        setState(() {
          _userTeams = List<Map<String, dynamic>>.from(response['userTeams'] ?? []);
          _isLoadingUserTeams = false;
        });

        DebugConfig.debugPrint('Loaded ${_userTeams.length} user teams');
      } else {
        if (mounted) {
          setState(() {
            _userTeams = [];
            _isLoadingUserTeams = false;
          });
        }
        DebugConfig.debugPrint('Failed to load user teams: ${response['error']}');
      }
    } catch (e) {
      DebugConfig.debugPrint('Error loading user teams: $e');
      if (mounted) {
        setState(() {
          _userTeams = [];
          _isLoadingUserTeams = false;
        });
      }
    }
  }

  void _startAutoRefresh() {
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (mounted) {
        _loadScorecard(silent: true);
        if (_contestId != null) {
          _loadUserTeams();
        }
        // Also refresh detailed data if showing detailed view
        if (_showingDetailedView) {
          _loadDetailedData(silent: true);
        }
      }
    });
  }

  Future<void> _loadScorecard({bool silent = false}) async {
    try {
      if (!silent) {
        setState(() {
          _isLoading = true;
          _errorMessage = null;
        });
      }

      DebugConfig.debugPrint('Loading scorecard for match ID: ${widget.match.id}');

      final response = await ContestApi.getScorecard(widget.match.id.toString());

      if (response['status'] == true) {
        final scorecardData = ScorecardModel.fromJson(response['data']);

        if (mounted) {
          setState(() {
            _scorecard = scorecardData;
            _isLoading = false;
            _errorMessage = null;
          });
        }

        DebugConfig.debugPrint('Scorecard loaded successfully');
      } else {
        throw Exception(response['message'] ?? 'Failed to load scorecard');
      }
    } catch (e) {
      DebugConfig.debugPrint('Error loading scorecard: $e');

      if (mounted) {
        setState(() {
          _isLoading = false;
          if (!silent) {
            _errorMessage = e.toString();
          }
        });
      }
    }
  }

  Future<void> _loadDetailedData({bool silent = false}) async {
    if (!silent) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    try {
      // Load full scorecard first
      final fullScorecardResult = await ContestApi.getFullScorecard(widget.match.id.toString());

      // Load player stats second
      final playerStatsResult = await ContestMatchApi.getMatchPlayerStats(
        matchId: widget.match.id.toString(),
      );

      if (mounted) {
        setState(() {
          _fullScorecardData = fullScorecardResult;
          _playerStatsData = playerStatsResult;
          _isLoading = false;
          _errorMessage = null;
        });
      }
    } catch (e) {
      DebugConfig.debugPrint('Error loading detailed data: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          if (!silent) {
            _errorMessage = e.toString();
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1B3A),
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF1A1B3A),
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      leading: IconButton(
        onPressed: () {
          if (_showingDetailedView) {
            setState(() {
              _showingDetailedView = false;
              _currentDetailView = 'main';
            });
          } else {
            Navigator.pop(context);
          }
        },
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _showingDetailedView
                ? (_currentDetailView == 'scorecard' ? 'Full Scorecard' : 'Player Stats')
                : 'Live Match',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            widget.match.matchType,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
      actions: [
        if (_showingDetailedView) ...[
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () => _loadDetailedData(),
          ),
        ],
        AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _pulseAnimation.value,
              child: Container(
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
                  ),
                  borderRadius: BorderRadius.circular(12),
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
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'LIVE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildBody() {
    if (_isLoading && (_scorecard == null || (_showingDetailedView && _fullScorecardData == null))) {
      return _buildLoadingState();
    }

    if (_errorMessage != null && (_scorecard == null || (_showingDetailedView && _fullScorecardData == null))) {
      return _buildErrorState();
    }

    if (_showingDetailedView) {
      return _buildDetailedView();
    }

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildTeamsHeader(),
          const SizedBox(height: 24),
          _buildScorecard(),
          const SizedBox(height: 24),
          // User Teams Section
          if (_contestId != null) ...[
            _buildUserTeamsSection(),
            const SizedBox(height: 24),
          ],
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildUserTeamsSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2D3748), Color(0xFF1A202C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF10B981), Color(0xFF059669)],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.emoji_events,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'My Teams',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              if (_userTeams.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${_userTeams.length} Team${_userTeams.length > 1 ? 's' : ''}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),
          if (_isLoadingUserTeams)
            const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
              ),
            )
          else if (_userTeams.isEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.white70,
                    size: 20,
                  ),
                  SizedBox(width: 12),
                  Text(
                    'No teams found in this contest',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            )
          else
            Column(
              children: [
                // Show top 3 user teams or all if less than 3
                ...(_userTeams.take(3).map((team) => _buildUserTeamItem(team))),
                if (_userTeams.length > 3) ...[
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () => _showFullLeaderboard(),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '+${_userTeams.length - 3} more teams',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white70,
                            size: 14,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildUserTeamItem(Map<String, dynamic> team) {
    final rank = team['rank'] ?? 0;
    final points = team['points']?.toString() ?? '0';
    final teamNumber = team['teamNumber'] ?? 1;
    final winningAmount = team['winningAmount'] ?? 0;
    final inWinningZone = team['inWinningZone'] ?? false;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: inWinningZone ? const Color(0xFF10B981) : Colors.transparent,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Rank
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: rank <= 3
                  ? (rank == 1 ? const Color(0xFFD97706) :
              rank == 2 ? const Color(0xFF6B7280) :
              const Color(0xFFF59E0B))
                  : const Color(0xFF3B82F6),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '#$rank',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Team Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'T$teamNumber',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (inWinningZone)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'In Winning Zone',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '$points Pts',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                    if (winningAmount > 0) ...[
                      const SizedBox(width: 8),
                      Text(
                        '• ₹$winningAmount',
                        style: const TextStyle(
                          color: Color(0xFF10B981),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedView() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverToBoxAdapter(
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Match Header (converted to white theme)
                    if (_fullScorecardData != null)
                      _buildWhiteMatchHeader(),

                    // Live Score (converted to white theme)
                    if (_fullScorecardData != null)
                      _buildWhiteLiveScore(),
                  ],
                ),
              ),
            ),

            // Tabs (only show if we have player stats data)
            if (_currentDetailView == 'stats' && _playerStatsData != null)
              SliverPersistentHeader(
                delegate: _TabBarDelegate(
                  TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    labelColor: Colors.blue,
                    unselectedLabelColor: Colors.grey[600],
                    indicatorColor: Colors.blue,
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                    tabs: const [
                      Tab(text: 'All Players'),
                      Tab(text: 'Player Stats'),
                      Tab(text: 'Team A'),
                      Tab(text: 'Team B'),
                    ],
                  ),
                ),
                pinned: true,
              ),
          ];
        },
        body: Container(
          color: Colors.white,
          child: _currentDetailView == 'scorecard'
              ? ScorecardTabsWidget(scorecardData: _fullScorecardData)
              : _currentDetailView == 'stats' && _playerStatsData != null
              ? TabBarView(
            controller: _tabController,
            children: [
              ScorecardTabsWidget(scorecardData: _fullScorecardData),
              PlayerStatsWidget(
                playerStatsData: _playerStatsData,
                scorecardData: _fullScorecardData,
              ),
              PlayerStatsWidget(
                playerStatsData: _playerStatsData,
                scorecardData: _fullScorecardData,
                teamFilter: 'team_a',
              ),
              PlayerStatsWidget(
                playerStatsData: _playerStatsData,
                scorecardData: _fullScorecardData,
                teamFilter: 'team_b',
              ),
            ],
          )
              : const Center(
            child: Text(
              'Player stats require contest ID',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWhiteMatchHeader() {
    if (_fullScorecardData == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: MatchHeaderWidget(scorecardData: _fullScorecardData!),
    );
  }

  Widget _buildWhiteLiveScore() {
    if (_fullScorecardData == null) return const SizedBox.shrink();

    return LiveScoreWidget(scorecardData: _fullScorecardData!);
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3B82F6)),
          ),
          const SizedBox(height: 16),
          Text(
            _showingDetailedView ? 'Loading detailed data...' : 'Loading live scores...',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
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
          const Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          Text(
            _showingDetailedView ? 'Failed to load detailed data' : 'Failed to load scorecard',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _errorMessage ?? 'Unknown error occurred',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              if (_showingDetailedView) {
                _loadDetailedData();
              } else {
                _loadScorecard();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3B82F6),
            ),
            child: const Text(
              'Retry',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamsHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2D3748), Color(0xFF1A202C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(child: _buildTeamInfo(
            widget.match.teamA,
            widget.match.teamAShort,
            widget.match.teamAFlag,
            const Color(0xFF3B82F6),
            isTeamA: true,
          )),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Color(0xFF4A5568),
              shape: BoxShape.circle,
            ),
            child: const Text(
              'VS',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ),
          Expanded(child: _buildTeamInfo(
            widget.match.teamB,
            widget.match.teamBShort,
            widget.match.teamBFlag,
            const Color(0xFFEF4444),
            isTeamA: false,
          )),
        ],
      ),
    );
  }

  Widget _buildTeamInfo(String teamName, String teamShort, String? teamFlag, Color color, {required bool isTeamA}) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipOval(
            child: teamFlag != null && teamFlag.isNotEmpty
                ? Image.network(
              teamFlag,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return _buildFallbackTeamLogo(teamShort, color);
              },
            )
                : _buildFallbackTeamLogo(teamShort, color),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          teamShort,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        Text(
          teamName,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
          maxLines: 2,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildFallbackTeamLogo(String teamShort, Color color) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.8), color],
        ),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          teamShort,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  Widget _buildScorecard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2D3748), Color(0xFF1A202C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.leaderboard,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Scorecard',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildScoreBlock(
                widget.match.teamAShort,
                _scorecard?.teamAScore ?? '0/0',
                isLeft: true,
              ),
              Container(
                width: 1,
                height: 40,
                color: Colors.white24,
              ),
              _buildScoreBlock(
                widget.match.teamBShort,
                _scorecard?.teamBScore ?? '0/0',
                isLeft: false,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScoreBlock(String teamShort, String score, {required bool isLeft}) {
    return Expanded(
      child: Column(
        crossAxisAlignment: isLeft ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          Text(
            teamShort,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            score,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        _buildActionButton(
          icon: Icons.leaderboard_outlined,
          title: 'View Full Scorecard',
          subtitle: 'Complete match statistics',
          gradient: const LinearGradient(
            colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
          ),
          onTap: () {
            _showFullScorecard();
          },
        ),
        const SizedBox(height: 12),
        _buildActionButton(
          icon: Icons.bar_chart_outlined,
          title: 'View Player Stats',
          subtitle: 'Individual player performance',
          gradient: const LinearGradient(
            colors: [Color(0xFF10B981), Color(0xFF059669)],
          ),
          onTap: () {
            _showPlayerStats();
          },
        ),
        const SizedBox(height: 12),
        if (_contestId != null)
          _buildActionButton(
            icon: Icons.emoji_events_outlined,
            title: 'View Leaderboard',
            subtitle: 'Complete contest rankings',
            gradient: const LinearGradient(
              colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
            ),
            onTap: () {
              _showFullLeaderboard();
            },
          ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String title,
    required String subtitle,
    required LinearGradient gradient,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: gradient.colors.first.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  void _showFullScorecard() async {
    // Show loading dialog while fetching full scorecard
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        backgroundColor: Color(0xFF2D3748),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3B82F6)),
            ),
            SizedBox(height: 16),
            Text(
              'Loading full scorecard...',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );

    try {
      await _loadDetailedData();
      Navigator.pop(context); // Close loading dialog

      setState(() {
        _showingDetailedView = true;
        _currentDetailView = 'scorecard';
      });
    } catch (e) {
      Navigator.pop(context); // Close loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load scorecard: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showPlayerStats() async {
    // Show loading dialog while fetching player stats
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        backgroundColor: Color(0xFF2D3748),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
            ),
            SizedBox(height: 16),
            Text(
              'Loading player stats...',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );

    try {
      await _loadDetailedData();
      Navigator.pop(context); // Close loading dialog

      setState(() {
        _showingDetailedView = true;
        _currentDetailView = 'stats';
      });
    } catch (e) {
      Navigator.pop(context); // Close loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load player stats: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showFullLeaderboard() {
    if (_contestId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Contest information not available'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LeaderboardPage(
          matchId: widget.match.id.toString(),
          contestId: _contestId.toString(),
        ),
      ),
    );
  }
}

// Helper class for persistent tab bar
class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  _TabBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_TabBarDelegate oldDelegate) {
    return false;
  }
}