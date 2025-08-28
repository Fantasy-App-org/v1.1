import 'package:flutter/material.dart';
import '../model/user_team.dart';
import '../model/player.dart';
import '../model/fixture.dart';
import 'create_team.dart';

class FullTeamDetailsPage extends StatelessWidget {
  final UserTeam team;
  final String teamAShort;
  final String teamBShort;
  final FixtureModel? fixture; // Add fixture parameter for edit functionality

  const FullTeamDetailsPage({
    Key? key,
    required this.team,
    required this.teamAShort,
    required this.teamBShort,
    this.fixture, // Make it optional for backward compatibility
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF16213E),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Team ${team.teamName ?? ''}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          // Add Edit Button
          if (fixture != null)
            Container(
              margin: const EdgeInsets.only(right: 8),
              child: IconButton(
                onPressed: () => _navigateToEditTeam(context),
                icon: const Icon(Icons.edit, color: Colors.white),
                tooltip: 'Edit Team',
              ),
            ),
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '$teamAShort vs $teamBShort',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Team Summary Card
            _buildTeamSummaryCard(),
            const SizedBox(height: 20),

            // Players List
            _buildPlayersSection(),
          ],
        ),
      ),
      // Add Floating Action Button for Edit
      floatingActionButton: fixture != null ? FloatingActionButton.extended(
        onPressed: () => _navigateToEditTeam(context),
        backgroundColor: const Color(0xFF22C55E),
        icon: const Icon(Icons.edit, color: Colors.white),
        label: const Text(
          'EDIT TEAM',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ) : null,
    );
  }

  void _navigateToEditTeam(BuildContext context) {
    if (fixture == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cannot edit team: Fixture information not available'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateTeamPage(
          fixture: fixture!,
          existingTeam: team, // Pass existing team for editing
        ),
      ),
    ).then((result) {
      // Refresh the page if team was edited successfully
      if (result == true) {
        Navigator.pop(context, true); // Pop with result to refresh parent
      }
    });
  }

  Widget _buildTeamSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF2D5A27),
            Color(0xFF1A3D18),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Team composition
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildTeamCount(teamAShort, team.teamACount ?? 0),
              Container(
                width: 2,
                height: 50,
                color: Colors.white24,
              ),
              _buildTeamCount(teamBShort, team.teamBCount ?? 0),
            ],
          ),
          const SizedBox(height: 20),

          // Captain and Vice Captain
          Row(
            children: [
              Expanded(
                child: _buildLeadershipCard(
                  team.captain?.toString() ?? "Unknown",
                  "Captain",
                  Colors.orange,
                  "C",
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildLeadershipCard(
                  team.viceCaptain?.toString() ?? "Unknown",
                  "Vice Captain",
                  Colors.blue,
                  "VC",
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Player type distribution
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildPlayerTypeCount("BAT", team.noOfBat ?? 0, Colors.green),
                _buildPlayerTypeCount("WK", team.noOfWk ?? 0, Colors.blue),
                _buildPlayerTypeCount("AR", team.noOfAr ?? 0, Colors.orange),
                _buildPlayerTypeCount("BOWL", team.noOfBowl ?? 0, Colors.red),
              ],
            ),
          ),

          // Add edit hint if fixture is available
          if (fixture != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Tap the edit button to modify your team composition',
                      style: const TextStyle(
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
        ],
      ),
    );
  }

  // ... (rest of the build methods remain the same)

  Widget _buildTeamCount(String teamName, int count) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          teamName,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildLeadershipCard(String playerName, String role, Color color, String badge) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: color, width: 3),
                ),
                child: Center(
                  child: Text(
                    playerName.split(' ').map((e) => e.isNotEmpty ? e[0] : '').join(''),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: -4,
                right: -4,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Center(
                    child: Text(
                      badge,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: badge == "VC" ? 10 : 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            playerName.length > 15 ? '${playerName.substring(0, 12)}...' : playerName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            role,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerTypeCount(String type, int count, Color color) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color, width: 2),
          ),
          child: Center(
            child: Text(
              count.toString(),
              style: TextStyle(
                color: color,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          type,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildPlayersSection() {
    if (team.teamPlayers == null || team.teamPlayers!.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Text(
            'No player details available',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
        ),
      );
    }

    // Group players by type
    Map<String, List<Player>> playersByType = {};
    for (var player in team.teamPlayers!) {
      String type = _getPlayerTypeLabel(player.role ?? '');
      if (!playersByType.containsKey(type)) {
        playersByType[type] = [];
      }
      playersByType[type]!.add(player);
    }

    // Order the types
    List<String> typeOrder = ['Batsman', 'Wicket Keeper', 'All Rounder', 'Bowler'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'PLAYERS',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...typeOrder.where((type) => playersByType.containsKey(type)).map((type) {
          return _buildPlayerTypeSection(type, playersByType[type]!);
        }).toList(),
      ],
    );
  }

  String _getPlayerTypeLabel(String type) {
    switch (type.toLowerCase()) {
      case 'bat':
        return 'Batsman';
      case 'wk':
        return 'Wicket Keeper';
      case 'ar':
        return 'All Rounder';
      case 'bowl':
        return 'Bowler';
      default:
        return 'Player';
    }
  }

  Color _getPlayerTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'batsman':
        return Colors.green;
      case 'wicket keeper':
        return Colors.blue;
      case 'all rounder':
        return Colors.orange;
      case 'bowler':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget _buildPlayerTypeSection(String type, List<Player> players) {
    Color typeColor = _getPlayerTypeColor(type);

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: typeColor.withOpacity(0.2),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: typeColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      players.length.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  type,
                  style: TextStyle(
                    color: typeColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ...players.map((player) => _buildPlayerCard(player)).toList(),
        ],
      ),
    );
  }

  Widget _buildPlayerCard(Player player) {
    bool isCaptain = player.playerName == team.captain.toString();
    bool isViceCaptain = player.playerName == team.viceCaptain.toString();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.white10, width: 1),
        ),
      ),
      child: Row(
        children: [
          // Player avatar
          Stack(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: isCaptain ? Colors.orange : isViceCaptain ? Colors.blue : Colors.white24,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    (player.playerName ?? '').split(' ').map((e) => e.isNotEmpty ? e[0] : '').join(''),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              if (isCaptain || isViceCaptain)
                Positioned(
                  top: -2,
                  right: -2,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: isCaptain ? Colors.orange : Colors.blue,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white, width: 1),
                    ),
                    child: Center(
                      child: Text(
                        isCaptain ? 'C' : 'VC',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),

          // Player details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  player.playerName ?? 'Unknown Player',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  player.teamName ?? 'Unknown Team',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
                if (player.battingStyle != null && player.battingStyle!.isNotEmpty)
                  Text(
                    player.battingStyle!,
                    style: const TextStyle(
                      color: Colors.white60,
                      fontSize: 11,
                    ),
                  ),
              ],
            ),
          ),

          // Player credit
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '${player.credits ?? 0} CR',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}