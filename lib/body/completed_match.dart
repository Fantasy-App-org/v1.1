import 'dart:math' as math;

import 'package:flutter/material.dart';

class CompletedMatchesPage extends StatelessWidget {
  const CompletedMatchesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        title: const Text(
          'Completed Matches',
          style: TextStyle(
            color: Color(0xFF1F2937),
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
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
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _buildMatchCard(
              context: context,
              team1: 'Phoenix Cricketers',
              team1Short: 'PC',
              team1Logo: '🏏',
              team1Score: '148/7',
              team1Overs: '17.3',
              team2: 'Lexus',
              team2Short: 'LEX',
              team2Logo: '🏆',
              team2Score: '147/10',
              team2Overs: '19.4',
              winner: 'Phoenix Cricketers won by 3 wickets',
              totalWinnings: '₹10000',
              winners: '81',
              entry: '₹100',
              onTap: () => _showMatchDetails(context),
              isWinner: true,
            ),
            const SizedBox(height: 20),
            _buildMatchCard(
              context: context,
              team1: 'Nellai Royal Kings',
              team1Short: 'NRK',
              team1Logo: '👑',
              team1Score: '165/8',
              team1Overs: '20.0',
              team2: 'Dindigul Dragons',
              team2Short: 'DD',
              team2Logo: '🐉',
              team2Score: '162/9',
              team2Overs: '20.0',
              winner: 'Nellai Royal Kings won by 3 runs',
              totalWinnings: '₹15000',
              winners: '94',
              entry: '₹150',
              onTap: () => _showMatchDetails(context),
              isWinner: true,
            ),
            const SizedBox(height: 20),
            _buildMatchCard(
              context: context,
              team1: 'Lyca Kovai Kings',
              team1Short: 'LKK',
              team1Logo: '⚡',
              team1Score: '178/6',
              team1Overs: '20.0',
              team2: 'IDream Tiruppur Tamizhans',
              team2Short: 'TT',
              team2Logo: '🌟',
              team2Score: '175/8',
              team2Overs: '20.0',
              winner: 'Lyca Kovai Kings won by 3 runs',
              totalWinnings: '₹12000',
              winners: '67',
              entry: '₹120',
              onTap: () => _showMatchDetails(context),
              isWinner: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMatchCard({
    required BuildContext context,
    required String team1,
    required String team1Short,
    required String team1Logo,
    required String team1Score,
    required String team1Overs,
    required String team2,
    required String team2Short,
    required String team2Logo,
    required String team2Score,
    required String team2Overs,
    required String winner,
    required String totalWinnings,
    required String winners,
    required String entry,
    required VoidCallback onTap,
    required bool isWinner,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            const Color(0xFFFAFBFF),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withOpacity(0.08),
            spreadRadius: 0,
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: const Color(0xFF6366F1).withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          splashColor: const Color(0xFF6366F1).withOpacity(0.1),
          highlightColor: const Color(0xFF6366F1).withOpacity(0.05),
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Status Badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF10B981),
                            const Color(0xFF059669),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF10B981).withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.check_circle,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          const Text(
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
                const SizedBox(height: 20),

                // Teams Section
                Row(
                  children: [
                    // Team 1
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            team1,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1F2937),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      const Color(0xFF3B82F6),
                                      const Color(0xFF1D4ED8),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF3B82F6).withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    team1Logo,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF3B82F6).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  team1Short,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1D4ED8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // VS Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF6B7280),
                            const Color(0xFF4B5563),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF6B7280).withOpacity(0.3),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Text(
                        'VS',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    // Team 2
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            team2,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1F2937),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.end,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF8B5CF6).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  team2Short,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF7C3AED),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      const Color(0xFF8B5CF6),
                                      const Color(0xFF7C3AED),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF8B5CF6).withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    team2Logo,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Score Section
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFFF8FAFC),
                        const Color(0xFFF1F5F9),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFF6366F1).withOpacity(0.1),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              team1Score,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1F2937),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '($team1Overs ov)',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 2,
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              const Color(0xFF6366F1).withOpacity(0.3),
                              const Color(0xFF8B5CF6).withOpacity(0.3),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(1),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              team2Score,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1F2937),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '($team2Overs ov)',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Winner Section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFFF59E0B).withOpacity(0.1),
                        const Color(0xFFD97706).withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFF59E0B).withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF59E0B),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.emoji_events,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          winner,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFD97706),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Prize Info
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF10B981).withOpacity(0.1),
                        const Color(0xFF059669).withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF10B981).withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Winnings',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            totalWinnings,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF059669),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Winners',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            winners,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF059669),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Entry Fee',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            entry,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF059669),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showMatchDetails(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MatchDetailsPage()),
    );
  }


}
// Match Details Page
class MatchDetailsPage extends StatelessWidget {
  const MatchDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Match Details',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Match Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Center(
                                child: Text(
                                  '🏏',
                                  style: TextStyle(fontSize: 24),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'PC',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              'Phoenix Cricketers',
                              style: TextStyle(fontSize: 12),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              'VS',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'PC 6 5 LEX',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.purple.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Center(
                                child: Text(
                                  '🏆',
                                  style: TextStyle(fontSize: 24),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'LEX',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              'Lexus',
                              style: TextStyle(fontSize: 12),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Completed',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Phoenix Cricketers won by 3 wickets',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Action Buttons
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
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
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF2563EB).withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap:
                              () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ScorecardPage(),
                                ),
                              ),
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 14,
                              horizontal: 16,
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.leaderboard_rounded,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'View Scorecard',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFF2563EB),
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap:
                              () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>  PlayerStatsPage(),
                                ),
                              ),
                          borderRadius: BorderRadius.circular(10),
                          splashColor: const Color(0xFF2563EB).withOpacity(0.1),
                          highlightColor: const Color(
                            0xFF2563EB,
                          ).withOpacity(0.05),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 14,
                              horizontal: 16,
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.analytics_outlined,
                                  color: Color(0xFF2563EB),
                                  size: 18,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Player Stats',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF2563EB),
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Leaderboard Preview
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 8,
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
                          'Leaderboard',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed:
                              () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LeaderboardPage(),
                                ),
                              ),
                          child: const Text('View All'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView(
                        children: [
                          _buildLeaderboardItem(
                            context,
                            '1',
                            'shiv18',
                            '907.5',
                            Colors.amber,
                          ),
                          _buildLeaderboardItem(
                            context,
                            '2',
                            'john_doe',
                            '900.5',
                            Colors.grey,
                          ),
                          _buildLeaderboardItem(
                            context,
                            '3',
                            'cricket_fan',
                            '844.5',
                            Colors.orange,
                          ),
                          _buildLeaderboardItem(
                            context,
                            '4',
                            'player123',
                            '820.0',
                            Colors.blue,
                          ),
                          _buildLeaderboardItem(
                            context,
                            '5',
                            'sports_lover',
                            '798.5',
                            Colors.green,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaderboardItem(
    BuildContext context,
    String rank,
    String name,
    String points,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap:
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => TeamPreviewPage(
                        playerName: name,
                        totalPoints: points,
                      ),
                ),
              ),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                    child: Text(
                      rank,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Text(
                  points,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Team Preview Page (Like Image 1)
class TeamPreviewPage extends StatelessWidget {
  final String playerName;
  final String totalPoints;

  const TeamPreviewPage({
    Key? key,
    required this.playerName,
    required this.totalPoints,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final availableHeight = screenHeight - kToolbarHeight - MediaQuery.of(context).padding.top - 180; // Reserve space for header and bottom

    return Scaffold(
      backgroundColor: Colors.green[600],
      appBar: AppBar(
        backgroundColor: Colors.green[600],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Team Preview',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Header with Completed status
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.green[700],
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Completed',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          // Cricket Field Layout - Full Screen
          Container(
            height: availableHeight,
            width: screenWidth,
            child: CustomPaint(
              painter: CricketFieldPainter(),
              child: Stack(
                children: [
                  // Wicket Keepers (Top)
                  Positioned(
                    top: availableHeight * 0.08,
                    left: 0,
                    right: 0,
                    child: Column(
                      children: [
                        Text(
                          'WICKET KEEPER',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth * 0.025,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildPlayerCard('V Vadakke...', '55.0 Pts', true, false, screenWidth),
                            _buildPlayerCard('S Balakrishn...', '105.0 Pts', true, true, screenWidth),
                            _buildPlayerCard('J Cholayil', '96.0 Pts', true, false, screenWidth),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Batsmen (Upper Middle)
                  Positioned(
                    top: availableHeight * 0.25,
                    left: 0,
                    right: 0,
                    child: Column(
                      children: [
                        Text(
                          'BATSMAN',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth * 0.025,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: screenWidth * 0.02,
                          runSpacing: 8,
                          children: [
                            _buildPlayerCard('S Sudhaka...', '40.0 Pts', true, false, screenWidth),
                            _buildPlayerCard('SR Henry', '23.0 Pts', false, false, screenWidth),
                            _buildPlayerCard('R Kumar', '5.0 Pts', true, false, screenWidth),
                            _buildPlayerCard('AFA Kadar', '41.0 Pts', false, false, screenWidth),
                            _buildPlayerCard('J Cyril', '11.0 Pts', false, false, screenWidth),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // All Rounders (Center)
                  Positioned(
                    top: availableHeight * 0.5,
                    left: 0,
                    right: 0,
                    child: Column(
                      children: [
                        Text(
                          'ALL ROUNDER',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth * 0.025,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildPlayerCard('R Raj', '346.5 Pts', true, true, screenWidth),
                            _buildPlayerCard('IH Banwa', '92.0 Pts', false, false, screenWidth),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Bowlers (Bottom)
                  Positioned(
                    bottom: availableHeight * 0.08,
                    left: 0,
                    right: 0,
                    child: Column(
                      children: [
                        Text(
                          'BOWLER',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth * 0.025,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildPlayerCard('A Kumar', '45.0 Pts', true, false, screenWidth),
                            _buildPlayerCard('M Singh', '38.0 Pts', false, false, screenWidth),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Bottom Stats
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        playerName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '$totalPoints Points',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Rank: #1',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    Text(
                      'Prize: ₹2,500',
                      style: TextStyle(
                        color: Colors.green[300],
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
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

  Widget _buildPlayerCard(
      String name,
      String points,
      bool isSelected,
      bool isCaptain,
      double screenWidth,
      ) {
    double cardSize = screenWidth * 0.12; // Responsive card size
    double iconSize = cardSize * 0.5;

    return Container(
      width: cardSize + 10,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: cardSize,
            height: cardSize,
            decoration: BoxDecoration(
              color: isSelected ? Colors.blue[600] : Colors.yellow[600],
              borderRadius: BorderRadius.circular(cardSize / 2),
              border: Border.all(
                color: isCaptain ? Colors.orange : Colors.white,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Stack(
              children: [
                Center(
                  child: Icon(
                    Icons.sports_cricket,
                    size: iconSize,
                    color: Colors.white,
                  ),
                ),
                if (isCaptain)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: cardSize * 0.3,
                      height: cardSize * 0.3,
                      decoration: const BoxDecoration(
                        color: Colors.orange,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          'C',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: cardSize * 0.2,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            name,
            style: TextStyle(
              color: Colors.white,
              fontSize: screenWidth * 0.02,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            points,
            style: TextStyle(
              color: Colors.white70,
              fontSize: screenWidth * 0.018,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// Custom painter for circular cricket field
class CricketFieldPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Calculate the radius to use the entire available space
    double radius = math.min(size.width, size.height) / 2 - 20;
    Offset center = Offset(size.width / 2, size.height / 2);

    // Draw green field background (circle)
    final Paint fieldPaint = Paint()
      ..color = Colors.green[600]!
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, fieldPaint);

    // Draw field boundary (circle outline)
    final Paint boundaryPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, radius, boundaryPaint);

    // Draw pitch (rectangle in center)
    final Paint pitchPaint = Paint()
      ..color = Colors.brown.withOpacity(0.4)
      ..style = PaintingStyle.fill;

    final Rect pitchRect = Rect.fromCenter(
      center: center,
      width: radius * 0.15,
      height: radius * 0.8,
    );
    canvas.drawRect(pitchRect, pitchPaint);

    // Draw pitch outline
    final Paint pitchOutlinePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawRect(pitchRect, pitchOutlinePaint);

    // Draw center circle
    final Paint circlePaint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, radius * 0.25, circlePaint);

    // Draw inner circle (30-yard circle)
    final Paint innerCirclePaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, radius * 0.6, innerCirclePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// Cricket Field Painter

// Scorecard Page



class ScorecardPage extends StatefulWidget {
  const ScorecardPage({Key? key}) : super(key: key);

  @override
  State<ScorecardPage> createState() => _ScorecardPageState();
}

class _ScorecardPageState extends State<ScorecardPage> {
  int selectedTeamIndex = 0; // 0 for Lexus, 1 for Phoenix Cricketers

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Scorecard',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Match Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Teams Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Team 1
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.directions_car,
                                color: Colors.black54,
                                size: 24,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Lexus',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              '147/10',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              '(19.4)',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // VS
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'VS',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ),

                      // Team 2
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.red.shade50,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.sports_cricket,
                                color: Colors.red,
                                size: 24,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Phoenix Cricketers',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              '148/7',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              '(17.3)',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Match Status
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.green.shade200),
                    ),
                    child: const Text(
                      'Completed',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Result
                  const Text(
                    'Phoenix Cricketers won by 3 wickets',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Batting Section
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Team Tabs
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedTeamIndex = 0;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                color: selectedTeamIndex == 0 ? Colors.teal : Colors.transparent,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                ),
                              ),
                              child: Text(
                                'Lexus',
                                style: TextStyle(
                                  color: selectedTeamIndex == 0 ? Colors.white : Colors.grey.shade600,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedTeamIndex = 1;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                color: selectedTeamIndex == 1 ? Colors.teal : Colors.transparent,
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(12),
                                ),
                              ),
                              child: Text(
                                'Phoenix Cricketers',
                                style: TextStyle(
                                  color: selectedTeamIndex == 1 ? Colors.white : Colors.grey.shade600,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Batting Header
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      border: Border(
                        bottom: BorderSide(color: Colors.grey.shade200),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Expanded(
                          flex: 3,
                          child: Text(
                            'BATTER',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 30,
                          child: Text(
                            'R',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(
                          width: 30,
                          child: Text(
                            'B',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(
                          width: 30,
                          child: Text(
                            '4s',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(
                          width: 30,
                          child: Text(
                            '6s',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(
                          width: 50,
                          child: Text(
                            'S/R',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Batting Data
                  ...getBattingData(selectedTeamIndex).map((player) => _buildBatterRow(player)).toList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBatterRow(Map<String, dynamic> player) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade100),
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
                        color: player['isOut'] ? Colors.red : Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Text(
                      player['name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                if (player['dismissal'] != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    player['dismissal'],
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ],
            ),
          ),
          SizedBox(
            width: 30,
            child: Text(
              player['runs'].toString(),
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: 30,
            child: Text(
              player['balls'].toString(),
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: 30,
            child: Text(
              player['fours'].toString(),
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: 30,
            child: Text(
              player['sixes'].toString(),
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: 50,
            child: Text(
              player['strikeRate'].toStringAsFixed(2),
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> getBattingData(int teamIndex) {
    if (teamIndex == 0) {
      // Lexus batting data
      return [
        {
          'name': 'Sunil Raja Henry',
          'dismissal': 'runout (S Balakrishnan / V Va...)',
          'runs': 9,
          'balls': 6,
          'fours': 2,
          'sixes': 0,
          'strikeRate': 150.00,
          'isOut': true,
        },
        {
          'name': 'Julius Cyril',
          'dismissal': 'c V Vadakkemadathil b M Sa...',
          'runs': 7,
          'balls': 15,
          'fours': 0,
          'sixes': 0,
          'strikeRate': 46.67,
          'isOut': true,
        },
        {
          'name': 'Ismail Hanif Banwa',
          'dismissal': 'c S Kassim b M Sawood',
          'runs': 25,
          'balls': 24,
          'fours': 3,
          'sixes': 0,
          'strikeRate': 104.17,
          'isOut': true,
        },
        {
          'name': 'Mahammad Ajizbhai...',
          'dismissal': 'runout (S Balakrishnan / R Raj)',
          'runs': 45,
          'balls': 26,
          'fours': 5,
          'sixes': 1,
          'strikeRate': 173.08,
          'isOut': true,
        },
        {
          'name': 'Rijil Venugopal',
          'dismissal': 'c J Vellapparakunnil b S Kassi...',
          'runs': 4,
          'balls': 5,
          'fours': 0,
          'sixes': 0,
          'strikeRate': 80.00,
          'isOut': true,
        },
        {
          'name': 'Ansari Farhan Abdul...',
          'dismissal': 'b R Raj',
          'runs': 19,
          'balls': 23,
          'fours': 2,
          'sixes': 0,
          'strikeRate': 82.61,
          'isOut': true,
        },
        {
          'name': 'Muhammad Usman',
          'dismissal': 'c S Kassim b R Raj',
          'runs': 20,
          'balls': 13,
          'fours': 1,
          'sixes': 1,
          'strikeRate': 153.85,
          'isOut': true,
        },
        {
          'name': 'Sameer Thajudeen',
          'dismissal': 'runout (R Raj)',
          'runs': 8,
          'balls': 6,
          'fours': 0,
          'sixes': 1,
          'strikeRate': 133.33,
          'isOut': true,
        },
        {
          'name': 'Mohamed Shihab',
          'dismissal': 'runout (R Raj / S Balakrishnan)',
          'runs': 0,
          'balls': 1,
          'fours': 0,
          'sixes': 0,
          'strikeRate': 0.00,
          'isOut': true,
        },
      ];
    } else {
      // Phoenix Cricketers batting data
      return [
        {
          'name': 'V Vadakkemadathil',
          'dismissal': 'c S Raja Henry b J Cyril',
          'runs': 32,
          'balls': 28,
          'fours': 4,
          'sixes': 1,
          'strikeRate': 114.29,
          'isOut': true,
        },
        {
          'name': 'S Balakrishnan',
          'dismissal': 'lbw b M Ajizbhai',
          'runs': 18,
          'balls': 15,
          'fours': 2,
          'sixes': 0,
          'strikeRate': 120.00,
          'isOut': true,
        },
        {
          'name': 'R Raj',
          'dismissal': null,
          'runs': 42,
          'balls': 31,
          'fours': 3,
          'sixes': 2,
          'strikeRate': 135.48,
          'isOut': false,
        },
        {
          'name': 'S Kassim',
          'dismissal': 'c I Banwa b U Farhan',
          'runs': 15,
          'balls': 12,
          'fours': 1,
          'sixes': 1,
          'strikeRate': 125.00,
          'isOut': true,
        },
        {
          'name': 'M Sawood',
          'dismissal': null,
          'runs': 28,
          'balls': 18,
          'fours': 2,
          'sixes': 1,
          'strikeRate': 155.56,
          'isOut': false,
        },
        {
          'name': 'J Vellapparakunnil',
          'dismissal': 'b M Usman',
          'runs': 7,
          'balls': 8,
          'fours': 1,
          'sixes': 0,
          'strikeRate': 87.50,
          'isOut': true,
        },
        {
          'name': 'A Mohammed',
          'dismissal': 'c S Thajudeen b R Venugopal',
          'runs': 3,
          'balls': 5,
          'fours': 0,
          'sixes': 0,
          'strikeRate': 60.00,
          'isOut': true,
        },
        {
          'name': 'K Rahman',
          'dismissal': 'run out (M Shihab)',
          'runs': 1,
          'balls': 2,
          'fours': 0,
          'sixes': 0,
          'strikeRate': 50.00,
          'isOut': true,
        },
      ];
    }
  }
}
// Player Stats Page


class Player {
  final String name;
  final double selectedByPercentage;
  final double points;
  final Map<String, dynamic> stats;

  Player({
    required this.name,
    required this.selectedByPercentage,
    required this.points,
    required this.stats,
  });
}

class PlayerStatsPage extends StatelessWidget {
  PlayerStatsPage({Key? key}) : super(key: key);

  final List<Player> players = [
   Player(
      name: 'Renil Raj',
      selectedByPercentage: 66.9,
      points: 231.0,
      stats: {
        'Starting 11': {'actual': 'Yes', 'points': 4},
        'Runs': {'actual': 52, 'points': 52},
        '4\'s': {'actual': 4, 'points': 20},
        '6\'s': {'actual': 3, 'points': 24},
        'S/R': {'actual': 153, 'points': 0},
        '50': {'actual': 'Yes', 'points': 8},
        '100': {'actual': 'No', 'points': 0},
        'Duck': {'actual': 'No', 'points': 0},
        'Wkts': {'actual': 2, 'points': 50},
      },
    ),
  Player(
      name: 'Shibu Balakrishnan',
      selectedByPercentage: 22.3,
      points: 105.0,
      stats: {
        'Starting 11': {'actual': 'Yes', 'points': 4},
        'Runs': {'actual': 35, 'points': 35},
        '4\'s': {'actual': 2, 'points': 10},
        '6\'s': {'actual': 1, 'points': 8},
        'S/R': {'actual': 125, 'points': 0},
        '50': {'actual': 'No', 'points': 0},
        '100': {'actual': 'No', 'points': 0},
        'Duck': {'actual': 'No', 'points': 0},
        'Wkts': {'actual': 4, 'points': 100},
      },
    ),
 Player(
      name: 'Mohammed Sawood',
      selectedByPercentage: 1.1,
      points: 78.0,
      stats: {
        'Starting 11': {'actual': 'Yes', 'points': 4},
        'Runs': {'actual': 28, 'points': 28},
        '4\'s': {'actual': 3, 'points': 15},
        '6\'s': {'actual': 1, 'points': 8},
        'S/R': {'actual': 140, 'points': 0},
        '50': {'actual': 'No', 'points': 0},
        '100': {'actual': 'No', 'points': 0},
        'Duck': {'actual': 'No', 'points': 0},
        'Wkts': {'actual': 2, 'points': 50},
      },
    ),
   Player(
      name: 'Vinod Vadakkemadathil',
      selectedByPercentage: 73.1,
      points: 55.0,
      stats: {
        'Starting 11': {'actual': 'Yes', 'points': 4},
        'Runs': {'actual': 18, 'points': 18},
        '4\'s': {'actual': 1, 'points': 5},
        '6\'s': {'actual': 0, 'points': 0},
        'S/R': {'actual': 90, 'points': 0},
        '50': {'actual': 'No', 'points': 0},
        '100': {'actual': 'No', 'points': 0},
        'Duck': {'actual': 'No', 'points': 0},
        'Wkts': {'actual': 3, 'points': 75},
      },
    ),
    Player(
      name: 'Jishudas Cholayil',
      selectedByPercentage: 40.6,
      points: 48.0,
      stats: {
        'Starting 11': {'actual': 'Yes', 'points': 4},
        'Runs': {'actual': 22, 'points': 22},
        '4\'s': {'actual': 2, 'points': 10},
        '6\'s': {'actual': 0, 'points': 0},
        'S/R': {'actual': 110, 'points': 0},
        '50': {'actual': 'No', 'points': 0},
        '100': {'actual': 'No', 'points': 0},
        'Duck': {'actual': 'No', 'points': 0},
        'Wkts': {'actual': 1, 'points': 25},
      },
    ),
  Player(
      name: 'Sadiq Kassim',
      selectedByPercentage: 3.4,
      points: 48.0,
      stats: {
        'Starting 11': {'actual': 'Yes', 'points': 4},
        'Runs': {'actual': 19, 'points': 19},
        '4\'s': {'actual': 1, 'points': 5},
        '6\'s': {'actual': 1, 'points': 8},
        'S/R': {'actual': 95, 'points': 0},
        '50': {'actual': 'No', 'points': 0},
        '100': {'actual': 'No', 'points': 0},
        'Duck': {'actual': 'No', 'points': 0},
        'Wkts': {'actual': 1, 'points': 25},
      },
    ),
 Player(
      name: 'Suneesh Sudhakaran',
      selectedByPercentage: 60.6,
      points: 40.0,
      stats: {
        'Starting 11': {'actual': 'Yes', 'points': 4},
        'Runs': {'actual': 15, 'points': 15},
        '4\'s': {'actual': 1, 'points': 5},
        '6\'s': {'actual': 0, 'points': 0},
        'S/R': {'actual': 75, 'points': 0},
        '50': {'actual': 'No', 'points': 0},
        '100': {'actual': 'No', 'points': 0},
        'Duck': {'actual': 'No', 'points': 0},
        'Wkts': {'actual': 2, 'points': 50},
      },
    ),
 Player(
      name: 'Sonu Sudhakaran',
      selectedByPercentage: 0.0,
      points: 28.0,
      stats: {
        'Starting 11': {'actual': 'Yes', 'points': 4},
        'Runs': {'actual': 12, 'points': 12},
        '4\'s': {'actual': 1, 'points': 5},
        '6\'s': {'actual': 0, 'points': 0},
        'S/R': {'actual': 80, 'points': 0},
        '50': {'actual': 'No', 'points': 0},
        '100': {'actual': 'No', 'points': 0},
        'Duck': {'actual': 'No', 'points': 0},
        'Wkts': {'actual': 0, 'points': 0},
      },
    ),
     Player(
      name: 'Jithu Vellapparakunnil',
      selectedByPercentage: 48.6,
      points: 23.0,
      stats: {
        'Starting 11': {'actual': 'Yes', 'points': 4},
        'Runs': {'actual': 8, 'points': 8},
        '4\'s': {'actual': 0, 'points': 0},
        '6\'s': {'actual': 0, 'points': 0},
        'S/R': {'actual': 67, 'points': 0},
        '50': {'actual': 'No', 'points': 0},
        '100': {'actual': 'No', 'points': 0},
        'Duck': {'actual': 'No', 'points': 0},
        'Wkts': {'actual': 1, 'points': 25},
      },
    ),
     Player(
      name: 'Roshan Kumar',
      selectedByPercentage: 97.7,
      points: 5.0,
      stats: {
        'Starting 11': {'actual': 'Yes', 'points': 4},
        'Runs': {'actual': 1, 'points': 1},
        '4\'s': {'actual': 0, 'points': 0},
        '6\'s': {'actual': 0, 'points': 0},
        'S/R': {'actual': 25, 'points': 0},
        '50': {'actual': 'No', 'points': 0},
        '100': {'actual': 'No', 'points': 0},
        'Duck': {'actual': 'No', 'points': 0},
        'Wkts': {'actual': 0, 'points': 0},
      },
    ),
    Player(
      name: 'Muzammil Shamsuddin',
      selectedByPercentage: 0.0,
      points: 4.0,
      stats: {
        'Starting 11': {'actual': 'Yes', 'points': 4},
        'Runs': {'actual': 0, 'points': 0},
        '4\'s': {'actual': 0, 'points': 0},
        '6\'s': {'actual': 0, 'points': 0},
        'S/R': {'actual': 0, 'points': 0},
        '50': {'actual': 'No', 'points': 0},
        '100': {'actual': 'No', 'points': 0},
        'Duck': {'actual': 'Yes', 'points': 0},
        'Wkts': {'actual': 0, 'points': 0},
      },
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Player Points',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Header Row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              border: Border(
                bottom: BorderSide(color: Colors.grey[200]!),
              ),
            ),
            child: const Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    'Player',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Selected By',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'Points',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Player List
          Expanded(
            child: ListView.builder(
              itemCount: players.length,
              itemBuilder: (context, index) {
                final player = players[index];
                return PlayerCard(player: player);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class PlayerCard extends StatelessWidget {
  final Player player;

  const PlayerCard({Key? key, required this.player}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => PlayerBreakupSheet(player: player),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey[200]!),
          ),
        ),
        child: Row(
          children: [
            // Player Info
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  // Player Avatar
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.person,
                      color: Colors.blue[600],
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Player Name with Icons
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          player.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 12,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 16,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Selected By Percentage
            Expanded(
              flex: 2,
              child: Text(
                '${player.selectedByPercentage}%',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
            // Points
            Expanded(
              flex: 1,
              child: Text(
                player.points.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.green[600],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PlayerBreakupSheet extends StatelessWidget {
  final Player player;

  const PlayerBreakupSheet({Key? key, required this.player}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle Bar
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Points Breakup',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          // Player Summary
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.person,
                    color: Colors.blue[600],
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        player.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            'SELECTED BY',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            'POINTS',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            'CREDITS',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            '${player.selectedByPercentage}%',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(width: 45),
                          Text(
                            player.points.toString(),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.green[600],
                            ),
                          ),
                          const SizedBox(width: 45),
                          const Text(
                            '10.0',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
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
          ),
          const SizedBox(height: 16),
          // Stats Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              border: Border(
                bottom: BorderSide(color: Colors.grey[200]!),
              ),
            ),
            child: const Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'Event',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'Actual',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'Points',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Stats List
          Expanded(
            child: ListView.builder(
              itemCount: player.stats.length,
              itemBuilder: (context, index) {
                final statKey = player.stats.keys.elementAt(index);
                final statValue = player.stats[statKey];

                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey[200]!),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          statKey,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          statValue['actual'].toString(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          statValue['points'].toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: statValue['points'] > 0
                                ? Colors.green[600]
                                : Colors.black87,
                          ),
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
    );
  }
}
// Leaderboard Page
class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Leaderboard',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Leaderboard Page', style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
