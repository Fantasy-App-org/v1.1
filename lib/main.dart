
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'body/homescreen.dart';
import 'body/refral.dart';
import 'auth/signup.dart';
import 'body/splash.dart';
import 'body/welcome.dart';

// Screens


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Set status bar to transparent with dark icons (for white background)
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark, // Dark icons for white background
    ),
  );
  runApp(const StarFantasyApp());
}

class StarFantasyApp extends StatelessWidget {
  const StarFantasyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'STAR25PRO',
      theme: ThemeData(
        primaryColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Roboto',
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black87),
          bodyMedium: TextStyle(color: Colors.black87),
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: Colors.red, // Red accent color from Dream11
          primary: Colors.black, // Black for headers
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          fillColor: const Color(0xFFF5F5F5), // Light gray background for inputs
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.red),
          ),
          labelStyle: TextStyle(color: Colors.grey.shade700),
          hintStyle: TextStyle(color: Colors.grey.shade500),
        ),
        // Add card theme for match cards and other containers
        cardTheme: CardTheme(
          color: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.shade200),
          ),
        ),
        // Customize divider theme
        dividerTheme: DividerThemeData(
          color: Colors.grey.shade200,
          thickness: 1,
          space: 1,
        ),
        // Icon theme
        iconTheme: IconThemeData(
          color: Colors.grey.shade700,
        ),
        // Bottom navigation bar theme
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: Colors.red,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
        ),
      ),
      // Start with the splash screen
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
         '/welcome': (context) => const WelcomeScreen(),
        '/signup': (context) => const SignupPage(),
        '/home': (context) => const HomeScreen(),
        '/referral': (context) => const ReferralScreen(),
      },
    );
  }
}

// Utility classes and widgets used across the app

// Custom Star painter
class StarPainter extends CustomPainter {
  final Color color;

  StarPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
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

// Gradient Star painter
class GradientStarPainter extends CustomPainter {
  final List<Color> colors;

  GradientStarPainter({required this.colors});

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

// Button with Red Background (previously Purple)
class ActionButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Widget? icon;
  final double width;

  const ActionButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.width = double.infinity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              icon!,
              const SizedBox(width: 10),
            ],
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Match Card Widget - Updated for white theme
class MatchCard extends StatelessWidget {
  final String team1Name;
  final String team1ShortName;
  final String team1Logo;
  final String team2Name;
  final String team2ShortName;
  final String team2Logo;
  final String time;
  final String matchTime;
  final String prize;
  final VoidCallback? onTap;

  const MatchCard({
    Key? key,
    required this.team1Name,
    required this.team1ShortName,
    required this.team1Logo,
    required this.team2Name,
    required this.team2ShortName,
    required this.team2Logo,
    required this.time,
    required this.matchTime,
    required this.prize,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
          children: [
            // League header
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Text(
                    '$team1Name vs $team2Name',
                    style: const TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  // Bookmark icon
                  Icon(Icons.bookmark_outline, color: Colors.grey.shade500),
                ],
              ),
            ),

            const Divider(height: 1, thickness: 1, color: Color(0xFFF5F5F5)),

            // Teams and match info
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Team 1
                  Column(
                    children: [
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
                              backgroundColor: Colors.blue[300],
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
                          team1Name,
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

                  // Match time info
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        time,
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (matchTime.isNotEmpty)
                        const SizedBox(height: 4),
                      if (matchTime.isNotEmpty)
                        Text(
                          matchTime,
                          style: const TextStyle(
                            color: Colors.green,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                    ],
                  ),

                  // Team 2
                  Column(
                    children: [
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
                              backgroundColor: Colors.amber,
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
                          team2Name,
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
                  const Text(
                    'Open',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}