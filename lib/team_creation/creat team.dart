import 'dart:math' as math;
import 'package:flutter/material.dart';

/// ---------- MODEL ----------

class Player {
  final int id;
  final String name;
  final String team;
  final String position; // WK | BAT | AR | BOWL
  final double credits;
  final int points;
  final double selectedBy;
  bool isSelected;

  Player({
    required this.id,
    required this.name,
    required this.team,
    required this.position,
    required this.credits,
    required this.points,
    required this.selectedBy,
    this.isSelected = false,
  });

  Player copyWith({bool? isSelected}) => Player(
    id: id,
    name: name,
    team: team,
    position: position,
    credits: credits,
    points: points,
    selectedBy: selectedBy,
    isSelected: isSelected ?? this.isSelected,
  );
}

/// ---------- COLORS & STYLES ----------

class AppColors {
  static const dark = Color(0xFF111827); // top area
  static const dark2 = Color(0xFF1F2937);
  static const white = Colors.white;
  static const lightBorder = Color(0xFFE5E7EB);
  static const brand = Color(0xFF10B981);
  static const brand2 = Color(0xFF059669);
  static const info = Color(0xFF3B82F6);
  static const danger = Color(0xFFEF4444);
  static const fieldGreen = Color(0xFF16A34A);
}

Color teamColor(String team) {
  switch (team) {
    case 'CSK':
      return const Color(0xFFFFD700);
    case 'MI':
      return const Color(0xFF004BA0);
    case 'RCB':
      return const Color(0xFFD32F2F);
    case 'DC':
      return const Color(0xFF282968);
    case 'KKR':
      return const Color(0xFF3A225D);
    case 'GT':
      return const Color(0xFF1B2951);
    case 'LSG':
      return const Color(0xFF00A8CC);
    case 'RR':
      return const Color(0xFFEA1A85);
    case 'PBKS':
      return const Color(0xFFDD1F2D);
    default:
      return Colors.grey;
  }
}

/// ---------- SCREEN ----------

class Dream11TeamBuilder extends StatefulWidget {
  final Function(Map<String, dynamic>) onTeamSaved;

  /// NEW: pass a previously saved team here to edit
  final Map<String, dynamic>? initialTeam;

  const Dream11TeamBuilder({
    Key? key,
    required this.onTeamSaved,
    this.initialTeam,
  }) : super(key: key);

  @override
  State<Dream11TeamBuilder> createState() => _Dream11TeamBuilderState();
}


