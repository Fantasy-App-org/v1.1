
import 'package:fantasy/body/refral%20/referal.dart';
import 'package:fantasy/drawe_pages/about_us.dart';
import 'package:fantasy/drawe_pages/profile.dart';
import 'package:fantasy/wallet/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import '../drawe_pages/FAQ.dart';
import '../drawe_pages/Legality_pages.dart';
import '../drawe_pages/fantasy point system.dart';
import '../drawe_pages/how_to_play.dart';
import '../drawe_pages/transection_history.dart';
import '../auth/login.dart';
import '../team_creation/contest_all_pages.dart';
import '../team_creation/creat team.dart';
import 'mygame.dart';

/// ---------- Shared helpers (top-level) ----------
String _flagFor(String short) {
  switch (short.toUpperCase()) {
    case 'IND': return '🇮🇳';
    case 'AUS': return '🇦🇺';
    case 'ENG': return '🇬🇧'; // England -> UK flag
    case 'PAK': return '🇵🇰';
    case 'SA':
    case 'RSA': return '🇿🇦';
    case 'NZ': return '🇳🇿';
    case 'BAN': return '🇧🇩';
    case 'SL': return '🇱🇰';
    case 'AFG': return '🇦🇫';
    case 'IRE': return '🇮🇪';
    case 'WI': return '🏴‍☠️'; // placeholder for West Indies
    default: return '🏏';
  }
}

