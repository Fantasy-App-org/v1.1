import 'package:flutter/material.dart';

class Player {
  final String name;
  final String team;
  final String position;
  final double credits;
  final int points;
  final double selectedBy;
  final String image;
  bool isSelected;
  bool isAnnounced;

  Player({
    required this.name,
    required this.team,
    required this.position,
    required this.credits,
    required this.points,
    required this.selectedBy,
    required this.image,
    this.isSelected = false,
    this.isAnnounced = true,
  });
}

class CreateTeamPage extends StatefulWidget {
  @override
  _CreateTeamPageState createState() => _CreateTeamPageState();
}

class _CreateTeamPageState extends State<CreateTeamPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late PageController _pageController;
  int _selectedTab = 0;
  List<Player> _selectedPlayers = [];
  Player? _captain;
  Player? _viceCaptain;
  double _creditsLeft = 100.0;
  int _currentView = 0; // 0: Player Selection, 1: Team Preview, 2: Captain Selection, 3: Team Saved View

  final List<Player> _wicketKeepers = [
    Player(
      name: "D Steyn",
      team: "BRN",
      position: "WK",
      credits: 8.0,
      points: 220,
      selectedBy: 96.12,
      image: "assets/players/steyn.jpg",
    ),
    Player(
      name: "A Khatiwala",
      team: "PCC",
      position: "WK",
      credits: 7.0,
      points: 171,
      selectedBy: 63.75,
      image: "assets/players/khatiwala.jpg",
    ),
    Player(
      name: "M Rizwan",
      team: "BRN",
      position: "WK",
      credits: 9.5,
      points: 195,
      selectedBy: 89.45,
      image: "assets/players/rizwan.jpg",
    ),
    Player(
      name: "S Dhawan",
      team: "PCC",
      position: "WK",
      credits: 8.5,
      points: 178,
      selectedBy: 72.33,
      image: "assets/players/dhawan.jpg",
      isAnnounced: false,
    ),
  ];

  final List<Player> _batsmen = [
    Player(
      name: "S Davizi",
      team: "PCC",
      position: "BAT",
      credits: 9.0,
      points: 140,
      selectedBy: 91.44,
      image: "assets/players/davizi.jpg",
    ),
    Player(
      name: "N Khanday",
      team: "BRN",
      position: "BAT",
      credits: 8.5,
      points: 146,
      selectedBy: 88.83,
      image: "assets/players/khanday.jpg",
    ),
    Player(
      name: "R Tomar",
      team: "PCC",
      position: "BAT",
      credits: 8.0,
      points: 150,
      selectedBy: 81.07,
      image: "assets/players/tomar.jpg",
    ),
    Player(
      name: "A Sridhar",
      team: "PCC",
      position: "BAT",
      credits: 7.5,
      points: 39,
      selectedBy: 4.88,
      image: "assets/players/sridhar.jpg",
    ),
    Player(
      name: "V Kohli",
      team: "BRN",
      position: "BAT",
      credits: 10.0,
      points: 285,
      selectedBy: 95.67,
      image: "assets/players/kohli.jpg",
    ),
    Player(
      name: "B Azam",
      team: "PCC",
      position: "BAT",
      credits: 9.5,
      points: 267,
      selectedBy: 93.21,
      image: "assets/players/azam.jpg",
    ),
    Player(
      name: "R Sharma",
      team: "BRN",
      position: "BAT",
      credits: 9.0,
      points: 198,
      selectedBy: 78.45,
      image: "assets/players/sharma.jpg",
      isAnnounced: false,
    ),
    Player(
      name: "K Williamson",
      team: "PCC",
      position: "BAT",
      credits: 8.5,
      points: 167,
      selectedBy: 67.89,
      image: "assets/players/williamson.jpg",
      isAnnounced: false,
    ),
  ];

  final List<Player> _allRounders = [
    Player(
      name: "S Roy Wickramasekara",
      team: "PCC",
      position: "AR",
      credits: 9.0,
      points: 149,
      selectedBy: 97.28,
      image: "assets/players/wickramasekara.jpg",
    ),
    Player(
      name: "H Ullah",
      team: "BRN",
      position: "AR",
      credits: 8.5,
      points: 76,
      selectedBy: 63.98,
      image: "assets/players/ullah.jpg",
    ),
    Player(
      name: "M Khan",
      team: "BRN",
      position: "AR",
      credits: 8.0,
      points: 146,
      selectedBy: 89.23,
      image: "assets/players/khan.jpg",
    ),
    Player(
      name: "H Pandya",
      team: "PCC",
      position: "AR",
      credits: 9.5,
      points: 234,
      selectedBy: 92.11,
      image: "assets/players/pandya.jpg",
    ),
    Player(
      name: "S Curran",
      team: "BRN",
      position: "AR",
      credits: 8.5,
      points: 187,
      selectedBy: 84.67,
      image: "assets/players/curran.jpg",
    ),
    Player(
      name: "R Jadeja",
      team: "PCC",
      position: "AR",
      credits: 8.0,
      points: 156,
      selectedBy: 71.23,
      image: "assets/players/jadeja.jpg",
      isAnnounced: false,
    ),
    Player(
      name: "A Russell",
      team: "BRN",
      position: "AR",
      credits: 8.5,
      points: 201,
      selectedBy: 86.34,
      image: "assets/players/russell.jpg",
      isAnnounced: false,
    ),
  ];

  final List<Player> _bowlers = [
    Player(
      name: "N Mishra",
      team: "BRN",
      position: "BOWL",
      credits: 8.5,
      points: 19,
      selectedBy: 14.49,
      image: "assets/players/mishra.jpg",
    ),
    Player(
      name: "S Patel-I",
      team: "PCC",
      position: "BOWL",
      credits: 8.5,
      points: 68,
      selectedBy: 69.0,
      image: "assets/players/patel.jpg",
    ),
    Player(
      name: "R Solanki",
      team: "PCC",
      position: "BOWL",
      credits: 8.0,
      points: 0,
      selectedBy: 24.37,
      image: "assets/players/solanki.jpg",
    ),
    Player(
      name: "D Ramani",
      team: "PCC",
      position: "BOWL",
      credits: 7.5,
      points: 56,
      selectedBy: 16.33,
      image: "assets/players/ramani.jpg",
    ),
    Player(
      name: "A Vasudevan",
      team: "BRN",
      position: "BOWL",
      credits: 6.5,
      points: 99,
      selectedBy: 29.19,
      image: "assets/players/vasudevan.jpg",
    ),
    Player(
      name: "J Bumrah",
      team: "BRN",
      position: "BOWL",
      credits: 9.5,
      points: 198,
      selectedBy: 87.66,
      image: "assets/players/bumrah.jpg",
    ),
    Player(
      name: "R Ashwin",
      team: "PCC",
      position: "BOWL",
      credits: 8.5,
      points: 167,
      selectedBy: 73.45,
      image: "assets/players/ashwin.jpg",
    ),
    Player(
      name: "T Boult",
      team: "BRN",
      position: "BOWL",
      credits: 8.5,
      points: 143,
      selectedBy: 68.92,
      image: "assets/players/boult.jpg",
    ),
    Player(
      name: "Y Chahal",
      team: "PCC",
      position: "BOWL",
      credits: 8.0,
      points: 134,
      selectedBy: 65.78,
      image: "assets/players/chahal.jpg",
    ),
    Player(
      name: "M Starc",
      team: "BRN",
      position: "BOWL",
      credits: 9.0,
      points: 178,
      selectedBy: 79.23,
      image: "assets/players/starc.jpg",
      isAnnounced: false,
    ),
    Player(
      name: "K Rabada",
      team: "PCC",
      position: "BOWL",
      credits: 8.5,
      points: 156,
      selectedBy: 71.89,
      image: "assets/players/rabada.jpg",
      isAnnounced: false,
    ),
    Player(
      name: "T Chikle",
      team: "BRN",
      position: "BOWL",
      credits: 6.0,
      points: 45,
      selectedBy: 12.67,
      image: "assets/players/chikle.jpg",
      isAnnounced: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _pageController = PageController();
    _calculateCreditsLeft();
  }

  void _calculateCreditsLeft() {
    double usedCredits = _selectedPlayers.fold(0, (sum, player) => sum + player.credits);
    setState(() {
      _creditsLeft = 100.0 - usedCredits;
    });
  }

  void _togglePlayerSelection(Player player) {
    setState(() {
      if (player.isSelected) {
        _selectedPlayers.remove(player);
        player.isSelected = false;
        if (_captain == player) _captain = null;
        if (_viceCaptain == player) _viceCaptain = null;
      } else {
        if (_selectedPlayers.length < 11 && _creditsLeft >= player.credits) {
          _selectedPlayers.add(player);
          player.isSelected = true;
        }
      }
      _calculateCreditsLeft();
    });
  }

  void _setCaptain(Player player) {
    setState(() {
      if (_captain == player) {
        _captain = null;
      } else {
        if (_viceCaptain == player) _viceCaptain = null;
        _captain = player;
      }
    });
  }

  void _setViceCaptain(Player player) {
    setState(() {
      if (_viceCaptain == player) {
        _viceCaptain = null;
      } else {
        if (_captain == player) _captain = null;
        _viceCaptain = player;
      }
    });
  }

  List<Player> _getCurrentTabPlayers() {
    switch (_selectedTab) {
      case 0:
        return _wicketKeepers;
      case 1:
        return _batsmen;
      case 2:
        return _allRounders;
      case 3:
        return _bowlers;
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: Color(0xFF2C1810),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            if (_currentView == 1 || _currentView == 2) {
              // Go back to player selection from preview or captain selection
              setState(() {
                _currentView = 0;
              });
            } else {
              // Exit the page
              Navigator.pop(context);
            }
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _currentView == 3 ? "Team Created" : "Create Team",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            if (_currentView != 3)
              Text(
                "${15 - (_selectedPlayers.length ~/ 60)}m ${59 - (_selectedPlayers.length % 60)}s left",
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
          ],
        ),
        actions: [
          Container(
            margin: EdgeInsets.all(8),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Color(0xFF3E5B8C),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.sports_cricket, color: Colors.white, size: 16),
                SizedBox(width: 4),
                Text("DreamGurus", style: TextStyle(color: Colors.white, fontSize: 12)),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(8),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text("PTS", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: _buildCurrentView(),
      bottomNavigationBar: _currentView != 3 ? _buildBottomBar() : null,
    );
  }

  Widget _buildCurrentView() {
    switch (_currentView) {
      case 0:
        return _buildPlayerSelection();
      case 1:
        return _buildTeamPreview();
      case 2:
        return _buildCaptainSelection();
      case 3:
        return _buildTeamSavedView();
      default:
        return _buildPlayerSelection();
    }
  }

  Widget _buildPlayerSelection() {
    return Column(
      children: [
        // Match Info
        Container(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              _buildTeamInfo("PCC", "0"),
              Expanded(
                child: Column(
                  children: [
                    Text("BRN Elected to field first", style: TextStyle(color: Colors.white70)),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: Row(
                        children: List.generate(11, (index) =>
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 1),
                                decoration: BoxDecoration(
                                  color: index < _selectedPlayers.length ? Colors.green : Colors.grey[800],
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                        ),
                      ),
                    ),
                    Text("${_selectedPlayers.length}/11", style: TextStyle(color: Colors.white70)),
                  ],
                ),
              ),
              _buildTeamInfo("BRN", "0"),
            ],
          ),
        ),

        // Stats Bar
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: Color(0xFF2A2A2A),
          child: Row(
            children: [
              Text("STATS", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              Spacer(),
              Text("Pitch: Batting", style: TextStyle(color: Colors.white70)),
              Text(" • Good for: Pace", style: TextStyle(color: Colors.white70)),
              Text(" • Avg Score: 120", style: TextStyle(color: Colors.white70)),
            ],
          ),
        ),

        // Tab Bar
        Container(
          color: Color(0xFF2A2A2A),
          child: TabBar(
            controller: _tabController,
            onTap: (index) {
              setState(() => _selectedTab = index);
              _pageController.animateToPage(
                index,
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            tabs: [
              Tab(text: "WK"),
              Tab(text: "BAT"),
              Tab(text: "AR"),
              Tab(text: "BOWL"),
            ],
            labelColor: Colors.red,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.red,
          ),
        ),

        // Player List with PageView for swiping
        Expanded(
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _selectedTab = index;

              });
            },
            children: [
              _buildPlayerListForPosition(_wicketKeepers),
              _buildPlayerListForPosition(_batsmen),
              _buildPlayerListForPosition(_allRounders),
              _buildPlayerListForPosition(_bowlers),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPlayerListForPosition(List<Player> players) {
    return ListView(
      children: [
        // Announced Players
        if (players.any((p) => p.isAnnounced)) ...[
          Container(
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              "Announced",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          ...players.where((p) => p.isAnnounced).map((player) => _buildPlayerCard(player)),
        ],

        // Unannounced Players
        if (players.any((p) => !p.isAnnounced)) ...[
          Container(
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              "Unannounced",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          ...players.where((p) => !p.isAnnounced).map((player) => _buildPlayerCard(player)),
        ],
      ],
    );
  }

  Widget _buildTeamInfo(String team, String score) {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: team == "PCC" ? Colors.purple : Colors.red,
          child: Text(team, style: TextStyle(color: Colors.white, fontSize: 12)),
        ),
        SizedBox(width: 8),
        Text(score, style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildPlayerCard(Player player) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(8),
        border: player.isSelected ? Border.all(color: Colors.green, width: 2) : null,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.grey[600],
            child: Text(
              player.name.split(' ').map((e) => e[0]).join(''),
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(player.name, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: player.team == "PCC" ? Colors.purple : Colors.red,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(player.team, style: TextStyle(color: Colors.white, fontSize: 10)),
                    ),
                    SizedBox(width: 8),
                    Text("${player.selectedBy.toStringAsFixed(2)}%", style: TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text("${player.points}", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              Text("${player.credits}", style: TextStyle(color: Colors.white70)),
            ],
          ),
          SizedBox(width: 12),
          GestureDetector(
            onTap: () => _togglePlayerSelection(player),
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: player.isSelected ? Colors.green : Colors.transparent,
                border: Border.all(color: Colors.green, width: 2),
                shape: BoxShape.circle,
              ),
              child: player.isSelected ? Icon(Icons.check, color: Colors.white, size: 20) : Icon(Icons.add, color: Colors.green, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamPreview() {
    // Organize selected players by position
    List<Player> selectedWK = _selectedPlayers.where((p) => p.position == "WK").toList();
    List<Player> selectedBAT = _selectedPlayers.where((p) => p.position == "BAT").toList();
    List<Player> selectedAR = _selectedPlayers.where((p) => p.position == "AR").toList();
    List<Player> selectedBOWL = _selectedPlayers.where((p) => p.position == "BOWL").toList();

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF2D5A27),
            Color(0xFF1A3D18),
          ],
        ),
      ),
      child: Column(
        children: [
          // Header with team info
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Text(
                  "RAJPUT9 SUPER11",
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Text(
                  "Credits Left",
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                SizedBox(width: 8),
                Text(
                  "${_creditsLeft.toStringAsFixed(0)}",
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          // Match score
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Players", style: TextStyle(color: Colors.white70, fontSize: 14)),
                SizedBox(width: 8),
                Text("${_selectedPlayers.length}/11", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(width: 32),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text("PCC", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                ),
                SizedBox(width: 8),
                Text("6 : 5", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(width: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text("BRN", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 40),

                  // Wicket Keepers
                  if (selectedWK.isNotEmpty) ...[
                    Text("WICKET-KEEPERS", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: selectedWK.map((player) => _buildFieldPlayer(player, isWK: true)).toList(),
                    ),
                    SizedBox(height: 40),
                  ],

                  // Batters
                  if (selectedBAT.isNotEmpty) ...[
                    Text("BATTERS", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                    SizedBox(height: 16),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 20,
                      runSpacing: 20,
                      children: selectedBAT.map((player) => _buildFieldPlayer(player)).toList(),
                    ),
                    SizedBox(height: 40),
                  ],

                  // All Rounders
                  if (selectedAR.isNotEmpty) ...[
                    Text("ALL-ROUNDERS", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: selectedAR.map((player) => _buildFieldPlayer(player)).toList(),
                    ),
                    SizedBox(height: 40),
                  ],

                  // Bowlers
                  if (selectedBOWL.isNotEmpty) ...[
                    Text("BOWLERS", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                    SizedBox(height: 16),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 20,
                      runSpacing: 20,
                      children: selectedBOWL.map((player) => _buildFieldPlayer(player)).toList(),
                    ),
                    SizedBox(height: 40),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldPlayer(Player player, {bool isWK = false}) {
    return Container(
        width: 80,
        child: Column(
          children: [
        Stack(
        children: [
        CircleAvatar(
        radius: 30,
          backgroundColor: Colors.grey[700],
          child: Text(
            player.name.split(' ').map((e) => e[0]).join(''),
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        if (_captain == player)
    Positioned(
      top: -5,
      right: -5,
      child: CircleAvatar(
        radius: 12,
        backgroundColor: Colors.orange,
        child: Text("C", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
      ),
    ),
    if (_viceCaptain == player)
    Positioned(
    top: -5,
    right: -5,
    child: CircleAvatar(
    radius: 12,
    backgroundColor: Colors.orange,
    child: Text("VC", style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
    ),
    ),
    ],
    ),
    SizedBox(height: 8),
    Container(
    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(4),
    ),
    child: Text(
    player.name.length > 10 ? player.name.substring(0, 7) + "..." : player.name,
    style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold),
    textAlign: TextAlign.center,
    ),
    ),
    SizedBox(height: 4),
    Text(
    "${player.credits} Cr",
    style: TextStyle(color: Colors.white70, fontSize: 10),
    ),
          ],
        ),
    );
  }

  Widget _buildCaptainSelection() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Choose Captain & Vice Captain",
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            "Captain gets 2x points, Vice Captain gets 1.5x points",
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: _selectedPlayers.length,
              itemBuilder: (context, index) {
                Player player = _selectedPlayers[index];
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 4),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Color(0xFF2A2A2A),
                    borderRadius: BorderRadius.circular(8),
                    border: (_captain == player || _viceCaptain == player)
                        ? Border.all(color: Colors.orange, width: 2)
                        : null,
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.grey[600],
                        child: Text(
                          player.name.split(' ').map((e) => e[0]).join(''),
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              player.name,
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "${player.position} • ${player.team}",
                              style: TextStyle(color: Colors.white70, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => _setCaptain(player),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: _captain == player ? Colors.orange : Colors.transparent,
                                border: Border.all(color: Colors.orange),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                "C",
                                style: TextStyle(
                                  color: _captain == player ? Colors.white : Colors.orange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          GestureDetector(
                            onTap: () => _setViceCaptain(player),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: _viceCaptain == player ? Colors.orange : Colors.transparent,
                                border: Border.all(color: Colors.orange),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                "VC",
                                style: TextStyle(
                                  color: _viceCaptain == player ? Colors.white : Colors.orange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
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

  Widget _buildTeamSavedView() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 80,
          ),
          SizedBox(height: 20),
          Text(
            "Team Created Successfully!",
            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
            "Your team has been saved with ${_selectedPlayers.length} players",
            style: TextStyle(color: Colors.white70, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),
          if (_captain != null)
            Text(
              "Captain: ${_captain!.name}",
              style: TextStyle(color: Colors.orange, fontSize: 16, fontWeight: FontWeight.bold),
            ),
          if (_viceCaptain != null)
            Text(
              "Vice Captain: ${_viceCaptain!.name}",
              style: TextStyle(color: Colors.orange, fontSize: 16, fontWeight: FontWeight.bold),
            ),
          SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
            ),
            child: Text(
              "Go to Contests",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF2A2A2A),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Players ${_selectedPlayers.length}/11",
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
                Text(
                  "Credits left: ${_creditsLeft.toStringAsFixed(1)}",
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          if (_currentView == 0)
            ElevatedButton(
              onPressed: _selectedPlayers.length == 11
                  ? () => setState(() => _currentView = 1)
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _selectedPlayers.length == 11 ? Colors.green : Colors.grey,
              ),
              child: Text("Preview", style: TextStyle(color: Colors.white)),
            ),
          if (_currentView == 1)
            ElevatedButton(
              onPressed: () => setState(() => _currentView = 2),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: Text("Next", style: TextStyle(color: Colors.white)),
            ),
          if (_currentView == 2)
            ElevatedButton(
              onPressed: (_captain != null && _viceCaptain != null)
                  ? () => setState(() => _currentView = 3)
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: (_captain != null && _viceCaptain != null)
                    ? Colors.green
                    : Colors.grey,
              ),
              child: Text("Save Team", style: TextStyle(color: Colors.white)),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }
}