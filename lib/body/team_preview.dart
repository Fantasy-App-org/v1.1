import 'dart:math' as math;
import 'package:flutter/material.dart';

class TeamPreviewPage extends StatelessWidget {
  final String playerName;
  final String totalPoints;

  const TeamPreviewPage({
    Key? key,
    required this.playerName,
    required this.totalPoints,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final availableHeight = screenHeight - kToolbarHeight - MediaQuery.of(context).padding.top - 180;

    return Scaffold(
      backgroundColor: const Color(0xFF059669),
      appBar: AppBar(
        backgroundColor: const Color(0xFF059669),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Team Preview',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Header with Completed status
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF10B981).withOpacity(0.8),
                  const Color(0xFF059669),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.check_circle,
                  color: Colors.white,
                  size: 16,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Completed',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // Cricket Field Layout
          Container(
            height: availableHeight,
            width: screenWidth,
            child: CustomPaint(
              painter: CricketFieldPainter(),
              child: Stack(
                children: [
                  // Wicket Keepers (Top)
                  Positioned(
                    top: availableHeight * 0.08,
                    left: 0,
                    right: 0,
                    child: Column(
                      children: [
                        Text(
                          'WICKET KEEPER',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth * 0.025,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildPlayerCard('V Vadakke...', '55.0 Pts', true, false, screenWidth),
                            _buildPlayerCard('S Balakrishn...', '105.0 Pts', true, true, screenWidth),
                            _buildPlayerCard('J Cholayil', '96.0 Pts', true, false, screenWidth),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Batsmen (Upper Middle)
                  Positioned(
                    top: availableHeight * 0.25,
                    left: 0,
                    right: 0,
                    child: Column(
                      children: [
                        Text(
                          'BATSMAN',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth * 0.025,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: screenWidth * 0.02,
                          runSpacing: 8,
                          children: [
                            _buildPlayerCard('S Sudhaka...', '40.0 Pts', true, false, screenWidth),
                            _buildPlayerCard('SR Henry', '23.0 Pts', false, false, screenWidth),
                            _buildPlayerCard('R Kumar', '5.0 Pts', true, false, screenWidth),
                            _buildPlayerCard('AFA Kadar', '41.0 Pts', false, false, screenWidth),
                            _buildPlayerCard('J Cyril', '11.0 Pts', false, false, screenWidth),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // All Rounders (Center)
                  Positioned(
                    top: availableHeight * 0.5,
                    left: 0,
                    right: 0,
                    child: Column(
                      children: [
                        Text(
                          'ALL ROUNDER',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth * 0.025,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildPlayerCard('R Raj', '346.5 Pts', true, true, screenWidth),
                            _buildPlayerCard('IH Banwa', '92.0 Pts', false, false, screenWidth),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Bowlers (Bottom)
                  Positioned(
                    bottom: availableHeight * 0.08,
                    left: 0,
                    right: 0,
                    child: Column(
                      children: [
                        Text(
                          'BOWLER',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth * 0.025,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildPlayerCard('A Kumar', '45.0 Pts', true, false, screenWidth),
                            _buildPlayerCard('M Singh', '38.0 Pts', false, false, screenWidth),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Stats Card
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.black.withOpacity(0.9),
                  Colors.black.withOpacity(0.7),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            playerName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Colors.amber, Colors.orange],
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'Rank: #1',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '$totalPoints Points',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFF10B981),
                            ),
                          ),
                          child: Text(
                            'Prize: ₹2,500',
                            style: TextStyle(
                              color: Colors.green[300],
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
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
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem('Teams', '11', Icons.groups),
                    _buildStatItem('Captain', '1', Icons.stars),
                    _buildStatItem('V.Captain', '1', Icons.star_border),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerCard(
      String name,
      String points,
      bool isSelected,
      bool isCaptain,
      double screenWidth,
      ) {
    double cardSize = screenWidth * 0.12;
    double iconSize = cardSize * 0.5;

    return Container(
      width: cardSize + 10,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: cardSize,
            height: cardSize,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isSelected
                    ? [Colors.blue[400]!, Colors.blue[600]!]
                    : [Colors.yellow[400]!, Colors.yellow[600]!],
              ),
              borderRadius: BorderRadius.circular(cardSize / 2),
              border: Border.all(
                color: isCaptain ? Colors.orange : Colors.white,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Stack(
              children: [
                Center(
                  child: Icon(
                    Icons.sports_cricket,
                    size: iconSize,
                    color: Colors.white,
                  ),
                ),
                if (isCaptain)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: cardSize * 0.35,
                      height: cardSize * 0.35,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.orange, Colors.deepOrange],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          'C',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: cardSize * 0.2,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            name,
            style: TextStyle(
              color: Colors.white,
              fontSize: screenWidth * 0.02,
              fontWeight: FontWeight.w500,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            points,
            style: TextStyle(
              color: Colors.white70,
              fontSize: screenWidth * 0.018,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: 20,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

// Custom painter for circular cricket field
class CricketFieldPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double radius = math.min(size.width, size.height) / 2 - 20;
    Offset center = Offset(size.width / 2, size.height / 2);

    // Draw green field background (circle)
    final Paint fieldPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF10B981),
          const Color(0xFF059669),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, fieldPaint);

    // Draw field boundary (circle outline)
    final Paint boundaryPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, radius, boundaryPaint);

    // Draw pitch (rectangle in center)
    final Paint pitchPaint = Paint()
      ..color = Colors.brown.withOpacity(0.4)
      ..style = PaintingStyle.fill;

    final Rect pitchRect = Rect.fromCenter(
      center: center,
      width: radius * 0.15,
      height: radius * 0.8,
    );
    canvas.drawRect(pitchRect, pitchPaint);

    // Draw pitch outline
    final Paint pitchOutlinePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawRect(pitchRect, pitchOutlinePaint);

    // Draw center circle
    final Paint circlePaint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, radius * 0.25, circlePaint);

    // Draw inner circle (30-yard circle)
    final Paint innerCirclePaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, radius * 0.6, innerCirclePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}