String _rb46(BatRow b) => '${b.r}  ${b.b}  ${b.fours}  ${b.sixes}';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late AnimationController _animationController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // ---- Data providers (mock) ----
  List<Map<String, String>> _getLiveMatches() => [
    {
      'format': 'ODI',
      'team1': 'India',
      'team2': 'Australia',
      'team1Short': 'IND',
      'team2Short': 'AUS',
      'score1': '285/6',
      'score2': '267/8',
      'overs1': '50.0',
      'overs2': '48.4',
      'status': 'India won by 18 runs',
      'venue': 'Wankhede Stadium',
    },
    {
      'format': 'ODI',
      'team1': 'England',
      'team2': 'Pakistan',
      'team1Short': 'ENG',
      'team2Short': 'PAK',
      'score1': '195/4',
      'score2': '180/7',
      'overs1': '35.2',
      'overs2': '40.0',
      'status': 'England won by 15 runs',
      'venue': 'The Oval',
    },
    {
      'format': 'ODI',
      'team1': 'South Africa',
      'team2': 'New Zealand',
      'team1Short': 'SA',
      'team2Short': 'NZ',
      'score1': '220/5',
      'score2': '205/9',
      'overs1': '45.3',
      'overs2': '47.2',
      'status': 'SA won by 15 runs',
      'venue': 'Newlands',
    },
  ];

  List<Map<String, String>> _getUpcomingMatches() => [
    {
      'team1': 'Mumbai Indians',
      'team2': 'Chennai Super Kings',
      'team1Short': 'MI',
      'team2Short': 'CSK',
      'time': '2h 30m',
      'contests': '24 Contests',
      'prize': '₹5 Lakhs',
      'venue': 'Wankhede Stadium',
      'series': 'IPL 2024 • T20',
    },
    {
      'team1': 'Royal Challengers Bangalore',
      'team2': 'Kolkata Knight Riders',
      'team1Short': 'RCB',
      'team2Short': 'KKR',
      'time': '1 Day 4h',
      'contests': '18 Contests',
      'prize': '₹10 Lakhs',
      'venue': 'Chinnaswamy Stadium',
      'series': 'IPL 2024 • T20',
    },
  ];

  void _openLiveMatchDetails(Map<String, String> match) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => LiveMatchDetailsPage(match: match)),
    );
  }

  void _openAllLive() {
    final matches = _getLiveMatches();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AllLiveMatchesPage(matches: matches)),
    );
  }

  void _openAllUpcoming() {
    final matches = _getUpcomingMatches();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AllUpcomingMatchesPage(matches: matches)),
    );
  }

  // Handle upcoming match tap
  void _handleUpcomingMatchTap(String team1, String team2, String matchId) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => FantasyCricketPage()));
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(duration: const Duration(milliseconds: 600), vsync: this);
    _slideController = AnimationController(duration: const Duration(milliseconds: 800), vsync: this);
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic));
    _animationController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: _buildPremiumAppBar(),
      drawer: _buildPremiumDrawer(),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: IndexedStack(
          index: _selectedIndex,
          children: [
            _buildHomeScreen(),
            MyMatchesScreen(),
            NewReferralScreen(),
          ],
        ),
      ),
      bottomNavigationBar: _buildPremiumBottomNav(),
    );
  }

  PreferredSizeWidget _buildPremiumAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      leading: Container(
        margin: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFFF1F5F9), Color(0xFFE2E8F0)]),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: IconButton(
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          icon: const Icon(Icons.menu_rounded, color: Color(0xFF1E293B), size: 18),
        ),
      ),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [BoxShadow(color: const Color(0xFF667eea).withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 2))],
            ),
            child: const Icon(Icons.sports_cricket, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text('STAR 25 PRO',
                  style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.w700, fontSize: 14, letterSpacing: 0.3)),
              Text('Cricket League',
                  style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.w400, fontSize: 8, letterSpacing: 0.2)),
            ],
          ),
        ],
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 6),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFFF1F5F9), Color(0xFFE2E8F0)]),
            borderRadius: BorderRadius.circular(10),
          ),
          child: IconButton(
            icon: Stack(clipBehavior: Clip.none, children: [
              const Icon(Icons.notifications_none_rounded, color: Color(0xFF475569), size: 18),
              Positioned(
                right: -1,
                top: -1,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFFEF4444), Color(0xFFDC2626)]),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  constraints: const BoxConstraints(minWidth: 12, minHeight: 12),
                  child: const Text('3',
                      style: TextStyle(color: Colors.white, fontSize: 7, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
                ),
              ),
            ]),
            onPressed: () {},
          ),
        ),
        Container(
          margin: const EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFF059669), Color(0xFF047857)]),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [BoxShadow(color: const Color(0xFF059669).withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 2))],
          ),
          child: IconButton(
            icon: const Icon(Icons.account_balance_wallet_rounded, color: Colors.white, size: 16),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const WalletScreen()));
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHomeScreen() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: SlideTransition(
        position: _slideAnimation,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _buildPremiumBanner(),
          _buildBalanceCard(),
          _buildLiveMatches(),
          _buildUpcomingMatches(),
          _buildPerformanceStats(),
          const SizedBox(height: 80),
        ]),
      ),
    );
  }

  Widget _buildPremiumBanner() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF667eea), Color(0xFF764ba2), Color(0xFF667eea)], begin: Alignment.topLeft, end: Alignment.bottomRight, stops: [0.0, 0.5, 1.0]),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: const Color(0xFF667eea).withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Stack(children: [
        Positioned(
          right: -40,
          top: -25,
          child: Container(width: 120, height: 120, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.08))),
        ),
        Positioned(
          right: 15,
          bottom: -15,
          child: Container(width: 60, height: 60, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.05))),
        ),
        Positioned(
          left: -20,
          top: 20,
          child: Container(width: 40, height: 40, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.06))),
        ),
        const Padding(padding: EdgeInsets.all(20), child: _BannerInner()),
      ]),
    );
  }

  Widget _buildBalanceCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: const Color(0xFF1E293B).withOpacity(0.06), blurRadius: 20, offset: const Offset(0, 4))],
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Row(children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFF10B981), Color(0xFF059669)]),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: const Color(0xFF10B981).withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 2))],
          ),
          child: const Icon(Icons.account_balance_wallet_rounded, color: Colors.white, size: 18),
        ),
        const SizedBox(width: 12),
        const Expanded(child: _BalanceText()),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [const Color(0xFF10B981).withOpacity(0.1), const Color(0xFF059669).withOpacity(0.05)]),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFF10B981).withOpacity(0.2)),
          ),
          child: const Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.add_rounded, color: Color(0xFF10B981), size: 14),
            SizedBox(width: 4),
            Text('Add Money', style: TextStyle(color: Color(0xFF10B981), fontSize: 10, fontWeight: FontWeight.w600)),
          ]),
        ),
      ]),
    );
  }

  Widget _buildLiveMatches() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final matches = _getLiveMatches();

    return Column(
      children: [
        _buildSectionHeader('Live Matches', 'See All', _openAllLive),
        SizedBox(
          height: screenHeight * 0.22,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: matches.length,
            itemBuilder: (context, index) {
              final m = matches[index];
              return GestureDetector(
                onTap: () => _openLiveMatchDetails(m),
                child: Container(
                  width: screenWidth * 0.80,
                  margin: const EdgeInsets.only(right: 12),
                  child: _buildLiveMatchCard(
                    team1: m['team1']!,
                    team2: m['team2']!,
                    team1Short: m['team1Short']!,
                    team2Short: m['team2Short']!,
                    score1: m['score1']!,
                    score2: m['score2']!,
                    overs1: m['overs1']!,
                    overs2: m['overs2']!,
                    status: m['status']!,
                    format: m['format']!,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildUpcomingMatches() {
    final upcoming = _getUpcomingMatches();

    return Column(
      children: [
        _buildSectionHeader('Upcoming Matches', 'View All', _openAllUpcoming),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: upcoming.length,
          itemBuilder: (context, index) {
            final m = upcoming[index];
            return GestureDetector(
              onTap: () => _handleUpcomingMatchTap(m['team1']!, m['team2']!, 'match_${index + 1}'),
              child: _buildUpcomingMatchCard(
                team1: m['team1']!,
                team2: m['team2']!,
                team1Short: m['team1Short']!,
                team2Short: m['team2Short']!,
                time: m['time']!,
                contests: m['contests']!,
                prize: m['prize']!,
                team1Color: index == 0 ? const Color(0xFF3B82F6) : const Color(0xFFEF4444),
                team2Color: index == 0 ? const Color(0xFFFBBF24) : const Color(0xFF8B5CF6),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildPerformanceStats() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Performance Stats', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: _buildStatCard('Total Contests', '45', Icons.sports_cricket, const Color(0xFF3B82F6))),
          const SizedBox(width: 10),
          Expanded(child: _buildStatCard('Winnings', '₹12,450', Icons.emoji_events, const Color(0xFF10B981))),
        ]),
        const SizedBox(height: 10),
        Row(children: [
          Expanded(child: _buildStatCard('Win Rate', '67%', Icons.trending_up, const Color(0xFFF59E0B))),
          const SizedBox(width: 10),
          Expanded(child: _buildStatCard('Rank', '#247', Icons.leaderboard, const Color(0xFF8B5CF6))),
        ]),
      ]),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: const Color(0xFF1E293B).withOpacity(0.06), blurRadius: 15, offset: const Offset(0, 3))],
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: color, size: 16)),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
        const SizedBox(height: 2),
        Text(title, style: const TextStyle(fontSize: 10, color: Color(0xFF64748B), fontWeight: FontWeight.w400)),
      ]),
    );
  }

  Widget _buildSectionHeader(String title, String actionText, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
        GestureDetector(onTap: onTap, child: Text(actionText, style: const TextStyle(fontSize: 12, color: Color(0xFF3B82F6), fontWeight: FontWeight.w500))),
      ]),
    );
  }

  Widget _buildPremiumDrawer() {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
            },
            child: Container(
              height: 250,
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [Color(0xFF667eea), Color(0xFF764ba2), Color(0xFF667eea)], begin: Alignment.topLeft, end: Alignment.bottomRight, stops: [0.0, 0.5, 1.0]),
              ),
              child: Stack(children: [
                Positioned(top: -40, right: -40, child: Container(width: 120, height: 120, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.1)))),
                Positioned(top: 25, right: 15, child: Container(width: 60, height: 60, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.05)))),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.end, children: [
                      Container(
                        decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 6))]),
                        child: const CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 26,
                            backgroundColor: Color(0xFF4F46E5),
                            child: Text('JD', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text('John Doe',
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700, letterSpacing: 0.3)),
                      const SizedBox(height: 3),
                      Row(children: [
                        Icon(Icons.sports_cricket, color: Colors.white.withOpacity(0.9), size: 12),
                        const SizedBox(width: 4),
                        Text('Fantasy Cricket Player', style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 11, fontWeight: FontWeight.w400)),
                      ]),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: Colors.amber.withOpacity(0.2), borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.amber.withOpacity(0.5), width: 1)),
                        child: Row(mainAxisSize: MainAxisSize.min, children: const [
                          Icon(Icons.star, color: Colors.amber, size: 10),
                          SizedBox(width: 3),
                          Text('Pro Player', style: TextStyle(color: Colors.amber, fontSize: 9, fontWeight: FontWeight.w500)),
                        ]),
                      ),
                      const SizedBox(height: 8),
                      Row(children: [
                        Text('Tap to view profile', style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 9, fontStyle: FontStyle.italic)),
                        const SizedBox(width: 4),
                        Icon(Icons.arrow_forward_ios, color: Colors.white.withOpacity(0.7), size: 10),
                      ]),
                    ]),
                  ),
                ),
              ]),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(Icons.person_rounded, 'Profile', () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage()));
                }),
                _buildDrawerItem(Icons.share_rounded, 'Referral', () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => NewReferralScreen()));
                }),
                _buildDrawerItem(Icons.account_balance_wallet_rounded, 'Wallet', () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => WalletScreen()));
                }),
                _buildDrawerItem(Icons.history_rounded, 'Transaction History', () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => TransactionHistoryPage()));
                }),
                _buildDrawerItem(Icons.stars_rounded, 'Fantasy Points', () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => FantasyPointsPage()));
                }),
                _buildDrawerItem(Icons.help_outline_rounded, 'How To Play', () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => HowToPlayPage()));
                }),
                _buildDrawerItem(Icons.info_outline_rounded, 'About us', () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AboutUsPage()));
                }),
                _buildDrawerItem(Icons.gavel_rounded, 'Legality', () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LegalityPage()));
                }),
                _buildDrawerItem(Icons.quiz_rounded, 'FAQ', () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Start25ProFAQPage()));
                }),
                const Divider(height: 12),
                _buildDrawerItem(Icons.logout_rounded, 'Logout', () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        title: const Text('Logout', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                        content: const Text('Are you sure you want to logout?', style: TextStyle(fontSize: 14)),
                        actions: [
                          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel', style: TextStyle(fontSize: 12))),
                          TextButton(
                            onPressed: () async {
                              Navigator.of(context).pop();
                              await _clearLoginState();
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => Dream11LoginPage()),
                                    (route) => false,
                              );
                            },
                            child: const Text('Logout', style: TextStyle(color: Colors.red, fontSize: 12)),
                          ),
                        ],
                      );
                    },
                  );
                }, isDestructive: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _clearLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    await prefs.remove('userMobile');
    await prefs.remove('loginTime');
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap, {bool isDestructive = false}) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: isDestructive ? const Color(0xFFEF4444).withOpacity(0.1) : const Color(0xFF3B82F6).withOpacity(0.1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, color: isDestructive ? const Color(0xFFEF4444) : const Color(0xFF3B82F6), size: 16),
      ),
      title: Text(title,
          style: TextStyle(color: isDestructive ? const Color(0xFFEF4444) : const Color(0xFF1E293B), fontWeight: FontWeight.w500, fontSize: 13)),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
    );
  }

  Widget _buildPremiumBottomNav() {
    return Container(
      decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: const Color(0xFF1E293B).withOpacity(0.08), blurRadius: 20, offset: const Offset(0, -4))]),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF3B82F6),
        unselectedItemColor: const Color(0xFF64748B),
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 10),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w400, fontSize: 9),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded, size: 20), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.sports_cricket, size: 20), label: 'My Games'),
          BottomNavigationBarItem(icon: Icon(Icons.share, size: 20), label: 'Refer'),
        ],
      ),
    );
  }

  // ---------- Cards & helpers ----------

  Widget _buildLiveMatchCard({
    required String team1,
    required String team2,
    required String team1Short,
    required String team2Short,
    required String score1,
    required String score2,
    required String overs1,
    required String overs2,
    required String status,
    required String format,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: const Color(0xFF1E293B).withOpacity(0.06), blurRadius: 15, offset: const Offset(0, 4))],
        border: Border.all(color: const Color(0xFF10B981).withOpacity(0.3), width: 1),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [Color(0xFFDCFDF7), Color(0xFFF0FDF4)]),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
            ),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFFEF4444), Color(0xFFDC2626)]), borderRadius: BorderRadius.circular(12)),
                child: Row(mainAxisSize: MainAxisSize.min, children: const [
                  SizedBox(width: 4, height: 4, child: DecoratedBox(decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle))),
                  SizedBox(width: 4),
                  Text('LIVE', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w600)),
                ]),
              ),
              Text(format, style: const TextStyle(color: Color(0xFF059669), fontSize: 11, fontWeight: FontWeight.w600)),
            ]),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                Row(children: [
                  Expanded(child: _scoreBlock(team1Short, score1, overs1)),
                  const SizedBox(width: 12),
                  const Text('vs', style: TextStyle(color: Color(0xFF64748B))),
                  const SizedBox(width: 12),
                  Expanded(child: _scoreBlock(team2Short, score2, overs2, right: true)),
                ]),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration:
                  BoxDecoration(gradient: LinearGradient(colors: [const Color(0xFF10B981).withOpacity(0.1), const Color(0xFF059669).withOpacity(0.05)]), borderRadius: BorderRadius.circular(8)),
                  child: Text(status, style: const TextStyle(fontSize: 11, color: Color(0xFF059669), fontWeight: FontWeight.w600), textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _scoreBlock(String short, String score, String overs, {bool right = false}) {
    final align = right ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    return Column(crossAxisAlignment: align, children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(8)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Text(_flagFor(short), style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 6),
          Text(short, style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
        ]),
      ),
      const SizedBox(height: 6),
      Text(score, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF0F172A))),
      Text('($overs ov)', style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
    ]);
  }

  Widget _buildUpcomingMatchCard({
    required String team1,
    required String team2,
    required String team1Short,
    required String team2Short,
    required String time,
    required String contests,
    required String prize,
    required Color team1Color,
    required Color team2Color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: const Color(0xFF1E293B).withOpacity(0.06), blurRadius: 15, offset: const Offset(0, 4))],
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [Color(0xFFF8FAFC), Colors.white]),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
            ),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: const [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('IPL 2024 • T20', style: TextStyle(color: Color(0xFF3B82F6), fontSize: 11, fontWeight: FontWeight.w600)),
                Text('Wankhede Stadium', style: TextStyle(color: Color(0xFF64748B), fontSize: 10)),
              ]),
              _TimePill(text: 'Starts soon'),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(children: [
              Expanded(child: _teamBadge(team1Short, team1, team1Color)),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(color: Color(0xFFF8FAFC), shape: BoxShape.circle),
                child: const Text('VS', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF64748B), fontSize: 10)),
              ),
              Expanded(child: _teamBadge(team2Short, team2, team2Color)),
            ]),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [Color(0xFFF8FAFC), Colors.white]),
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16)),
            ),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(contests, style: const TextStyle(color: Color(0xFF1E293B), fontSize: 12, fontWeight: FontWeight.w600)),
                Text('Prize Pool: $prize', style: const TextStyle(color: Color(0xFF10B981), fontSize: 11, fontWeight: FontWeight.w600)),
              ]),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)]),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [BoxShadow(color: const Color(0xFF3B82F6).withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 2))],
                ),
                child: const Text('Join Contest', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _teamBadge(String short, String name, Color color) {
    return Column(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [color.withOpacity(0.8), color]),
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: color.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 2))],
          ),
          child: Center(child: Text(short, style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.white, fontSize: 12))),
        ),
        const SizedBox(height: 6),
        Text(name, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)), textAlign: TextAlign.center, maxLines: 2),
      ],
    );
  }
}

