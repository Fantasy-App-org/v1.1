import 'package:flutter/material.dart';
import '../model/fixture.dart';
import '../model/player.dart';
import '../model/user_team.dart';
import '../service/team_service.dart';

class CreateTeamPage extends StatefulWidget {
  final FixtureModel fixture;
  final UserTeam? existingTeam; // For editing existing teams
  final UserTeam? teamToCopy; // For copying teams

  const CreateTeamPage({
    Key? key,
    required this.fixture,
    this.existingTeam, // Optional parameter for editing
    this.teamToCopy, // Optional parameter for copying
  }) : super(key: key);

  @override
  _CreateTeamPageState createState() => _CreateTeamPageState();
}

class _CreateTeamPageState extends State<CreateTeamPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late PageController _pageController;

  // Services
  final TeamService _teamService = TeamService();

  // State variables
  int _selectedTab = 0;
  List<Player> _selectedPlayers = [];
  Player? _captain;
  Player? _viceCaptain;
  double _creditsLeft = 100.0;
  int _currentView = 0; // 0: Player Selection, 1: Team Preview, 2: Captain Selection, 3: Team Saved View

  // Backend data
  List<Player> _allPlayers = [];
  bool _isLoading = true;
  String? _errorMessage;

  // Categorized players
  List<Player> _wicketKeepers = [];
  List<Player> _batsmen = [];
  List<Player> _allRounders = [];
  List<Player> _bowlers = [];

  // Mode properties
  bool get _isEditMode => widget.existingTeam != null;
  bool get _isCopyMode => widget.teamToCopy != null;
  String get _pageTitle => _isEditMode ? "Edit Team" : _isCopyMode ? "Copy Team" : "Create Team";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _pageController = PageController();
    _loadPlayersFromBackend();
  }

  Future<void> _loadPlayersFromBackend() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      print('Loading players for match ID: ${widget.fixture.id}, series ID: ${widget.fixture.seriesId}');

      final players = await _teamService.getSquadListForMatch(
        seriesId: widget.fixture.seriesId,
        matchId: widget.fixture.id,
      );

      setState(() {
        _allPlayers = players;
        _categorizePlayersByPosition();

        // If editing, pre-populate the team
        if (_isEditMode && widget.existingTeam != null) {
          _populateExistingTeam(widget.existingTeam!);
        }
        // If copying, pre-populate the team but don't set captain/vice-captain
        else if (_isCopyMode && widget.teamToCopy != null) {
          _populateCopyTeam(widget.teamToCopy!);
        }

        _isLoading = false;
      });

      print('Successfully loaded ${_allPlayers.length} players');
    } catch (e) {
      print('Error loading players: $e');
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  // Method to populate existing team data for editing
  void _populateExistingTeam(UserTeam existingTeam) {
    print('Populating existing team: ${existingTeam.teamName}');

    if (existingTeam.teamPlayers == null || existingTeam.teamPlayers!.isEmpty) {
      print('No players found in existing team');
      return;
    }

    _selectedPlayers.clear();

    for (Player existingPlayer in existingTeam.teamPlayers!) {
      // Find matching player in the loaded squad
      Player? matchingPlayer = _allPlayers.firstWhere(
            (player) => player.id == existingPlayer.id ||
            player.playerName == existingPlayer.playerName,
        orElse: () => existingPlayer,
      );

      if (matchingPlayer != null) {
        matchingPlayer.isSelected = true;
        _selectedPlayers.add(matchingPlayer);

        // Set captain and vice captain
        if (existingPlayer.playerName == existingTeam.captain?.toString()) {
          _captain = matchingPlayer;
        }
        if (existingPlayer.playerName == existingTeam.viceCaptain?.toString()) {
          _viceCaptain = matchingPlayer;
        }
      }
    }

    _calculateCreditsLeft();
    print('Populated team with ${_selectedPlayers.length} players');
    print('Captain: ${_captain?.playerName}, Vice Captain: ${_viceCaptain?.playerName}');
  }

  // New method to populate team for copying (without captain/vice-captain)
  void _populateCopyTeam(UserTeam teamToCopy) {
    print('Populating team to copy: ${teamToCopy.teamName}');

    if (teamToCopy.teamPlayers == null || teamToCopy.teamPlayers!.isEmpty) {
      print('No players found in team to copy');
      return;
    }

    _selectedPlayers.clear();

    for (Player existingPlayer in teamToCopy.teamPlayers!) {
      // Find matching player in the loaded squad
      Player? matchingPlayer = _allPlayers.firstWhere(
            (player) => player.id == existingPlayer.id ||
            player.playerName == existingPlayer.playerName,
        orElse: () => existingPlayer,
      );

      if (matchingPlayer != null) {
        matchingPlayer.isSelected = true;
        _selectedPlayers.add(matchingPlayer);
      }
    }

    // DON'T set captain and vice captain for copy mode - let user choose new ones
    _captain = null;
    _viceCaptain = null;

    _calculateCreditsLeft();
    print('Populated copy team with ${_selectedPlayers.length} players');
    print('Captain and Vice Captain will be selected by user');
  }

  void _categorizePlayersByPosition() {
    _wicketKeepers = _allPlayers.where((p) => p.role?.toLowerCase().contains('wk') == true ||
        p.role?.toLowerCase().contains('wk') == true).toList();

    _batsmen = _allPlayers.where((p) => p.role?.toLowerCase().contains('bat') == true ||
        p.role?.toLowerCase().contains('bat') == true).toList();

    _allRounders = _allPlayers.where((p) => p.role?.toLowerCase().contains('allrounder') == true ||
        p.role?.toLowerCase().contains('all-rounder') == true ||
        p.role?.toLowerCase().contains('ar') == true).toList();

    _bowlers = _allPlayers.where((p) => p.role?.toLowerCase().contains('bowler') == true ||
        p.role?.toLowerCase().contains('bowl') == true).toList();

    // Sort each category by credits in descending order
    _wicketKeepers.sort((a, b) => (b.credits ?? 0.0).compareTo(a.credits ?? 0.0));
    _batsmen.sort((a, b) => (b.credits ?? 0.0).compareTo(a.credits ?? 0.0));
    _allRounders.sort((a, b) => (b.credits ?? 0.0).compareTo(a.credits ?? 0.0));
    _bowlers.sort((a, b) => (b.credits ?? 0.0).compareTo(a.credits ?? 0.0));

    print('Categorized players: WK:${_wicketKeepers.length}, BAT:${_batsmen.length}, AR:${_allRounders.length}, BOWL:${_bowlers.length}');
  }

  void _calculateCreditsLeft() {
    double usedCredits = _selectedPlayers.fold(0, (sum, player) => sum + (player.credits ?? 0.0));
    setState(() {
      _creditsLeft = 100.0 - usedCredits;
    });
  }

  bool _validateTeamComposition() {
    // Count players by position
    int wkCount = _selectedPlayers.where((p) => _isWicketKeeper(p)).length;
    int batCount = _selectedPlayers.where((p) => _isBatsman(p)).length;
    int arCount = _selectedPlayers.where((p) => _isAllRounder(p)).length;
    int bowlCount = _selectedPlayers.where((p) => _isBowler(p)).length;

    // Count players by team
    int teamACount = _selectedPlayers.where((p) => p.teamId == widget.fixture.teamAId).length;
    int teamBCount = _selectedPlayers.where((p) => p.teamId == widget.fixture.teamBId).length;

    // Validation rules
    if (wkCount < 1) return false; // At least 1 wicket keeper
    if (batCount < 1) return false; // At least 1 batsman
    if (arCount < 1) return false; // At least 1 all rounder
    if (bowlCount < 1) return false; // At least 1 bowler
    if (teamACount == 0 || teamBCount == 0) return false; // At least 1 from each team
    if (teamACount > 7 || teamBCount > 7) return false; // Max 7 from any team

    return true;
  }

  String _getValidationMessage() {
    int wkCount = _selectedPlayers.where((p) => _isWicketKeeper(p)).length;
    int batCount = _selectedPlayers.where((p) => _isBatsman(p)).length;
    int arCount = _selectedPlayers.where((p) => _isAllRounder(p)).length;
    int bowlCount = _selectedPlayers.where((p) => _isBowler(p)).length;

    int teamACount = _selectedPlayers.where((p) => p.teamId == widget.fixture.teamAId).length;
    int teamBCount = _selectedPlayers.where((p) => p.teamId == widget.fixture.teamBId).length;

    if (wkCount < 1) return "Select at least 1 wicket keeper";
    if (batCount < 1) return "Select at least 1 batsman";
    if (arCount < 1) return "Select at least 1 all rounder";
    if (bowlCount < 1) return "Select at least 1 bowler";
    if (teamACount == 0) return "Select at least 1 player from ${widget.fixture.teamAShort}";
    if (teamBCount == 0) return "Select at least 1 player from ${widget.fixture.teamBShort}";
    if (teamACount > 7) return "Maximum 7 players from ${widget.fixture.teamAShort}";
    if (teamBCount > 7) return "Maximum 7 players from ${widget.fixture.teamBShort}";

    return "Complete your team selection";
  }

  bool _isWicketKeeper(Player player) => _wicketKeepers.contains(player);
  bool _isBatsman(Player player) => _batsmen.contains(player);
  bool _isAllRounder(Player player) => _allRounders.contains(player);
  bool _isBowler(Player player) => _bowlers.contains(player);

  String _getPlayerPosition(Player player) {
    if (_isWicketKeeper(player)) return "WK";
    if (_isBatsman(player)) return "BAT";
    if (_isAllRounder(player)) return "AR";
    if (_isBowler(player)) return "BOWL";
    return "UNKNOWN";
  }

  void _togglePlayerSelection(Player player) {
    setState(() {
      if (player.isSelected) {
        _selectedPlayers.remove(player);
        player.isSelected = false;
        if (_captain == player) _captain = null;
        if (_viceCaptain == player) _viceCaptain = null;
      } else {
        if (_selectedPlayers.length < 11 && _creditsLeft >= (player.credits ?? 0.0)) {
          _selectedPlayers.add(player);
          player.isSelected = true;
        } else if (_creditsLeft < (player.credits ?? 0.0)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Not enough credits to select this player'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 2),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Team is full (11 players)'),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 2),
            ),
          );
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

  Future<void> _createTeam() async {
    try {
      if (_captain == null || _viceCaptain == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please select captain and vice captain'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      final playerIds = _selectedPlayers.map((p) => p.id!).toList();

      // Use existing team ID if editing, empty string if creating new or copying
      String teamId = _isEditMode && widget.existingTeam?.teamId != null
          ? widget.existingTeam!.teamId.toString()
          : "";

      final response = await _teamService.createTeam(
        captainId: _captain!.id!,
        viceCaptainId: _viceCaptain!.id!,
        matchId: widget.fixture.id,
        sportsId: 1, // Cricket sport ID
        playerIds: playerIds,
        teamId: teamId, // Pass team ID for editing, empty for new team or copy
        seriesId: widget.fixture.seriesId,
      );

      setState(() {
        _isLoading = false;
        _currentView = 3; // Show success view
      });

      String actionText = _isEditMode ? 'updated' : _isCopyMode ? 'copied' : 'created';
      print('Team $actionText successfully: ${response}');
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      String actionText = _isEditMode ? 'update' : _isCopyMode ? 'copy' : 'create';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to $actionText team: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );

      print('Error ${actionText}ing team: $e');
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
              setState(() {
                _currentView = 0;
              });
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _currentView == 3
                  ? (_isEditMode ? "Team Updated" : _isCopyMode ? "Team Copied" : "Team Created")
                  : _pageTitle,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            if (_currentView != 3)
              Text(
                "${widget.fixture.teamAShort} vs ${widget.fixture.teamBShort}",
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
          ],
        ),
        actions: [
          Container(
            margin: EdgeInsets.all(8),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _isEditMode
                  ? Colors.orange
                  : _isCopyMode
                  ? Colors.blue
                  : Color(0xFF8B1538),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                    _isEditMode
                        ? Icons.edit
                        : _isCopyMode
                        ? Icons.copy
                        : Icons.sports_cricket,
                    color: Colors.white,
                    size: 16
                ),
                SizedBox(width: 4),
                Text(
                    _isEditMode
                        ? "Edit"
                        : _isCopyMode
                        ? "Copy"
                        : "Fantasy",
                    style: TextStyle(color: Colors.white, fontSize: 12)
                ),
              ],
            ),
          ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: _currentView != 3 ? _buildBottomBar() : null,
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return _buildLoadingState();
    }

    if (_errorMessage != null) {
      return _buildErrorState();
    }

    return _buildCurrentView();
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8B1538)),
          ),
          SizedBox(height: 16),
          Text(
            'Loading players...',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.grey[400],
            ),
            SizedBox(height: 16),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadPlayersFromBackend,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF8B1538),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              child: Text('Retry'),
            ),
          ],
        ),
      ),
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
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF2A2A2A), Color(0xFF1A1A1A)],
            ),
          ),
          child: Column(
            children: [
              // Copy mode notification
              if (_isCopyMode) ...[
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.copy, color: Colors.blue, size: 16),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Copying Team ${widget.teamToCopy!.teamName} - Select new Captain and Vice Captain',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
              ],
              Row(
                children: [
                  _buildTeamInfo(widget.fixture.teamAShort, "0"),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          widget.fixture.matchTitle,
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          height: 6,
                          decoration: BoxDecoration(
                            color: Colors.grey[800],
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: Row(
                            children: List.generate(11, (index) =>
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.symmetric(horizontal: 1),
                                    decoration: BoxDecoration(
                                      color: index < _selectedPlayers.length ? Color(0xFF8B1538) : Colors.grey[800],
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                  ),
                                ),
                            ),
                          ),
                        ),
                        Text("${_selectedPlayers.length}/11", style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  _buildTeamInfo(widget.fixture.teamBShort, "0"),
                ],
              ),
            ],
          ),
        ),

        // Credits Info
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          color: Color(0xFF2A2A2A),
          child: Row(
            children: [
              Icon(Icons.monetization_on, color: Colors.orange, size: 20),
              SizedBox(width: 8),
              Text(
                "Credits Left: ${_creditsLeft.toStringAsFixed(1)}",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Color(0xFF8B1538),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "Max 7 from any team",
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
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
              _buildTabWithCount("WK", _selectedPlayers.where((p) => _isWicketKeeper(p)).length),
              _buildTabWithCount("BAT", _selectedPlayers.where((p) => _isBatsman(p)).length),
              _buildTabWithCount("AR", _selectedPlayers.where((p) => _isAllRounder(p)).length),
              _buildTabWithCount("BOWL", _selectedPlayers.where((p) => _isBowler(p)).length),
            ],
            labelColor: Color(0xFF8B1538),
            unselectedLabelColor: Colors.white70,
            indicatorColor: Color(0xFF8B1538),
            indicatorWeight: 3,
          ),
        ),

        // Player List with PageView for swiping
        Expanded(
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _selectedTab = index;
                _tabController.animateTo(index);
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

  Widget _buildTabWithCount(String label, int count) {
    return Tab(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          if (count > 0)
            Container(
              margin: EdgeInsets.only(top: 2),
              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Color(0xFF8B1538),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                count.toString(),
                style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPlayerListForPosition(List<Player> players) {
    if (players.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.sports_cricket_outlined, size: 64, color: Colors.grey[400]),
            SizedBox(height: 16),
            Text(
              'No players available for this position',
              style: TextStyle(color: Colors.grey[400], fontSize: 16),
            ),
          ],
        ),
      );
    }

    // Separate announced and unannounced players
    List<Player> announcedPlayers = players.where((p) => p.isAnnounced == true).toList();
    List<Player> unannouncedPlayers = players.where((p) => p.isAnnounced == false).toList();

    return ListView(
      children: [
        // Announced Players
        if (announcedPlayers.isNotEmpty) ...[
          Container(
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green, Colors.green.shade700],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white, size: 16),
                SizedBox(width: 8),
                Text(
                  "Announced",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          ...announcedPlayers.map((player) => _buildPlayerCard(player)),
        ],

        // Unannounced Players
        if (unannouncedPlayers.isNotEmpty) ...[
          Container(
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange, Colors.orange.shade700],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.warning, color: Colors.white, size: 16),
                SizedBox(width: 8),
                Text(
                  "Unannounced",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          ...unannouncedPlayers.map((player) => _buildPlayerCard(player)),
        ],
      ],
    );
  }

  Widget _buildTeamInfo(String team, String score) {
    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: team == widget.fixture.teamAShort ? Color(0xFF8B1538) : Color(0xFF2E5BBA),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.white30, width: 2),
          ),
          child: Center(
            child: Text(
              team,
              style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        SizedBox(width: 8),
        Text(score, style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildPlayerCard(Player player) {
    bool canSelect = _selectedPlayers.length < 11 && _creditsLeft >= (player.credits ?? 0.0);
    String teamShort = player.teamId == widget.fixture.teamAId ? widget.fixture.teamAShort : widget.fixture.teamBShort;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: player.isSelected
              ? [Color(0xFF8B1538), Color(0xFFA91B47)]
              : [Color(0xFF2A2A2A), Color(0xFF1E1E1E)],
        ),
        borderRadius: BorderRadius.circular(12),
        border: player.isSelected
            ? Border.all(color: Colors.white, width: 2)
            : Border.all(color: Colors.grey[700]!, width: 1),
        boxShadow: player.isSelected ? [
          BoxShadow(
            color: Color(0xFF8B1538).withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ] : null,
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            // Player Avatar
            Stack(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey[600],
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: player.teamId == widget.fixture.teamAId
                          ? Color(0xFF8B1538)
                          : Color(0xFF2E5BBA),
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      (player.playerName ?? "Unknown").split(' ').map((e) => e.isNotEmpty ? e[0] : '').join(''),
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ),
                if (player.isSelected)
                  Positioned(
                    top: -2,
                    right: -2,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.check, color: Colors.white, size: 14),
                    ),
                  ),
              ],
            ),
            SizedBox(width: 16),

            // Player Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    player.playerName ?? "Unknown",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: player.teamId == widget.fixture.teamAId
                              ? Color(0xFF8B1538)
                              : Color(0xFF2E5BBA),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          teamShort,
                          style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        "${(player.selectedBy ?? 0.0).toStringAsFixed(1)}% selected",
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.orange, size: 14),
                      SizedBox(width: 4),
                      Text(
                        "${player.points ?? 0} pts",
                        style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Credits and Selection Button
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "${player.credits ?? 0.0}",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  "Credits",
                  style: TextStyle(color: Colors.white70, fontSize: 10),
                ),
                SizedBox(height: 8),
                GestureDetector(
                  onTap: () => _togglePlayerSelection(player),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: player.isSelected ? Colors.white : Colors.transparent,
                      border: Border.all(
                        color: player.isSelected ? Colors.white : (canSelect ? Color(0xFF8B1538) : Colors.grey),
                        width: 2,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      player.isSelected ? Icons.check : Icons.add,
                      color: player.isSelected ? Color(0xFF8B1538) : (canSelect ? Color(0xFF8B1538) : Colors.grey),
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Team Preview
  Widget _buildTeamPreview() {
    // Organize selected players by position
    List<Player> selectedWK = _selectedPlayers.where((p) => _isWicketKeeper(p)).toList();
    List<Player> selectedBAT = _selectedPlayers.where((p) => _isBatsman(p)).toList();
    List<Player> selectedAR = _selectedPlayers.where((p) => _isAllRounder(p)).toList();
    List<Player> selectedBOWL = _selectedPlayers.where((p) => _isBowler(p)).toList();

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
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF2A2A2A), Colors.transparent],
              ),
            ),
            child: Row(
              children: [
                Text(
                  "TEAM PREVIEW",
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "Credits Left",
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    Text(
                      "${_creditsLeft.toStringAsFixed(0)}",
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Team composition stats
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
                    color: Color(0xFF8B1538),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(widget.fixture.teamAShort, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                SizedBox(width: 8),
                Text(
                  "${_selectedPlayers.where((p) => p.teamId == widget.fixture.teamAId).length} : ${_selectedPlayers.where((p) => p.teamId == widget.fixture.teamBId).length}",
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Color(0xFF2E5BBA),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(widget.fixture.teamBShort, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
                    _buildPositionHeader("WICKET-KEEPERS", selectedWK.length),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: selectedWK.map((player) => _buildFieldPlayer(player, isWK: true)).toList(),
                    ),
                    SizedBox(height: 40),
                  ],

                  // Batters
                  if (selectedBAT.isNotEmpty) ...[
                    _buildPositionHeader("BATTERS", selectedBAT.length),
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
                    _buildPositionHeader("ALL-ROUNDERS", selectedAR.length),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: selectedAR.map((player) => _buildFieldPlayer(player)).toList(),
                    ),
                    SizedBox(height: 40),
                  ],

                  // Bowlers
                  if (selectedBOWL.isNotEmpty) ...[
                    _buildPositionHeader("BOWLERS", selectedBOWL.length),
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

  Widget _buildPositionHeader(String title, int count) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        "$title ($count)",
        style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildFieldPlayer(Player player, {bool isWK = false}) {
    String teamShort = player.teamId == widget.fixture.teamAId ? widget.fixture.teamAShort : widget.fixture.teamBShort;

    return Container(
      width: 80,
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: player.teamId == widget.fixture.teamAId
                      ? Color(0xFF8B1538)
                      : Color(0xFF2E5BBA),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    (player.playerName ?? "Unknown").split(' ').map((e) => e.isNotEmpty ? e[0] : '').join(''),
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
              if (_captain == player)
                Positioned(
                  top: -5,
                  right: -5,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Center(
                      child: Text("C", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              if (_viceCaptain == player)
                Positioned(
                  top: -5,
                  right: -5,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Center(
                      child: Text("VC", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 8),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              (player.playerName ?? "Unknown").length > 8
                  ? (player.playerName ?? "Unknown").substring(0, 6) + ".."
                  : (player.playerName ?? "Unknown"),
              style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 4),
          Text(
            "${player.credits ?? 0.0} Cr",
            style: TextStyle(color: Colors.white70, fontSize: 10),
          ),
        ],
      ),
    );
  }

  // Captain Selection
  Widget _buildCaptainSelection() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _isCopyMode
                    ? [Colors.blue, Colors.blue.shade700]
                    : _isEditMode
                    ? [Colors.orange, Colors.orange.shade700]
                    : [Color(0xFF8B1538), Color(0xFFA91B47)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isCopyMode
                      ? "Choose New Captain & Vice Captain"
                      : "Choose Captain & Vice Captain",
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  _isCopyMode
                      ? "Select different captain and vice captain for your copied team. Captain gets 2x points, Vice Captain gets 1.5x points"
                      : "Captain gets 2x points, Vice Captain gets 1.5x points",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: _selectedPlayers.length,
              itemBuilder: (context, index) {
                Player player = _selectedPlayers[index];
                String teamShort = player.teamId == widget.fixture.teamAId ? widget.fixture.teamAShort : widget.fixture.teamBShort;

                return Container(
                  margin: EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: (_captain == player || _viceCaptain == player)
                          ? _isCopyMode
                          ? [Colors.blue, Colors.blue.shade700]
                          : _isEditMode
                          ? [Colors.orange, Colors.orange.shade700]
                          : [Color(0xFF8B1538), Color(0xFFA91B47)]
                          : [Color(0xFF2A2A2A), Color(0xFF1E1E1E)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: (_captain == player || _viceCaptain == player)
                        ? Border.all(color: Colors.white, width: 2)
                        : Border.all(color: Colors.grey[700]!, width: 1),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: player.teamId == widget.fixture.teamAId
                                ? Color(0xFF8B1538)
                                : Color(0xFF2E5BBA),
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: Center(
                            child: Text(
                              (player.playerName ?? "Unknown").split(' ').map((e) => e.isNotEmpty ? e[0] : '').join(''),
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                player.playerName ?? "Unknown",
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "${_getPlayerPosition(player)} • $teamShort • ${player.points ?? 0} pts",
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
                                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: _captain == player ? Colors.orange : Colors.transparent,
                                  border: Border.all(color: Colors.orange, width: 2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  "C",
                                  style: TextStyle(
                                    color: _captain == player ? Colors.white : Colors.orange,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 12),
                            GestureDetector(
                              onTap: () => _setViceCaptain(player),
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: _viceCaptain == player ? Colors.blue : Colors.transparent,
                                  border: Border.all(color: Colors.blue, width: 2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  "VC",
                                  style: TextStyle(
                                    color: _viceCaptain == player ? Colors.white : Colors.blue,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF1A1A1A),
            Color(0xFF2A2A2A),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _isEditMode
                    ? [Colors.orange, Colors.orange.shade700]
                    : _isCopyMode
                    ? [Colors.blue, Colors.blue.shade700]
                    : [Colors.green, Colors.green.shade700],
              ),
              borderRadius: BorderRadius.circular(60),
            ),
            child: Icon(
              Icons.check_circle,
              color: Colors.white,
              size: 60,
            ),
          ),
          SizedBox(height: 30),
          Text(
            _isEditMode
                ? "Team Updated Successfully!"
                : _isCopyMode
                ? "Team Copied Successfully!"
                : "Team Created Successfully!",
            style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          Text(
            _isEditMode
                ? "Your team changes have been saved with ${_selectedPlayers.length} players"
                : _isCopyMode
                ? "Your new team has been created with ${_selectedPlayers.length} players from the copied team"
                : "Your team has been saved with ${_selectedPlayers.length} players",
            style: TextStyle(color: Colors.white70, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 40),
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _isCopyMode
                    ? [Colors.blue, Colors.blue.shade700]
                    : _isEditMode
                    ? [Colors.orange, Colors.orange.shade700]
                    : [Color(0xFF8B1538), Color(0xFFA91B47)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                if (_captain != null)
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text("C", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(width: 12),
                      Text(
                        "Captain: ${_captain!.playerName ?? 'Unknown'}",
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                if (_captain != null && _viceCaptain != null) SizedBox(height: 16),
                if (_viceCaptain != null)
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text("VC", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(width: 12),
                      Text(
                        "Vice Captain: ${_viceCaptain!.playerName ?? 'Unknown'}",
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          SizedBox(height: 40),
          Container(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true); // Return true to indicate successful action
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _isEditMode
                    ? Colors.orange
                    : _isCopyMode
                    ? Colors.blue
                    : Colors.green,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                _isEditMode ? "Go Back" : _isCopyMode ? "View New Team" : "Go to Contests",
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    bool isValid = _selectedPlayers.length == 11 && _validateTeamComposition();

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF2A2A2A), Color(0xFF1A1A1A)],
        ),
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
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  _selectedPlayers.length == 11 && !_validateTeamComposition()
                      ? _getValidationMessage()
                      : "Credits left: ${_creditsLeft.toStringAsFixed(1)}",
                  style: TextStyle(
                      color: _selectedPlayers.length == 11 && !_validateTeamComposition()
                          ? Colors.red
                          : Colors.white70,
                      fontSize: 14
                  ),
                ),
              ],
            ),
          ),
          if (_currentView == 0)
            Container(
              decoration: BoxDecoration(
                gradient: isValid
                    ? LinearGradient(colors: [Color(0xFF8B1538), Color(0xFFA91B47)])
                    : null,
                color: isValid ? null : Colors.grey,
                borderRadius: BorderRadius.circular(8),
              ),
              child: ElevatedButton(
                onPressed: isValid
                    ? () => setState(() => _currentView = 1)
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: Text(
                  "Preview",
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          if (_currentView == 1)
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Color(0xFF8B1538), Color(0xFFA91B47)]),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ElevatedButton(
                onPressed: () => setState(() => _currentView = 2),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: Text(
                  "Next",
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          if (_currentView == 2)
            Container(
              decoration: BoxDecoration(
                gradient: (_captain != null && _viceCaptain != null)
                    ? LinearGradient(colors: _isCopyMode
                    ? [Colors.blue, Colors.blue.shade700]
                    : _isEditMode
                    ? [Colors.orange, Colors.orange.shade700]
                    : [Colors.green, Colors.green.shade700])
                    : null,
                color: (_captain != null && _viceCaptain != null) ? null : Colors.grey,
                borderRadius: BorderRadius.circular(8),
              ),
              child: ElevatedButton(
                onPressed: (_captain != null && _viceCaptain != null && !_isLoading)
                    ? _createTeam
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: _isLoading
                    ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 2,
                  ),
                )
                    : Text(
                  _isEditMode ? "Update Team" : _isCopyMode ? "Save Copy" : "Save Team",
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
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