class _Dream11TeamBuilderState extends State<Dream11TeamBuilder>
    with TickerProviderStateMixin {
  late final TabController _tab;
  int _step = 0; // 0 select, 1 preview(field), 2 C/VC
  final List<Player> _selected = [];
  Player? _captain;
  Player? _viceCaptain;
  double _creditsLeft = 100.0;

  // Sample data
  final List<Player> _wk = [
    Player(id: 1, name: "MS Dhoni", team: "CSK", position: "WK", credits: 9.5, points: 245, selectedBy: 85.2),
    Player(id: 2, name: "KL Rahul", team: "LSG", position: "WK", credits: 9.0, points: 198, selectedBy: 72.8),
    Player(id: 3, name: "Rishabh Pant", team: "DC", position: "WK", credits: 8.5, points: 176, selectedBy: 68.5),
    Player(id: 4, name: "Jos Buttler", team: "RR", position: "WK", credits: 10.0, points: 267, selectedBy: 91.2),
  ];
  final List<Player> _bat = [
    Player(id: 5, name: "Virat Kohli", team: "RCB", position: "BAT", credits: 10.5, points: 341, selectedBy: 95.7),
    Player(id: 6, name: "Rohit Sharma", team: "MI", position: "BAT", credits: 10.0, points: 298, selectedBy: 89.3),
    Player(id: 7, name: "Shubman Gill", team: "GT", position: "BAT", credits: 9.0, points: 234, selectedBy: 76.4),
    Player(id: 8, name: "Faf du Plessis", team: "RCB", position: "BAT", credits: 8.5, points: 198, selectedBy: 65.2),
    Player(id: 9, name: "David Warner", team: "DC", position: "BAT", credits: 8.5, points: 187, selectedBy: 71.8),
    Player(id: 10, name: "Quinton de Kock", team: "LSG", position: "BAT", credits: 8.0, points: 156, selectedBy: 58.9),
  ];
  final List<Player> _ar = [
    Player(id: 11, name: "Hardik Pandya", team: "GT", position: "AR", credits: 10.0, points: 298, selectedBy: 88.5),
    Player(id: 12, name: "Ravindra Jadeja", team: "CSK", position: "AR", credits: 9.5, points: 267, selectedBy: 79.3),
    Player(id: 13, name: "Andre Russell", team: "KKR", position: "AR", credits: 9.0, points: 234, selectedBy: 73.6),
    Player(id: 14, name: "Axar Patel", team: "DC", position: "AR", credits: 8.5, points: 187, selectedBy: 65.8),
    Player(id: 15, name: "Moeen Ali", team: "CSK", position: "AR", credits: 8.0, points: 156, selectedBy: 52.4),
  ];
  final List<Player> _bowl = [
    Player(id: 16, name: "Jasprit Bumrah", team: "MI", position: "BOWL", credits: 9.5, points: 278, selectedBy: 87.9),
    Player(id: 17, name: "Rashid Khan", team: "GT", position: "BOWL", credits: 9.0, points: 245, selectedBy: 81.2),
    Player(id: 18, name: "Yuzvendra Chahal", team: "RR", position: "BOWL", credits: 8.5, points: 198, selectedBy: 69.7),
    Player(id: 19, name: "Mohammed Shami", team: "GT", position: "BOWL", credits: 8.5, points: 187, selectedBy: 72.1),
    Player(id: 20, name: "Trent Boult", team: "RR", position: "BOWL", credits: 8.0, points: 156, selectedBy: 58.3),
    Player(id: 21, name: "Kagiso Rabada", team: "PBKS", position: "BOWL", credits: 8.5, points: 198, selectedBy: 64.9),
  ];

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 4, vsync: this);
    _loadInitialTeam(); // <-- add this
  }
  @override


  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  List<Player> _tabPlayers(int index) {
    switch (index) {
      case 0:
        return _wk;
      case 1:
        return _bat;
      case 2:
        return _ar;
      case 3:
        return _bowl;
    }
    return const [];
  }
  void _loadInitialTeam() {
    final t = widget.initialTeam;
    if (t == null) return;

    final List sel = (t['selectedPlayers'] as List?) ?? [];
    _selected.clear();

    for (final m in sel) {
      final p = Player(
        id: m['id'] as int,
        name: m['name'] as String,
        team: m['team'] as String,
        position: m['position'] as String, // 'WK' | 'BAT' | 'AR' | 'BOWL'
        credits: (m['credits'] as num).toDouble(),
        points: (m['points'] as num).toInt(),
        selectedBy: (m['selectedBy'] as num).toDouble(),
        isSelected: true,
      );
      _selected.add(p);
      if (m['isCaptain'] == true) _captain = p;
      if (m['isViceCaptain'] == true) _viceCaptain = p;
    }

    // mark the master lists so the green check shows up
    void mark(List<Player> pool) {
      for (var i = 0; i < pool.length; i++) {
        final found = _selected.any((sp) => sp.id == pool[i].id);
        pool[i] = pool[i].copyWith(isSelected: found);
      }
    }
    mark(_wk); mark(_bat); mark(_ar); mark(_bowl);

    _recalcCredits();
    setState(() {});
  }

  void _recalcCredits() {
    final used = _selected.fold<double>(0.0, (s, p) => s + p.credits);
    setState(() => _creditsLeft = 100.0 - used);
  }

  void _toggle(Player p) {
    setState(() {
      final already = _selected.any((x) => x.id == p.id);
      if (already) {
        _selected.removeWhere((x) => x.id == p.id);
        if (_captain?.id == p.id) _captain = null;
        if (_viceCaptain?.id == p.id) _viceCaptain = null;
        p.isSelected = false;
      } else {
        if (_selected.length < 11 && _creditsLeft >= p.credits) {
          _selected.add(p);
          p.isSelected = true;
        }
      }
      _recalcCredits();
    });
  }

  // ---------- UI ----------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white, // rest of the screen is white
      appBar: AppBar(
        backgroundColor: AppColors.dark,
        elevation: 0,
        title: Text(
          _step == 0
              ? 'Create Team'
              : _step == 1
              ? 'Team Preview'
              : 'Choose Captain',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (_step > 0) {
              setState(() => _step--);
            } else {
              Navigator.pop(context);
            }
          },
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.dark2,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white10),
            ),
            child: Text(
              'Cr Left: ${_creditsLeft.toStringAsFixed(1)}',
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _bottomBar(),
      body: SafeArea(
        child: _step == 0
            ? _playerSelection()
            : _step == 1
            ? _previewField()
            : _captainPicker(),
      ),
    );
  }

  /// --- Step 0: Selection ---

  Widget _playerSelection() {
    return Column(
      children: [
        // DARK TOP STRIP (header)
        Container(
          width: double.infinity,
          color: AppColors.dark,
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // match row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('CSK vs MI',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w700)),
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text('Starts soon',
                        style: TextStyle(color: Colors.white70, fontSize: 12)),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _chipDark('Players: ${_selected.length}/11'),
                  const SizedBox(width: 8),
                  _chipDark('Credits: ${_creditsLeft.toStringAsFixed(1)}'),
                ],
              ),
            ],
          ),
        ),

        // WHITE AREA
        Container(
          decoration: const BoxDecoration(
            color: AppColors.white,
            border: Border(
              top: BorderSide(color: AppColors.lightBorder, width: 1),
            ),
          ),
          child: Column(
            children: [
              // TabBar (white background)
              TabBar(
                controller: _tab,
                labelColor: AppColors.dark,
                unselectedLabelColor: Colors.black54,
                indicatorColor: AppColors.dark,
                tabs: const [
                  Tab(text: 'WK'),
                  Tab(text: 'BAT'),
                  Tab(text: 'AR'),
                  Tab(text: 'BOWL'),
                ],
                onTap: (_) => setState(() {}),
              ),
            ],
          ),
        ),

        // Players list
        Expanded(
          child: Container(
            color: AppColors.white,
            child: TabBarView(
              controller: _tab,
              children: [
                _playerList(_wk),
                _playerList(_bat),
                _playerList(_ar),
                _playerList(_bowl),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _chipDark(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.dark2,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white10),
      ),
      child: Text(text,
          style: const TextStyle(color: Colors.white70, fontSize: 12)),
    );
  }

  Widget _playerList(List<Player> list) {
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: list.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, i) {
        final p = list[i];
        final canPick = _selected.length < 11 && _creditsLeft >= p.credits;
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.lightBorder),
          ),
          child: Row(
            children: [
              // avatar
              CircleAvatar(
                radius: 18,
                backgroundColor: teamColor(p.team),
                child: Text(
                  p.name.split(' ').map((e) => e[0]).join(),
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 12),
                ),
              ),
              const SizedBox(width: 12),
              // info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(p.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        _teamTag(p.team),
                        const SizedBox(width: 6),
                        Text('Sel ${p.selectedBy.toStringAsFixed(1)}%',
                            style: const TextStyle(
                                color: Colors.black54, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
              // stats
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('${p.points} pts',
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text('${p.credits} Cr',
                      style:
                      const TextStyle(color: Colors.black54, fontSize: 12)),
                ],
              ),
              const SizedBox(width: 8),
              // action
              GestureDetector(
                onTap: () => _toggle(p),
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor: p.isSelected
                      ? AppColors.brand
                      : (canPick ? Colors.transparent : Colors.grey.shade200),
                  child: Icon(
                    p.isSelected ? Icons.check : (canPick ? Icons.add : Icons.close),
                    size: 16,
                    color: p.isSelected
                        ? Colors.white
                        : (canPick ? AppColors.brand : Colors.black26),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _teamTag(String t) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    decoration: BoxDecoration(
      color: teamColor(t),
      borderRadius: BorderRadius.circular(6),
    ),
    child: Text(t,
        style: const TextStyle(
            color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600)),
  );

  /// --- Step 1: Preview on a Dream11-like Field ---

  Widget _previewField() {
    // compute team split for header
    final byTeam = <String, int>{};
    for (final p in _selected) {
      byTeam[p.team] = (byTeam[p.team] ?? 0) + 1;
    }
    // pick the two most frequent teams (fallbacks if >2 teams)
    final teamsSorted = byTeam.keys.toList()
      ..sort((a, b) => (byTeam[b] ?? 0).compareTo(byTeam[a] ?? 0));
    final t1 = teamsSorted.isNotEmpty ? teamsSorted[0] : 'TEAM A';
    final t2 = teamsSorted.length > 1 ? teamsSorted[1] : 'TEAM B';
    final c1 = byTeam[t1] ?? 0;
    final c2 = byTeam[t2] ?? 0;

    return Column(
      children: [
        // top dark bar with title + divider
        Container(
          color: AppColors.dark,
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('RAJPUT9 SUPER11',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
              const SizedBox(height: 10),
              Container(height: 1, color: Colors.white.withOpacity(0.08)),
              const SizedBox(height: 10),

              // header row: Players | team split | Credits Left
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Players', style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12)),
                      const SizedBox(height: 2),
                      const Text('11/11', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                    ],
                  ),
                  const Spacer(),
                  // central split like SOB-W 6:5 OVI-W
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white.withOpacity(0.08)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _teamPill(t1),
                        const SizedBox(width: 8),
                        Text('$c1 : $c2',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16)),
                        const SizedBox(width: 8),
                        _teamPill(t2),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Credits Left', style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12)),
                      const SizedBox(height: 2),
                      Text(_creditsLeft.toStringAsFixed(1),
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),

        // Field
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: AspectRatio(
              aspectRatio: 9 / 16,
              child: _CricketField(players: _selected),
            ),
          ),
        ),
      ],
    );
  }

  Widget _teamPill(String t) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.dark2,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(t, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12)),
    );
  }

  /// --- Step 2: Captain / Vice-Captain ---

  Widget _captainPicker() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          color: AppColors.dark,
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
          child: const Text('Choose Captain & Vice Captain',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: _selected.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, i) {
              final p = _selected[i];
              final isC = _captain?.id == p.id;
              final isVC = _viceCaptain?.id == p.id;
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.lightBorder),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                        radius: 18,
                        backgroundColor: teamColor(p.team),
                        child: Text(
                            p.name.split(' ').map((e) => e[0]).join(),
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700))),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(p.name,
                              style:
                              const TextStyle(fontWeight: FontWeight.w600)),
                          Text('${p.team} • ${p.points} pts',
                              style: const TextStyle(color: Colors.black54)),
                        ],
                      ),
                    ),
                    _toggleRoleButton('VC', isVC, AppColors.info, () {
                      setState(() {
                        if (isVC) {
                          _viceCaptain = null;
                        } else {
                          if (_captain?.id == p.id) _captain = null;
                          _viceCaptain = p;
                        }
                      });
                    }),
                    const SizedBox(width: 8),
                    _toggleRoleButton('C', isC, AppColors.brand2, () {
                      setState(() {
                        if (isC) {
                          _captain = null;
                        } else {
                          if (_viceCaptain?.id == p.id) _viceCaptain = null;
                          _captain = p;
                        }
                      });
                    }),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _toggleRoleButton(String label, bool active, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: active ? color : Colors.transparent,
          border: Border.all(color: color),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: TextStyle(
              color: active ? Colors.white : color,
              fontWeight: FontWeight.w700,
              fontSize: 12),
        ),
      ),
    );
  }

  /// --- Bottom Bar ---

  Widget _bottomBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: const Border(top: BorderSide(color: AppColors.lightBorder)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, -2)),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Players: ${_selected.length}/11',
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  Text('Credits Left: ${_creditsLeft.toStringAsFixed(1)}',
                      style:
                      const TextStyle(color: Colors.black54, fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(width: 12),
            if (_step == 0)
              _primaryBtn(
                label: 'Preview',
                enabled: _selected.length == 11,
                onTap: _selected.length == 11 ? () => setState(() => _step = 1) : null,
              )
            else if (_step == 1)
              _primaryBtn(label: 'Next', enabled: true, onTap: () => setState(() => _step = 2))
            else
              _primaryBtn(
                label: 'Save Team',
                enabled: _captain != null && _viceCaptain != null,
                onTap: (_captain != null && _viceCaptain != null)
                    ? () {
                  final now = DateTime.now();
                  final teamName = 'Team ${now.hour}${now.minute}${now.second}';
                  final data = {
                    'id': now.millisecondsSinceEpoch,
                    'name': teamName,
                    'captain': _captain!.name,
                    'viceCaptain': _viceCaptain!.name,
                    'points': 0,
                    'players': _selected.length,
                    'createdAt': 'Just now',
                    'selectedPlayers': _selected
                        .map((p) => {
                      'id': p.id,
                      'name': p.name,
                      'team': p.team,
                      'position': p.position,
                      'credits': p.credits,
                      'points': p.points,
                      'selectedBy': p.selectedBy,
                      'isCaptain': _captain?.id == p.id,
                      'isViceCaptain': _viceCaptain?.id == p.id,
                    })
                        .toList(),
                    'totalCreditsUsed': 100.0 - _creditsLeft,
                  };
                  widget.onTeamSaved(data);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Team saved successfully!')),
                  );
                }
                    : null,
              ),
          ],
        ),
      ),
    );
  }

  Widget _primaryBtn({required String label, required bool enabled, VoidCallback? onTap}) {
    return ElevatedButton(
      onPressed: enabled ? onTap : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: enabled ? AppColors.brand : Colors.grey.shade300,
        foregroundColor: enabled ? Colors.white : Colors.black45,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 0,
      ),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
    );
  }
}

