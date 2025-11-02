// lib/widgets/player_stats_widget.dart
import 'package:flutter/material.dart';

class PlayerStatsWidget extends StatefulWidget {
  final Map<String, dynamic>? playerStatsData;
  final Map<String, dynamic>? scorecardData;
  final String? teamFilter;

  const PlayerStatsWidget({
    Key? key,
    this.playerStatsData,
    this.scorecardData,
    this.teamFilter,
  }) : super(key: key);

  @override
  State<PlayerStatsWidget> createState() => _PlayerStatsWidgetState();
}

class _PlayerStatsWidgetState extends State<PlayerStatsWidget> {
  String _sortBy = 'points'; // 'points', 'selection', 'runs'
  bool _sortAscending = false;

  @override
  Widget build(BuildContext context) {
    if (widget.playerStatsData == null ||
        widget.playerStatsData!['status'] != true) {
      return const Center(
        child: Text(
          'No player stats available',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      );
    }

    List<dynamic> playersData = widget.playerStatsData!['data'] ?? [];

    // Filter by team if specified
    if (widget.teamFilter != null) {
      playersData = playersData.where((player) {
        if (widget.teamFilter == 'team_a') {
          return player['team_a'] == true;
        } else if (widget.teamFilter == 'team_b') {
          return player['team_a'] == false;
        }
        return true;
      }).toList();
    }

    // Sort players
    playersData.sort((a, b) {
      switch (_sortBy) {
        case 'points':
          final aPoints = a['player_points'] ?? 0;
          final bPoints = b['player_points'] ?? 0;
          return _sortAscending ? aPoints.compareTo(bPoints) : bPoints.compareTo(aPoints);
        case 'selection':
          final aSelection = double.tryParse(
              a['selection_percent']?.toString().replaceAll(' %', '') ?? '0') ?? 0;
          final bSelection = double.tryParse(
              b['selection_percent']?.toString().replaceAll(' %', '') ?? '0') ?? 0;
          return _sortAscending ? aSelection.compareTo(bSelection) : bSelection.compareTo(aSelection);
        case 'runs':
          final aRuns = a['player_breakup']?['runs']?['actual'] ?? 0;
          final bRuns = b['player_breakup']?['runs']?['actual'] ?? 0;
          return _sortAscending ? aRuns.compareTo(bRuns) : bRuns.compareTo(aRuns);
        default:
          return 0;
      }
    });

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // Sort Options
          _buildSortOptions(),

          // Players List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: playersData.length,
              itemBuilder: (context, index) {
                return _buildPlayerCard(playersData[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSortOptions() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        children: [
          const Text(
            'Sort by: ',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 8),
          _buildSortChip('Points', 'points'),
          const SizedBox(width: 8),
          _buildSortChip('Selection %', 'selection'),
          const SizedBox(width: 8),
          _buildSortChip('Runs', 'runs'),
          const Spacer(),
          IconButton(
            onPressed: () {
              setState(() {
                _sortAscending = !_sortAscending;
              });
            },
            icon: Icon(
              _sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
              size: 20,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSortChip(String label, String value) {
    final isSelected = _sortBy == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _sortBy = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey[300]!,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[700],
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildPlayerCard(Map<String, dynamic> player) {
    final playerBreakup = player['player_breakup'] ?? {};
    final isInDreamTeam = player['in_dream_team'] ?? false;
    final isInContest = player['in_contest'] ?? false;
    final selectionPercent = player['selection_percent'] ?? '0%';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isInDreamTeam ? Colors.blue : Colors.grey[200]!,
          width: isInDreamTeam ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Player Header
          Row(
            children: [
              // Player Name and Team
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            player['player_name'] ?? '',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: player['team_a'] == true ? Colors.blue : Colors.green,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            player['team_a'] == true ? 'ENG' : 'SA',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        if (isInDreamTeam) ...[
                          Icon(Icons.star, color: Colors.blue, size: 16),
                          const SizedBox(width: 4),
                        ],
                        if (isInContest) ...[
                          Icon(Icons.check_circle, color: Colors.green, size: 16),
                          const SizedBox(width: 4),
                        ],
                        Text(
                          'Selected by $selectionPercent',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Points
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Text(
                      '${player['player_points'] ?? 0}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.blue,
                      ),
                    ),
                    const Text(
                      'PTS',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Performance Stats
          _buildPerformanceStats(playerBreakup),
        ],
      ),
    );
  }

  Widget _buildPerformanceStats(Map<String, dynamic> breakup) {
    final List<Map<String, dynamic>> stats = [];

    // Add batting stats
    final runs = breakup['runs'];
    final fours = breakup['fours'];
    final sixes = breakup['sixes'];
    final strikeRate = breakup['strke_rate'];

    if (runs != null && runs['actual'] > 0) {
      stats.add({
        'label': 'Runs',
        'value': '${runs['actual']}',
        'points': runs['points'],
      });
    }

    if (fours != null && fours['actual'] > 0) {
      stats.add({
        'label': '4s',
        'value': '${fours['actual']}',
        'points': fours['points'],
      });
    }

    if (sixes != null && sixes['actual'] > 0) {
      stats.add({
        'label': '6s',
        'value': '${sixes['actual']}',
        'points': sixes['points'],
      });
    }

    // Add bowling stats
    final wickets = breakup['wickets'];
    final maidens = breakup['maiden_overs'];
    final economy = breakup['economy'];

    if (wickets != null && wickets['actual'] > 0) {
      stats.add({
        'label': 'Wickets',
        'value': '${wickets['actual']}',
        'points': wickets['points'],
      });
    }

    if (maidens != null && maidens['actual'] > 0) {
      stats.add({
        'label': 'Maidens',
        'value': '${maidens['actual']}',
        'points': maidens['points'],
      });
    }

    // Add fielding stats
    final catches = breakup['catches'];
    final runOut = breakup['run_out'];

    if (catches != null && catches['actual'] > 0) {
      stats.add({
        'label': 'Catches',
        'value': '${catches['actual']}',
        'points': catches['points'],
      });
    }

    if (runOut != null && runOut['actual'] > 0) {
      stats.add({
        'label': 'Run Outs',
        'value': '${runOut['actual']}',
        'points': runOut['points'],
      });
    }

    // Starting XI points
    final starting11 = breakup['staring11'];
    if (starting11 != null && starting11['points'] > 0) {
      stats.add({
        'label': 'Playing XI',
        'value': '✓',
        'points': starting11['points'],
      });
    }

    // Bonus points
    final bonus = breakup['bonus'];
    if (bonus != null && bonus['points'] > 0) {
      stats.add({
        'label': 'Bonus',
        'value': '${bonus['points']}',
        'points': bonus['points'],
      });
    }

    if (stats.isEmpty) {
      return Text(
        'No performance data available',
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey[500],
          fontStyle: FontStyle.italic,
        ),
      );
    }

    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: stats.map((stat) => _buildStatChip(
        stat['label'],
        stat['value'],
        stat['points'],
      )).toList(),
    );
  }

  Widget _buildStatChip(String label, String value, int points) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: points > 0 ? Colors.green.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: points > 0 ? Colors.green.withOpacity(0.3) : Colors.grey.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label: $value',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: points > 0 ? Colors.green[700] : Colors.grey[600],
            ),
          ),
          if (points > 0) ...[
            const SizedBox(width: 4),
            Text(
              '(+$points)',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Colors.green[800],
              ),
            ),
          ],
        ],
      ),
    );
  }
}