import 'dart:math' as math;
import 'package:flutter/material.dart';

/// ----------------------
/// DESIGN SYSTEM
/// ----------------------
class AppColors {
  static const bg = Color(0xFFF8FAFC);
  static const bg2 = Color(0xFFF1F5F9);
  static const ink = Color(0xFF1F2937);
  static const sub = Color(0xFF6B7280);

  static const primary = Color(0xFF2563EB);
  static const primaryDark = Color(0xFF1D4ED8);

  static const success = Color(0xFF10B981);
  static const successDark = Color(0xFF059669);

  static const accentBlue = Color(0xFF3B82F6);
  static const accentIndigo = Color(0xFF6366F1);
  static const accentViolet = Color(0xFF7C3AED);
  static const warn = Color(0xFFF59E0B);
}

class AppText {
  static const title = TextStyle(
    color: AppColors.ink,
    fontSize: 18,
    fontWeight: FontWeight.w700,
  );
  static const h2 = TextStyle(
    color: AppColors.ink,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );
  static const body = TextStyle(
    color: AppColors.ink,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );
  static const small = TextStyle(
    color: AppColors.sub,
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );
}

class Spacing {
  static const xs = 6.0;
  static const sm = 10.0;
  static const md = 14.0;
  static const lg = 18.0;
  static const xl = 22.0;
}

/// ----------------------
/// REUSABLE WIDGETS
/// ----------------------
class StatusBadge extends StatelessWidget {
  final String text;
  final Color color;
  final Color? bg;
  final EdgeInsets padding;
  final double radius;

  const StatusBadge({
    super.key,
    required this.text,
    required this.color,
    this.bg,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    this.radius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: bg ?? color.withOpacity(.1),
        border: Border.all(color: color.withOpacity(.2)),
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Text(
        text,
        style: AppText.small.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
          letterSpacing: .2,
        ),
      ),
    );
  }
}