/// ---------- DREAM11-STYLE CRICKET FIELD ----------
/// Horizontal bands with section labels; neat rows of player tiles.
class _CricketField extends StatelessWidget {
  final List<Player> players;
  const _CricketField({required this.players});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      final w = c.maxWidth;
      final h = c.maxHeight;

      // row Y positions
      final yWK   = h * 0.20;
      final yBAT  = h * 0.38;
      final yAR   = h * 0.60;
      final yBOWL = h * 0.82;

      final wk   = players.where((p) => p.position == 'WK').toList();
      final bat  = players.where((p) => p.position == 'BAT').toList();
      final ar   = players.where((p) => p.position == 'AR').toList();
      final bowl = players.where((p) => p.position == 'BOWL').toList();

      return Stack(
        children: [
          Positioned.fill(child: _FieldBackground()),

          // Keeper semi-arc
          Positioned.fill(
            child: CustomPaint(
              painter: _KeeperArcPainter(),
            ),
          ),

          // Section labels
          _label('WICKET-KEEPERS', yWK - 28, w),
          _label('BATTERS',         yBAT - 28, w),
          _label('ALL-ROUNDERS',    yAR  - 28, w),
          _label('BOWLERS',         yBOWL- 28, w),

          // Rows
          ..._row(wk,   yWK,   w),
          ..._row(bat,  yBAT,  w),
          ..._row(ar,   yAR,   w),
          ..._row(bowl, yBOWL, w),

          // pitch strip
          // ✅ Subtle hint (optional)
          // PITCH with stumps
          Positioned(
            left: w * 0.5 - (w * 0.05),
            top: h * 0.25,
            width: w * 0.10,
            height: h * 0.50,
            child: IgnorePointer(
              child: CustomPaint(
                painter: PitchPainter(),
              ),
            ),
          ),


        ],
      );
    });
  }


  List<Widget> _row(List<Player> list, double y, double width) {
    if (list.isEmpty) return const [];
    final xs = _slots(list.length);
    return [
      for (int i = 0; i < list.length; i++)
        Positioned(
          left: (xs[i] * width) - 44,   // tile width ~88
          top:  y - 66,                 // place nicely above the band
          child: _PlayerTile(player: list[i]),
        )
    ];
  }

  List<double> _slots(int n) {
    switch (n) {
      case 1: return const [0.50];
      case 2: return const [0.30, 0.70];
      case 3: return const [0.18, 0.50, 0.82];
      case 4: return const [0.12, 0.38, 0.62, 0.88];
      case 5: return const [0.10, 0.30, 0.50, 0.70, 0.90];
      case 6: return const [0.08, 0.28, 0.44, 0.56, 0.72, 0.92];
      default: return List<double>.generate(n, (i) => (i + 1) / (n + 1));
    }
  }

  Widget _label(String text, double top, double width) {
    return Positioned(
      top: top,
      left: 0,
      width: width,
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white70,
            letterSpacing: 1.0,
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

/// Smooth green outfield with subtle vertical strips + border.
class _FieldBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1E8A42), Color(0xFF0F6D2D)],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.withOpacity(0.20), width: 1.4),
      ),
      child: CustomPaint(painter: _OutfieldStripesPainter()),
    );
  }
}

