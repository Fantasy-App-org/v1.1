import 'package:flutter/material.dart';

import '../wallet/wallet.dart';
import 'creat team.dart';

class FantasyCricketPage extends StatefulWidget {
  @override
  _FantasyCricketPageState createState() => _FantasyCricketPageState();
}

class _FantasyCricketPageState extends State<FantasyCricketPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTabIndex = 0;

  // Empty saved teams list - will show empty state initially
  List<Map<String, dynamic>> savedTeams = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedTabIndex = _tabController.index;
      });
    });

    // Load saved teams from storage if available
    _loadSavedTeams();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Method to load saved teams (implement your storage logic here)
  void _loadSavedTeams() {
    // TODO: Implement loading from SharedPreferences or local database
    // For now, keeping empty to show only actual saved teams
  }

  // Method to save teams to storage
  void _saveTeamsToStorage() {
    // TODO: Implement saving to SharedPreferences or local database
  }

  // Method to add a new team when created
  void addNewTeam(Map<String, dynamic> newTeam) {
    setState(() {
      savedTeams.add({
        'name': newTeam['name'] ?? 'My Team ${savedTeams.length + 1}',
        'captain': newTeam['captain'] ?? 'Player Name',
        'viceCaptain': newTeam['viceCaptain'] ?? 'Player Name',
        'points': newTeam['points'] ?? 0,
        'players': newTeam['players'] ?? 11,
        'createdAt': 'Just now',
        'teamData': newTeam, // Store full team data for future use
      });
    });
    _saveTeamsToStorage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Color(0xFF16213E),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'SSM v AHW',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '26m 17s left',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const WalletScreen()),
              );
            },
            child: Container(
              margin: EdgeInsets.only(right: 16),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white30, width: 1),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.account_balance_wallet,
                    color: Colors.white,
                    size: 16,
                  ),
                  SizedBox(width: 6),
                  Text(
                    '₹0',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 8),
                  Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.white30,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Icon(Icons.add, color: Colors.white, size: 14),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: Color(0xFF3730A3),
              unselectedLabelColor: Colors.grey[600],
              indicatorColor: Color(0xFF3730A3),
              indicatorWeight: 3,
              labelStyle: TextStyle(fontWeight: FontWeight.bold),
              tabs: [
                Tab(text: 'Contests'),
                Tab(text: 'My Contests'),
                Tab(text: 'My Teams'),
                Tab(text: 'Stats'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildContestsTab(),
                _buildMyContestsTab(),
                _buildMyTeamsTab(),
                _buildStatsTab(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: Color(0xFF1a1a1a),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[800],
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.emoji_events, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'CONTESTS',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  // Navigate to team builder and wait for result
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Dream11TeamBuilder(
                      onTeamSaved: (Map<String, dynamic> teamData) {
                        addNewTeam(teamData);
                      },
                    )),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF22C55E),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'CREATE TEAM',
                      style: TextStyle(fontWeight: FontWeight.bold),
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

  Widget _buildContestsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter Row
          Row(
            children: [
              _buildFilterChip('OFF', true),
              SizedBox(width: 8),
              _buildFilterChip('Entry', false),
              SizedBox(width: 8),
              _buildFilterChip('Spots', false),
              SizedBox(width: 8),
              _buildFilterChip('Prize Pool', false),
              SizedBox(width: 8),
              _buildFilterChip('%Winners', false),
              Spacer(),
              Icon(Icons.filter_list, color: Colors.grey[600]),
            ],
          ),
          SizedBox(height: 16),

          // Discounted Entry Section
          Text(
            'Discounted Entry',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Text(
            'Up to ₹20.0 can be utilised for the contests below',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
          Container(
            margin: EdgeInsets.only(top: 4, bottom: 16),
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'DISCOUNT',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Contest Cards
          _buildContestCard(
            prizePool: '₹27.50 Lakhs',
            entry: '₹49',
            discountedEntry: '₹29',
            spotsLeft: '68,080 Left',
            totalSpots: '77,947 Spots',
            firstPrize: '₹3L',
            winnersPercent: '58%',
            maxTeams: '20',
            guaranteed: true,
            isGuaranteedPrize: true,
          ),

          SizedBox(height: 16),

          _buildContestCard(
            prizePool: '₹2 Lakhs',
            entry: '₹39',
            discountedEntry: '₹19',
            spotsLeft: '5,824 Left',
            totalSpots: '6,837 Spots',
            firstPrize: '₹9,500',
            winnersPercent: '60%',
            maxTeams: 'Upto 11',
            guaranteed: true,
            isGuaranteedPrize: true,
          ),

          SizedBox(height: 24),

          // Multiplier Contests
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Multiplier Contests',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'View All',
                  style: TextStyle(
                    color: Color(0xFF8B1538),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          _buildMultiplierCard(
            prizePool: '₹1.50 Lakhs',
            entry: '₹25,000',
            spotsLeft: '7 Left',
            totalSpots: '7 Spots',
            firstPrize: '₹75,000',
            winnersPercent: '29%',
            entryType: 'S',
          ),

          SizedBox(height: 16),

          _buildMultiplierCard(
            prizePool: '₹1.26 Lakhs',
            entry: '₹75',
            spotsLeft: '1,940 Left',
            totalSpots: '2,000 Spots',
            firstPrize: '₹300',
            winnersPercent: '41%',
            maxTeams: 'Upto 11',
          ),
        ],
      ),
    );
  }

  Widget _buildMyContestsTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.sports_cricket, size: 80, color: Colors.grey[400]),
          SizedBox(height: 16),
          Text(
            "You haven't joined a contest yet!",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Find a contest to join and start winning',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF22C55E),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'JOIN A CONTEST',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // My Teams Tab - Shows only saved teams
  Widget _buildMyTeamsTab() {
    return Container(
      color: Colors.white,
      child: savedTeams.isEmpty
          ? _buildEmptyTeamsState()
          : ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: savedTeams.length,
        itemBuilder: (context, index) {
          return _buildTeamCard(savedTeams[index], index);
        },
      ),
    );
  }

  Widget _buildEmptyTeamsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.group_add, size: 80, color: Colors.grey[400]),
          SizedBox(height: 16),
          Text(
            "No teams created yet!",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Create your first team to get started',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () async {
              // Navigate to team builder and wait for result
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Dream11TeamBuilder(
                  onTeamSaved: (Map<String, dynamic> teamData) {
                    addNewTeam(teamData);
                  },
                )),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF22C55E),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'CREATE TEAM',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamCard(Map<String, dynamic> team, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                team['name'],
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () => _editTeam(index),
                    icon: Icon(Icons.edit, color: Color(0xFF3730A3)),
                    iconSize: 20,
                  ),
                  IconButton(
                    onPressed: () => _deleteTeam(index),
                    icon: Icon(Icons.delete, color: Colors.red),
                    iconSize: 20,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Captain',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'C',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            team['captain'],
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Vice Captain',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'VC',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            team['viceCaptain'],
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Points',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '${team['points']}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Players',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '${team['players']}/11',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Created',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    SizedBox(height: 4),
                    Text(
                      team['createdAt'],
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _viewTeam(index),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF3730A3),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'VIEW TEAM',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _cloneTeam(index),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Color(0xFF3730A3),
                    padding: EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: Color(0xFF3730A3)),
                    ),
                  ),
                  child: Text(
                    'CLONE TEAM',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Team action methods
  void _editTeam(int index) {
    final existing = savedTeams[index]['teamData'] as Map<String, dynamic>?;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Dream11TeamBuilder(
          initialTeam: existing, // <-- prefill
          onTeamSaved: (Map<String, dynamic> updated) {
            // write changes back into the list
            setState(() {
              savedTeams[index] = {
                'name': updated['name'] ?? savedTeams[index]['name'],
                'captain': updated['captain'],
                'viceCaptain': updated['viceCaptain'],
                'points': updated['points'] ?? 0,
                'players': updated['players'] ?? 11,
                'createdAt': 'Just now',
                'teamData': updated, // store the full updated team
              };
            });
            _saveTeamsToStorage();
          },
        ),
      ),
    );
  }


  void _deleteTeam(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Team'),
          content: Text(
            'Are you sure you want to delete ${savedTeams[index]['name']}?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  savedTeams.removeAt(index);
                });
                _saveTeamsToStorage(); // Save after deletion
                Navigator.pop(context);
              },
              child: Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _viewTeam(int index) {
    final team = savedTeams[index]['teamData'] as Map<String, dynamic>?;
    if (team == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TeamViewPage(team: team),
      ),
    );
  }

  void _cloneTeam(int index) {
    // Clone team logic
    setState(() {
      Map<String, dynamic> clonedTeam = Map.from(savedTeams[index]);
      clonedTeam['name'] = '${clonedTeam['name']} (Copy)';
      clonedTeam['createdAt'] = 'Just now';
      clonedTeam['points'] = 0; // Reset points for cloned team
      savedTeams.add(clonedTeam);
    });
    _saveTeamsToStorage(); // Save after cloning
  }

  Widget _buildStatsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Team Header
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Color(0xFF8B1538),
                radius: 20,
                child: Text(
                  'SSM',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
              Spacer(),
              CircleAvatar(
                backgroundColor: Colors.purple,
                radius: 20,
                child: Text(
                  'AHW',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),

          // Recent Form
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    _buildFormBadge('W', Colors.green),
                    SizedBox(width: 4),
                    _buildFormBadge('W', Colors.green),
                    SizedBox(width: 4),
                    _buildFormBadge('L', Colors.red),
                    SizedBox(width: 4),
                    _buildFormBadge('A', Colors.grey),
                    SizedBox(width: 4),
                    _buildFormBadge('W', Colors.green),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildFormBadge('A', Colors.grey),
                    SizedBox(width: 4),
                    _buildFormBadge('W', Colors.green),
                    SizedBox(width: 4),
                    _buildFormBadge('L', Colors.red),
                    SizedBox(width: 4),
                    _buildFormBadge('W', Colors.green),
                    SizedBox(width: 4),
                    _buildFormBadge('W', Colors.green),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'Most recent matches from left to right',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
          SizedBox(height: 16),

          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Text(
                  'View more',
                  style: TextStyle(
                    color: Colors.green[700],
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Spacer(),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.green[700],
                  size: 16,
                ),
              ],
            ),
          ),

          SizedBox(height: 24),

          // Head to Head
          Text(
            'Head To Head',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Text(
            'Results in Last 5 Years - T20 Domestic',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SSM Wins',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    Text(
                      '3',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF8B1538),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey[300]!, width: 2),
                ),
                child: Center(
                  child: Text(
                    'VS',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'AHW Wins',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    Text(
                      '2',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 16),

          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Text(
                  'View detailed head to head',
                  style: TextStyle(
                    color: Colors.green[700],
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Spacer(),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.green[700],
                  size: 16,
                ),
              ],
            ),
          ),

          SizedBox(height: 24),

          // Recent Record
          Text(
            'Recent Record',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Text(
            'In Last 5 - T20s',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          SizedBox(height: 16),

          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Text(
                  'View recent matches',
                  style: TextStyle(
                    color: Colors.green[700],
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Spacer(),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.green[700],
                  size: 16,
                ),
              ],
            ),
          ),

          SizedBox(height: 24),

          // Venue Stats
          Text(
            'Venue Stats',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Text(
            'Eden Gardens, Kolkata\n(Kolkata, India)',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _buildVenueStatCard(
                  'Pitch',
                  'Balanced',
                  Icons.sports_cricket,
                  Colors.orange,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildVenueStatCard(
                  'Good for',
                  'Pacers',
                  Icons.speed,
                  Colors.red,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildVenueStatCard(
                  'Weather',
                  'Rainy',
                  Icons.cloud,
                  Colors.blue,
                ),
              ),
            ],
          ),

          SizedBox(height: 24),

          // Recent Record Stats
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Avg. Runs',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    Text(
                      '147',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Wickets',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    Text(
                      '43',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Container(width: 20, height: 4, color: Colors.orange),
                        SizedBox(width: 4),
                        Text('By Pacers 28', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Container(width: 15, height: 4, color: Colors.yellow),
                        SizedBox(width: 4),
                        Text('By Spinners 15', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? Color(0xFF3730A3) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? Color(0xFF3730A3) : Colors.grey[300]!,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.grey[700],
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildContestCard({
    required String prizePool,
    required String entry,
    String? discountedEntry,
    required String spotsLeft,
    required String totalSpots,
    required String firstPrize,
    required String winnersPercent,
    String? maxTeams,
    bool guaranteed = false,
    bool isGuaranteedPrize = false,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                prizePool,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              if (guaranteed)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'GUARANTEED',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              if (discountedEntry != null) ...[
                Text(
                  discountedEntry,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  entry,
                  style: TextStyle(
                    fontSize: 14,
                    decoration: TextDecoration.lineThrough,
                    color: Colors.grey[600],
                  ),
                ),
              ] else ...[
                Text(
                  entry,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
              Spacer(),
              Text(
                spotsLeft,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.orange,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          Text(
            totalSpots,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'First Prize',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    Text(
                      firstPrize,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Winners',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    Text(
                      winnersPercent,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              if (maxTeams != null)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Max Teams',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      Text(
                        maxTeams,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMultiplierCard({
    required String prizePool,
    required String entry,
    required String spotsLeft,
    required String totalSpots,
    required String firstPrize,
    required String winnersPercent,
    String? maxTeams,
    String? entryType,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                prizePool,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              if (entryType == 'S')
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'SINGLE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Text(
                entry,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Spacer(),
              Text(
                spotsLeft,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.orange,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          Text(
            totalSpots,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'First Prize',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    Text(
                      firstPrize,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Winners',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    Text(
                      winnersPercent,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              if (maxTeams != null)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Max Teams',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      Text(
                        maxTeams,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFormBadge(String label, Color color) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildVenueStatCard(
      String title,
      String value,
      IconData icon,
      Color color,
      ) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          SizedBox(height: 8),
          Text(title, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
class TeamViewPage extends StatelessWidget {
  final Map<String, dynamic> team;
  const TeamViewPage({Key? key, required this.team}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final players = (team['selectedPlayers'] as List).cast<Map<String, dynamic>>();

    List<Map<String, dynamic>> ofPos(String pos) =>
        players.where((m) => m['position'] == pos).toList();

    Widget group(String title, List<Map<String, dynamic>> list) {
      if (list.isEmpty) return const SizedBox.shrink();
      return Container(
        margin: const EdgeInsets.only(top: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$title (${list.length})', style: const TextStyle(fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            ...list.map((m) {
              final isC = m['isCaptain'] == true;
              final isVC = m['isViceCaptain'] == true;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: _teamClr(m['team'] as String),
                      child: Text(
                        _initials(m['name'] as String),
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 11),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text('${m['name']}  •  ${m['team']}',
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    ),
                    if (isVC)
                      _roleChip('VC', Colors.blue),
                    if (isC) ...[
                      const SizedBox(width: 6),
                      _roleChip('C', Colors.green),
                    ],
                    const SizedBox(width: 8),
                    Text('${m['credits']} Cr', style: const TextStyle(color: Colors.black54)),
                  ],
                ),
              );
            }),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(team['name'] ?? 'Team'),
        backgroundColor: const Color(0xFF111827),
      ),
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // quick header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Captain', style: TextStyle(color: Colors.black54, fontSize: 12)),
                        Text(team['captain'] ?? '-', style: const TextStyle(fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Vice-Captain', style: TextStyle(color: Colors.black54, fontSize: 12)),
                        Text(team['viceCaptain'] ?? '-', style: const TextStyle(fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text('Credits Used', style: TextStyle(color: Colors.black54, fontSize: 12)),
                      Text(
                        ((team['totalCreditsUsed'] ?? 0) as num).toStringAsFixed(1),
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // groups
            group('WICKET-KEEPERS', ofPos('WK')),
            group('BATTERS', ofPos('BAT')),
            group('ALL-ROUNDERS', ofPos('AR')),
            group('BOWLERS', ofPos('BOWL')),
          ],
        ),
      ),
    );
  }

  static String _initials(String name) =>
      name.split(' ').where((e) => e.isNotEmpty).map((e) => e[0]).take(2).join().toUpperCase();

  static Color _teamClr(String t) {
    switch (t) {
      case 'CSK': return const Color(0xFFFFD700);
      case 'MI':  return const Color(0xFF004BA0);
      case 'RCB': return const Color(0xFFD32F2F);
      case 'DC':  return const Color(0xFF282968);
      case 'KKR': return const Color(0xFF3A225D);
      case 'GT':  return const Color(0xFF1B2951);
      case 'LSG': return const Color(0xFF00A8CC);
      case 'RR':  return const Color(0xFFEA1A85);
      case 'PBKS':return const Color(0xFFDD1F2D);
      default:    return Colors.grey;
    }
  }

  static Widget _roleChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }
}
