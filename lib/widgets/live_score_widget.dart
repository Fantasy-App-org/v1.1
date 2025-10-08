// lib/widgets/live_score_widget.dart
import 'package:flutter/material.dart';

class LiveScoreWidget extends StatelessWidget {
  final Map<String, dynamic> scorecardData;

  const LiveScoreWidget({
    Key? key,
    required this.scorecardData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final data = scorecardData['data'] ?? {};
    final innings = data['innings'] as List<dynamic>? ?? [];

    if (innings.isEmpty) {
      return const SizedBox.shrink();
    }

    final currentInnings = innings.first as Map<String, dynamic>;
    final equations = currentInnings['equations'] ?? {};
    final batTeam = currentInnings['bat'] ?? {};
    final bowlTeam = currentInnings['bowl'] ?? {};
    final batPlayers = batTeam['team'] as List<dynamic>? ?? [];
    final bowlPlayers = bowlTeam['team'] as List<dynamic>? ?? [];

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Current Score Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Current Partnership',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'RR: ${equations['runrate'] ?? '0.00'}',
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Current Batsmen
          if (batPlayers.isNotEmpty) ...[
            ...batPlayers.where((player) =>
            player['outType']?['outComment'] == 'Not out'
            ).map((player) => _buildBatsmanCard(player)),

            const SizedBox(height: 16),

            // Partnership Info
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.withOpacity(0.2)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem('Runs', equations['totalRuns']?.toString() ?? '0'),
                  _buildStatItem('Wickets', equations['totalWickets']?.toString() ?? '0'),
                  _buildStatItem('Overs', equations['overs']?.toString() ?? '0.0'),
                ],
              ),
            ),

            const SizedBox(height: 16),
          ],

          // Current Bowler
          if (bowlPlayers.isNotEmpty) ...[
            const Text(
              'Current Bowler',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            _buildBowlerCard(bowlPlayers.last),
          ],
        ],
      ),
    );
  }

  Widget _buildBatsmanCard(Map<String, dynamic> player) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          // Player Name
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  player['playerName'] ?? '',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  player['outType']?['outComment'] ?? 'Not out',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          // Stats
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildBattingStatColumn('Runs', player['runsScored']?.toString() ?? '0'),
                _buildBattingStatColumn('Balls', player['ballsFaced']?.toString() ?? '0'),
                _buildBattingStatColumn('SR',
                    double.tryParse(player['strikeRate']?.toString() ?? '0')?.toStringAsFixed(1) ?? '0.0'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBowlerCard(Map<String, dynamic> player) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          // Player Name
          Expanded(
            flex: 2,
            child: Text(
              player['playerName'] ?? '',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),

          // Bowling Stats
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildBowlingStatColumn('O', player['oversBowled']?.toString() ?? '0'),
                _buildBowlingStatColumn('R', player['runsGiven']?.toString() ?? '0'),
                _buildBowlingStatColumn('W', player['wicketsTaken']?.toString() ?? '0'),
                _buildBowlingStatColumn('Econ',
                    double.tryParse(player['economy']?.toString() ?? '0')?.toStringAsFixed(1) ?? '0.0'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBattingStatColumn(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Colors.black,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildBowlingStatColumn(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
            color: Colors.black,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.blue,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}