class _TimePill extends StatelessWidget {
  final String text;
  const _TimePill({required this.text});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFFF59E0B), Color(0xFFD97706)]), borderRadius: BorderRadius.circular(10)),
      child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
    );
  }
}

class _BannerInner extends StatelessWidget {
  const _BannerInner();

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Welcome Back! 👋', style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 12, fontWeight: FontWeight.w400)),
            const SizedBox(height: 6),
            const Text('Build Your\nDream Team', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700, height: 1.1)),
          ]),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.3)),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
          ),
          child: const Icon(Icons.emoji_events_rounded, color: Color(0xFFFBBF24), size: 24),
        ),
      ]),
      const SizedBox(height: 15),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.white.withOpacity(0.25))),
        child: Text('🏆 Join upcoming IPL matches and win big!', style: TextStyle(color: Colors.white.withOpacity(0.95), fontSize: 11, fontWeight: FontWeight.w400)),
      ),
    ]);
  }
}

class _BalanceText extends StatelessWidget {
  const _BalanceText();

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
      Text('Total Balance', style: TextStyle(color: Color(0xFF64748B), fontSize: 11, fontWeight: FontWeight.w400)),
      SizedBox(height: 2),
      Text('₹2,450.00', style: TextStyle(color: Color(0xFF0F172A), fontSize: 18, fontWeight: FontWeight.w700)),
    ]);
  }
}

