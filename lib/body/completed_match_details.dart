import 'package:flutter/material.dart';
import 'package:fantasy/body/match_details.dart';
import '../api/contest_api.dart';

class CompletedMatchesPage extends StatefulWidget {
  const CompletedMatchesPage({Key? key}) : super(key: key);

  @override
  State<CompletedMatchesPage> createState() => _CompletedMatchesPageState();
}

class _CompletedMatchesPageState extends State<CompletedMatchesPage> {
  List<Map<String, dynamic>> completedMatches = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchCompletedMatches();
  }

  Future<void> _fetchCompletedMatches() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      // Fetch joined contest matches
      final joinedMatchesResponse = await ContestApi.getJoinedContestMatches();

      if (joinedMatchesResponse['status'] == true &&
          joinedMatchesResponse['data'] != null &&
          joinedMatchesResponse['data']['data'] != null) {

        final List<dynamic> allMatches = joinedMatchesResponse['data']['data'];

        // Filter completed matches (is_playing = 0 means completed)
        final List<Map<String, dynamic>> completedOnly = allMatches
            .cast<Map<String, dynamic>>()
            .toList();

        // Fetch scorecard for each completed match
        List<Map<String, dynamic>> matchesWithScorecard = [];

        for (var match in completedOnly) {
          try {
            final matchId = match['id'].toString();
            final scorecardResponse = await ContestApi.getScorecard(matchId);

            // Combine match data with scorecard data
            final combinedData = Map<String, dynamic>.from(match);
            if (scorecardResponse['status'] == true && scorecardResponse['data'] != null) {
              combinedData['scorecard'] = scorecardResponse['data'];
            }

            matchesWithScorecard.add(combinedData);
          } catch (e) {
            print('Error fetching scorecard for match ${match['id']}: $e');
            // Add match without scorecard data if scorecard fetch fails
            matchesWithScorecard.add(Map<String, dynamic>.from(match));
          }
        }

        setState(() {
          completedMatches = matchesWithScorecard;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'No completed matches found';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load completed matches: $e';
        isLoading = false;
      });
      print('Error fetching completed matches: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Completed Matches',
          style: TextStyle(
            color: Color(0xFF1F2937),
            fontWeight: FontWeight.w600,
          ),
        ),
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
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
            ),
            SizedBox(height: 16),
            Text(
              'Loading completed matches...',
              style: TextStyle(
                color: Color(0xFF6B7280),
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red[400],
            ),
            const SizedBox(height: 16),
            Text(
              errorMessage!,
              style: const TextStyle(
                color: Color(0xFF6B7280),
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchCompletedMatches,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                foregroundColor: Colors.white,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (completedMatches.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.sports_cricket,
              size: 64,
              color: Color(0xFF6B7280),
            ),
            SizedBox(height: 16),
            Text(
              'No completed matches found',
              style: TextStyle(
                color: Color(0xFF6B7280),
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Completed matches will appear here once available',
              style: TextStyle(
                color: Color(0xFF9CA3AF),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchCompletedMatches,
      color: const Color(0xFF10B981),
      child: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: completedMatches.length,
        itemBuilder: (context, index) {
          final match = completedMatches[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: _buildCompletedMatchCard(match),
          );
        },
      ),
    );
  }

  Widget _buildCompletedMatchCard(Map<String, dynamic> match) {
    final scorecard = match['scorecard'];

    // Extract team data
    final team1Name = match['team_a'] ?? 'Team A';
    final team2Name = match['team_b'] ?? 'Team B';
    final team1Short = _getTeamShort(team1Name);
    final team2Short = _getTeamShort(team2Name);

    // Extract scorecard data if available
    String team1Score = 'N/A';
    String team1Overs = '';
    String team2Score = 'N/A';
    String team2Overs = '';
    String winner = 'Match completed';

    if (scorecard != null) {
      team1Score = scorecard['team_a_score'] ?? 'N/A';
      team2Score = scorecard['team_b_score'] ?? 'N/A';
      winner = scorecard['winning_comment'] ?? 'Match completed';

      // Parse overs from score if available (format: "180/6 (18.4 ov)")
      if (team1Score.contains('(') && team1Score.contains('ov)')) {
        final parts = team1Score.split('(');
        if (parts.length > 1) {
          team1Score = parts[0].trim();
          team1Overs = parts[1].replaceAll('ov)', '').trim();
        }
      }

      if (team2Score.contains('(') && team2Score.contains('ov)')) {
        final parts = team2Score.split('(');
        if (parts.length > 1) {
          team2Score = parts[0].trim();
          team2Overs = parts[1].replaceAll('ov)', '').trim();
        }
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: const Color(0xFF10B981).withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showMatchDetails(match),
          borderRadius: BorderRadius.circular(16),
          splashColor: const Color(0xFF10B981).withOpacity(0.1),
          highlightColor: const Color(0xFF10B981).withOpacity(0.05),
          child: Column(
            children: [
              // Header with match info and status
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF10B981).withOpacity(0.1),
                      Colors.white.withOpacity(0.8)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'T20 Match',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            match['match_title'] ?? 'Cricket Match',
                            style: TextStyle(
                              fontSize: 13,
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
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF10B981), Color(0xFF059669)],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF10B981).withOpacity(0.3),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.white,
                            size: 14,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Completed',
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
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Team 1
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [Colors.blue[100]!, Colors.blue[300]!],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blue.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 28,
                              backgroundColor: Colors.transparent,
                              child: Text(
                                team1Short,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            team1Name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            team1Score,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          if (team1Overs.isNotEmpty)
                            Text(
                              '($team1Overs ov)',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                        ],
                      ),
                    ),

                    // VS separator
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

                    // Team 2
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [Colors.orange[100]!, Colors.orange[300]!],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.orange.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 28,
                              backgroundColor: Colors.transparent,
                              child: Text(
                                team2Short,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.orange,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            team2Name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            team2Score,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          if (team2Overs.isNotEmpty)
                            Text(
                              '($team2Overs ov)',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Winner section
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFFF59E0B).withOpacity(0.1),
                      const Color(0xFFD97706).withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: const Color(0xFFF59E0B).withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF59E0B),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.emoji_events,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        winner,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFD97706),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Match info section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.grey[50]!, Colors.grey[100]!],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                  border: Border(top: BorderSide(color: Colors.grey[300]!)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.sports_cricket, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      'Match ID: ${match['id']}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
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

  String _getTeamShort(String teamName) {
    // Extract initials from team name
    final words = teamName.split(' ');
    if (words.length >= 2) {
      return '${words[0][0]}${words[1][0]}'.toUpperCase();
    } else if (words.isNotEmpty) {
      return words[0].length >= 3 ? words[0].substring(0, 3).toUpperCase() : words[0].toUpperCase();
    }
    return 'T';
  }

  void _showMatchDetails(Map<String, dynamic> match) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MatchDetailsPage(matchData: match),
      ),
    );
  }}