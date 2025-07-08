// lib/utils/contest_utils.dart
import '../model/contest.dart';
import '../model/joined_contest.dart';
import '../model/player.dart';

class ContestUtils {
  /// Calculate win percentage for a contest
  static double calculateWinPercentage(Contest contest) {
    if (contest.totalTeams == null || contest.totalWinners == null || contest.totalTeams == 0) {
      return 0.0;
    }
    return (contest.totalWinners! / contest.totalTeams!) * 100;
  }

  /// Calculate prize per winner
  static int calculatePrizePerWinner(Contest contest) {
    if (contest.prizeMoney == null || contest.totalWinners == null || contest.totalWinners == 0) {
      return 0;
    }
    return contest.prizeMoney! ~/ contest.totalWinners!;
  }

  /// Check if contest is almost full
  static bool isContestAlmostFull(Contest contest, {double threshold = 0.9}) {
    if (contest.totalTeams == null || contest.teamsJoined == null) {
      return false;
    }
    return (contest.teamsJoined! / contest.totalTeams!) >= threshold;
  }

  /// Get contest status text
  static String getContestStatus(Contest contest) {
    if (contest.isCancelled == true) {
      return 'Cancelled';
    }

    final spotsLeft = (contest.totalTeams ?? 0) - (contest.teamsJoined ?? 0);
    if (spotsLeft <= 0) {
      return 'Full';
    } else if (spotsLeft <= 5) {
      return 'Filling Fast';
    }

    return 'Open';
  }

  /// Format prize money display
  static String formatPrizeMoney(int? prize) {
    if (prize == null || prize == 0) return '₹0';

    if (prize >= 10000000) {
      return '₹${(prize / 10000000).toStringAsFixed(1)}Cr';
    } else if (prize >= 100000) {
      return '₹${(prize / 100000).toStringAsFixed(1)}L';
    } else if (prize >= 1000) {
      return '₹${(prize / 1000).toStringAsFixed(1)}K';
    }

    return '₹$prize';
  }
}

/// Team validation utilities
class TeamUtils {
  /// Validate team composition
  static TeamValidationResult validateTeam(List<Player> selectedPlayers, {
    int maxPlayers = 11,
    int maxFromOneTeam = 7,
    double maxCredits = 100.0,
    int? teamAId,
    int? teamBId,
  }) {
    final errors = <String>[];

    // Check player count
    if (selectedPlayers.length != maxPlayers) {
      errors.add('Please select exactly $maxPlayers players');
    }

    // Check credits
    final totalCredits = selectedPlayers.fold(0.0, (sum, player) => sum + (player.credits ?? 0.0));
    if (totalCredits > maxCredits) {
      errors.add('Total credits (${totalCredits.toStringAsFixed(1)}) exceed limit ($maxCredits)');
    }

    // Check team composition
    if (teamAId != null && teamBId != null) {
      final teamACount = selectedPlayers.where((p) => p.teamId == teamAId).length;
      final teamBCount = selectedPlayers.where((p) => p.teamId == teamBId).length;

      if (teamACount > maxFromOneTeam) {
        errors.add('Maximum $maxFromOneTeam players allowed from one team');
      }
      if (teamBCount > maxFromOneTeam) {
        errors.add('Maximum $maxFromOneTeam players allowed from one team');
      }
    }

    // Check role distribution (example constraints)
    final wicketKeepers = selectedPlayers.where((p) => p.playerRole?.contains('WK') == true).length;
    final batsmen = selectedPlayers.where((p) => p.playerRole?.contains('BAT') == true).length;
    final allRounders = selectedPlayers.where((p) => p.playerRole?.contains('AR') == true).length;
    final bowlers = selectedPlayers.where((p) => p.playerRole?.contains('BOWL') == true).length;

    if (wicketKeepers < 1) {
      errors.add('At least 1 wicket-keeper required');
    }
    if (batsmen < 3) {
      errors.add('At least 3 batsmen required');
    }
    if (bowlers < 3) {
      errors.add('At least 3 bowlers required');
    }

    return TeamValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
      totalCredits: totalCredits,
    );
  }

  /// Calculate team strength score (example implementation)
  static double calculateTeamStrength(List<Player> selectedPlayers) {
    if (selectedPlayers.isEmpty) return 0.0;

    // Simple calculation based on player credits
    final totalCredits = selectedPlayers.fold(0.0, (sum, player) => sum + (player.credits ?? 0.0));
    return (totalCredits / selectedPlayers.length) * 10; // Scale to 0-100
  }
}

class TeamValidationResult {
  final bool isValid;
  final List<String> errors;
  final double totalCredits;

  TeamValidationResult({
    required this.isValid,
    required this.errors,
    required this.totalCredits,
  });
}