/// =================== LIVE MATCH DETAILS PAGE ===================
class LiveMatchDetailsPage extends StatelessWidget {
  final Map<String, String> match;
  const LiveMatchDetailsPage({Key? key, required this.match}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final t1 = match['team1Short']!;
    final t2 = match['team2Short']!;
    final t1Name = match['team1']!;
    final t2Name = match['team2']!;
    final status = match['status']!;
    final score1 = match['score1']!;
    final score2 = match['score2']!;
    final overs1 = match['overs1']!;
    final overs2 = match['overs2']!;
    final format = match['format'] ?? 'International';
    final venue = match['venue'] ?? '';

    // --- Mock full scorecard data (replace with API later) ---
    final innings1 = InningsData(
      teamShort: t1,
      teamName: t1Name,
      score: score1,
      overs: overs1,
      batting: [
        BatRow('R Sharma', 'c Carey b Starc', 84, 76, 9, 2, 110.5),
        BatRow('S Gill', 'lbw b Zampa', 41, 52, 4, 0, 78.8),
        BatRow('V Kohli', 'b Hazlewood', 62, 58, 5, 1, 106.8),
        BatRow('S Iyer', 'run out (Smith)', 22, 18, 3, 0, 122.2),
      ],
      fallOfWkts: '1-72 (Gill, 14.2 ov), 2-140 (Sharma, 27.1 ov), 3-198 (Kohli, 39.4 ov)',
      didNotBat: ['R Jadeja', 'M Shami', 'K Yadav', 'M Siraj'],
      bowlingAgainst: [
        BowlRow('M Starc', 10, 0, 52, 2, 5.20),
        BowlRow('A Zampa', 10, 1, 44, 1, 4.40),
        BowlRow('J Hazlewood', 10, 0, 46, 1, 4.60),
      ],
      extras: Extras(b: 1, lb: 2, w: 5, nb: 1, p: 0),
      totalNote: 'IND 285/6 (50.0 ov), RR: 5.70',
    );

    final innings2 = InningsData(
      teamShort: t2,
      teamName: t2Name,
      score: score2,
      overs: overs2,
      batting: [
        BatRow('D Warner', 'c Gill b Shami', 71, 88, 7, 1, 80.6),
        BatRow('S Smith', 'b Jadeja', 39, 47, 3, 0, 82.9),
        BatRow('M Marsh', 'c Rahul b Shami', 34, 28, 2, 2, 121.4),
      ],
      fallOfWkts: '1-60 (Warner, 15.1 ov), 2-120 (Smith, 29.3 ov), 3-176 (Marsh, 38.2 ov)',
      didNotBat: ['A Carey', 'M Starc', 'P Cummins'],
      bowlingAgainst: [
        BowlRow('M Shami', 10, 0, 43, 3, 4.30),
        BowlRow('R Jadeja', 10, 2, 38, 1, 3.80),
        BowlRow('M Siraj', 9.4, 0, 52, 2, 5.38),
      ],
      extras: Extras(b: 0, lb: 1, w: 7, nb: 0, p: 0),
      totalNote: 'AUS 267/8 (48.4 ov), RR: 5.48',
    );

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Text(_flagFor(t1), style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 8),
              Text('$t1 vs $t2', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
              const SizedBox(width: 8),
              Text(_flagFor(t2), style: const TextStyle(fontSize: 16)),
            ]),
            Text('$format • $venue', style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
            Text(status, style: const TextStyle(fontSize: 11, color: Color(0xFF059669), fontWeight: FontWeight.w600)),
          ]),
          bottom: const TabBar(
            indicatorColor: Color(0xFF3B82F6),
            labelColor: Color(0xFF1E293B),
            unselectedLabelColor: Color(0xFF94A3B8),
            tabs: [
              Tab(text: 'Scorecard'),
              Tab(text: 'Player Stats'),
              Tab(text: 'Info'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // ===== SCORECARD (with inner two-team switcher) =====
            _TeamScorecardSwitcher(
              innings1: innings1,
              innings2: innings2,
              t1: t1,
              t2: t2,
              score1: score1,
              score2: score2,
              overs1: overs1,
              overs2: overs2,
            ),

            // ===== PLAYER STATS =====
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const _SectionTitle('Top Performers'),
                  const SizedBox(height: 8),
                  _TopPerformerTile(name: 'R Sharma', team: t1, statLabel: 'Batting', statValue: '84 (76)'),
                  _TopPerformerTile(name: 'M Shami', team: t1, statLabel: 'Bowling', statValue: '3/43 (10)'),
                  _TopPerformerTile(name: 'D Warner', team: t2, statLabel: 'Batting', statValue: '71 (88)'),
                  _TopPerformerTile(name: 'M Starc', team: t2, statLabel: 'Bowling', statValue: '2/52 (10)'),
                  const SizedBox(height: 16),
                  const _SectionTitle('Batting (All)'),
                  const SizedBox(height: 6),
                  _ScrollableDataTableW(
                    columns: const ['Batsman', 'R  B  4s  6s', 'SR'],
                    rows: [
                      ...innings1.batting.map((b) => [
                        _BatsmanCell(name: b.name, dismissal: b.dismissal),
                        Text(_rb46(b), overflow: TextOverflow.ellipsis),
                        Text(b.sr.toStringAsFixed(1), overflow: TextOverflow.ellipsis),
                      ]),
                      ...innings2.batting.map((b) => [
                        _BatsmanCell(name: b.name, dismissal: b.dismissal),
                        Text(_rb46(b), overflow: TextOverflow.ellipsis),
                        Text(b.sr.toStringAsFixed(1), overflow: TextOverflow.ellipsis),
                      ]),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const _SectionTitle('Bowling (All)'),
                  const SizedBox(height: 6),
                  _ScrollableDataTable(
                    columns: const ['Bowler', 'O', 'M', 'R', 'W', 'Eco'],
                    rows: [
                      ...innings1.bowlingAgainst.map((b) => [b.name, _ov(b.o), '${b.m}', '${b.r}', '${b.w}', b.eco.toStringAsFixed(2)]),
                      ...innings2.bowlingAgainst.map((b) => [b.name, _ov(b.o), '${b.m}', '${b.r}', '${b.w}', b.eco.toStringAsFixed(2)]),
                    ],
                  ),
                  const SizedBox(height: 24),
                ]),
              ),
            ),

            // ===== INFO =====
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
                  _SectionTitle('Match Info'),
                  SizedBox(height: 8),
                  _InfoRow(label: 'Format', value: 'ODI'),
                  _InfoRow(label: 'Venue', value: '—'),
                  _InfoRow(label: 'Umpires', value: '—'),
                  _InfoRow(label: 'Toss', value: '—'),
                  SizedBox(height: 24),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _ov(num o) => o % 1 == 0 ? o.toStringAsFixed(1) : '$o';
}

