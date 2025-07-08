import 'package:flutter/material.dart';
import 'package:fantasy/body/scorecard.dart';
import 'package:fantasy/body/player_stats.dart';
import 'package:fantasy/body/leaderboard.dart';
import 'package:fantasy/body/team_preview.dart';
import 'package:fantasy/api/leaderboard_api.dart';

class MatchDetailsPage extends StatefulWidget {
  final Map<String, dynamic> matchData;

  const MatchDetailsPage({
    Key? key,
    required this.matchData,
  }) : super(key: key);

  @override
  State<MatchDetailsPage> createState() => _MatchDetailsPageState();
}

class _MatchDetailsPageState extends State<MatchDetailsPage> {
  Map<String, dynamic>? userTeamsData;
  List<Map<String, dynamic>> topLeaderboard = [];
  bool isLoadingTeams = true;
  String? teamsError;
  String? contestId; // Add contest ID storage

  @override
  void initState() {
    super.initState();
    _fetchUserTeams();
  }

  Future<void> _fetchUserTeams() async {
    try {
      setState(() {
        isLoadingTeams = true;
        teamsError = null;
      });

      final matchId = widget.matchData['id'].toString();

      // First, get the contest ID from joined contests
      contestId = await LeaderboardApi.getFirstContestId(matchId: matchId);

      if (contestId == null) {
        setState(() {
          teamsError = 'No contests found for this match';
          isLoadingTeams = false;
        });
        return;
      }

      print('Using contest ID: $contestId for match: $matchId');

      // Fetch user teams summary with contest ID
      final userTeamsResponse = await LeaderboardApi.getUserTeamsSummary(
          matchId: matchId,
          contestId: contestId!
      );

      if (userTeamsResponse['status'] == true) {
        setState(() {
          userTeamsData = userTeamsResponse;

          // Set user teams as top performers (sorted by rank)
          if (userTeamsData != null && userTeamsData!['userTeams'] != null) {
            final userTeams = userTeamsData!['userTeams'] as List<Map<String, dynamic>>;

            // Remove duplicates based on teamId and sort by rank
            final Map<String, Map<String, dynamic>> uniqueTeams = {};
            for (final team in userTeams) {
              final teamKey = '${team['teamId']}_${team['teamNumber']}';
              if (!uniqueTeams.containsKey(teamKey)) {
                uniqueTeams[teamKey] = team;
              }
            }

            final uniqueTeamsList = uniqueTeams.values.toList();
            uniqueTeamsList.sort((a, b) => (a['rank'] as int).compareTo(b['rank'] as int));
            topLeaderboard = uniqueTeamsList.take(5).toList();

            print('Unique teams found: ${uniqueTeamsList.length}');
            for (final team in topLeaderboard) {
              print('Team: ${team['teamName']}, Rank: ${team['rank']}, TeamNumber: ${team['teamNumber']}');
            }
          }

          isLoadingTeams = false;
        });
      } else {
        setState(() {
          teamsError = userTeamsResponse['error'] ?? 'Failed to fetch user teams';
          isLoadingTeams = false;
        });
      }
    } catch (e) {
      setState(() {
        teamsError = 'Error: $e';
        isLoadingTeams = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1F2937)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Match Details',
          style: TextStyle(
            color: Color(0xFF1F2937),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _fetchUserTeams,
        color: const Color(0xFF3B82F6),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // Match Header
              _buildMatchHeader(),

              // My Teams
              _buildMyTeams(),

              // Action Buttons
              _buildActionButtons(),

              // Top Leaderboard
              _buildTopLeaderboard(),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMatchHeader() {
    final scorecard = widget.matchData['scorecard'];
    final team1Name = widget.matchData['team_a'] ?? 'Team A';
    final team2Name = widget.matchData['team_b'] ?? 'Team B';

    String winner = 'Match completed';
    if (scorecard != null && scorecard['winning_comment'] != null) {
      winner = scorecard['winning_comment'];
    }

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Teams Section
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                // Team 1
                Expanded(
                  child: _buildTeamCard(team1Name, true),
                ),

                // VS Section
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFF6B7280),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: const Center(
                          child: Text(
                            'VS',
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

                // Team 2
                Expanded(
                  child: _buildTeamCard(team2Name, false),
                ),
              ],
            ),
          ),

          // Match Result
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDF4),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'COMPLETED',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Flexible(
                  child: Text(
                    winner,
                    style: const TextStyle(
                      color: Color(0xFF059669),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
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

  Widget _buildTeamCard(String teamName, bool isFirstTeam) {
    return Column(
      children: [
        // Team Logo
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isFirstTeam
                  ? [const Color(0xFF3B82F6), const Color(0xFF1D4ED8)]
                  : [const Color(0xFFF59E0B), const Color(0xFFD97706)],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Text(
              isFirstTeam ? '🏏' : '🏆',
              style: const TextStyle(fontSize: 24),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Team Abbreviation
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: isFirstTeam
                ? const Color(0xFF3B82F6).withOpacity(0.1)
                : const Color(0xFFF59E0B).withOpacity(0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            _getTeamShort(teamName),
            style: TextStyle(
              color: isFirstTeam ? const Color(0xFF3B82F6) : const Color(0xFFF59E0B),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        const SizedBox(height: 8),

        // Team Name
        Text(
          teamName,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF6B7280),
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildMyTeams() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.groups_outlined,
                color: Color(0xFF8B5CF6),
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                'My Teams',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F2937),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          if (isLoadingTeams)
            _buildLoadingState()
          else if (teamsError != null)
            _buildErrorState()
          else if (userTeamsData != null)
              _buildTeamsInfo()
            else
              _buildNoDataState(),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: const Column(
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8B5CF6)),
            strokeWidth: 2,
          ),
          SizedBox(height: 12),
          Text(
            'Loading your teams...',
            style: TextStyle(
              color: Color(0xFF6B7280),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFECACA)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.info_outline,
            color: Color(0xFFDC2626),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Teams not found',
                  style: TextStyle(
                    color: Color(0xFFDC2626),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  teamsError ?? 'You may not have participated in this match',
                  style: TextStyle(
                    color: const Color(0xFFDC2626).withOpacity(0.8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoDataState() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: const Center(
        child: Text(
          'Team data not available',
          style: TextStyle(
            color: Color(0xFF6B7280),
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildTeamsInfo() {
    final userTeams = userTeamsData!['userTeams'] as List<Map<String, dynamic>>;
    final summary = userTeamsData!['summary'] as Map<String, dynamic>;

    if (userTeams.isEmpty) {
      return _buildNoDataState();
    }

    return Column(
      children: [
        // Summary Row
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF8B5CF6).withOpacity(0.05),
                const Color(0xFF8B5CF6).withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF8B5CF6).withOpacity(0.2)),
          ),
          child: Column(
            children: [
              // Top Row: Total Teams and Best Rank
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'TOTAL TEAMS',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF6B7280),
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${summary['totalTeams']}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF8B5CF6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (summary['bestRank'] != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'BEST RANK',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF6B7280),
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '#${summary['bestRank']}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF10B981),
                          ),
                        ),
                      ],
                    ),
                ],
              ),

              const SizedBox(height: 16),
              const Divider(color: Color(0xFFE5E7EB), height: 1),
              const SizedBox(height: 16),

              // Bottom Row: Total Points and Winnings
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'TOTAL POINTS',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF6B7280),
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${summary['totalPoints']?.toStringAsFixed(1) ?? '0.0'}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if ((summary['totalWinnings'] ?? 0) > 0)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'WINNINGS',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF6B7280),
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF59E0B),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '₹${summary['totalWinnings']}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
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

        // Teams in Winning Zone indicator
        if (summary['teamsInWinningZone'] > 0) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${summary['teamsInWinningZone']} team${summary['teamsInWinningZone'] > 1 ? 's' : ''} in winning zone',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildActionButtons() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _buildActionButton(
              'View Scorecard',
              Icons.leaderboard,
              const Color(0xFF3B82F6),
              false,
                  () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ScorecardPage(
                    matchId: widget.matchData['id'].toString(),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildActionButton(
              'Player Stats',
              Icons.analytics_outlined,
              const Color(0xFF3B82F6),
              true,
                  () => Navigator.push(
                context,
                    MaterialPageRoute(
                      builder: (context) => PlayerStatsPage(
                        matchId: widget.matchData['id'].toString(),
                        contestId: contestId!,
                      ),
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon, Color color, bool isOutlined, VoidCallback onTap) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: isOutlined ? Colors.white : color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 1.5),
        boxShadow: isOutlined ? [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ] : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isOutlined ? color : Colors.white,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: isOutlined ? color : Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopLeaderboard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'My Teams Performance',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F2937),
                ),
              ),
              TextButton(
                onPressed: () {
                  if (contestId != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LeaderboardPage(
                          matchId: widget.matchData['id'].toString(),
                          contestId: contestId!,
                        ),
                      ),
                    );
                  } else {
                    // Fallback if no contest ID available
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Unable to load leaderboard. Contest not found.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: const Text(
                  'View All',
                  style: TextStyle(
                    color: Color(0xFF3B82F6),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          if (topLeaderboard.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'No teams found for this match',
                  style: TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 14,
                  ),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: topLeaderboard.length > 5 ? 5 : topLeaderboard.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final team = topLeaderboard[index];
                return _buildMyTeamItem(team);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildMyTeamItem(Map<String, dynamic> team) {
    final Color rankColor = _getRankColor(team['rank'] ?? 0);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          // Team Number Badge
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFF8B5CF6),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                'T${team['teamNumber'] ?? '?'}',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Team Name
          Expanded(
            child: Text(
              team['teamName'] ?? 'My Team',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1F2937),
              ),
            ),
          ),

          // Points
          Text(
            '${team['points'] ?? 0}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F2937),
            ),
          ),

          const SizedBox(width: 16),

          // Rank
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: rankColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '#${team['rank'] ?? 0}',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboardItem(Map<String, dynamic> entry, int rank) {
    final Color rankColor = _getRankColor(rank);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: rankColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '#$rank',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry['team_name'] ?? 'Team $rank',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${entry['point'] ?? '0'} points',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),

          const Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Color(0xFF9CA3AF),
          ),
        ],
      ),
    );
  }

  String _getTeamShort(String teamName) {
    final words = teamName.split(' ');
    if (words.length >= 2) {
      return '${words[0][0]}${words[1][0]}'.toUpperCase();
    } else if (words.isNotEmpty) {
      return words[0].length >= 3
          ? words[0].substring(0, 3).toUpperCase()
          : words[0].toUpperCase();
    }
    return 'T';
  }

  Color _getRankColor(int rank) {
    if (rank <= 3) {
      switch (rank) {
        case 1: return const Color(0xFFD97706); // Gold
        case 2: return const Color(0xFF6B7280); // Silver
        case 3: return const Color(0xFFF59E0B); // Bronze
        default: return const Color(0xFF3B82F6); // Blue
      }
    } else if (rank <= 10) {
      return const Color(0xFF10B981); // Green for top 10
    } else if (rank <= 50) {
      return const Color(0xFF3B82F6); // Blue for top 50
    } else {
      return const Color(0xFF6B7280); // Gray for others
    }
  }
}