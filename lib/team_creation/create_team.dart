import 'dart:ui';

import 'package:flutter/material.dart';
import '../model/fixture.dart';
import '../model/player.dart';
import '../model/user_team.dart';
import '../service/team_service.dart';

class CreateTeamPage extends StatefulWidget {
  final FixtureModel fixture;
  final UserTeam? existingTeam;
  final UserTeam? teamToCopy;

  const CreateTeamPage({
    Key? key,
    required this.fixture,
    this.existingTeam,
    this.teamToCopy,
  }) : super(key: key);

  @override
  _CreateTeamPageState createState() => _CreateTeamPageState();
}

class _CreateTeamPageState extends State<CreateTeamPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late PageController _pageController;
  late AnimationController _blinkController;

  final TeamService _teamService = TeamService();

  int _selectedTab = 0;
  List<Player> _selectedPlayers = [];
  Player? _captain;
  Player? _viceCaptain;
  double _creditsLeft = 100.0;
  int _currentView = 0;

  List<Player> _allPlayers = [];
  bool _isLoading = true;
  String? _errorMessage;

  List<Player> _wicketKeepers = [];
  List<Player> _batsmen = [];
  List<Player> _allRounders = [];
  List<Player> _bowlers = [];

  // Modern color scheme
  final Color primaryColor = Color(0xFF2563EB);
  final Color secondaryColor = Color(0xFF10B981);
  final Color accentColor = Color(0xFFF59E0B);
  final Color teamAColor = Color(0xFF1E88E5);
  final Color teamBColor = Color(0xFFFF6F00);
  final Color backgroundColor = Color(0xFFF8FAFC);

  bool get _isEditMode => widget.existingTeam != null;
  bool get _isCopyMode => widget.teamToCopy != null;
  String get _pageTitle => _isEditMode ? "Edit Team" : _isCopyMode ? "Copy Team" : "Create Team";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _pageController = PageController();
    _blinkController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _loadPlayersFromBackend();
  }

  Future<void> _loadPlayersFromBackend() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final players = await _teamService.getSquadListForMatch(
        seriesId: widget.fixture.seriesId,
        matchId: widget.fixture.id,
      );

      setState(() {
        _allPlayers = players;
        _categorizePlayersByPosition();

        if (_isEditMode && widget.existingTeam != null) {
          _populateExistingTeam(widget.existingTeam!);
        } else if (_isCopyMode && widget.teamToCopy != null) {
          _populateCopyTeam(widget.teamToCopy!);
        }

        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  void _populateExistingTeam(UserTeam existingTeam) {
    if (existingTeam.teamPlayers == null || existingTeam.teamPlayers!.isEmpty) return;

    _selectedPlayers.clear();

    for (Player existingPlayer in existingTeam.teamPlayers!) {
      Player? matchingPlayer = _allPlayers.firstWhere(
            (player) => player.id == existingPlayer.id || player.playerName == existingPlayer.playerName,
        orElse: () => existingPlayer,
      );

      if (matchingPlayer != null) {
        matchingPlayer.isSelected = true;
        _selectedPlayers.add(matchingPlayer);

        if (existingPlayer.playerName == existingTeam.captain?.toString()) {
          _captain = matchingPlayer;
        }
        if (existingPlayer.playerName == existingTeam.viceCaptain?.toString()) {
          _viceCaptain = matchingPlayer;
        }
      }
    }

    _calculateCreditsLeft();
  }

  void _populateCopyTeam(UserTeam teamToCopy) {
    if (teamToCopy.teamPlayers == null || teamToCopy.teamPlayers!.isEmpty) return;

    _selectedPlayers.clear();

    for (Player existingPlayer in teamToCopy.teamPlayers!) {
      Player? matchingPlayer = _allPlayers.firstWhere(
            (player) => player.id == existingPlayer.id || player.playerName == existingPlayer.playerName,
        orElse: () => existingPlayer,
      );

      if (matchingPlayer != null) {
        matchingPlayer.isSelected = true;
        _selectedPlayers.add(matchingPlayer);
      }
    }

    _captain = null;
    _viceCaptain = null;
    _calculateCreditsLeft();
  }

  void _categorizePlayersByPosition() {
    _wicketKeepers = _allPlayers.where((p) => p.role?.toLowerCase().contains('wk') == true).toList();
    _batsmen = _allPlayers.where((p) => p.role?.toLowerCase().contains('bat') == true).toList();
    _allRounders = _allPlayers.where((p) =>
    p.role?.toLowerCase().contains('allrounder') == true ||
        p.role?.toLowerCase().contains('all-rounder') == true ||
        p.role?.toLowerCase().contains('ar') == true).toList();
    _bowlers = _allPlayers.where((p) => p.role?.toLowerCase().contains('bowl') == true).toList();

    _wicketKeepers.sort((a, b) => (b.credits ?? 0.0).compareTo(a.credits ?? 0.0));
    _batsmen.sort((a, b) => (b.credits ?? 0.0).compareTo(a.credits ?? 0.0));
    _allRounders.sort((a, b) => (b.credits ?? 0.0).compareTo(a.credits ?? 0.0));
    _bowlers.sort((a, b) => (b.credits ?? 0.0).compareTo(a.credits ?? 0.0));
  }

  void _calculateCreditsLeft() {
    double usedCredits = _selectedPlayers.fold(0, (sum, player) => sum + (player.credits ?? 0.0));
    setState(() {
      _creditsLeft = 100.0 - usedCredits;
    });
  }

  bool _validateTeamComposition() {
    int wkCount = _selectedPlayers.where((p) => _isWicketKeeper(p)).length;
    int batCount = _selectedPlayers.where((p) => _isBatsman(p)).length;
    int arCount = _selectedPlayers.where((p) => _isAllRounder(p)).length;
    int bowlCount = _selectedPlayers.where((p) => _isBowler(p)).length;
    int teamACount = _selectedPlayers.where((p) => p.teamId == widget.fixture.teamAId).length;
    int teamBCount = _selectedPlayers.where((p) => p.teamId == widget.fixture.teamBId).length;

    if (wkCount < 1 || batCount < 1 || arCount < 1 || bowlCount < 1) return false;
    if (teamACount == 0 || teamBCount == 0) return false;
    if (teamACount > 7 || teamBCount > 7) return false;

    return true;
  }

  String _getValidationMessage() {
    int wkCount = _selectedPlayers.where((p) => _isWicketKeeper(p)).length;
    int batCount = _selectedPlayers.where((p) => _isBatsman(p)).length;
    int arCount = _selectedPlayers.where((p) => _isAllRounder(p)).length;
    int bowlCount = _selectedPlayers.where((p) => _isBowler(p)).length;
    int teamACount = _selectedPlayers.where((p) => p.teamId == widget.fixture.teamAId).length;
    int teamBCount = _selectedPlayers.where((p) => p.teamId == widget.fixture.teamBId).length;

    if (_selectedPlayers.length < 11) return "Select ${11 - _selectedPlayers.length} more players";
    if (wkCount < 1) return "You must pick atleast 1 Wicket Keeper";
    if (batCount < 1) return "You must pick atleast 1 Batsman";
    if (arCount < 1) return "You must pick atleast 1 All Rounder";
    if (bowlCount < 1) return "You must pick atleast 1 Bowler";
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
            SnackBar(content: Text('Not enough credits'), backgroundColor: Colors.orange, duration: Duration(seconds: 2)),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Team is full (11 players)'), backgroundColor: Colors.orange, duration: Duration(seconds: 2)),
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

  Future<void> _createTeam() async {
    try {
      if (_captain == null || _viceCaptain == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select captain and vice captain'), backgroundColor: Colors.orange),
        );
        return;
      }

      setState(() => _isLoading = true);

      final playerIds = _selectedPlayers.map((p) => p.id!).toList();
      String teamId = _isEditMode && widget.existingTeam?.teamId != null
          ? widget.existingTeam!.teamId.toString()
          : "";

      await _teamService.createTeam(
        captainId: _captain!.id!,
        viceCaptainId: _viceCaptain!.id!,
        matchId: widget.fixture.id,
        sportsId: 1,
        playerIds: playerIds,
        teamId: teamId,
        seriesId: widget.fixture.seriesId,
      );

      setState(() {
        _isLoading = false;
        _currentView = 3;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      String actionText = _isEditMode ? 'update' : _isCopyMode ? 'copy' : 'create';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to $actionText team: ${e.toString()}'), backgroundColor: Colors.orange, duration: Duration(seconds: 3)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: _currentView != 3 ? _buildBottomBar() : null,
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.black87),
        onPressed: () {
          if (_currentView == 1 || _currentView == 2) {
            setState(() => _currentView = 0);
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
            style: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          if (_currentView != 3)
            Text(
              "43m 31s left",
              style: TextStyle(color: Colors.black54, fontSize: 12),
            ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) return _buildLoadingState();
    if (_errorMessage != null) return _buildErrorState();
    return _buildCurrentView();
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(primaryColor)),
          SizedBox(height: 16),
          Text('Loading players...', style: TextStyle(color: Colors.black87, fontSize: 16)),
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
            Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
            SizedBox(height: 16),
            Text(_errorMessage!, textAlign: TextAlign.center, style: TextStyle(color: Colors.black87, fontSize: 16)),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadPlayersFromBackend,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
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
      case 0: return _buildPlayerSelection();
      case 1: return _buildTeamPreview();
      case 2: return _buildCaptainSelection();
      case 3: return _buildTeamSavedView();
      default: return _buildPlayerSelection();
    }
  }

  Widget _buildPlayerSelection() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          _buildMatchInfo(),
          _buildTabBar(),
          Expanded(
            child: Container(
              color: Colors.white,
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
          ),
        ],
      ),
    );
  }
  Widget _buildMatchInfo() {
    int teamACount = _selectedPlayers.where((p) => p.teamId == widget.fixture.teamAId).length;
    int teamBCount = _selectedPlayers.where((p) => p.teamId == widget.fixture.teamBId).length;

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: Offset(0, 2))],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    widget.fixture.teamAShort,
                    style: TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 4),
                  Text(
                    teamACount.toString(),
                    style: TextStyle(color: teamAColor, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    "Credits Left",
                    style: TextStyle(color: Colors.black54, fontSize: 12),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "${_creditsLeft.toStringAsFixed(0)}/100",
                    style: TextStyle(color: accentColor, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    widget.fixture.teamBShort,
                    style: TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 4),
                  Text(
                    teamBCount.toString(),
                    style: TextStyle(color: teamBColor, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            "Max 7 players from a team",
            style: TextStyle(color: Colors.black54, fontSize: 12),
          ),
          SizedBox(height: 12),
          Row(
            children: List.generate(11, (index) {
              bool isSelected = index < _selectedPlayers.length;
              return Expanded(
                child: Container(
                  height: 28,
                  margin: EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    gradient: isSelected ? LinearGradient(colors: [primaryColor, secondaryColor]) : null,
                    color: !isSelected ? Colors.grey[200] : null,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                    child: Text(
                      isSelected ? (index + 1).toString() : "",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          if (_selectedPlayers.length < 11) ...[
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.remove_circle, color: Colors.red, size: 16),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _getValidationMessage(),
                      style: TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.w500),
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

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        onTap: (index) {
          setState(() => _selectedTab = index);
          _pageController.animateToPage(index, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
        },
        tabs: [
          _buildTabWithCount("WK", _selectedPlayers.where((p) => _isWicketKeeper(p)).length),
          _buildTabWithCount("BAT", _selectedPlayers.where((p) => _isBatsman(p)).length),
          _buildTabWithCount("AR", _selectedPlayers.where((p) => _isAllRounder(p)).length),
          _buildTabWithCount("BOWL", _selectedPlayers.where((p) => _isBowler(p)).length),
        ],
        labelColor: primaryColor,
        unselectedLabelColor: Colors.black54,
        indicatorColor: primaryColor,
        indicatorWeight: 3,
      ),
    );
  }

  Widget _buildTabWithCount(String label, int count) {
    return Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          Text("($count)", style: TextStyle(fontSize: 12)),
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
            Icon(Icons.sports_cricket_outlined, size: 64, color: Colors.grey[300]),
            SizedBox(height: 16),
            Text('No players available', style: TextStyle(color: Colors.grey[400], fontSize: 16)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 8),
      itemCount: players.length,
      itemBuilder: (context, index) => _buildPlayerCard(players[index]),
    );
  }

  Widget _buildPlayerCard(Player player) {
    bool canSelect = _selectedPlayers.length < 11 && _creditsLeft >= (player.credits ?? 0.0);
    String teamShort = player.teamId == widget.fixture.teamAId ? widget.fixture.teamAShort : widget.fixture.teamBShort;
    Color teamColor = player.teamId == widget.fixture.teamAId ? teamAColor : teamBColor;
    bool isUnannounced = player.isAnnounced != true;
    Color statusColor = isUnannounced ? Colors.red : Colors.green;
    bool showStatusBlinker = widget.fixture.lineupOut == true;

    return AnimatedBuilder(
      animation: _blinkController,
      builder: (context, child) {
        return Column(
          children: [
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _togglePlayerSelection(player),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: teamColor.withOpacity(0.1),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: teamColor.withOpacity(0.3),
                                width: 2,
                              ),
                            ),
                            child: Icon(
                              Icons.person,
                              color: teamColor,
                              size: 28,
                            ),
                          ),
                          if (showStatusBlinker)
                            Positioned(
                              top: -2,
                              right: -2,
                              child: Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: statusColor.withOpacity(_blinkController.value * 0.7 + 0.3),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: statusColor.withOpacity(_blinkController.value * 0.5),
                                      blurRadius: 6,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          if (player.isSelected)
                            Positioned(
                              bottom: -2,
                              right: -2,
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [primaryColor, secondaryColor],
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 14,
                                ),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (showStatusBlinker)
                              Row(
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: statusColor.withOpacity(_blinkController.value * 0.7 + 0.3),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    isUnannounced ? "Unannounced" : "Announced",
                                    style: TextStyle(
                                      color: statusColor,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            if (showStatusBlinker) SizedBox(height: 6),
                            Text(
                              player.playerName ?? "Unknown",
                              style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: teamColor,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    teamShort,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12),
                                Icon(Icons.people, color: Colors.black45, size: 14),
                                SizedBox(width: 4),
                                Text(
                                  "${(player.selectedBy ?? 0.0).toStringAsFixed(1)}%",
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 12,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Icon(Icons.star, color: accentColor, size: 14),
                                SizedBox(width: 4),
                                Text(
                                  "${player.points ?? 0}",
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "${player.credits ?? 0.0}",
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            "Credits",
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 10,
                            ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              gradient: player.isSelected
                                  ? LinearGradient(colors: [primaryColor, secondaryColor])
                                  : null,
                              color: !player.isSelected && !canSelect ? Colors.grey[100] : null,
                              border: Border.all(
                                color: player.isSelected
                                    ? Colors.transparent
                                    : (canSelect ? primaryColor : Colors.grey[300]!),
                                width: 2,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              player.isSelected ? Icons.check : Icons.add,
                              color: player.isSelected
                                  ? Colors.white
                                  : (canSelect ? primaryColor : Colors.grey[400]),
                              size: 22,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Divider(
                height: 1,
                thickness: 1,
                color: Colors.grey[300],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTeamPreview() {
    List<Player> selectedWK = _selectedPlayers.where((p) => _isWicketKeeper(p)).toList();
    List<Player> selectedBAT = _selectedPlayers.where((p) => _isBatsman(p)).toList();
    List<Player> selectedAR = _selectedPlayers.where((p) => _isAllRounder(p)).toList();
    List<Player> selectedBOWL = _selectedPlayers.where((p) => _isBowler(p)).toList();

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1E3A8A), Color(0xFF0F172A)],
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Color(0xFF000000).withOpacity(0.3), Colors.transparent]),
            ),
            child: Row(
              children: [
                Icon(Icons.visibility, color: Colors.white, size: 24),
                SizedBox(width: 8),
                Text("TEAM PREVIEW", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("Credits Left", style: TextStyle(color: Colors.white70, fontSize: 12)),
                    Text("${_creditsLeft.toStringAsFixed(0)}", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [teamAColor, teamAColor.withOpacity(0.7)]),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(widget.fixture.teamAShort, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                ),
                SizedBox(width: 12),
                Text(
                  "${_selectedPlayers.where((p) => p.teamId == widget.fixture.teamAId).length} : ${_selectedPlayers.where((p) => p.teamId == widget.fixture.teamBId).length}",
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 12),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [teamBColor, teamBColor.withOpacity(0.7)]),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(widget.fixture.teamBShort, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 40),
                  if (selectedWK.isNotEmpty) ...[
                    _buildPositionHeader("WICKET-KEEPERS", selectedWK.length),
                    SizedBox(height: 20),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 20,
                      runSpacing: 20,
                      children: selectedWK.map((player) => _buildFieldPlayer(player)).toList(),
                    ),
                    SizedBox(height: 40),
                  ],
                  if (selectedBAT.isNotEmpty) ...[
                    _buildPositionHeader("BATTERS", selectedBAT.length),
                    SizedBox(height: 20),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 20,
                      runSpacing: 20,
                      children: selectedBAT.map((player) => _buildFieldPlayer(player)).toList(),
                    ),
                    SizedBox(height: 40),
                  ],
                  if (selectedAR.isNotEmpty) ...[
                    _buildPositionHeader("ALL-ROUNDERS", selectedAR.length),
                    SizedBox(height: 20),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 20,
                      runSpacing: 20,
                      children: selectedAR.map((player) => _buildFieldPlayer(player)).toList(),
                    ),
                    SizedBox(height: 40),
                  ],
                  if (selectedBOWL.isNotEmpty) ...[
                    _buildPositionHeader("BOWLERS", selectedBOWL.length),
                    SizedBox(height: 20),
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
        gradient: LinearGradient(
          colors: [Colors.white.withOpacity(0.2), Colors.white.withOpacity(0.15)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text("$title ($count)", style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
    );
  }

  Widget _buildFieldPlayer(Player player) {
    Color teamColor = player.teamId == widget.fixture.teamAId ? teamAColor : teamBColor;
    String lastName = (player.playerName ?? "Unknown").split(' ').last;
    if (lastName.length > 8) {
      lastName = lastName.substring(0, 7) + ".";
    }
    bool isUnannounced = player.isAnnounced != true;

    return Container(
      width: 75,
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [teamColor, teamColor.withOpacity(0.6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(
                    color: isUnannounced ? Colors.orange : Colors.white,
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: (isUnannounced ? Colors.orange : teamColor).withOpacity(0.5),
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    )
                  ],
                ),
                child: Center(
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
              if (_captain == player)
                Positioned(
                  top: -8,
                  right: -8,
                  child: Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [accentColor, Color(0xFFF97316)]),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 4)],
                    ),
                    child: Center(
                      child: Text(
                        "C",
                        style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              if (_viceCaptain == player)
                Positioned(
                  top: -8,
                  right: -8,
                  child: Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [primaryColor, Color(0xFF1D4ED8)]),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 4)],
                    ),
                    child: Center(
                      child: Text(
                        "VC",
                        style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            lastName,
            style: TextStyle(
              color: isUnannounced ? Colors.orange : Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              shadows: [Shadow(color: Colors.black.withOpacity(0.7), blurRadius: 4)],
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 2),
          Text(
            "${player.credits ?? 0.0} Cr",
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 10,
              shadows: [Shadow(color: Colors.black.withOpacity(0.7), blurRadius: 4)],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCaptainSelection() {
    return Container(
      color: backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _isCopyMode
                    ? [primaryColor, Color(0xFF1D4ED8)]
                    : _isEditMode
                    ? [accentColor, Color(0xFFF97316)]
                    : [primaryColor, secondaryColor],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.3),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.stars, color: Colors.white, size: 28),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _isCopyMode ? "Choose New Leaders" : "Choose Captain & Vice Captain",
                        style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  "Captain gets 2x points • Vice Captain gets 1.5x points",
                  style: TextStyle(color: Colors.white.withOpacity(0.95), fontSize: 14),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: _selectedPlayers.length,
              separatorBuilder: (context, index) => SizedBox(height: 12),
              itemBuilder: (context, index) {
                Player player = _selectedPlayers[index];
                String teamShort = player.teamId == widget.fixture.teamAId ? widget.fixture.teamAShort : widget.fixture.teamBShort;
                Color teamColor = player.teamId == widget.fixture.teamAId ? teamAColor : teamBColor;
                bool isLeader = _captain == player || _viceCaptain == player;
                bool isUnannounced = player.isAnnounced != true;

                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isLeader ? primaryColor : Colors.grey[200]!,
                      width: isLeader ? 2 : 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isLeader
                            ? primaryColor.withOpacity(0.2)
                            : Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [teamColor.withOpacity(0.2), teamColor.withOpacity(0.1)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isUnannounced ? accentColor : teamColor,
                              width: 2.5,
                            ),
                          ),
                          child: Icon(Icons.person, color: teamColor, size: 26),
                        ),
                        SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                player.playerName ?? "Unknown",
                                style: TextStyle(
                                  color: isUnannounced ? accentColor : Colors.black87,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 6),
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: teamColor.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      "${_getPlayerPosition(player)}",
                                      style: TextStyle(
                                        color: teamColor,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 6),
                                  Text("$teamShort", style: TextStyle(color: Colors.black54, fontSize: 12)),
                                  SizedBox(width: 8),
                                  Icon(Icons.star, color: accentColor, size: 12),
                                  SizedBox(width: 2),
                                  Text("${player.points ?? 0}", style: TextStyle(color: Colors.black54, fontSize: 12)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => _setCaptain(player),
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                decoration: BoxDecoration(
                                  gradient: _captain == player
                                      ? LinearGradient(colors: [accentColor, Color(0xFFF97316)])
                                      : null,
                                  color: _captain != player ? Colors.transparent : null,
                                  border: Border.all(
                                    color: _captain == player ? Colors.transparent : accentColor,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  "C",
                                  style: TextStyle(
                                    color: _captain == player ? Colors.white : accentColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            GestureDetector(
                              onTap: () => _setViceCaptain(player),
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                decoration: BoxDecoration(
                                  gradient: _viceCaptain == player
                                      ? LinearGradient(colors: [primaryColor, Color(0xFF1D4ED8)])
                                      : null,
                                  color: _viceCaptain != player ? Colors.transparent : null,
                                  border: Border.all(
                                    color: _viceCaptain == player ? Colors.transparent : primaryColor,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  "VC",
                                  style: TextStyle(
                                    color: _viceCaptain == player ? Colors.white : primaryColor,
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
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF667eea),
            Color(0xFF764ba2),
            Color(0xFFF093fb),
          ],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.white.withOpacity(0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            left: -80,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.white.withOpacity(0.08),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 160,
                        height: 160,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.3),
                              blurRadius: 40,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.white.withOpacity(0.3),
                                  Colors.white.withOpacity(0.1),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(60),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 20,
                                  offset: Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.check_circle_rounded,
                              color: Colors.white,
                              size: 70,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 36),
                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [Colors.white, Colors.white.withOpacity(0.9)],
                    ).createShader(bounds),
                    child: Text(
                      _isEditMode ? "Team Updated!" : _isCopyMode ? "Team Copied!" : "Team Created!",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.3),
                            offset: Offset(0, 4),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    _isEditMode
                        ? "Your changes have been saved successfully"
                        : _isCopyMode
                        ? "Your new team is ready to compete"
                        : "Your team has been saved successfully",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.3,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 48),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: Container(
                        padding: EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withOpacity(0.25),
                              Colors.white.withOpacity(0.1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            if (_captain != null)
                              _buildPlayerRow(
                                "C",
                                "Captain",
                                _captain!.playerName ?? 'Unknown',
                                [Color(0xFFf093fb), Color(0xFFf5576c)],
                              ),
                            if (_captain != null && _viceCaptain != null)
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                child: Container(
                                  height: 1,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.transparent,
                                        Colors.white.withOpacity(0.3),
                                        Colors.transparent,
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            if (_viceCaptain != null)
                              _buildPlayerRow(
                                "VC",
                                "Vice Captain",
                                _viceCaptain!.playerName ?? 'Unknown',
                                [Color(0xFF4facfe), Color(0xFF00f2fe)],
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 48),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        width: double.infinity,
                        height: 64,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withOpacity(0.4),
                              Colors.white.withOpacity(0.2),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.4),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () => Navigator.pop(context, true),
                            splashColor: Colors.white.withOpacity(0.2),
                            highlightColor: Colors.white.withOpacity(0.1),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    _isEditMode ? "Go Back" : _isCopyMode ? "View New Team" : "Go to Contests",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black.withOpacity(0.3),
                                          offset: Offset(0, 2),
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Icon(
                                    Icons.arrow_forward_rounded,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerRow(String badge, String role, String name, List<Color> gradientColors) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: gradientColors,
                ),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: gradientColors[0].withOpacity(0.4),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  badge,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                role,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.8,
                  height: 1.2,
                ),
              ),
              SizedBox(height: 4),
              Text(
                name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
        Icon(
          Icons.star_rounded,
          color: Colors.amber.withOpacity(0.8),
          size: 28,
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    bool isValid = _selectedPlayers.length == 11 && _validateTeamComposition();

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: Offset(0, -2))],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: _buildBottomButton(isValid, true),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _buildBottomButton(isValid, false),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButton(bool isValid, bool isPreview) {
    String buttonText = "";
    Color buttonColor = Colors.grey;
    VoidCallback? onPressed;

    if (_currentView == 0) {
      if (isPreview) {
        buttonText = "TEAM PREVIEW";
        buttonColor = backgroundColor;
        onPressed = isValid ? () => setState(() => _currentView = 1) : null;
      } else {
        buttonText = "CONTINUE";
        buttonColor = isValid ? secondaryColor : Colors.grey[300]!;
        onPressed = isValid ? () => setState(() => _currentView = 2) : null;
      }
    } else if (_currentView == 1) {
      if (isPreview) {
        buttonText = "EDIT TEAM";
        buttonColor = backgroundColor;
        onPressed = () => setState(() => _currentView = 0);
      } else {
        buttonText = "CONTINUE";
        buttonColor = secondaryColor;
        onPressed = () => setState(() => _currentView = 2);
      }
    } else if (_currentView == 2) {
      if (isPreview) {
        buttonText = "PREVIEW";
        buttonColor = backgroundColor;
        onPressed = () => setState(() => _currentView = 1);
      } else {
        bool canSave = _captain != null && _viceCaptain != null;
        buttonText = _isEditMode ? "UPDATE TEAM" : _isCopyMode ? "SAVE COPY" : "SAVE TEAM";
        buttonColor = canSave ? primaryColor : Colors.grey[300]!;
        onPressed = canSave ? _createTeam : null;
      }
    }

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        foregroundColor: isPreview ? Colors.black87 : Colors.white,
        elevation: 0,
        padding: EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        disabledBackgroundColor: Colors.grey[300],
        disabledForegroundColor: Colors.grey[500],
      ),
      child: Text(
        buttonText,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    _blinkController.dispose();
    super.dispose();
  }
}