/// Inner scorecard switcher like Cricbuzz (two tabs for both innings)
class _TeamScorecardSwitcher extends StatelessWidget {
  final InningsData innings1;
  final InningsData innings2;
  final String t1, t2, score1, score2, overs1, overs2;

  const _TeamScorecardSwitcher({
    Key? key,
    required this.innings1,
    required this.innings2,
    required this.t1,
    required this.t2,
    required this.score1,
    required this.score2,
    required this.overs1,
    required this.overs2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(children: [
        // Quick scoreboard header with tappable chips
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(children: [
            Expanded(child: _teamChip(t1, score1, overs1, selected: true, onTapIndex: 0)),
            const SizedBox(width: 8),
            Expanded(child: _teamChip(t2, score2, overs2, selected: false, onTapIndex: 1)),
          ]),
        ),

        // Team tabs (flags + short)
        Container(
          color: Colors.white,
          child: TabBar(
            indicator: BoxDecoration(
              color: const Color(0xFFDBEAFE),
              borderRadius: BorderRadius.circular(10),
            ),
            labelColor: const Color(0xFF1E293B),
            unselectedLabelColor: const Color(0xFF64748B),
            tabs: [
              Tab(child: _tabLabel(t1)),
              Tab(child: _tabLabel(t2)),
            ],
          ),
        ),

        // Scorecards per team
        Expanded(
          child: TabBarView(
            children: [
              _ScorecardScroll(innings: innings1),
              _ScorecardScroll(innings: innings2),
            ],
          ),
        ),
      ]),
    );
  }

  Widget _tabLabel(String short) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(_flagFor(short), style: const TextStyle(fontSize: 16)),
      const SizedBox(width: 6),
      Text(short, style: const TextStyle(fontWeight: FontWeight.w700)),
    ]);
  }

  Widget _teamChip(String short, String score, String ov, {required bool selected, required int onTapIndex}) {
    return Builder(
      builder: (context) {
        return InkWell(
          onTap: () => DefaultTabController.of(context)?.animateTo(onTapIndex),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: selected ? const Color(0xFFF1F5F9) : const Color(0xFFFFFFFF),
              border: Border.all(color: const Color(0xFFE2E8F0)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(_flagFor(short), style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 8),
              Text(short, style: const TextStyle(fontWeight: FontWeight.w800)),
              const SizedBox(width: 10),
              Text(score, style: const TextStyle(fontWeight: FontWeight.w800)),
              const SizedBox(width: 6),
              Text('($ov ov)', style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
            ]),
          ),
        );
      },
    );
  }
}

