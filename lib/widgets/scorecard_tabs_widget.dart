// lib/widgets/scorecard_tabs_widget.dart
import 'package:flutter/material.dart';

class ScorecardTabsWidget extends StatefulWidget {
  final Map<String, dynamic>? scorecardData;

  const ScorecardTabsWidget({
    Key? key,
    this.scorecardData,
  }) : super(key: key);

  @override
  State<ScorecardTabsWidget> createState() => _ScorecardTabsWidgetState();
}

class _ScorecardTabsWidgetState extends State<ScorecardTabsWidget> {
  int selectedInningsIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.scorecardData == null || widget.scorecardData!['data'] == null) {
      return Container(
        color: Colors.white,
        child: const Center(
          child: Text(
            'No scorecard data available',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ),
      );
    }

    final data = widget.scorecardData!['data'];
    final innings = data['innings'] as List<dynamic>? ?? [];
    final teams = data['teams'] ?? {};

    if (innings.isEmpty) {
      return Container(
        color: Colors.white,
        child: const Center(
          child: Text(
            'Match not started yet',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ),
      );
    }

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // Innings Tabs
          _buildInningsTabs(innings, teams),

          // Scorecard Content
          Expanded(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: _buildScorecardContent(innings[selectedInningsIndex]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInningsTabs(List<dynamic> innings, Map<String, dynamic> teams) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        children: innings.asMap().entries.map((entry) {
          int index = entry.key;
          Map<String, dynamic> inning = entry.value;

          // Get the team name for this innings
          final teamAPIId = inning['bat']?['teamAPIId'];
          String teamName = 'Innings ${index + 1}';

          if (teamAPIId == teams['teamA']?['teamAPIId']) {
            teamName = teams['teamA']?['shortName'] ?? teams['teamA']?['name'] ?? 'Team A';
          } else if (teamAPIId == teams['teamB']?['teamAPIId']) {
            teamName = teams['teamB']?['shortName'] ?? teams['teamB']?['name'] ?? 'Team B';
          }

          final equations = inning['equations'] ?? {};
          final score = '${equations['totalRuns'] ?? 0}/${equations['totalWickets'] ?? 0}';
          final overs = '(${equations['overs'] ?? '0'} ov)';

          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedInningsIndex = index;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                decoration: BoxDecoration(
                  gradient: selectedInningsIndex == index
                      ? const LinearGradient(
                    colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
                  )
                      : null,
                ),
                child: Column(
                  children: [
                    Text(
                      teamName,
                      style: TextStyle(
                        color: selectedInningsIndex == index ? Colors.white : Colors.grey[600],
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$score $overs',
                      style: TextStyle(
                        color: selectedInningsIndex == index ? Colors.white70 : Colors.grey[500],
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildScorecardContent(Map<String, dynamic> inning) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Match Summary
        _buildMatchSummary(inning),

        const SizedBox(height: 24),

        // Batting Section
        _buildBattingSection(inning),

        const SizedBox(height: 24),

        // Bowling Section
        _buildBowlingSection(inning),

        const SizedBox(height: 24),

        // Extras Section
        _buildExtrasSection(inning),

        const SizedBox(height: 24),

        // Fall of Wickets Section
        _buildFallOfWicketsSection(inning),

        // Bottom padding for better scrolling
        const SizedBox(height: 100),
      ],
    );
  }

  Widget _buildMatchSummary(Map<String, dynamic> inning) {
    final equations = inning['equations'] ?? {};
    final extras = inning['extras'] ?? {};

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Innings Summary',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSummaryItem('Total', '${equations['totalRuns'] ?? 0}'),
              _buildSummaryItem('Wickets', '${equations['totalWickets'] ?? 0}'),
              _buildSummaryItem('Overs', '${equations['overs'] ?? '0'}'),
              _buildSummaryItem('Run Rate', '${equations['runrate'] ?? '0.0'}'),
              _buildSummaryItem('Extras', '${extras['total'] ?? 0}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF3B82F6),
          ),
        ),
        const SizedBox(height: 4),
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

  Widget _buildBattingSection(Map<String, dynamic> inning) {
    final battingData = _getBattingDataFromAPI(inning);

    if (battingData.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
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
          // Batting Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: const Text(
              'Batting',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),

          // Batting Table Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
            ),
            child: const Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'BATTER',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: Color(0xFF374151),
                    ),
                  ),
                ),
                SizedBox(
                  width: 30,
                  child: Text('R', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12), textAlign: TextAlign.center),
                ),
                SizedBox(
                  width: 30,
                  child: Text('B', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12), textAlign: TextAlign.center),
                ),
                SizedBox(
                  width: 30,
                  child: Text('4s', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12), textAlign: TextAlign.center),
                ),
                SizedBox(
                  width: 30,
                  child: Text('6s', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12), textAlign: TextAlign.center),
                ),
                SizedBox(
                  width: 50,
                  child: Text('S/R', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12), textAlign: TextAlign.center),
                ),
              ],
            ),
          ),

          // Batting Rows
          ...battingData.map((player) => _buildBattingRow(player)),
        ],
      ),
    );
  }

  Widget _buildBattingRow(Map<String, dynamic> player) {
    final isNotOut = player['outType'] == 'Not out';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: isNotOut ? Colors.green : Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        player['name'] ?? '',
                        style: TextStyle(
                          fontWeight: isNotOut ? FontWeight.w600 : FontWeight.w500,
                          fontSize: 14,
                          color: isNotOut ? Colors.blue : Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 30,
                child: Text(
                  '${player['runs']}',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                width: 30,
                child: Text(
                  '${player['balls']}',
                  style: const TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                width: 30,
                child: Text(
                  '${player['fours']}',
                  style: const TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                width: 30,
                child: Text(
                  '${player['sixes']}',
                  style: const TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                width: 50,
                child: Text(
                  '${player['strikeRate'].toStringAsFixed(1)}',
                  style: const TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          if (!isNotOut && player['dismissal'] != null && player['dismissal'] != '') ...[
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(left: 14),
              child: Text(
                player['dismissal'],
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBowlingSection(Map<String, dynamic> inning) {
    final bowlingData = _getBowlingDataFromAPI(inning);

    if (bowlingData.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
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
          // Bowling Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: const Text(
              'Bowling',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),

          // Bowling Table Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
            ),
            child: const Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'BOWLER',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: Color(0xFF374151),
                    ),
                  ),
                ),
                SizedBox(
                  width: 35,
                  child: Text('O', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12), textAlign: TextAlign.center),
                ),
                SizedBox(
                  width: 35,
                  child: Text('M', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12), textAlign: TextAlign.center),
                ),
                SizedBox(
                  width: 35,
                  child: Text('R', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12), textAlign: TextAlign.center),
                ),
                SizedBox(
                  width: 35,
                  child: Text('W', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12), textAlign: TextAlign.center),
                ),
                SizedBox(
                  width: 50,
                  child: Text('Econ', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12), textAlign: TextAlign.center),
                ),
              ],
            ),
          ),

          // Bowling Rows
          ...bowlingData.map((bowler) => _buildBowlingRow(bowler)),
        ],
      ),
    );
  }

  Widget _buildBowlingRow(Map<String, dynamic> bowler) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              bowler['name'] ?? '',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
          SizedBox(
            width: 35,
            child: Text(
              '${bowler['overs']}',
              style: const TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: 35,
            child: Text(
              '${bowler['maidens']}',
              style: const TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: 35,
            child: Text(
              '${bowler['runs']}',
              style: const TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: 35,
            child: Text(
              '${bowler['wickets']}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: bowler['wickets'] > 0 ? FontWeight.w600 : FontWeight.normal,
                color: bowler['wickets'] > 0 ? Colors.green : Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: 50,
            child: Text(
              '${bowler['economyRate'].toStringAsFixed(1)}',
              style: const TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExtrasSection(Map<String, dynamic> inning) {
    final extras = inning['extras'];
    if (extras == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Extras',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildExtrasItem('Byes', extras['byes']),
              _buildExtrasItem('Leg Byes', extras['legbyes']),
              _buildExtrasItem('Wides', extras['wides']),
              _buildExtrasItem('No Balls', extras['noballs']),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildExtrasItem('Penalty', extras['penalty']),
              const Spacer(),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Total: ${extras['total'] ?? 0}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExtrasItem(String label, dynamic value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          '${value ?? 0}',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.orange,
          ),
        ),
      ],
    );
  }

  Widget _buildFallOfWicketsSection(Map<String, dynamic> inning) {
    final fallOfWickets = inning['fallofWickets'] as List<dynamic>? ?? [];

    if (fallOfWickets.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.05),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: const Text(
              'Fall of Wickets',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),

          ...fallOfWickets.map((wicket) => _buildWicketRow(wicket)),
        ],
      ),
    );
  }

  Widget _buildWicketRow(Map<String, dynamic> wicket) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(
                '${wicket['wicketOrder'] ?? '?'}',
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
            child: Text(
              wicket['name'] ?? 'Unknown Player',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            '${wicket['score']}/${wicket['wicketOrder']}',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.red,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '(${wicket['overs']} ov)',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods to parse API data
  List<Map<String, dynamic>> _getBattingDataFromAPI(Map<String, dynamic> inning) {
    final battingData = inning['bat']?['team'];
    if (battingData == null || battingData is! List) return [];

    return battingData.map<Map<String, dynamic>>((player) {
      final isOut = player['outType']?['outComment'] != null &&
          player['outType']['outComment'] != 'Not out';

      return {
        'name': player['playerName'] ?? 'Unknown Player',
        'dismissal': player['outType']?['outComment'] ?? '',
        'runs': _parseInt(player['runsScored']),
        'balls': _parseInt(player['ballsFaced']),
        'fours': _parseInt(player['foursHit']),
        'sixes': _parseInt(player['sixesHit']),
        'strikeRate': _parseDouble(player['strikeRate']),
        'outType': player['outType']?['outComment'] ?? 'Not out',
      };
    }).toList();
  }

  List<Map<String, dynamic>> _getBowlingDataFromAPI(Map<String, dynamic> inning) {
    final bowlingData = inning['bowl']?['team'];
    if (bowlingData == null || bowlingData is! List) return [];

    return bowlingData.map<Map<String, dynamic>>((bowler) {
      return {
        'name': bowler['playerName'] ?? 'Unknown Bowler',
        'overs': _parseDouble(bowler['oversBowled']),
        'maidens': _parseInt(bowler['maidensBowled']),
        'runs': _parseInt(bowler['runsGiven']),
        'wickets': _parseInt(bowler['wicketsTaken']),
        'economyRate': _parseDouble(bowler['economy']),
      };
    }).toList();
  }

  int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    if (value is double) return value.toInt();
    return 0;
  }

  double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
}