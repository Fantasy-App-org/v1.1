import 'package:flutter/material.dart';

class MyMatchesScreen extends StatefulWidget {
  const MyMatchesScreen({Key? key}) : super(key: key);

  @override
  State<MyMatchesScreen> createState() => _MyMatchesScreenState();
}

class _MyMatchesScreenState extends State<MyMatchesScreen> {
  int _selectedTabIndex = 0; // 0: Upcoming, 1: Live, 2: Completed
  int _selectedSportIndex = 0; // 0: All, 1: Cricket, 2: Football, etc.

  final List<String> _sports = [
    'All',
    'Cricket',
    'Football',
    'Basketball',
    'Baseball',
  ];

  final List<IconData> _sportsIcons = [
    Icons.apps, // All
    Icons.sports_cricket,
    Icons.sports_soccer,
    Icons.sports_basketball,
    Icons.sports_baseball,
  ];

  @override
  Widget build(BuildContext context) {
    // Get device dimensions for responsive design
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;

    return Scaffold(
      backgroundColor: Colors.white,
      // No AppBar at all
      body: SafeArea(
        child: Column(
          children: [
            // Sport Selection Tabs - directly at the top of the screen
            Container(
              height: 50,
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _sports.length,
                itemBuilder: (context, index) {
                  return buildSportTab(index);
                },
              ),
            ),

            // Match Status Tabs (Upcoming, Live, Completed)
            Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  buildStatusTab(0, 'Upcoming'),
                  buildStatusTab(1, 'Live'),
                  buildStatusTab(2, 'Completed'),
                ],
              ),
            ),

            // Content Area - Empty State
            Expanded(
              child: buildEmptyState(screenWidth, screenHeight),
            ),
          ],
        ),
      ),
    );
  }

  // Build sport selection tab (All, Cricket, Football, etc.)
  Widget buildSportTab(int index) {
    bool isSelected = _selectedSportIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedSportIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? Colors.red : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              _sportsIcons[index],
              color: isSelected ? Colors.red : Colors.grey[600],
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              _sports[index],
              style: TextStyle(
                color: isSelected ? Colors.red : Colors.grey[600],
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build status tab (Upcoming, Live, Completed)
  Widget buildStatusTab(int index, String title) {
    bool isSelected = _selectedTabIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTabIndex = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.black : Colors.grey[700],
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Build empty state with cricket equipment image
  Widget buildEmptyState(double screenWidth, double screenHeight) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Cricket equipment image
          Container(
            width: screenWidth * 0.5,
            height: screenWidth * 0.5,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFF5F5F5),
            ),
            child: Center(
              child: Image.asset(
                'assets/images/dream11_equipment.png',
                width: screenWidth * 0.3,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback if image not available
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      // Red duffel bag
                      Container(
                        width: screenWidth * 0.25,
                        height: screenWidth * 0.12,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            'DREAM 11',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth * 0.02,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      // Cricket bat
                      Positioned(
                        top: screenWidth * 0.05,
                        right: screenWidth * 0.1,
                        child: Transform.rotate(
                          angle: -0.5,
                          child: Container(
                            width: screenWidth * 0.04,
                            height: screenWidth * 0.25,
                            color: Colors.grey[300],
                          ),
                        ),
                      ),
                      // Cricket stick
                      Positioned(
                        bottom: screenWidth * 0.05,
                        left: screenWidth * 0.1,
                        child: Transform.rotate(
                          angle: 0.7,
                          child: Container(
                            width: screenWidth * 0.03,
                            height: screenWidth * 0.25,
                            color: Colors.grey[300],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Ready to play text
          const Text(
            'Ready to Play? Join a match now.',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 24),

          // View upcoming matches button
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: Colors.grey[300]!),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text(
              'VIEW UPCOMING MATCHES',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}