class _ScorecardScroll extends StatelessWidget {
  final InningsData innings;
  const _ScorecardScroll({required this.innings});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: ScorecardInnings(innings: innings),
      ),
    );
  }
}

// ---------- Scorecard widgets ----------
class ScorecardInnings extends StatelessWidget {
  final InningsData innings;
  const ScorecardInnings({Key? key, required this.innings}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
      BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFF1F5F9)), boxShadow: [BoxShadow(color: const Color(0xFF1E293B).withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 4))]),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Text(innings.teamName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF0F172A))),
            const SizedBox(width: 8),
            Text(innings.score, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF0F172A))),
            const SizedBox(width: 6),
            Text('(${innings.overs} ov)', style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
          ]),
          const SizedBox(height: 10),

          // Batting (name + dismissal beneath) + compact RB46 + SR
          _ScrollableDataTableW(
            columns: const ['Batsman', 'R  B  4s  6s', 'SR'],
            rows: innings.batting
                .map((b) => [
              _BatsmanCell(name: b.name, dismissal: b.dismissal),
              Text(_rb46(b), overflow: TextOverflow.ellipsis),
              Text(b.sr.toStringAsFixed(1), overflow: TextOverflow.ellipsis),
            ])
                .toList(),
          ),

          const SizedBox(height: 8),
          _KeyValueRow(label: 'Extras', value: innings.extras.format()),
          const SizedBox(height: 4),
          _KeyValueRow(label: 'Total', value: innings.totalNote),
          const SizedBox(height: 8),
          _KeyValueRow(label: 'Did Not Bat', value: innings.didNotBat.join(', ')),
          const SizedBox(height: 8),
          _KeyValueRow(label: 'Fall of Wickets', value: innings.fallOfWkts),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),
          const _SectionTitle('Bowling'),
          const SizedBox(height: 6),
          _ScrollableDataTable(
            columns: const ['Bowler', 'O', 'M', 'R', 'W', 'Eco'],
            rows: innings.bowlingAgainst
                .map((b) => [b.name, LiveMatchDetailsPage._ov(b.o), '${b.m}', '${b.r}', '${b.w}', b.eco.toStringAsFixed(2)])
                .toList(),
          ),
        ]),
      ),
    );
  }
}

