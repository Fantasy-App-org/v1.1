class Performance {
  String? id;
  int? mId;
  String? teamType;
  int? teamId;
  String? teamName;
  int? playerId;
  int? pId;
  String? playerName;
  String? playerType;
  double? totalPoints;
  int? playerPoints;
  bool? isPlaying;
  int? totalScore;
  int? runScored;
  int? ballsFaced;
  int? foursHit;
  int? sixesHit;
  int? battingStrikerate;
  int? battingPosition;
  bool? isCurrentBatsman;
  int? extraRunsScored;
  bool? outStatus;
  String? outComment;
  int? oversBowled;
  int? maidensBowled;
  int? widesBowled;
  int? noballsBowled;
  int? runsGiven;
  int? wicketsTaken;
  int? bowledMade;
  int? lbwMade;
  int? economy;
  bool? isCurrentBowler;
  int? runoutThrower;
  int? runoutCatcher;
  int? runoutDirectHit;
  int? stumping;
  int? catches;
  double? testPlayerPoints;
  bool? testIsPlaying;
  int? testTotalScore;
  int? testRunScored;
  int? testBallsFaced;
  int? testFoursHit;
  int? testSixesHit;
  int? testBattingStrikerate;
  int? testBattingPosition;
  bool? testIsCurrentBatsman;
  int? testExtraRunsScored;
  bool? testOutStatus;
  String? testOutComment;
  int? testOversBowled;
  int? testMaidensBowled;
  int? testWidesBowled;
  int? testNoballsBowled;
  int? testRunsGiven;
  int? testWicketsTaken;
  int? testBowledMade;
  int? testLbwMade;
  int? testEconomy;
  bool? testIsCurrentBowler;
  int? testRunoutThrower;
  int? testRunoutCatcher;
  int? testRunoutDirectHit;
  int? testStumping;
  int? testCatches;

  Performance({
    this.id,
    this.mId,
    this.teamType,
    this.teamId,
    this.teamName,
    this.playerId,
    this.pId,
    this.playerName,
    this.playerType,
    this.totalPoints,
    this.playerPoints,
    this.isPlaying,
    this.totalScore,
    this.runScored,
    this.ballsFaced,
    this.foursHit,
    this.sixesHit,
    this.battingStrikerate,
    this.battingPosition,
    this.isCurrentBatsman,
    this.extraRunsScored,
    this.outStatus,
    this.outComment,
    this.oversBowled,
    this.maidensBowled,
    this.widesBowled,
    this.noballsBowled,
    this.runsGiven,
    this.wicketsTaken,
    this.bowledMade,
    this.lbwMade,
    this.economy,
    this.isCurrentBowler,
    this.runoutThrower,
    this.runoutCatcher,
    this.runoutDirectHit,
    this.stumping,
    this.catches,
    this.testPlayerPoints,
    this.testIsPlaying,
    this.testTotalScore,
    this.testRunScored,
    this.testBallsFaced,
    this.testFoursHit,
    this.testSixesHit,
    this.testBattingStrikerate,
    this.testBattingPosition,
    this.testIsCurrentBatsman,
    this.testExtraRunsScored,
    this.testOutStatus,
    this.testOutComment,
    this.testOversBowled,
    this.testMaidensBowled,
    this.testWidesBowled,
    this.testNoballsBowled,
    this.testRunsGiven,
    this.testWicketsTaken,
    this.testBowledMade,
    this.testLbwMade,
    this.testEconomy,
    this.testIsCurrentBowler,
    this.testRunoutThrower,
    this.testRunoutCatcher,
    this.testRunoutDirectHit,
    this.testStumping,
    this.testCatches,
  });

  factory Performance.fromJson(Map<String, dynamic> json) {
    return Performance(
      id: json['id']?.toString(),
      mId: json['m_id'],
      teamType: json['team_type'],
      teamId: json['team_id'],
      teamName: json['team_name'],
      playerId: json['player_id'],
      pId: json['p_id'],
      playerName: json['player_name'],
      playerType: json['player_type'],
      totalPoints: json['total_points'] != null ? double.parse(json['total_points'].toString()) : null,
      playerPoints: json['player_points'],
      isPlaying: json['is_playing'],
      totalScore: json['total_score'],
      runScored: json['run_scored'],
      ballsFaced: json['balls_faced'],
      foursHit: json['fours_hit'],
      sixesHit: json['sixes_hit'],
      battingStrikerate: json['batting_strikerate'],
      battingPosition: json['batting_position'],
      isCurrentBatsman: json['is_current_batsman'],
      extraRunsScored: json['extra_runs_scored'],
      outStatus: json['out_status'],
      outComment: json['out_comment'],
      oversBowled: json['overs_bowled'],
      maidensBowled: json['maidens_bowled'],
      widesBowled: json['wides_bowled'],
      noballsBowled: json['noballs_bowled'],
      runsGiven: json['runs_given'],
      wicketsTaken: json['wickets_taken'],
      bowledMade: json['bowled_made'],
      lbwMade: json['lbw_made'],
      economy: json['economy'],
      isCurrentBowler: json['is_current_bowler'],
      runoutThrower: json['runout_thrower'],
      runoutCatcher: json['runout_catcher'],
      runoutDirectHit: json['runout_direct_hit'],
      stumping: json['stumping'],
      catches: json['catches'],
      testPlayerPoints: json['test_player_points'] != null ? double.parse(json['test_player_points'].toString()) : null,
      testIsPlaying: json['test_is_playing'],
      testTotalScore: json['test_total_score'],
      testRunScored: json['test_run_scored'],
      testBallsFaced: json['test_balls_faced'],
      testFoursHit: json['test_fours_hit'],
      testSixesHit: json['test_sixes_hit'],
      testBattingStrikerate: json['test_batting_strikerate'],
      testBattingPosition: json['test_batting_position'],
      testIsCurrentBatsman: json['test_is_current_batsman'],
      testExtraRunsScored: json['test_extra_runs_scored'],
      testOutStatus: json['test_out_status'],
      testOutComment: json['test_out_comment'],
      testOversBowled: json['test_overs_bowled'],
      testMaidensBowled: json['test_maidens_bowled'],
      testWidesBowled: json['test_wides_bowled'],
      testNoballsBowled: json['test_noballs_bowled'],
      testRunsGiven: json['test_runs_given'],
      testWicketsTaken: json['test_wickets_taken'],
      testBowledMade: json['test_bowled_made'],
      testLbwMade: json['test_lbw_made'],
      testEconomy: json['test_economy'],
      testIsCurrentBowler: json['test_is_current_bowler'],
      testRunoutThrower: json['test_runout_thrower'],
      testRunoutCatcher: json['test_runout_catcher'],
      testRunoutDirectHit: json['test_runout_direct_hit'],
      testStumping: json['test_stumping'],
      testCatches: json['test_catches'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'm_id': mId,
      'team_type': teamType,
      'team_id': teamId,
      'team_name': teamName,
      'player_id': playerId,
      'p_id': pId,
      'player_name': playerName,
      'player_type': playerType,
      'total_points': totalPoints,
      'player_points': playerPoints,
      'is_playing': isPlaying,
      'total_score': totalScore,
      'run_scored': runScored,
      'balls_faced': ballsFaced,
      'fours_hit': foursHit,
      'sixes_hit': sixesHit,
      'batting_strikerate': battingStrikerate,
      'batting_position': battingPosition,
      'is_current_batsman': isCurrentBatsman,
      'extra_runs_scored': extraRunsScored,
      'out_status': outStatus,
      'out_comment': outComment,
      'overs_bowled': oversBowled,
      'maidens_bowled': maidensBowled,
      'wides_bowled': widesBowled,
      'noballs_bowled': noballsBowled,
      'runs_given': runsGiven,
      'wickets_taken': wicketsTaken,
      'bowled_made': bowledMade,
      'lbw_made': lbwMade,
      'economy': economy,
      'is_current_bowler': isCurrentBowler,
      'runout_thrower': runoutThrower,
      'runout_catcher': runoutCatcher,
      'runout_direct_hit': runoutDirectHit,
      'stumping': stumping,
      'catches': catches,
      'test_player_points': testPlayerPoints,
      'test_is_playing': testIsPlaying,
      'test_total_score': testTotalScore,
      'test_run_scored': testRunScored,
      'test_balls_faced': testBallsFaced,
      'test_fours_hit': testFoursHit,
      'test_sixes_hit': testSixesHit,
      'test_batting_strikerate': testBattingStrikerate,
      'test_batting_position': testBattingPosition,
      'test_is_current_batsman': testIsCurrentBatsman,
      'test_extra_runs_scored': testExtraRunsScored,
      'test_out_status': testOutStatus,
      'test_out_comment': testOutComment,
      'test_overs_bowled': testOversBowled,
      'test_maidens_bowled': testMaidensBowled,
      'test_wides_bowled': testWidesBowled,
      'test_noballs_bowled': testNoballsBowled,
      'test_runs_given': testRunsGiven,
      'test_wickets_taken': testWicketsTaken,
      'test_bowled_made': testBowledMade,
      'test_lbw_made': testLbwMade,
      'test_economy': testEconomy,
      'test_is_current_bowler': testIsCurrentBowler,
      'test_runout_thrower': testRunoutThrower,
      'test_runout_catcher': testRunoutCatcher,
      'test_runout_direct_hit': testRunoutDirectHit,
      'test_stumping': testStumping,
      'test_catches': testCatches,
    };
  }
}