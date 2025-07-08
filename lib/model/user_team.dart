// lib/model/user_team.dart
class UserTeam {
  final String? captain;
  final String? viceCaptain;
  final int? teamACount;
  final int? teamBCount;
  final String? teamAName;
  final String? teamBName;
  final bool? capTeam;
  final bool? vcTeam;
  final int? teamName;

  UserTeam({
    this.captain,
    this.viceCaptain,
    this.teamACount,
    this.teamBCount,
    this.teamAName,
    this.teamBName,
    this.capTeam,
    this.vcTeam,
    this.teamName,
  });

  factory UserTeam.fromJson(Map<String, dynamic> json) {
    return UserTeam(
      captain: json['captain'],
      viceCaptain: json['vice_captain'],
      teamACount: json['team_a_count'],
      teamBCount: json['team_b_count'],
      teamAName: json['team_a_name'],
      teamBName: json['team_b_name'],
      capTeam: json['cap_team'] ?? false,
      vcTeam: json['vc_team'] ?? false,
      teamName: json['team_name'],
    );
  }
}