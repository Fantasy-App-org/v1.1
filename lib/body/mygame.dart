import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'completed_match.dart';

class MyMatchesScreen extends StatefulWidget {
  const MyMatchesScreen({Key? key}) : super(key: key);

  @override
  State<MyMatchesScreen> createState() => _MyMatchesScreenState();
}

class _MyMatchesScreenState extends State<MyMatchesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xfff6f8fc),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        automaticallyImplyLeading: false,
        title: Text(
          'My Matches',
          style: GoogleFonts.poppins(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xfff0f2f5),
              borderRadius: BorderRadius.circular(30),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: const LinearGradient(
                  colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF667eea).withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  )
                ],
              ),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.black87,
              labelStyle: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              unselectedLabelStyle: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              indicatorPadding: const EdgeInsets.all(4),
              labelPadding: EdgeInsets.zero,
              tabs: [
                Container(
                  height: 40,
                  alignment: Alignment.center,
                  child: const Text('Upcoming'),
                ),
                Container(
                  height: 40,
                  alignment: Alignment.center,
                  child: const Text('Live'),
                ),
                Container(
                  height: 40,
                  alignment: Alignment.center,
                  child: const Text('Completed'),
                ),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildUpcoming(size),
          _buildEmptyState(size, 'Live'),
          const CompletedMatchesPage(),
        ],
      ),
    );
  }

  Widget _buildUpcoming(Size size) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _matchCard(
          team1: 'India',
          team1Logo: 'assets/images/Board_of_Control_for_Cricket_in_India_Logo_(2024).svg.png',
          team2: 'Australia',
          team2Logo: 'assets/images/australiya.jpeg',
          matchType: 'World Cup',
          timeLeft: '2h 30m',
          contests: '12',
          teams: '5',
        ),
        const SizedBox(height: 16),
        _matchCard(
          team1: 'Mumbai',
          team1Logo: 'assets/ipl/mi.png',
          team2: 'Chennai',
          team2Logo: 'assets/ipl/csk.png',
          matchType: 'IPL',
          timeLeft: '5h 15m',
          contests: '8',
          teams: '3',
        ),
      ],
    );
  }

  Widget _matchCard({
    required String team1,
    required String team1Logo,
    required String team2,
    required String team2Logo,
    required String matchType,
    required String timeLeft,
    required String contests,
    required String teams,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Colors.white, Color(0xfffef6f6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF667eea), Color(0xFF764ba2)],
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  matchType,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    timeLeft,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Teams Row
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _teamColumn(team1, team1Logo),
                Text(
                  'VS',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
                _teamColumn(team2, team2Logo),
              ],
            ),
          ),

          // Stats
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xfff9f9f9),
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _statBadge(Icons.emoji_events, Colors.amber, '$contests Contests'),
                _statBadge(Icons.groups, Colors.green, '$teams Teams'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _teamColumn(String name, String logo) {
    return Column(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: Colors.white,
          backgroundImage: AssetImage(logo),
        ),
        const SizedBox(height: 6),
        Text(
          name,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _statBadge(IconData icon, Color color, String text) {
    return Row(
      children: [
        CircleAvatar(
          radius: 14,
          backgroundColor: color.withOpacity(0.15),
          child: Icon(icon, size: 16, color: color),
        ),
        const SizedBox(width: 5),
        Text(
          text,
          style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildEmptyState(Size size, String type) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/no_upcoming_fixtures_found.png',
              width: size.width * 0.6,
            ),
            const SizedBox(height: 20),
            Text(
              type == 'Live' ? 'No Live Matches' : 'No Upcoming Matches',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              type == 'Live'
                  ? 'Come back when matches are live!'
                  : 'Join upcoming matches to start playing.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                backgroundColor: const Color(0xFF667eea),
              ),
              child: Text(
                'VIEW MATCHES',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}