class _BatsmanCell extends StatelessWidget {
  final String name;
  final String dismissal;
  const _BatsmanCell({Key? key, required this.name, required this.dismissal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dismissalStyle = GoogleFonts.lato(
      fontSize: 12,
      fontStyle: FontStyle.italic,
      color: const Color(0xFF64748B),
      fontWeight: FontWeight.w500,
      height: 1.2,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 13,
            color: Color(0xFF0F172A),
          ),
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          dismissal,
          style: dismissalStyle,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _ScrollableDataTableW extends StatelessWidget {
  final List<String> columns;
  final List<List<Widget>> rows;
  const _ScrollableDataTableW({Key? key, required this.columns, required this.rows}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Slightly narrower than the string-only table since we merged columns
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 520),
        child: DataTable(
          headingTextStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            color: Color(0xFF334155),
            fontSize: 12,
          ),
          dataTextStyle: const TextStyle(
            fontSize: 12,
            color: Color(0xFF0F172A),
          ),
          columnSpacing: 18,
          columns: columns.map((c) => DataColumn(label: Text(c))).toList(),
          rows: rows.map((r) {
            // First cell wider to fit name + dismissal
            final cells = <DataCell>[
              DataCell(SizedBox(width: 200, child: r[0])),
              ...r.skip(1).map((w) => DataCell(SizedBox(width: 120, child: w))),
            ];
            return DataRow(cells: cells);
          }).toList(),
        ),
      ),
    );
  }
}

class _ScrollableDataTable extends StatelessWidget {
  final List<String> columns;
  final List<List<String>> rows;
  const _ScrollableDataTable({Key? key, required this.columns, required this.rows}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Horizontal scroll to prevent RenderFlex overflow
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 640),
        child: DataTable(
          headingTextStyle: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF334155), fontSize: 12),
          dataTextStyle: const TextStyle(fontSize: 12, color: Color(0xFF0F172A)),
          columnSpacing: 18,
          columns: columns.map((c) => DataColumn(label: Text(c))).toList(),
          rows: rows
              .map((r) => DataRow(cells: r.map((v) => DataCell(SizedBox(width: 110, child: Text(v, overflow: TextOverflow.ellipsis)))).toList()))
              .toList(),
        ),
      ),
    );
  }
}

class _KeyValueRow extends StatelessWidget {
  final String label;
  final String value;
  const _KeyValueRow({Key? key, required this.label, required this.value}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(width: 110, child: Text(label, style: const TextStyle(color: Color(0xFF64748B), fontSize: 12, fontWeight: FontWeight.w600))),
      const SizedBox(width: 6),
      Expanded(child: Text(value, style: const TextStyle(color: Color(0xFF0F172A), fontSize: 12))),
    ]);
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)));
  }
}

class _TopPerformerTile extends StatelessWidget {
  final String name;
  final String team;
  final String statLabel;
  final String statValue;
  const _TopPerformerTile({Key? key, required this.name, required this.team, required this.statLabel, required this.statValue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFF1F5F9)), boxShadow: [BoxShadow(color: const Color(0xFF1E293B).withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 4))]),
      child: Row(children: [
        Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.person, color: Color(0xFF3B82F6), size: 16)),
        const SizedBox(width: 10),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Color(0xFF0F172A))),
            Text(team, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
          ]),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(8)),
          child: Text('$statLabel: $statValue', style: const TextStyle(color: Color(0xFF16A34A), fontSize: 11, fontWeight: FontWeight.w700)),
        ),
      ]),
    );
  }
}

// ---------- Models for scorecard ----------
class BatRow {
  final String name;
  final String dismissal;
  final int r;
  final int b;
  final int fours;
  final int sixes;
  final double sr;
  BatRow(this.name, this.dismissal, this.r, this.b, this.fours, this.sixes, this.sr);
}

class BowlRow {
  final String name;
  final num o;
  final int m;
  final int r;
  final int w;
  final double eco;
  BowlRow(this.name, this.o, this.m, this.r, this.w, this.eco);
}

class Extras {
  final int b, lb, w, nb, p;
  Extras({this.b = 0, this.lb = 0, this.w = 0, this.nb = 0, this.p = 0});
  String format() {
    final parts = <String>[];
    if (b > 0) parts.add('b $b');
    if (lb > 0) parts.add('lb $lb');
    if (w > 0) parts.add('w $w');
    if (nb > 0) parts.add('nb $nb');
    if (p > 0) parts.add('p $p');
    if (parts.isEmpty) return '0';
    return parts.join(', ');
  }
}

class InningsData {
  final String teamShort;
  final String teamName;
  final String score;
  final String overs;
  final List<BatRow> batting;
  final List<BowlRow> bowlingAgainst;
  final Extras extras;
  final String totalNote;
  final String fallOfWkts;
  final List<String> didNotBat;
  InningsData({
    required this.teamShort,
    required this.teamName,
    required this.score,
    required this.overs,
    required this.batting,
    required this.bowlingAgainst,
    required this.extras,
    required this.totalNote,
    required this.fallOfWkts,
    required this.didNotBat,
  });
}

