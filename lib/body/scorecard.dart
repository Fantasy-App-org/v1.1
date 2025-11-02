import 'package:flutter/material.dart';
import 'package:fantasy/api/contest_api.dart';

class ScorecardPage extends StatefulWidget {
  final String matchId;

  const ScorecardPage({
    Key? key,
    required this.matchId,
  }) : super(key: key);

  @override
  State<ScorecardPage> createState() => _ScorecardPageState();
}

class _ScorecardPageState extends State<ScorecardPage> {
  int selectedTeamIndex = 0;
  Map<String, dynamic>? scorecardData;
  bool isLoading = true;
  String? error;
  List<Map<String, dynamic>> teams = [];
  List<Map<String, dynamic>> innings = [];
  Map<String, dynamic>? matchInfo;

  @override
  void initState() {
    super.initState();
    _fetchScorecardData();
  }

  Future<void> _fetchScorecardData() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      print('Fetching scorecard data for match: ${widget.matchId}');

      final response = await ContestApi.getFullScorecard(widget.matchId);

      print('Scorecard API Response: ${response.toString()}');

      if (response['status'] == true) {
        setState(() {
          scorecardData = response['data'];

          if (scorecardData != null) {
            print('Scorecard data structure: ${scorecardData!.keys.toList()}');

            // Parse the correct team structure from API response
            _parseTeamsData();
            _parseInningsData();
            _parseMatchInfo();
          }

          isLoading = false;
        });
      } else {
        setState(() {
          error = response['message'] ?? response['error'] ?? 'Failed to load scorecard data';
          isLoading = false;
        });
        print('API returned error: ${response['message'] ?? response['error']}');
      }
    } catch (e) {
      setState(() {
        error = 'Error loading scorecard: $e';
        isLoading = false;
      });
      print('Error fetching scorecard: $e');
    }
  }

  void _parseTeamsData() {
    teams = [];

    if (scorecardData == null || scorecardData!['teams'] == null) return;

    final teamsData = scorecardData!['teams'];

    // Handle the correct API structure: teams.teamA and teams.teamB
    if (teamsData['teamA'] != null) {
      teams.add(teamsData['teamA']);
      print('Added Team A: ${teamsData['teamA']['name']}');
    }

    if (teamsData['teamB'] != null) {
      teams.add(teamsData['teamB']);
      print('Added Team B: ${teamsData['teamB']['name']}');
    }

    print('Total teams parsed: ${teams.length}');
  }

  void _parseInningsData() {
    innings = [];

    if (scorecardData == null || scorecardData!['innings'] == null) return;

    final inningsData = scorecardData!['innings'] as List<dynamic>;

    for (final inning in inningsData) {
      if (inning is Map<String, dynamic>) {
        innings.add(inning);
        print('Added innings ${inning['innings_number']}');
      }
    }

    print('Total innings parsed: ${innings.length}');
  }

  void _parseMatchInfo() {
    if (scorecardData == null) return;

    matchInfo = {
      'fixtureType': scorecardData!['fixtureType'] ?? 'Unknown',
      'fixtureStatus': scorecardData!['fixtureStatus'] ?? 'Unknown',
      'fixtureStatusNote': scorecardData!['fixtureStatusNote'] ?? '',
      'toss': scorecardData!['toss'],
    };

    print('Match info parsed: $matchInfo');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,
              color: Color(0xFF1F2937), size: 22),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Scorecard',
          style: TextStyle(
            color: Color(0xFF1F2937),
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Color(0xFF1F2937)),
            onPressed: _fetchScorecardData,
          ),
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, Color(0xFFF8FAFC)],
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF8FAFC), Color(0xFFF1F5F9)],
          ),
        ),
        child: isLoading
            ? const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2563EB)),
              ),
              SizedBox(height: 16),
              Text(
                'Loading scorecard...',
                style: TextStyle(
                  color: Color(0xFF6B7280),
                  fontSize: 16,
                ),
              ),
            ],
          ),
        )
            : error != null
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red[300],
              ),
              const SizedBox(height: 16),
              Text(
                error!,
                style: const TextStyle(
                  color: Color(0xFF6B7280),
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _fetchScorecardData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Retry'),
              ),
            ],
          ),
        )
            : RefreshIndicator(
          onRefresh: _fetchScorecardData,
          color: const Color(0xFF2563EB),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Match Header Card
                _buildMatchHeaderCard(),
                const SizedBox(height: 24),

                // Toss Information
                if (matchInfo?['toss'] != null) _buildTossCard(),
                if (matchInfo?['toss'] != null) const SizedBox(height: 20),

                // Scorecard Section
                if (teams.isNotEmpty && innings.isNotEmpty)
                  _buildScorecardSection()
                else
                  _buildNoDataCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNoDataCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.info_outline,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          const Text(
            'No scorecard data available',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'The scorecard data is not available for this match yet.',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF6B7280),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMatchHeaderCard() {
    if (teams.isEmpty && matchInfo == null) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              spreadRadius: 2,
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Text(
          'Match information not available',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF6B7280),
          ),
          textAlign: TextAlign.center,
        ),
      );
    }

    final team1 = teams.isNotEmpty ? teams[0] : null;
    final team2 = teams.length > 1 ? teams[1] : null;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            spreadRadius: 2,
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: const Color(0xFF6366F1).withOpacity(0.05),
            spreadRadius: 0,
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(
          color: const Color(0xFF6366F1).withOpacity(0.1),
        ),
      ),
      child: Column(
        children: [
          // Teams Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Team 1
              if (team1 != null) _buildTeamColumn(team1, Colors.orange),

              // VS
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'VS',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[500],
                  ),
                ),
              ),

              // Team 2
              if (team2 != null) _buildTeamColumn(team2, Colors.blue),
            ],
          ),

          const SizedBox(height: 24),

          // Match Status
          if (matchInfo != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: matchInfo!['fixtureStatus'] == 'Completed'
                      ? [const Color(0xFF10B981), const Color(0xFF059669)]
                      : [const Color(0xFFF59E0B), const Color(0xFFD97706)],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: (matchInfo!['fixtureStatus'] == 'Completed'
                        ? const Color(0xFF10B981)
                        : const Color(0xFFF59E0B))
                        .withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    matchInfo!['fixtureStatus'] == 'Completed'
                        ? Icons.check_circle
                        : Icons.schedule,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    matchInfo!['fixtureStatus'] ?? 'Unknown',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 16),

          // Result
          if (matchInfo != null && matchInfo!['fixtureStatusNote'] != null && matchInfo!['fixtureStatusNote'] != '')
            Text(
              matchInfo!['fixtureStatusNote'],
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF059669),
              ),
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }

  Widget _buildTeamColumn(Map<String, dynamic> team, MaterialColor color) {
    final teamName = team['name'] ?? team['shortName'] ?? 'Unknown Team';
    final teamScore = team['scores_full'] ?? team['scores'] ?? 'N/A';

    return Expanded(
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color[100]!, color[300]!],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              Icons.sports_cricket,
              color: color,
              size: 28,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            teamName,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F2937),
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            teamScore.toString(),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTossCard() {
    final toss = matchInfo!['toss'];
    if (toss == null) return const SizedBox.shrink();

    final tossText = toss['text'] ?? toss.toString();
    if (tossText == null || tossText.toString().isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.toll,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Toss',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  tossText.toString(),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScorecardSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            spreadRadius: 1,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Innings Tabs
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: innings.asMap().entries.map((entry) {
                int index = entry.key;
                Map<String, dynamic> inning = entry.value;

                // Get the team name for this innings
                final teamAPIId = inning['bat']?['teamAPIId'];
                final team = teams.firstWhere(
                      (t) => t['teamAPIId'] == teamAPIId,
                  orElse: () => {'name': 'Innings ${index + 1}'},
                );

                final teamName = team['shortName'] ?? team['name'] ?? 'Innings ${index + 1}';

                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedTeamIndex = index;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        gradient: selectedTeamIndex == index
                            ? const LinearGradient(
                          colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
                        )
                            : null,
                        borderRadius: BorderRadius.only(
                          topLeft: index == 0 ? const Radius.circular(16) : Radius.zero,
                          topRight: index == innings.length - 1 ? const Radius.circular(16) : Radius.zero,
                        ),
                      ),
                      child: Text(
                        teamName,
                        style: TextStyle(
                          color: selectedTeamIndex == index ? Colors.white : Colors.grey[600],
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // Batting Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.grey[50]!, Colors.grey[100]!],
              ),
              border: Border(
                bottom: BorderSide(color: Colors.grey[300]!),
              ),
            ),
            child: const Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'BATTER',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                ),
                SizedBox(
                  width: 30,
                  child: Text(
                    'R',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Color(0xFF1F2937),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  width: 30,
                  child: Text(
                    'B',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Color(0xFF1F2937),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  width: 30,
                  child: Text(
                    '4s',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Color(0xFF1F2937),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  width: 30,
                  child: Text(
                    '6s',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Color(0xFF1F2937),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  width: 50,
                  child: Text(
                    'S/R',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Color(0xFF1F2937),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),

          // Batting Data
          if (selectedTeamIndex < innings.length)
            ...getBattingDataFromAPI(innings[selectedTeamIndex])
                .map((player) => _buildBatterRow(player))
                .toList(),

          // Bowling Section
          const SizedBox(height: 20),
          _buildBowlingSection(),

          // Extras Section
          const SizedBox(height: 20),
          _buildExtrasSection(),

          // Fall of Wickets Section
          const SizedBox(height: 20),
          _buildFallOfWicketsSection(),
        ],
      ),
    );
  }

  Widget _buildBowlingSection() {
    if (selectedTeamIndex >= innings.length) return const SizedBox.shrink();

    final bowlingData = getBowlingDataFromAPI(innings[selectedTeamIndex]);
    if (bowlingData.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.grey[100]!, Colors.grey[200]!],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: const Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'BOWLER',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                ),
                SizedBox(
                  width: 30,
                  child: Text(
                    'O',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Color(0xFF1F2937),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  width: 30,
                  child: Text(
                    'M',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Color(0xFF1F2937),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  width: 30,
                  child: Text(
                    'R',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Color(0xFF1F2937),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  width: 30,
                  child: Text(
                    'W',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Color(0xFF1F2937),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  width: 50,
                  child: Text(
                    'ER',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Color(0xFF1F2937),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          ...bowlingData.map((bowler) => _buildBowlerRow(bowler)).toList(),
        ],
      ),
    );
  }

  Widget _buildBatterRow(Map<String, dynamic> player) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: player['isOut'] == true
                            ? Colors.red[400]
                            : const Color(0xFF10B981),
                        shape: BoxShape.circle,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        player['name'] ?? 'Unknown Player',
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                    ),
                  ],
                ),
                if (player['dismissal'] != null && player['dismissal'] != '') ...[
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
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
          ),
          SizedBox(
            width: 30,
            child: Text(
              (player['runs'] ?? 0).toString(),
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Color(0xFF1F2937),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: 30,
            child: Text(
              (player['balls'] ?? 0).toString(),
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Color(0xFF1F2937),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: 30,
            child: Text(
              (player['fours'] ?? 0).toString(),
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Color(0xFF1F2937),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: 30,
            child: Text(
              (player['sixes'] ?? 0).toString(),
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Color(0xFF1F2937),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: 50,
            child: Text(
              (player['strikeRate'] ?? 0.0).toStringAsFixed(1),
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Color(0xFF1F2937),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBowlerRow(Map<String, dynamic> bowler) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              bowler['name'] ?? 'Unknown Bowler',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Color(0xFF1F2937),
              ),
            ),
          ),
          SizedBox(
            width: 30,
            child: Text(
              (bowler['overs'] ?? 0.0).toString(),
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Color(0xFF1F2937),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: 30,
            child: Text(
              (bowler['maidens'] ?? 0).toString(),
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Color(0xFF1F2937),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: 30,
            child: Text(
              (bowler['runs'] ?? 0).toString(),
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Color(0xFF1F2937),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: 30,
            child: Text(
              (bowler['wickets'] ?? 0).toString(),
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Color(0xFF1F2937),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: 50,
            child: Text(
              (bowler['economyRate'] ?? 0.0).toStringAsFixed(1),
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Color(0xFF1F2937),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> getBattingDataFromAPI(Map<String, dynamic> inning) {
    // Get batting data from innings.bat.team structure
    final battingData = inning['bat']?['team'];

    if (battingData == null || battingData is! List) {
      print('No batting data found for inning: ${inning.keys.toList()}');
      return [];
    }

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
        'isOut': isOut,
      };
    }).toList();
  }

  List<Map<String, dynamic>> getBowlingDataFromAPI(Map<String, dynamic> inning) {
    // Get bowling data from innings.bowl.team structure
    final bowlingData = inning['bowl']?['team'];

    if (bowlingData == null || bowlingData is! List) {
      print('No bowling data found for inning: ${inning.keys.toList()}');
      return [];
    }

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

  Widget _buildExtrasSection() {
    if (selectedTeamIndex >= innings.length) return const SizedBox.shrink();

    final inning = innings[selectedTeamIndex];
    final extras = inning['extras'];
    final equations = inning['equations'];

    if (extras == null && equations == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          // Extras Header
          if (extras != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.grey[100]!, Colors.grey[200]!],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: const Row(
                children: [
                  Text(
                    'EXTRAS',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                ],
              ),
            ),

            // Extras Data
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildExtrasItem('Byes', extras['byes']),
                      _buildExtrasItem('Leg Byes', extras['legbyes']),
                      _buildExtrasItem('Wides', extras['wides']),
                      _buildExtrasItem('No Balls', extras['noballs']),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildExtrasItem('Penalty', extras['penalty']),
                      const Spacer(),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3B82F6),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Total: ${extras['total'] ?? 0}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],

          // Match Summary
          if (equations != null) ...[
            const Divider(height: 1),
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'INNINGS SUMMARY',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildSummaryItem('Total Runs', '${equations['totalRuns'] ?? 0}'),
                      _buildSummaryItem('Wickets', '${equations['totalWickets'] ?? 0}'),
                      _buildSummaryItem('Overs', '${equations['overs'] ?? 0}'),
                      _buildSummaryItem('Run Rate', '${equations['runrate'] ?? 0}'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildExtrasItem(String label, dynamic value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF6B7280),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${value ?? 0}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1F2937),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF3B82F6),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF6B7280),
          ),
        ),
      ],
    );
  }

  Widget _buildFallOfWicketsSection() {
    if (selectedTeamIndex >= innings.length) return const SizedBox.shrink();

    final inning = innings[selectedTeamIndex];
    final fallOfWickets = inning['fallofWickets'];

    if (fallOfWickets == null || fallOfWickets is! List || fallOfWickets.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.grey[100]!, Colors.grey[200]!],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: const Row(
              children: [
                Text(
                  'FALL OF WICKETS',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ],
            ),
          ),

          // Wickets List
          ...fallOfWickets.map<Widget>((wicket) => _buildWicketItem(wicket)).toList(),
        ],
      ),
    );
  }

  Widget _buildWicketItem(Map<String, dynamic> wicket) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.red[400],
              borderRadius: BorderRadius.circular(12),
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
                color: Color(0xFF1F2937),
              ),
            ),
          ),
          Text(
            '${wicket['score'] ?? 0}/${wicket['wicketOrder'] ?? 0}',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '(${wicket['overs'] ?? '0.0'} ov)',
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
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