class GradientButton extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final String label;

  const GradientButton({
    super.key,
    required this.onTap,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(.25),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    letterSpacing: .2,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OutlineButtonSmall extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final String label;

  const OutlineButtonSmall({
    super.key,
    required this.onTap,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primary, width: 1.2),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: AppColors.primary, size: 18),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    letterSpacing: .2,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SmallCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final EdgeInsets? margin;
  final BorderRadius radius;

  const SmallCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(14),
    this.margin,
    this.radius = const BorderRadius.all(Radius.circular(14)),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: radius,
        border: Border.all(color: AppColors.accentIndigo.withOpacity(.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: padding,
      child: child,
    );
  }
}

class CompactDivider extends StatelessWidget {
  const CompactDivider({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(height: 1, color: Colors.grey.shade100);
  }
}

/// ----------------------
/// COMPLETED MATCHES
/// ----------------------
class CompletedMatchesPage extends StatelessWidget {
  const CompletedMatchesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      //   title: const Text("", style: AppText.title),
      //   centerTitle: true,
      // ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter, end: Alignment.bottomCenter,
            colors: [AppColors.bg, AppColors.bg2],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            MatchCard(
              team1: const TeamMeta(
                name: 'Phoenix Cricketers', short: 'PC', emoji: '🏏',
                score: '148/7', overs: '17.3',
                primary: AppColors.accentBlue,
              ),
              team2: const TeamMeta(
                name: 'Lexus', short: 'LEX', emoji: '🏆',
                score: '147/10', overs: '19.4',
                primary: AppColors.accentViolet,
              ),
              winnerText: 'Phoenix Cricketers won by 3 wickets',
              totalWinnings: '₹10,000',
              winners: '81',
              entry: '₹100',
              isWinner: true,
              onTap: () => _showMatchDetails(context),
            ),
            const SizedBox(height: 14),
            MatchCard(
              team1: const TeamMeta(
                name: 'Nellai Royal Kings', short: 'NRK', emoji: '👑',
                score: '165/8', overs: '20.0',
                primary: AppColors.accentBlue,
              ),
              team2: const TeamMeta(
                name: 'Dindigul Dragons', short: 'DD', emoji: '🐉',
                score: '162/9', overs: '20.0',
                primary: AppColors.accentViolet,
              ),
              winnerText: 'Nellai Royal Kings won by 3 runs',
              totalWinnings: '₹15,000',
              winners: '94',
              entry: '₹150',
              isWinner: true,
              onTap: () => _showMatchDetails(context),
            ),
            const SizedBox(height: 14),
            MatchCard(
              team1: const TeamMeta(
                name: 'Lyca Kovai Kings', short: 'LKK', emoji: '⚡',
                score: '178/6', overs: '20.0',
                primary: AppColors.accentBlue,
              ),
              team2: const TeamMeta(
                name: 'IDream Tiruppur Tamizhans', short: 'TT', emoji: '🌟',
                score: '175/8', overs: '20.0',
                primary: AppColors.accentViolet,
              ),
              winnerText: 'Lyca Kovai Kings won by 3 runs',
              totalWinnings: '₹12,000',
              winners: '67',
              entry: '₹120',
              isWinner: true,
              onTap: () => _showMatchDetails(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showMatchDetails(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const MatchDetailsPage()));
  }
}

class TeamMeta {
  final String name;
  final String short;
  final String emoji;
  final String score;
  final String overs;
  final Color primary;

  const TeamMeta({
    required this.name,
    required this.short,
    required this.emoji,
    required this.score,
    required this.overs,
    required this.primary,
  });
}

class MatchCard extends StatelessWidget {
  final TeamMeta team1;
  final TeamMeta team2;
  final String winnerText;
  final String totalWinnings;
  final String winners;
  final String entry;
  final VoidCallback onTap;
  final bool isWinner;

  const MatchCard({
    super.key,
    required this.team1,
    required this.team2,
    required this.winnerText,
    required this.totalWinnings,
    required this.winners,
    required this.entry,
    required this.onTap,
    required this.isWinner,
  });

  @override
  Widget build(BuildContext context) {
    return SmallCard(
      padding: const EdgeInsets.all(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Column(
          children: [
            // Compact "Completed" badge
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StatusBadge(
                  text: 'Completed',
                  color: AppColors.successDark,
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  radius: 10,
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Teams row
            Row(
              children: [
                Expanded(child: _TeamSide(meta: team1, alignEnd: false)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(.65),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text('VS',
                    style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700),
                  ),
                ),
                Expanded(child: _TeamSide(meta: team2, alignEnd: true)),
              ],
            ),

            const SizedBox(height: 12),
            // Score strip
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.bg,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.accentIndigo.withOpacity(.08)),
              ),
              child: Row(
                children: [
                  Expanded(child: _ScoreBlock(score: team1.score, overs: team1.overs)),
                  Container(width: 1, height: 28, color: Colors.black12),
                  Expanded(child: _ScoreBlock(score: team2.score, overs: team2.overs)),
                ],
              ),
            ),

            const SizedBox(height: 10),
            // Winner
            Row(
              children: [
                const Icon(Icons.emoji_events, size: 16, color: AppColors.warn),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    winnerText,
                    style: AppText.small.copyWith(
                      color: AppColors.warn,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),
            // Prize row (compact)
            Row(
              children: [
                Expanded(child: _PrizeCell(label: 'Total Winnings', value: totalWinnings)),
                Expanded(child: _PrizeCell(label: 'Winners', value: winners)),
                Expanded(child: _PrizeCell(label: 'Entry Fee', value: entry)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TeamSide extends StatelessWidget {
  final TeamMeta meta;
  final bool alignEnd;

  const _TeamSide({required this.meta, required this.alignEnd});

  @override
  Widget build(BuildContext context) {
    final align = alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    return Column(
      crossAxisAlignment: align,
      children: [
        Text(
          meta.name,
          maxLines: 1, overflow: TextOverflow.ellipsis,
          style: AppText.body.copyWith(fontWeight: FontWeight.w700),
          textAlign: alignEnd ? TextAlign.end : TextAlign.start,
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: alignEnd ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            if (!alignEnd) _Logo(meta: meta),
            if (!alignEnd) const SizedBox(width: 8),
            _ShortTag(meta: meta),
            if (alignEnd) const SizedBox(width: 8),
            if (alignEnd) _Logo(meta: meta),
          ],
        ),
      ],
    );
  }
}

class _Logo extends StatelessWidget {
  final TeamMeta meta;
  const _Logo({required this.meta});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34, height: 34,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [meta.primary.withOpacity(.9), meta.primary]),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: meta.primary.withOpacity(.25), blurRadius: 6, offset: const Offset(0, 3))],
      ),
      child: Center(child: Text(meta.emoji, style: const TextStyle(fontSize: 16))),
    );
  }
}

class _ShortTag extends StatelessWidget {
  final TeamMeta meta;
  const _ShortTag({required this.meta});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: meta.primary.withOpacity(.08),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        meta.short,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w800,
          color: meta.primary,
          letterSpacing: .2,
        ),
      ),
    );
  }
}

class _ScoreBlock extends StatelessWidget {
  final String score, overs;
  const _ScoreBlock({required this.score, required this.overs});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(score, style: AppText.h2.copyWith(fontSize: 18, fontWeight: FontWeight.w800)),
        const SizedBox(height: 2),
        Text('($overs ov)', style: AppText.small),
      ],
    );
  }
}

class _PrizeCell extends StatelessWidget {
  final String label, value;
  const _PrizeCell({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppText.small),
        const SizedBox(height: 2),
        Text(value, style: AppText.h2.copyWith(color: AppColors.successDark)),
      ],
    );
  }
}

