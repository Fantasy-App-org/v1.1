class PointSystem {
  String? id;
  int? matchType;
  int? batRun;
  int? batFour;
  int? batSix;
  int? batHalfCentury;
  int? batCentury;
  int? batDuck;
  int? bowlWicket;
  int? bowl4wicket;
  int? bowl5wicket;
  int? bowlMaiden;
  int? bowlDotball;
  int? fieldCatch;
  int? fieldRunoutDirect;
  int? fieldRunoutThrower;
  int? fieldRunoutCatcher;
  double? captain;
  double? viceCaptain;
  int? starting11;
  int? t10Bonus30Runs;
  int? t10Bonus50Runs;
  int? t10Bowling2Wicket;
  int? t10Bowling3Wicket;
  int? t20EcoLt4runs;
  int? t20EcoGt4runs;
  int? t20EcoGt5runs;
  int? t20EcoGt9runs;
  int? t20EcoGt10runs;
  int? t20EcoGt11runs;
  int? odiEcoLt2_5runs;
  int? odiEcoGt2_5runs;
  int? odiEcoGt3_5runs;
  int? odiEcoGt5runs;
  int? odiEcoGt8runs;
  int? odiEcoGt9runs;
  int? t10EcoLt6runs;
  int? t10EcoGt6runs;
  int? t10EcoBt7_8runs;
  int? t10EcoBt11_12runs;
  int? t10EcoBt12_13runs;
  int? t10EcoGt13_runs;
  int? t20StrikeLt50runs;
  int? t20StrikeGt50runs;
  int? t20StrikeGt60runs;
  int? odiStrikeLt40runs;
  int? odiStrikeGt40runs;
  int? odiStrikeGt50runs;
  int? t10StrikeLt80runs;
  int? t10StrikeBt80_90runs;
  int? t10StrikeGt90runs;

  PointSystem({
    this.id,
    this.matchType,
    this.batRun,
    this.batFour,
    this.batSix,
    this.batHalfCentury,
    this.batCentury,
    this.batDuck,
    this.bowlWicket,
    this.bowl4wicket,
    this.bowl5wicket,
    this.bowlMaiden,
    this.bowlDotball,
    this.fieldCatch,
    this.fieldRunoutDirect,
    this.fieldRunoutThrower,
    this.fieldRunoutCatcher,
    this.captain,
    this.viceCaptain,
    this.starting11,
    this.t10Bonus30Runs,
    this.t10Bonus50Runs,
    this.t10Bowling2Wicket,
    this.t10Bowling3Wicket,
    this.t20EcoLt4runs,
    this.t20EcoGt4runs,
    this.t20EcoGt5runs,
    this.t20EcoGt9runs,
    this.t20EcoGt10runs,
    this.t20EcoGt11runs,
    this.odiEcoLt2_5runs,
    this.odiEcoGt2_5runs,
    this.odiEcoGt3_5runs,
    this.odiEcoGt5runs,
    this.odiEcoGt8runs,
    this.odiEcoGt9runs,
    this.t10EcoLt6runs,
    this.t10EcoGt6runs,
    this.t10EcoBt7_8runs,
    this.t10EcoBt11_12runs,
    this.t10EcoBt12_13runs,
    this.t10EcoGt13_runs,
    this.t20StrikeLt50runs,
    this.t20StrikeGt50runs,
    this.t20StrikeGt60runs,
    this.odiStrikeLt40runs,
    this.odiStrikeGt40runs,
    this.odiStrikeGt50runs,
    this.t10StrikeLt80runs,
    this.t10StrikeBt80_90runs,
    this.t10StrikeGt90runs,
  });

  factory PointSystem.fromJson(Map<String, dynamic> json) {
    return PointSystem(
      id: json['id']?.toString(),
      matchType: json['match_type'],
      batRun: json['bat_run'],
      batFour: json['bat_four'],
      batSix: json['bat_six'],
      batHalfCentury: json['bat_half_century'],
      batCentury: json['bat_century'],
      batDuck: json['bat_duck'],
      bowlWicket: json['bowl_wicket'],
      bowl4wicket: json['bowl_4wicket'],
      bowl5wicket: json['bowl_5wicket'],
      bowlMaiden: json['bowl_maiden'],
      bowlDotball: json['bowl_dotball'],
      fieldCatch: json['field_catch'],
      fieldRunoutDirect: json['field_runout_direct'],
      fieldRunoutThrower: json['field_runout_thrower'],
      fieldRunoutCatcher: json['field_runout_catcher'],
      captain: json['captain'] != null ? double.parse(json['captain'].toString()) : null,
      viceCaptain: json['vice_captain'] != null ? double.parse(json['vice_captain'].toString()) : null,
      starting11: json['starting_11'],
      t10Bonus30Runs: json['t10_bonus30_runs'],
      t10Bonus50Runs: json['t10_bonus50_runs'],
      t10Bowling2Wicket: json['t10_bowling2_wicket'],
      t10Bowling3Wicket: json['t10_bowling3_wicket'],
      t20EcoLt4runs: json['t20_eco_lt4runs'],
      t20EcoGt4runs: json['t20_eco_gt4runs'],
      t20EcoGt5runs: json['t20_eco_gt5runs'],
      t20EcoGt9runs: json['t20_eco_gt9runs'],
      t20EcoGt10runs: json['t20_eco_gt10runs'],
      t20EcoGt11runs: json['t20_eco_gt11runs'],
      odiEcoLt2_5runs: json['odi_eco_lt2_5runs'],
      odiEcoGt2_5runs: json['odi_eco_gt2_5runs'],
      odiEcoGt3_5runs: json['odi_eco_gt3_5runs'],
      odiEcoGt5runs: json['odi_eco_gt5runs'],
      odiEcoGt8runs: json['odi_eco_gt8runs'],
      odiEcoGt9runs: json['odi_eco_gt9runs'],
      t10EcoLt6runs: json['t10_eco_lt6runs'],
      t10EcoGt6runs: json['t10_eco_gt6runs'],
      t10EcoBt7_8runs: json['t10_eco_bt7_8runs'],
      t10EcoBt11_12runs: json['t10_eco_bt11_12runs'],
      t10EcoBt12_13runs: json['t10_eco_bt12_13runs'],
      t10EcoGt13_runs: json['t10_eco_gt13_runs'],
      t20StrikeLt50runs: json['t20_strike_lt50runs'],
      t20StrikeGt50runs: json['t20_strike_gt50runs'],
      t20StrikeGt60runs: json['t20_strike_gt60runs'],
      odiStrikeLt40runs: json['odi_strike_lt40runs'],
      odiStrikeGt40runs: json['odi_strike_gt40runs'],
      odiStrikeGt50runs: json['odi_strike_gt50runs'],
      t10StrikeLt80runs: json['t10_strike_lt80runs'],
      t10StrikeBt80_90runs: json['t10_strike_bt80_90runs'],
      t10StrikeGt90runs: json['t10_strike_gt90runs'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'match_type': matchType,
      'bat_run': batRun,
      'bat_four': batFour,
      'bat_six': batSix,
      'bat_half_century': batHalfCentury,
      'bat_century': batCentury,
      'bat_duck': batDuck,
      'bowl_wicket': bowlWicket,
      'bowl_4wicket': bowl4wicket,
      'bowl_5wicket': bowl5wicket,
      'bowl_maiden': bowlMaiden,
      'bowl_dotball': bowlDotball,
      'field_catch': fieldCatch,
      'field_runout_direct': fieldRunoutDirect,
      'field_runout_thrower': fieldRunoutThrower,
      'field_runout_catcher': fieldRunoutCatcher,
      'captain': captain,
      'vice_captain': viceCaptain,
      'starting_11': starting11,
      't10_bonus30_runs': t10Bonus30Runs,
      't10_bonus50_runs': t10Bonus50Runs,
      't10_bowling2_wicket': t10Bowling2Wicket,
      't10_bowling3_wicket': t10Bowling3Wicket,
      't20_eco_lt4runs': t20EcoLt4runs,
      't20_eco_gt4runs': t20EcoGt4runs,
      't20_eco_gt5runs': t20EcoGt5runs,
      't20_eco_gt9runs': t20EcoGt9runs,
      't20_eco_gt10runs': t20EcoGt10runs,
      't20_eco_gt11runs': t20EcoGt11runs,
      'odi_eco_lt2_5runs': odiEcoLt2_5runs,
      'odi_eco_gt2_5runs': odiEcoGt2_5runs,
      'odi_eco_gt3_5runs': odiEcoGt3_5runs,
      'odi_eco_gt5runs': odiEcoGt5runs,
      'odi_eco_gt8runs': odiEcoGt8runs,
      'odi_eco_gt9runs': odiEcoGt9runs,
      't10_eco_lt6runs': t10EcoLt6runs,
      't10_eco_gt6runs': t10EcoGt6runs,
      't10_eco_bt7_8runs': t10EcoBt7_8runs,
      't10_eco_bt11_12runs': t10EcoBt11_12runs,
      't10_eco_bt12_13runs': t10EcoBt12_13runs,
      't10_eco_gt13_runs': t10EcoGt13_runs,
      't20_strike_lt50runs': t20StrikeLt50runs,
      't20_strike_gt50runs': t20StrikeGt50runs,
      't20_strike_gt60runs': t20StrikeGt60runs,
      'odi_strike_lt40runs': odiStrikeLt40runs,
      'odi_strike_gt40runs': odiStrikeGt40runs,
      'odi_strike_gt50runs': odiStrikeGt50runs,
      't10_strike_lt80runs': t10StrikeLt80runs,
      't10_strike_bt80_90runs': t10StrikeBt80_90runs,
      't10_strike_gt90runs': t10StrikeGt90runs,
    };
  }
}