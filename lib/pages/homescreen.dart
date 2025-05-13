import 'package:flutter/material.dart';
import 'package:fantasy/pages/login.dart';
import 'package:fantasy/pages/mygame.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  int _selectedSportIndex = 3; // 0: Cricket, 1: Football, 2: Basketball, 3: Baseball (default selected)
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<String> _sports = [
    'Cricket',
    'Football',
    'Basketball',
    'Baseball',
  ];

  final List<IconData> _sportsIcons = [
    Icons.sports_cricket,
    Icons.sports_soccer,
    Icons.sports_basketball,
    Icons.sports_baseball,
  ];

  // Tab controller for My Games screen
  TabController? _tabController;
  int _myGamesTabIndex = 0;

  @override
  void initState() {
    super.initState();
    // Initialize tab controller for My Games screen
    _tabController = TabController(length: 3, vsync: this);
    _tabController!.addListener(() {
      setState(() {
        _myGamesTabIndex = _tabController!.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get device dimensions for responsive design
    final Size screenSize = MediaQuery.of(context).size;
    final double screenHeight = screenSize.height;
    final double screenWidth = screenSize.width;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white, // White background
      // Keep the AppBar
      appBar: AppBar(
        backgroundColor: Colors.black, // Black app bar
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Colors.grey[300],
              child: const Icon(Icons.person, color: Colors.grey),
            ),
          ),
        ),
        title: Row(
          children: [
            Image.asset(
              'assets/images/dream11_logo.png',
              height: 24,
              errorBuilder: (context, error, stackTrace) {
                return const Row(
                  children: [
                    Icon(Icons.emoji_events, color: Colors.white, size: 20),
                    SizedBox(width: 4),
                    Text(
                      'DREAM11',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
        actions: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {},
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      '4',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.chat_outlined),
            onPressed: () {},
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildHomeScreen(screenHeight, screenWidth),
          MyMatchesScreen(),
          _buildRewardsScreen(),
          ReferralScreen(),
          _buildGamesScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events),
            label: 'My Matches',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard),
            label: 'Rewards',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Refer & Win',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view),
            label: 'Games',
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: const Color( 0xFFF5F5F5),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 150,
            child: DrawerHeader(
              decoration: const BoxDecoration(
                color: Color( 0xFFF5F5F5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: Color(0xFF90CAF9),
                        radius: 25,
                        child: Icon(Icons.person, color: Color(0xFF1A1D48), size: 30),
                      ),
                      const SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'pll3mu1',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'View Profile',
                            style: TextStyle(
                              color: Color(0xFF4ADE80),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.chevron_right, color: Colors.white),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2F59),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                _buildMenuItem(
                  icon: Icons.group_add,
                  color: const Color(0xFFFFC0CB),
                  title: 'Refer Friends',
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ReferralScreen(),
                    ));
                  },
                ),
                _buildMenuDivider(),
                _buildMenuItem(
                  icon: Icons.person,
                  color: const Color(0xFFD8B4FE),
                  title: 'Update Profile',
                  onTap: () {},
                ),
                _buildMenuDivider(),
                _buildMenuItem(
                  icon: Icons.account_balance_wallet,
                  color: const Color(0xFFFFC0CB),
                  title: 'My Transactions',
                  onTap: () {},
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2F59),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                _buildMenuItem(
                  icon: Icons.leaderboard,
                  color: const Color(0xFFFFD700),
                  title: 'Fantasy Point System',
                  onTap: () {},
                ),
                _buildMenuDivider(),
                _buildMenuItem(
                  icon: Icons.videogame_asset,
                  color: const Color(0xFFFFC0CB),
                  title: 'How to Play',
                  onTap: () {},
                ),
                _buildMenuDivider(),
                _buildMenuItem(
                  icon: Icons.info,
                  color: const Color(0xFFFFC0CB),
                  title: 'About Us',
                  onTap: () {},
                ),
                _buildMenuDivider(),
                _buildMenuItem(
                  icon: Icons.gavel,
                  color: const Color(0xFFD8B4FE),
                  title: 'Legality',
                  onTap: () {},
                ),
                _buildMenuDivider(),
                _buildMenuItem(
                  icon: Icons.help,
                  color: const Color(0xFFFFC0CB),
                  title: 'FAQ',
                  onTap: () {},
                ),
                _buildMenuDivider(),
                _buildMenuItem(
                  icon: Icons.logout,
                  color: const Color(0xFF4ADE80),
                  title: 'Logout',
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const Dream11LoginPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required Color color,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 15,
              backgroundColor: color,
              child: Icon(
                icon,
                size: 16,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 15),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuDivider() {
    return const Divider(
      color: Color(0xFF3A3F69),
      height: 1,
    );
  }

  Widget _buildHomeScreen(double screenHeight, double screenWidth) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sports tabs with black background - starts right after the AppBar
          Container(
            color: Colors.black,
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _sports.length,
              itemBuilder: (context, index) {
                final bool isSelected = _selectedSportIndex == index;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedSportIndex = index;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: isSelected ? Colors.red : Colors.transparent,
                          width: 3,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _sportsIcons[index],
                          color: isSelected ? Colors.red : Colors.white,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _sports[index],
                          style: TextStyle(
                            color: isSelected ? Colors.red : Colors.white,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Starting Soon header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              'Starting Soon',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // Match cards - MLB 1
          _buildMatchCard(
            league: 'MLB',
            team1Logo: 'assets/images/team1.png',
            team1ShortName: 'MIT',
            team1FullName: 'Minnesota Twins',
            team1Color: Colors.purple[200],
            team2Logo: 'assets/images/team2.png',
            team2ShortName: 'BAO',
            team2FullName: 'Baltimore Orioles',
            team2Color: Colors.amber,
            timeLeft: '48m : 16s',
            additionalInfo: 'Lineups Out',
            prize: '₹1 Lakh +',
          ),

          // Match cards - MLB 2
          _buildMatchCard(
            league: 'MLB',
            team1Logo: 'assets/images/team3.png',
            team1ShortName: 'AD',
            team1FullName: 'Arizona Diamondbacks',
            team1Color: Colors.blue[300],
            team2Logo: 'assets/images/team4.png',
            team2ShortName: 'LAD',
            team2FullName: 'Los Angeles Dodgers',
            team2Color: Colors.green,
            timeLeft: '9h : 18m',
            additionalInfo: '7:10 AM',
            prize: '₹1 Lakh +',
          ),

          // Match cards - KBO
          _buildMatchCard(
            league: 'KBO',
            team1Logo: 'assets/images/team5.png',
            team1ShortName: 'KIH',
            team1FullName: 'Kiwoom Heroes',
            team1Color: Colors.blue,
            team2Logo: 'assets/images/team6.png',
            team2ShortName: 'HAE',
            team2FullName: 'Hanwha Eagles',
            team2Color: Colors.red,
            timeLeft: 'Tomorrow',
            additionalInfo: '3:00 PM',
            prize: '₹50,000 +',
          ),

          // Match cards - MLB 3
          _buildMatchCard(
            league: 'MLB',
            team1Logo: 'assets/images/team7.png',
            team1ShortName: 'OA',
            team1FullName: 'Oakland Athletics',
            team1Color: Colors.blue,
            team2Logo: 'assets/images/team8.png',
            team2ShortName: 'SM',
            team2FullName: 'Seattle Mariners',
            team2Color: Colors.yellow,
            timeLeft: '10 May',
            additionalInfo: '',
            prize: '₹20,000 +',
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildMatchCard({
    required String league,
    required String team1Logo,
    required String team1ShortName,
    required String team1FullName,
    required Color? team1Color,
    required String team2Logo,
    required String team2ShortName,
    required String team2FullName,
    required Color? team2Color,
    required String timeLeft,
    required String additionalInfo,
    required String prize,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // League header
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Text(
                  league,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Icon(Icons.chevron_right, size: 16),
                const Spacer(),
                // Bookmark icon
                const Icon(Icons.bookmark_outline, color: Colors.grey),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFF5F5F5)),

          // Teams and match info
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            child: Row(
              children: [
                // Team 1
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      // Logo
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.grey[200],
                        child: Image.asset(
                          team1Logo,
                          width: 30,
                          height: 30,
                          errorBuilder: (context, error, stackTrace) {
                            return CircleAvatar(
                              radius: 18,
                              backgroundColor: team1Color ?? Colors.grey[300],
                              child: Text(
                                team1ShortName.substring(0, 1),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Short name - bold
                      Text(
                        team1ShortName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 2),
                      // Full name - gray and smaller
                      SizedBox(
                        width: 80, // Fixed width to prevent overflow
                        child: Text(
                          team1FullName,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),

                // Match time info - center column
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        timeLeft,
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (additionalInfo.isNotEmpty)
                        const SizedBox(height: 4),
                      if (additionalInfo.isNotEmpty)
                        Text(
                          additionalInfo,
                          style: const TextStyle(
                            color: Colors.green,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                    ],
                  ),
                ),

                // Team 2
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      // Logo
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.grey[200],
                        child: Image.asset(
                          team2Logo,
                          width: 30,
                          height: 30,
                          errorBuilder: (context, error, stackTrace) {
                            return CircleAvatar(
                              radius: 18,
                              backgroundColor: team2Color ?? Colors.grey[300],
                              child: Text(
                                team2ShortName.substring(0, 1),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Short name - bold
                      Text(
                        team2ShortName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 2),
                      // Full name - gray and smaller
                      SizedBox(
                        width: 80, // Fixed width to prevent overflow
                        child: Text(
                          team2FullName,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, thickness: 1, color: Color(0xFFF5F5F5)),

          // Prize pool
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Row(
                  children: [
                    Icon(Icons.emoji_events, color: Colors.amber[700], size: 16),
                    const SizedBox(width: 4),
                    Text(
                      prize,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRewardsScreen() {
    return const Center(
      child: Text(
        'Rewards Screen',
        style: TextStyle(color: Colors.black87, fontSize: 24),
      ),
    );
  }

  Widget _buildReferAndWinScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Refer & Win Screen',
            style: TextStyle(color: Colors.black87, fontSize: 24),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const ReferralScreen(),
              ));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: const Text(
              'Invite Friends',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGamesScreen() {
    return const Center(
      child: Text(
        'Games Screen',
        style: TextStyle(color: Colors.black87, fontSize: 24),
      ),
    );
  }
}

// ReferralScreen class remains unchanged
class ReferralScreen extends StatelessWidget {
  const ReferralScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1D48),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1D48),
        elevation: 0,
        title: const Text('Invite Friends'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        Row(
        children: [
        Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Get Your Friends to signup',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Play & Win',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      // Referral image
      Container(
        width: 120,
        height: 100,
        child: Stack(
          children: [
            Positioned(
              right: 0,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.person, size: 50, color: Color(0xFF1A1D48)),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFF4ADE80),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.attach_money, size: 40, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      ],
    ),
    const SizedBox(height: 40),
    const Text(
    'Share Your Referral Code',
    style: TextStyle(
    color: Colors.white,
    fontSize: 16,
    ),
    ),
    const SizedBox(height: 12),
    Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
    const Text(
    'QBYWWIOKCW',
    style: TextStyle(
    color: Color(0xFF1A1D48),
    fontSize: 16,
    fontWeight: FontWeight.bold,
    ),
    ),
    IconButton(
    icon: const Icon(
    Icons.copy,
    color: Color(0xFF4ADE80),
    ),
    onPressed: () {
    // Copy to clipboard logic
    ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
    content: Text('Referral code copied to clipboard'),
    backgroundColor: Color(0xFF4ADE80),
    ),
    );
    },
    ),
    ],
    ),
    ),
    const SizedBox(height: 24),
    GestureDetector(
    onTap: () {
    // Share on WhatsApp logic
    },
    child: Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(vertical: 14),
    decoration: BoxDecoration(
    gradient: const LinearGradient(
    colors: [Color(0xFFB956D7), Color(0xFF8B3DB3)],
    ),
    borderRadius: BorderRadius.circular(25),
    ),
    child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: const [
    SizedBox(width: 10),
    Text(
    'SHARE ON WHATSAPP',
    style: TextStyle(
    color: Colors.white,
    fontSize: 16,
    fontWeight: FontWeight.bold,
    ),
    ),
    ],
    ),
    ),
    ),
    const SizedBox(height: 16),
    GestureDetector(
    onTap: () {
    // More options logic
    },
    child: Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(vertical: 14),
    decoration: BoxDecoration(
    color: Colors.transparent,
    border: Border.all(
    color: const Color(0xFF4ADE80),
    ),
    borderRadius: BorderRadius.circular(25),
    ),
    child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: const [
    Icon(
    Icons.share,
    color: Color(0xFF4ADE80),
    ),
    SizedBox(width: 10),
    Text(
    'MORE OPTIONS',
    style: TextStyle(
    color: Color(0xFF4ADE80),
    fontSize: 16,
    fontWeight: FontWeight.bold,
    ),
    ),
    ],
    ),
    ),
    ),
    const Spacer(),
    Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    const Text(
    'To know about How its Works ',
    style: TextStyle(
    color: Colors.white70,
    ),
    ),
    TextButton(
    onPressed: () {},
    child: const Text(
    'Click Here',
    style: TextStyle(
      color: Color(0xFF4ADE80),
    ),
    ),
    ),
    ],
    ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'To know about the Rules of FairPlay ',
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Click Here',
                    style: TextStyle(
                      color: Color(0xFF4ADE80),
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
}