class _OutfieldStripesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final stripeW = size.width / 9;
    final paint = Paint();
    for (int i = 0; i < 9; i++) {
      paint.color = (i.isEven)
          ? Colors.black.withOpacity(0.06)
          : Colors.white.withOpacity(0.06);
      canvas.drawRect(Rect.fromLTWH(i * stripeW, 0, stripeW, size.height), paint);
    }
    final ring = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..color = Colors.white.withOpacity(0.22);
    final rect = Rect.fromLTWH(6, 6, size.width - 12, size.height - 12);
    canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(28)), ring);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// subtle semi-circular arc for the keeper area (like the screenshot)
class _KeeperArcPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    final top = size.height * 0.145;
    final left = size.width * 0.12;
    final right = size.width * 0.88;
    final midY = size.height * 0.25;

    path.moveTo(left, midY);
    path.quadraticBezierTo(size.width * 0.50, top, right, midY);

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = Colors.white.withOpacity(0.30);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}


/// Single player tile: avatar, name chip, credits (Dream11-like)
class _PlayerTile extends StatelessWidget {
  final Player player;
  const _PlayerTile({required this.player});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 88, // a bit wider for nicer chips
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // avatar – swap to NetworkImage for real faces
          CircleAvatar(
            radius: 26,
            backgroundColor: teamColor(player.team),
            child: Text(
              _initials(player.name),
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16),
            ),
          ),
          const SizedBox(height: 6),

          // name chip (dark capsule like Dream11)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF1F2937),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.18), blurRadius: 4, offset: const Offset(0, 1))],
            ),
            child: Text(
              _shortName(player.name),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(height: 4),

          // credits under the chip
          Text(
            '${player.credits.toStringAsFixed(player.credits.truncateToDouble() == player.credits ? 0 : 1)} Cr',
            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  String _initials(String name) =>
      name.split(' ').where((e) => e.isNotEmpty).map((e) => e[0]).take(2).join().toUpperCase();

  // “R Southby” style, not a hard cutoff
  String _shortName(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts.first[0].toUpperCase()} ${parts.sublist(1).join(' ')}';
    }
    return name;
  }
}


