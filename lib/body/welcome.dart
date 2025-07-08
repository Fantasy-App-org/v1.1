import 'package:flutter/material.dart';

import 'homescreen.dart';
import '../auth/login.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo and cricket equipment pattern
            Container(
              height: MediaQuery.of(context).size.height * 0.7,
              decoration: const BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                  image: AssetImage('assets/cricket_pattern.png'),
                  fit: BoxFit.cover,
                  opacity: 0.15, // Faded pattern
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Star Logo
                    Container(
                      width: 80,
                      height: 80,
                      child: CustomPaint(
                        painter: StarPainter(
                          // Gradient from pink to purple
                          colors: [
                            const Color(0xFFE066FF),
                            const Color(0xFF9333EA),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // App Name
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'STAR',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          '25',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFB956D7),
                          ),
                        ),
                        Text(
                          'PRO',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Tagline
                    RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: 'Play Hard! ',
                            style: TextStyle(
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: 'Earn Daily!',
                            style: TextStyle(
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                              color: Color(0xFFB956D7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Get Started button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const Dream11LoginPage(), // Replace with your login screen
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFB956D7), Color(0xFF8B3DB3)],
                    ),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Center(
                    child: Text(
                      'GET STARTED',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom Star painter with gradient
class StarPainter extends CustomPainter {
  final List<Color> colors;

  StarPainter({required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final gradient = LinearGradient(
      colors: colors,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    final Paint paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.fill;

    final double width = size.width;
    final double height = size.height;

    final Path path = Path();

    // Draw a 5-point star
    path.moveTo(width * 0.5, 0);
    path.lineTo(width * 0.618, height * 0.382);
    path.lineTo(width, height * 0.382);
    path.lineTo(width * 0.691, height * 0.618);
    path.lineTo(width * 0.809, height);
    path.lineTo(width * 0.5, height * 0.765);
    path.lineTo(width * 0.191, height);
    path.lineTo(width * 0.309, height * 0.618);
    path.lineTo(0, height * 0.382);
    path.lineTo(width * 0.382, height * 0.382);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}