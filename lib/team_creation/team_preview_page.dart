// lib/widgets/joined_team_preview.dart
import 'package:flutter/material.dart';
import '../model/user_team.dart';

class JoinedTeamPreview extends StatelessWidget {
  final UserTeam team;
  final String teamAShort;
  final String teamBShort;
  final VoidCallback? onTap;

  const JoinedTeamPreview({
    Key? key,
    required this.team,
    required this.teamAShort,
    required this.teamBShort,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF2D5A27),
              Color(0xFF1A3D18),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Text(
                    "Team ${team.teamName ?? ''}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "Created",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),

              // Team Composition
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    teamAShort,
                    "${team.teamACount ?? 0}",
                    Icons.sports_cricket,
                    Colors.orange,
                  ),
                  Container(
                    width: 1,
                    height: 40,
                    color: Colors.white24,
                  ),
                  _buildStatItem(
                    teamBShort,
                    "${team.teamBCount ?? 0}",
                    Icons.sports_cricket,
                    Colors.blue,
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Captain & Vice Captain Section
              Text(
                "LEADERSHIP",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12),

              Row(
                children: [
                  // Captain
                  Expanded(
                    child: _buildLeaderCard(
                      team.captain?.toString() ?? "Unknown",
                      "Captain",
                      Colors.orange,
                      "C",
                    ),
                  ),
                  SizedBox(width: 16),
                  // Vice Captain
                  Expanded(
                    child: _buildLeaderCard(
                      team.viceCaptain?.toString() ?? "Unknown",
                      "Vice Captain",
                      Colors.blue,
                      "VC",
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),

              // Player composition summary
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildPlayerTypeCount("BAT", team.noOfBat ?? 0),
                    _buildPlayerTypeCount("WK", team.noOfWk ?? 0),
                    _buildPlayerTypeCount("AR", team.noOfAr ?? 0),
                    _buildPlayerTypeCount("BOWL", team.noOfBowl ?? 0),
                  ],
                ),
              ),
              SizedBox(height: 12),

              // Tap to view full team
              if (onTap != null)
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.visibility, color: Colors.white70, size: 16),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Tap to view full team details",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 12),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildPlayerTypeCount(String type, int count) {
    return Column(
      children: [
        Text(
          type,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          count.toString(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildLeaderCard(String playerName, String role, Color color, String badge) {
    return Container(
      padding: EdgeInsets.all(12),
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
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: color, width: 2),
                ),
                child: Center(
                  child: Text(
                    playerName.split(' ').map((e) => e.isNotEmpty ? e[0] : '').join(''),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: -4,
                right: -4,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Center(
                    child: Text(
                      badge,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: badge == "VC" ? 8 : 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            playerName.length > 12
                ? playerName.substring(0, 10) + ".."
                : playerName,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            role,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}