/// ---------- UTIL EXTENSIONS ----------

extension FirstChars on String {
  String firstCharacters(int n) {
    if (isEmpty) return this;
    return length <= n ? this : substring(0, n);
  }
}
class PitchPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final pitchPaint = Paint()
      ..color = Colors.grey.withOpacity(0.25)
      ..style = PaintingStyle.fill;

    // Draw main pitch rectangle
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(6),
    );
    canvas.drawRRect(rect, pitchPaint);

    // Draw pitch border
    final border = Paint()
      ..color = Colors.grey.withOpacity(0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawRRect(rect, border);

    // Stumps parameters
    const stumpCount = 3;
    final stumpWidth = size.width * 0.05;
    final stumpHeight = size.height * 0.08;
    final gap = stumpWidth * 1.4;

    final stumpPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = stumpWidth
      ..strokeCap = StrokeCap.round;

    // Draw stumps at top
    final topY = -stumpHeight / 2;
    final startX = (size.width / 2) - (gap);
    for (int i = 0; i < stumpCount; i++) {
      final x = startX + i * gap;
      canvas.drawLine(Offset(x, topY), Offset(x, topY + stumpHeight), stumpPaint);
    }

    // Draw stumps at bottom
    final bottomY = size.height - stumpHeight / 2;
    for (int i = 0; i < stumpCount; i++) {
      final x = startX + i * gap;
      canvas.drawLine(Offset(x, bottomY), Offset(x, bottomY + stumpHeight), stumpPaint);
    }

    // Bails (small line on top of stumps)
    final bailPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2;
    final bailLength = gap * (stumpCount - 1);
    // top bails
    canvas.drawLine(
      Offset(startX, topY),
      Offset(startX + bailLength, topY),
      bailPaint,
    );
    // bottom bails
    canvas.drawLine(
      Offset(startX, bottomY),
      Offset(startX + bailLength, bottomY),
      bailPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
