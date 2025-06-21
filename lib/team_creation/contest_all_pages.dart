import 'package:flutter/material.dart';

import '../body/wallet.dart';
import 'creat team.dart';

class FantasyCricketPage extends StatefulWidget {
  @override
  _FantasyCricketPageState createState() => _FantasyCricketPageState();
}

class _FantasyCricketPageState extends State<FantasyCricketPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedTabIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
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
                  Icon(Icons.account_balance_wallet, color: Colors.white, size: 16),
                  SizedBox(width: 6),
                  Text('₹0', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
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
                Tab(text: 'Teams'),
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
                _buildTeamsTab(),
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
                    Text('CONTESTS', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateTeamPage(),
                    ),
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
                    Text('CREATE TEAM', style: TextStyle(fontWeight: FontWeight.bold)),
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
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
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
          Icon(
            Icons.sports_cricket,
            size: 80,
            color: Colors.grey[400],
          ),
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
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
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

  Widget _buildTeamsTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "You haven't created a team yet!",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'The first step to winning starts here.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateTeamPage(),
                ),
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
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add, size: 20),
                SizedBox(width: 8),
                Text(
                  'CREATE A TEAM',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
                child: Text('SSM', style: TextStyle(color: Colors.white, fontSize: 12)),
              ),
              Spacer(),
              CircleAvatar(
                backgroundColor: Colors.purple,
                radius: 20,
                child: Text('AHW', style: TextStyle(color: Colors.white, fontSize: 12)),
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
                  'View recent matches',
                  style: TextStyle(
                    color: Colors.green[700],
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Spacer(),
                Icon(Icons.arrow_forward_ios,
                    color: Colors.green[700], size: 16),
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
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
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
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Avg. Runs',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
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
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
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
                        Container(
                          width: 20,
                          height: 4,
                          color: Colors.orange,
                        ),
                        SizedBox(width: 4),
                        Text('By Pacers 28', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          width: 15,
                          height: 4,
                          color: Colors.yellow,
                        ),
                        SizedBox(width: 4),
                        Text('By Spinners 15', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 24),

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
                Icon(Icons.arrow_forward_ios,
                    color: Colors.green[700], size: 16),
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
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Matches\nPlayed',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      '1',
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
                  children: [
                    Row(
                      children: [
                        Text('SSM Won', style: TextStyle(fontSize: 14)),
                        Spacer(),
                        Text('1', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 4),
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    Row(
                      children: [
                        Text('AHW Won', style: TextStyle(fontSize: 14)),
                        Spacer(),
                        Text('0', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 4),
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        borderRadius: BorderRadius.circular(2),
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

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? Color(0xFF8B1538) : Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
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
    required String discountedEntry,
    required String spotsLeft,
    required String totalSpots,
    required String firstPrize,
    required String winnersPercent,
    String? maxTeams,
    bool guaranteed = false,
    bool isGuaranteedPrize = false,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              if (guaranteed) ...[
                Icon(Icons.verified, color: Colors.green, size: 16),
                SizedBox(width: 4),
                Text(
                  'Guaranteed ',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
              if (isGuaranteedPrize)
                Text(
                  'Prize Pool',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    entry,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Color(0xFF22C55E),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      discountedEntry,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Text(
                prizePool,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Text(
                spotsLeft,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Spacer(),
              Text(
                totalSpots,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Container(
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(2),
            ),
            child: FractionallySizedBox(
              widthFactor: 0.9,
              alignment: Alignment.centerLeft,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.emoji_events, color: Colors.orange, size: 16),
              SizedBox(width: 4),
              Text(
                firstPrize,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 16),
              Icon(Icons.people, color: Colors.green, size: 16),
              SizedBox(width: 4),
              Text(
                winnersPercent,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (maxTeams != null) ...[
                SizedBox(width: 16),
                Icon(Icons.person, color: Colors.blue, size: 16),
                SizedBox(width: 4),
                Text(
                  maxTeams,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
              Spacer(),
              Text(
                '₹44 Lakhs',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              Icon(Icons.keyboard_arrow_down, color: Colors.grey[600], size: 16),
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
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
          children: [
      Row(
      children: [
      Icon(Icons.trending_up, color: Colors.grey[600], size: 16),
      SizedBox(width: 4),
      Text(
        'Flexible Prize Pool',
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
      Spacer(),
      Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Color(0xFF22C55E),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          entry,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
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
    prizePool,
    style: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.black87,
    ),
    ),
    ],
    ),
    SizedBox(height: 8),
    Row(
    children: [
    Text(
    spotsLeft,
    style: TextStyle(
    color: Colors.red,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    ),
    ),
    Spacer(),
    Text(
    totalSpots,
    style: TextStyle(
    color: Colors.grey[600],
    fontSize: 12,
    ),
    ),
    ],
    ),
    SizedBox(height: 12),
    Row(
    children: [
    Icon(Icons.emoji_events, color: Colors.orange, size: 16),
    SizedBox(width: 4),
      Row(
        children: [
          Text(
            firstPrize,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: 16),
          Icon(Icons.people, color: Colors.green, size: 16),
          SizedBox(width: 4),
          Text(
            winnersPercent,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),

      if (maxTeams != null) ...[
        SizedBox(width: 16),
        Icon(Icons.person, color: Colors.blue, size: 16),
        SizedBox(width: 4),
        Text(
          maxTeams,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
      if (entryType != null) ...[
        SizedBox(width: 16),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            entryType,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
        ),
      ],
      Spacer(),
      Icon(Icons.keyboard_arrow_down, color: Colors.grey[600], size: 16),
    ],
    ),
          ],
      ),
    );
  }

  Widget _buildFormBadge(String label, Color color) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildVenueStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
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