/// ----------------------
/// MATCH DETAILS
/// ----------------------
class MatchDetailsPage extends StatelessWidget {
  const MatchDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: Colors.white, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios, color: Colors.black87), onPressed: () => Navigator.pop(context)),
        title: const Text('Match Details', style: AppText.h2),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            SmallCard(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: _MiniTeamTile(emoji: '🏏', short: 'PC', name: 'Phoenix Cricketers', color: AppColors.accentBlue)),
                      const StatusBadge(text: 'PC 6 5 LEX', color: AppColors.successDark),
                      Expanded(child: _MiniTeamTile(emoji: '🏆', short: 'LEX', name: 'Lexus', color: AppColors.accentViolet, right: true)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const StatusBadge(text: 'Completed', color: AppColors.successDark),
                  const SizedBox(height: 8),
                  Text('Phoenix Cricketers won by 3 wickets',
                      style: AppText.small.copyWith(color: AppColors.successDark, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SmallCard(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(child: GradientButton(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ScorecardPage())),
                    icon: Icons.leaderboard_rounded, label: 'Scorecard',
                  )),
                  const SizedBox(width: 10),
                  Expanded(child: OutlineButtonSmall(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PlayerStatsPage())),
                    icon: Icons.analytics_outlined, label: 'Player Stats',
                  )),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: SmallCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      const Text('Leaderboard', style: AppText.h2),
                      TextButton(
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LeaderboardPage())),
                        child: const Text('View All'),
                      )
                    ]),
                    const SizedBox(height: 8),
                    Expanded(
                      child: ListView(
                        children: const [
                          LeaderboardTile(rank: '1', name: 'shiv18', points: '907.5', color: Colors.amber),
                          LeaderboardTile(rank: '2', name: 'john_doe', points: '900.5', color: Colors.grey),
                          LeaderboardTile(rank: '3', name: 'cricket_fan', points: '844.5', color: Colors.orange),
                          LeaderboardTile(rank: '4', name: 'player123', points: '820.0', color: Colors.blue),
                          LeaderboardTile(rank: '5', name: 'sports_lover', points: '798.5', color: Colors.green),
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
}

class _MiniTeamTile extends StatelessWidget {
  final String emoji, short, name;
  final Color color;
  final bool right;

  const _MiniTeamTile({
    required this.emoji,
    required this.short,
    required this.name,
    required this.color,
    this.right = false,
  });

  @override
  Widget build(BuildContext context) {
    final align = right ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    return Column(
      crossAxisAlignment: align,
      children: [
        Container(
          width: 42, height: 42,
          decoration: BoxDecoration(color: color.withOpacity(.08), borderRadius: BorderRadius.circular(10)),
          child: Center(child: Text(emoji, style: const TextStyle(fontSize: 22))),
        ),
        const SizedBox(height: 6),
        Text(short, style: AppText.h2),
        Text(name, style: AppText.small, textAlign: right ? TextAlign.end : TextAlign.start, maxLines: 1, overflow: TextOverflow.ellipsis),
      ],
    );
  }
}

class LeaderboardTile extends StatelessWidget {
  final String rank, name, points;
  final Color color;
  const LeaderboardTile({super.key, required this.rank, required this.name, required this.points, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(color: Colors.grey.withOpacity(.06), borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          Container(
            width: 22, height: 22,
            decoration: BoxDecoration(color: color.withOpacity(.2), borderRadius: BorderRadius.circular(4)),
            child: Center(child: Text(rank, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800))),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(name, style: AppText.body)),
          Text(points, style: AppText.body.copyWith(fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}

/// ----------------------
/// TEAM PREVIEW (unchanged logic; condensed paddings & sizes)
/// ----------------------
class TeamPreviewPage extends StatelessWidget {
  final String playerName;
  final String totalPoints;

  const TeamPreviewPage({super.key, required this.playerName, required this.totalPoints});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final availableHeight = screenHeight - kToolbarHeight - MediaQuery.of(context).padding.top - 160;

    return Scaffold(
      backgroundColor: Colors.green[600],
      appBar: AppBar(
        backgroundColor: Colors.green[600], elevation: 0,
        leading: IconButton(icon: const Icon(Icons.close, color: Colors.white), onPressed: () => Navigator.pop(context)),
        title: const Text('Team Preview', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(color: Colors.green[700], borderRadius: BorderRadius.circular(14)),
            child: const Text('Completed', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
          ),
          SizedBox(
            height: availableHeight, width: screenWidth,
            child: CustomPaint(
              painter: CricketFieldPainter(),
              child: Stack(
                children: [
                  _FieldSection(
                    top: availableHeight * 0.08,
                    title: 'WICKET KEEPER',
                    children: [
                      _player('V Vadakke...', '55.0 Pts', true, false, screenWidth),
                      _player('S Balakrishn...', '105.0 Pts', true, true, screenWidth),
                      _player('J Cholayil', '96.0 Pts', true, false, screenWidth),
                    ],
                  ),
                  _FieldSection(
                    top: availableHeight * 0.25,
                    title: 'BATSMAN',
                    wrap: true,
                    children: [
                      _player('S Sudhaka...', '40.0 Pts', true, false, screenWidth),
                      _player('SR Henry', '23.0 Pts', false, false, screenWidth),
                      _player('R Kumar', '5.0 Pts', true, false, screenWidth),
                      _player('AFA Kadar', '41.0 Pts', false, false, screenWidth),
                      _player('J Cyril', '11.0 Pts', false, false, screenWidth),
                    ],
                  ),
                  _FieldSection(
                    top: availableHeight * 0.5,
                    title: 'ALL ROUNDER',
                    children: [
                      _player('R Raj', '346.5 Pts', true, true, screenWidth),
                      _player('IH Banwa', '92.0 Pts', false, false, screenWidth),
                    ],
                  ),
                  _FieldSection(
                    bottom: availableHeight * 0.08,
                    title: 'BOWLER',
                    children: [
                      _player('A Kumar', '45.0 Pts', true, false, screenWidth),
                      _player('M Singh', '38.0 Pts', false, false, screenWidth),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.black.withOpacity(.85), borderRadius: BorderRadius.circular(10)),
            child: Column(
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Flexible(child: Text(playerName, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700), overflow: TextOverflow.ellipsis)),
                  Text('$totalPoints Points', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                ]),
                const SizedBox(height: 8),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  const Text('Rank: #1', style: TextStyle(color: Colors.white70, fontSize: 12)),
                  Text('Prize: ₹2,500', style: TextStyle(color: Colors.green[300], fontSize: 12, fontWeight: FontWeight.w700)),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _player(String n, String pts, bool sel, bool cap, double w) {
    final cardSize = w * 0.10; // Slightly smaller
    final iconSize = cardSize * 0.52;
    return SizedBox(
      width: cardSize + 8,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: cardSize, height: cardSize,
            decoration: BoxDecoration(
              color: sel ? Colors.blue[600] : Colors.yellow[700],
              borderRadius: BorderRadius.circular(cardSize / 2),
              border: Border.all(color: cap ? Colors.orange : Colors.white, width: 2),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(.25), blurRadius: 4, offset: const Offset(0, 2))],
            ),
            child: Stack(
              children: [
                Center(child: Icon(Icons.sports_cricket, size: iconSize, color: Colors.white)),
                if (cap)
                  Positioned(
                    top: 0, right: 0,
                    child: Container(
                      width: cardSize * 0.28, height: cardSize * 0.28,
                      decoration: const BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
                      child: Center(child: Text('C', style: TextStyle(color: Colors.white, fontSize: cardSize * 0.18, fontWeight: FontWeight.w800))),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 3),
          Text(n, style: TextStyle(color: Colors.white, fontSize: w * 0.018, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center),
          Text(pts, style: TextStyle(color: Colors.white70, fontSize: w * 0.016), maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _FieldSection extends StatelessWidget {
  final double? top;
  final double? bottom;
  final String title;
  final bool wrap;
  final List<Widget> children;
  const _FieldSection({this.top, this.bottom, required this.title, this.wrap = false, required this.children});

  @override
  Widget build(BuildContext context) {
    final label = Text(title, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w800));
    final content = wrap
        ? Wrap(alignment: WrapAlignment.center, spacing: 8, runSpacing: 6, children: children)
        : Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: children);

    return Positioned(
      top: top, bottom: bottom, left: 0, right: 0,
      child: Column(children: [label, const SizedBox(height: 6), content]),
    );
  }
}

/// ----------------------
/// SCORECARD (compact tabs)
/// ----------------------
class ScorecardPage extends StatefulWidget {
  const ScorecardPage({super.key});

  @override
  State<ScorecardPage> createState() => _ScorecardPageState();
}

class _ScorecardPageState extends State<ScorecardPage> {
  int selectedTeamIndex = 0; // 0 Lexus, 1 Phoenix

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: Colors.white, elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios, color: Colors.black87), onPressed: () => Navigator.pop(context)),
        title: const Text('Scorecard', style: AppText.h2),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            SmallCard(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: _ScoreTeam(name: 'Lexus', score: '147/10', overs: '(19.4)', icon: Icons.directions_car, color: Colors.black54)),
                      const SizedBox(width: 2),
                      Text('VS', style: AppText.small),
                      const SizedBox(width: 2),
                      Expanded(child: _ScoreTeam(name: 'Phoenix Cricketers', score: '148/7', overs: '(17.3)', icon: Icons.sports_cricket, color: Colors.red)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const StatusBadge(text: 'Completed', color: AppColors.successDark),
                  const SizedBox(height: 8),
                  const Text('Phoenix Cricketers won by 3 wickets', style: AppText.body, textAlign: TextAlign.center),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // COMPACT PILL TABS
            SmallCard(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
              child: Column(
                children: [
                  _CompactSegmented(
                    options: const ['Lexus', 'Phoenix Cricketers'],
                    index: selectedTeamIndex,
                    onChanged: (i) => setState(() => selectedTeamIndex = i),
                  ),
                  const SizedBox(height: 8),
                  const CompactDivider(),
                  _BattingHeader(),
                  ...getBattingData(selectedTeamIndex).map(_batterRow).toList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _batterRow(Map<String, dynamic> p) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade100))),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Container(
                  width: 7, height: 7,
                  margin: const EdgeInsets.only(right: 6),
                  decoration: BoxDecoration(color: p['isOut'] ? Colors.red : Colors.green, shape: BoxShape.circle),
                ),
                Text(p['name'], style: AppText.body),
              ]),
              if (p['dismissal'] != null) ...[
                const SizedBox(height: 2),
                Text(p['dismissal'], style: AppText.small),
              ]
            ]),
          ),
          _cell(p['runs'].toString(), isBold: true),
          _cell(p['balls'].toString()),
          _cell(p['fours'].toString()),
          _cell(p['sixes'].toString()),
          _cell((p['strikeRate'] as num).toStringAsFixed(2)),
        ],
      ),
    );
  }

  Widget _cell(String t, {bool isBold = false}) => SizedBox(
    width: 44,
    child: Text(
      t,
      textAlign: TextAlign.center,
      style: isBold ? AppText.body : AppText.body.copyWith(fontWeight: FontWeight.w500),
    ),
  );

  List<Map<String, dynamic>> getBattingData(int teamIndex) {
    if (teamIndex == 0) {
      return [
        {
          'name': 'Sunil Raja Henry',
          'dismissal': 'runout (S Balakrishnan / V Va...)',
          'runs': 9, 'balls': 6, 'fours': 2, 'sixes': 0, 'strikeRate': 150.00, 'isOut': true,
        },
        {
          'name': 'Julius Cyril',
          'dismissal': 'c V Vadakkemadathil b M Sa...',
          'runs': 7, 'balls': 15, 'fours': 0, 'sixes': 0, 'strikeRate': 46.67, 'isOut': true,
        },
        {
          'name': 'Ismail Hanif Banwa',
          'dismissal': 'c S Kassim b M Sawood',
          'runs': 25, 'balls': 24, 'fours': 3, 'sixes': 0, 'strikeRate': 104.17, 'isOut': true,
        },
        {
          'name': 'Mahammad Ajizbhai...',
          'dismissal': 'runout (S Balakrishnan / R Raj)',
          'runs': 45, 'balls': 26, 'fours': 5, 'sixes': 1, 'strikeRate': 173.08, 'isOut': true,
        },
        {
          'name': 'Rijil Venugopal',
          'dismissal': 'c J Vellapparakunnil b S Kassi...',
          'runs': 4, 'balls': 5, 'fours': 0, 'sixes': 0, 'strikeRate': 80.00, 'isOut': true,
        },
        {
          'name': 'Ansari Farhan Abdul...',
          'dismissal': 'b R Raj',
          'runs': 19, 'balls': 23, 'fours': 2, 'sixes': 0, 'strikeRate': 82.61, 'isOut': true,
        },
        {
          'name': 'Muhammad Usman',
          'dismissal': 'c S Kassim b R Raj',
          'runs': 20, 'balls': 13, 'fours': 1, 'sixes': 1, 'strikeRate': 153.85, 'isOut': true,
        },
        {
          'name': 'Sameer Thajudeen',
          'dismissal': 'runout (R Raj)',
          'runs': 8, 'balls': 6, 'fours': 0, 'sixes': 1, 'strikeRate': 133.33, 'isOut': true,
        },
        {
          'name': 'Mohamed Shihab',
          'dismissal': 'runout (R Raj / S Balakrishnan)',
          'runs': 0, 'balls': 1, 'fours': 0, 'sixes': 0, 'strikeRate': 0.00, 'isOut': true,
        },
      ];
    } else {
      return [
        {'name': 'V Vadakkemadathil', 'dismissal': 'c S Raja Henry b J Cyril', 'runs': 32, 'balls': 28, 'fours': 4, 'sixes': 1, 'strikeRate': 114.29, 'isOut': true},
        {'name': 'S Balakrishnan', 'dismissal': 'lbw b M Ajizbhai', 'runs': 18, 'balls': 15, 'fours': 2, 'sixes': 0, 'strikeRate': 120.00, 'isOut': true},
        {'name': 'R Raj', 'dismissal': null, 'runs': 42, 'balls': 31, 'fours': 3, 'sixes': 2, 'strikeRate': 135.48, 'isOut': false},
        {'name': 'S Kassim', 'dismissal': 'c I Banwa b U Farhan', 'runs': 15, 'balls': 12, 'fours': 1, 'sixes': 1, 'strikeRate': 125.00, 'isOut': true},
        {'name': 'M Sawood', 'dismissal': null, 'runs': 28, 'balls': 18, 'fours': 2, 'sixes': 1, 'strikeRate': 155.56, 'isOut': false},
        {'name': 'J Vellapparakunnil', 'dismissal': 'b M Usman', 'runs': 7, 'balls': 8, 'fours': 1, 'sixes': 0, 'strikeRate': 87.50, 'isOut': true},
        {'name': 'A Mohammed', 'dismissal': 'c S Thajudeen b R Venugopal', 'runs': 3, 'balls': 5, 'fours': 0, 'sixes': 0, 'strikeRate': 60.00, 'isOut': true},
        {'name': 'K Rahman', 'dismissal': 'run out (M Shihab)', 'runs': 1, 'balls': 2, 'fours': 0, 'sixes': 0, 'strikeRate': 50.00, 'isOut': true},
      ];
    }
  }
}

class _ScoreTeam extends StatelessWidget {
  final String name;
  final String score;
  final String overs;
  final IconData icon;
  final Color color;

  const _ScoreTeam({
    required this.name, required this.score, required this.overs,
    required this.icon, required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        width: 42, height: 42,
        decoration: BoxDecoration(color: color.withOpacity(.08), shape: BoxShape.circle),
        child: Icon(icon, color: color, size: 20),
      ),
      const SizedBox(height: 6),
      Text(name, style: AppText.body, textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
      const SizedBox(height: 2),
      Text(score, style: AppText.h2.copyWith(fontSize: 16)),
      Text(overs, style: AppText.small),
    ]);
  }
}

class _CompactSegmented extends StatelessWidget {
  final List<String> options;
  final int index;
  final ValueChanged<int> onChanged;

  const _CompactSegmented({required this.options, required this.index, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: List.generate(options.length, (i) {
          final selected = i == index;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                margin: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: selected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: selected
                      ? [BoxShadow(color: Colors.black.withOpacity(.06), blurRadius: 6, offset: const Offset(0, 2))]
                      : null,
                ),
                child: Center(
                  child: Text(
                    options[i],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.small.copyWith(
                      fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                      color: selected ? AppColors.ink : AppColors.sub,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _BattingHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Text _h(String t) => Text(t, style: AppText.small.copyWith(color: AppColors.ink, fontWeight: FontWeight.w800), textAlign: TextAlign.center);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      color: Colors.grey.shade50,
      child: Row(
        children: [
          const Expanded(flex: 3, child: Text('BATTER', style: AppText.h2)),
          SizedBox(width: 44, child: _h('R')),
          SizedBox(width: 44, child: _h('B')),
          SizedBox(width: 44, child: _h('4s')),
          SizedBox(width: 44, child: _h('6s')),
          SizedBox(width: 44, child: _h('S/R')),
        ],
      ),
    );
  }
}

/// ----------------------
/// PLAYER STATS (same logic, compact UI)
/// ----------------------
class Player {
  final String name;
  final double selectedByPercentage;
  final double points;
  final Map<String, dynamic> stats;
  Player({required this.name, required this.selectedByPercentage, required this.points, required this.stats});
}

class PlayerStatsPage extends StatelessWidget {
  PlayerStatsPage({super.key});

  final List<Player> players = [
  Player(
  name: 'Renil Raj', selectedByPercentage: 66.9, points: 231.0,
  stats: {'Starting 11': {'actual': 'Yes', 'points': 4}, 'Runs': {'actual': 52, 'points': 52}, '4\'s': {'actual': 4, 'points': 20}, '6\'s': {'actual': 3, 'points': 24}, 'S/R': {'actual': 153, 'points': 0}, '50': {'actual': 'Yes', 'points': 8}, '100': {'actual': 'No', 'points': 0}, 'Duck': {'actual': 'No', 'points': 0}, 'Wkts': {'actual': 2, 'points': 50}},
  ),
  Player(
  name: 'Shibu Balakrishnan', selectedByPercentage: 22.3, points: 105.0,
  stats: {'Starting 11': {'actual': 'Yes', 'points': 4}, 'Runs': {'actual': 35, 'points': 35}, '4\'s': {'actual': 2, 'points': 10}, '6\'s': {'actual': 1, 'points': 8}, 'S/R': {'actual': 125, 'points': 0}, '50': {'actual': 'No', 'points': 0}, '100': {'actual': 'No', 'points': 0}, 'Duck': {'actual': 'No', 'points': 0}, 'Wkts': {'actual': 4, 'points': 100}},
  ),
  Player(
  name: 'Mohammed Sawood', selectedByPercentage: 1.1, points: 78.0,
  stats: {'Starting 11': {'actual': 'Yes', 'points': 4}, 'Runs': {'actual': 28, 'points': 28}, '4\'s': {'actual': 3, 'points': 15}, '6\'s': {'actual': 1, 'points': 8}, 'S/R': {'actual': 140, 'points': 0}, '50': {'actual': 'No', 'points': 0}, '100': {'actual': 'No', 'points': 0}, 'Duck': {'actual': 'No', 'points': 0}, 'Wkts': {'actual': 2, 'points': 50}},
  ),
  Player(
  name: 'Vinod Vadakkemadathil', selectedByPercentage: 73.1, points: 55.0,
  stats: {'Starting 11': {'actual': 'Yes', 'points': 4}, 'Runs': {'actual': 18, 'points': 18}, '4\'s': {'actual': 1, 'points': 5}, '6\'s': {'actual': 0, 'points': 0}, 'S/R': {'actual': 90, 'points': 0}, '50': {'actual': 'No', 'points': 0}, '100': {'actual': 'No', 'points': 0}, 'Duck': {'actual': 'No', 'points': 0}, 'Wkts': {'actual': 3, 'points': 75}},
  ),
  Player(
  name: 'Jishudas Cholayil', selectedByPercentage: 40.6, points: 48.0,
  stats: {'Starting 11': {'actual': 'Yes', 'points': 4}, 'Runs': {'actual': 22, 'points': 22}, '4\'s': {'actual': 2, 'points': 10}, '6\'s': {'actual': 0, 'points': 0}, 'S/R': {'actual': 110, 'points': 0}, '50': {'actual': 'No', 'points': 0}, '100': {'actual': 'No', 'points': 0}, 'Duck': {'actual': 'No', 'points': 0}, 'Wkts': {'actual': 1, 'points': 25}},
  ),
  Player(
  name: 'Sadiq Kassim', selectedByPercentage: 3.4, points: 48.0,
  stats: {'Starting 11': {'actual': 'Yes', 'points': 4}, 'Runs': {'actual': 19, 'points': 19}, '4\'s': {'actual': 1, 'points': 5}, '6\'s': {'actual': 1, 'points': 8}, 'S/R': {'actual': 95, 'points': 0}, '50': {'actual': 'No', 'points': 0}, '100': {'actual': 'No', 'points': 0}, 'Duck': {'actual': 'No', 'points': 0}, 'Wkts': {'actual': 1, 'points': 25}},
  ),
  Player(
  name: 'Suneesh Sudhakaran', selectedByPercentage: 60.6, points: 40.0,
  stats: {'Starting 11': {'actual': 'Yes', 'points': 4}, 'Runs': {'actual': 15, 'points': 15}, '4\'s': {'actual': 1, 'points': 5}, '6\'s': {'actual': 0, 'points': 0}, 'S/R': {'actual': 75, 'points': 0}, '50': {'actual': 'No', 'points': 0}, '100': {'actual': 'No', 'points': 0}, 'Duck': {'actual': 'No', 'points': 0}, 'Wkts': {'actual': 2, 'points': 50}},
  ),
  Player(
  name: 'Sonu Sudhakaran', selectedByPercentage: 0.0, points: 28.0,
  stats: {'Starting 11': {'actual': 'Yes', 'points': 4}, 'Runs': {'actual': 12, 'points': 12}, '4\'s': {'actual': 1, 'points': 5}, '6\'s': {'actual': 0, 'points': 0}, 'S/R': {'actual': 80, 'points': 0}, '50': {'actual': 'No', 'points': 0}, '100': {'actual': 'No', 'points': 0}, 'Duck': {'actual': 'No', 'points': 0}, 'Wkts': {'actual': 0, 'points': 0}},
  ),
  Player(
  name: 'Jithu Vellapparakunnil', selectedByPercentage: 48.6, points: 23.0,
  stats: {'Starting 11': {'actual': 'Yes', 'points': 4}, 'Runs': {'actual': 8, 'points': 8}, '4\'s': {'actual': 0, 'points': 0}, '6\'s': {'actual': 0, 'points': 0}, 'S/R': {'actual': 67, 'points': 0}, '50': {'actual': 'No', 'points': 0}, '100': {'actual': 'No', 'points': 0}, 'Duck': {'actual': 'No', 'points': 0}, 'Wkts': {'actual': 1, 'points': 25}},
  ),
    Player(
      name: 'Roshan Kumar', selectedByPercentage: 97.7, points: 5.0,
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
      name: 'Sameer Thajudeen', selectedByPercentage: 22.5, points: 8.0,
      stats: {
        'Starting 11': {'actual': 'Yes', 'points': 4},
        'Runs': {'actual': 8, 'points': 8},
        '4\'s': {'actual': 0, 'points': 0},
        '6\'s': {'actual': 1, 'points': 8},
        'S/R': {'actual': 133, 'points': 0},
        '50': {'actual': 'No', 'points': 0},
        '100': {'actual': 'No', 'points': 0},
        'Duck': {'actual': 'No', 'points': 0},
        'Wkts': {'actual': 0, 'points': 0},
      },
    ),
    Player(
      name: 'Mohamed Shihab', selectedByPercentage: 10.2, points: 0.0,
      stats: {
        'Starting 11': {'actual': 'Yes', 'points': 4},
        'Runs': {'actual': 0, 'points': 0},
        '4\'s': {'actual': 0, 'points': 0},
        '6\'s': {'actual': 0, 'points': 0},
        'S/R': {'actual': 0, 'points': 0},
        '50': {'actual': 'No', 'points': 0},
        '100': {'actual': 'No', 'points': 0},
        'Duck': {'actual': 'Yes', 'points': -2},
        'Wkts': {'actual': 0, 'points': 0},
      },
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: Colors.white, elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Player Stats', style: AppText.h2),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(14),
        itemCount: players.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final p = players[index];
          return SmallCard(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row
                Row(
                  children: [
                    Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.accentIndigo.withOpacity(.08),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.person, color: AppColors.accentIndigo, size: 20),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(p.name, style: AppText.h2, maxLines: 1, overflow: TextOverflow.ellipsis),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.success.withOpacity(.08),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${p.points.toStringAsFixed(1)} pts',
                        style: AppText.small.copyWith(color: AppColors.successDark, fontWeight: FontWeight.w800),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Selected by meter
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Selected by', style: AppText.small),
                    Text('${p.selectedByPercentage.toStringAsFixed(1)}%', style: AppText.small.copyWith(color: AppColors.ink, fontWeight: FontWeight.w700)),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: (p.selectedByPercentage / 100).clamp(0.0, 1.0),
                    minHeight: 8,
                    backgroundColor: AppColors.bg2,
                    valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                  ),
                ),

                const SizedBox(height: 12),
                const CompactDivider(),
                const SizedBox(height: 8),

                // Stats grid
                _StatsGrid(stats: p.stats),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  final Map<String, dynamic> stats;
  const _StatsGrid({required this.stats});

  @override
  Widget build(BuildContext context) {
    final entries = stats.entries.toList();
    return GridView.builder(
      itemCount: entries.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, mainAxisExtent: 58, crossAxisSpacing: 8, mainAxisSpacing: 8,
      ),
      itemBuilder: (_, i) {
        final k = entries[i].key;
        final v = entries[i].value;
        return Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.bg,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(k, style: AppText.small),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${v['actual']}', style: AppText.body.copyWith(fontWeight: FontWeight.w700)),
                  Text('+${v['points']}', style: AppText.small.copyWith(color: AppColors.successDark, fontWeight: FontWeight.w800)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

/// ----------------------
/// LEADERBOARD PAGE
/// ----------------------
class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = const [
      LeaderboardTile(rank: '1', name: 'shiv18', points: '907.5', color: Colors.amber),
      LeaderboardTile(rank: '2', name: 'john_doe', points: '900.5', color: Colors.grey),
      LeaderboardTile(rank: '3', name: 'cricket_fan', points: '844.5', color: Colors.orange),
      LeaderboardTile(rank: '4', name: 'player123', points: '820.0', color: Colors.blue),
      LeaderboardTile(rank: '5', name: 'sports_lover', points: '798.5', color: Colors.green),
      LeaderboardTile(rank: '6', name: 'mvp_rahul', points: '790.0', color: Colors.purple),
      LeaderboardTile(rank: '7', name: 'deep_point', points: '775.0', color: Colors.teal),
      LeaderboardTile(rank: '8', name: 'pull_shot', points: '760.0', color: Colors.brown),
      LeaderboardTile(rank: '9', name: 'cover_drive', points: '742.0', color: Colors.cyan),
      LeaderboardTile(rank: '10', name: 'sweep_king', points: '735.5', color: Colors.indigo),
    ];

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: Colors.white, elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Leaderboard', style: AppText.h2),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(14),
        itemCount: items.length,
        itemBuilder: (_, i) => SmallCard(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.only(bottom: 10),
          child: items[i],
        ),
      ),
    );
  }
}

/// ----------------------
/// CRICKET FIELD PAINTER
/// ----------------------
class CricketFieldPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final shortest = math.min(size.width, size.height);

    // Ground (oval)
    final groundPaint = Paint()..color = Colors.green.shade600;
    final groundRect = Rect.fromCenter(center: center, width: size.width * 0.9, height: size.height * 0.9);
    canvas.drawOval(groundRect, groundPaint);

    // Inner circle
    final innerPaint = Paint()..color = Colors.green.shade500;
    canvas.drawCircle(center, shortest * 0.36, innerPaint);

    // Boundary ring
    final boundaryPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..color = Colors.white.withOpacity(.6);
    canvas.drawOval(groundRect.deflate(6), boundaryPaint);

    // Pitch
    final pitchWidth = size.width * 0.08;
    final pitchHeight = size.height * 0.36;
    final pitchRect = Rect.fromCenter(center: center, width: pitchWidth, height: pitchHeight);
    final pitchPaint = Paint()..color = const Color(0xFFCFB997); // clay-ish
    canvas.drawRRect(RRect.fromRectAndRadius(pitchRect, const Radius.circular(8)), pitchPaint);

    // Crease lines
    final creasePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2;
    final creaseOffset = pitchHeight * 0.38;
    canvas.drawLine(Offset(center.dx - pitchWidth / 2, center.dy - creaseOffset),
        Offset(center.dx + pitchWidth / 2, center.dy - creaseOffset), creasePaint);
    canvas.drawLine(Offset(center.dx - pitchWidth / 2, center.dy + creaseOffset),
        Offset(center.dx + pitchWidth / 2, center.dy + creaseOffset), creasePaint);

    // Dots around field (fielding positions vibe)
    final dotPaint = Paint()..color = Colors.white70;
    for (int i = 0; i < 12; i++) {
      final angle = (2 * math.pi / 12) * i;
      final r = shortest * 0.40;
      final dx = center.dx + r * math.cos(angle);
      final dy = center.dy + r * math.sin(angle);
      canvas.drawCircle(Offset(dx, dy), 2.5, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// ----------------------
/// MAIN (for quick run)
/// ----------------------
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Completed Matches',
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.bg,
        useMaterial3: false,
        fontFamily: 'Inter',
        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(color: AppColors.ink),
          titleTextStyle: AppText.title,
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
      ),
      home: const CompletedMatchesPage(),
    );
  }
}