/// =================== SEE ALL: LIVE MATCHES ===================
class AllLiveMatchesPage extends StatefulWidget {
  final List<Map<String, String>> matches;
  const AllLiveMatchesPage({Key? key, required this.matches}) : super(key: key);

  @override
  State<AllLiveMatchesPage> createState() => _AllLiveMatchesPageState();
}

class _AllLiveMatchesPageState extends State<AllLiveMatchesPage> {
  String filter = 'All';

  @override
  Widget build(BuildContext context) {
    final formats = ['All', ...{...widget.matches.map((m) => m['format'] ?? 'Match')}];
    final list = filter == 'All' ? widget.matches : widget.matches.where((m) => m['format'] == filter).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(title: const Text('All Live Matches')),
      body: Column(
        children: [
          // Filters
          SizedBox(
            height: 48,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              scrollDirection: Axis.horizontal,
              itemCount: formats.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final f = formats[i];
                final selected = f == filter;
                return GestureDetector(
                  onTap: () => setState(() => filter = f),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: selected ? const Color(0xFFDBEAFE) : const Color(0xFFF1F5F9),
                      border: Border.all(color: selected ? const Color(0xFF3B82F6) : const Color(0xFFE2E8F0)),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(f, style: TextStyle(color: selected ? const Color(0xFF1D4ED8) : const Color(0xFF334155), fontWeight: FontWeight.w600)),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: list.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, i) {
                final m = list[i];
                return InkWell(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => LiveMatchDetailsPage(match: m))),
                  child: _LiveListCard(match: m),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _LiveListCard extends StatelessWidget {
  final Map<String, String> match;
  const _LiveListCard({Key? key, required this.match}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final t1 = match['team1Short']!;
    final t2 = match['team2Short']!;
    final score1 = match['score1']!;
    final score2 = match['score2']!;
    final ov1 = match['overs1']!;
    final ov2 = match['overs2']!;
    final status = match['status']!;
    final format = match['format'] ?? 'Match';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: [BoxShadow(color: const Color(0xFF1E293B).withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 3))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFFEF4444), Color(0xFFDC2626)]), borderRadius: BorderRadius.circular(8)),
            child: const Text('LIVE', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700)),
          ),
          const SizedBox(width: 8),
          Text(format, style: const TextStyle(color: Color(0xFF059669), fontSize: 12, fontWeight: FontWeight.w700)),
        ]),
        const SizedBox(height: 10),
        Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Expanded(child: _teamScoreCol(flag: _flagFor(t1), short: t1, score: score1, ov: ov1)),
          const Text('vs', style: TextStyle(color: Color(0xFF64748B))),
          Expanded(child: _teamScoreCol(flag: _flagFor(t2), short: t2, score: score2, ov: ov2, right: true)),
        ]),
        const SizedBox(height: 8),
        Text(status, style: const TextStyle(color: Color(0xFF059669), fontWeight: FontWeight.w600)),
      ]),
    );
  }

  Widget _teamScoreCol({required String flag, required String short, required String score, required String ov, bool right = false}) {
    final align = right ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    return Column(crossAxisAlignment: align, children: [
      Row(mainAxisSize: MainAxisSize.min, children: [
        Text(flag, style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 6),
        Text(short, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
      ]),
      const SizedBox(height: 4),
      Text(score, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
      Text('($ov ov)', style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
    ]);
  }
}

/// =================== VIEW ALL: UPCOMING MATCHES ===================
class AllUpcomingMatchesPage extends StatelessWidget {
  final List<Map<String, String>> matches;
  const AllUpcomingMatchesPage({Key? key, required this.matches}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(title: const Text('All Upcoming Matches')),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: matches.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, i) {
          final m = matches[i];
          return InkWell(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => FantasyCricketPage())),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFF1F5F9)),
                boxShadow: [BoxShadow(color: const Color(0xFF1E293B).withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 3))],
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(m['series'] ?? 'T20', style: const TextStyle(color: Color(0xFF3B82F6), fontSize: 12, fontWeight: FontWeight.w700)),
                    Text(m['venue'] ?? '', style: const TextStyle(color: Color(0xFF64748B), fontSize: 11)),
                  ]),
                  _TimePill(text: m['time'] ?? ''),
                ]),
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(child: _franchiseBadge(m['team1Short']!, m['team1']!, const Color(0xFF3B82F6))),
                  const SizedBox(width: 12),
                  const Text('VS', style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.w700)),
                  const SizedBox(width: 12),
                  Expanded(child: _franchiseBadge(m['team2Short']!, m['team2']!, const Color(0xFF8B5CF6))),
                ]),
                const SizedBox(height: 10),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text(m['contests'] ?? '', style: const TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.w600)),
                  Text('Prize: ${m['prize']}', style: const TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.w700)),
                ]),
              ]),
            ),
          );
        },
      ),
    );
  }

  Widget _franchiseBadge(String short, String name, Color color) {
    return Row(children: [
      Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [color.withOpacity(0.8), color]),
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: color.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 2))]),
          child: Center(child: Text(short, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)))),
      const SizedBox(width: 10),
      Expanded(child: Text(name, style: const TextStyle(fontWeight: FontWeight.w700))),
    ]);
  }
}

/// ---------- Small info row used in Info tab ----------
class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({Key? key, required this.label, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 110,
          child: Text(
            label,
            style: const TextStyle(
              color: Color(0xFF64748B),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: Color(0xFF0F172A),
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}
