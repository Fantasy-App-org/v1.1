import 'package:fantasy/auth/signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../auth/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _titleController;
  late AnimationController _taglineController;
  late AnimationController _backgroundController;
  late AnimationController _particleController;

  late Animation<double> _logoScale;
  late Animation<double> _logoRotation;
  late Animation<double> _titleOpacity;
  late Animation<Offset> _titleSlide;
  late Animation<double> _taglineOpacity;
  late Animation<Offset> _taglineSlide;
  late Animation<double> _backgroundOpacity;
  late Animation<double> _particleAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _titleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _taglineController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _backgroundController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _particleController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    // Initialize animations
    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );

    _logoRotation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeInOut),
    );

    _titleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _titleController, curve: Curves.easeIn),
    );

    _titleSlide = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _titleController, curve: Curves.easeOutCubic),
    );

    _taglineOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _taglineController, curve: Curves.easeIn),
    );

    _taglineSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _taglineController, curve: Curves.easeOutCubic),
    );

    _backgroundOpacity = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _backgroundController, curve: Curves.easeInOut),
    );

    _particleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _particleController, curve: Curves.linear),
    );

    // Start animations sequence
    _startAnimations();

    // Navigate to signup screen after animations
    Future.delayed(const Duration(milliseconds: 3500), () {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const SignupPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    });
  }

  void _startAnimations() async {
    // Add haptic feedback
    HapticFeedback.lightImpact();

    _backgroundController.forward();
    _particleController.repeat();

    await Future.delayed(const Duration(milliseconds: 200));
    _logoController.forward();

    await Future.delayed(const Duration(milliseconds: 600));
    _titleController.forward();

    await Future.delayed(const Duration(milliseconds: 300));
    _taglineController.forward();
  }

  @override
  void dispose() {
    _logoController.dispose();
    _titleController.dispose();
    _taglineController.dispose();
    _backgroundController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _logoController,
          _titleController,
          _taglineController,
          _backgroundController,
          _particleController,
        ]),
        builder: (context, child) {
          return Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF1A1D48).withOpacity(_backgroundOpacity.value),
                  const Color(0xFF2D1B69).withOpacity(_backgroundOpacity.value),
                  const Color(0xFF8B3DB3).withOpacity(_backgroundOpacity.value * 0.8),
                ],
              ),
            ),
            child: Stack(
              children: [
                // Background image with opacity
                Opacity(
                  opacity: 0.3,
                  child: Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/background_2.jpeg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),

                // Animated particles
                ...List.generate(8, (index) => _buildParticle(index)),

                // Glowing orbs
                _buildGlowingOrb(
                  top: 100,
                  left: 50,
                  color: const Color(0xFFB956D7).withOpacity(0.3),
                  size: 80,
                ),
                _buildGlowingOrb(
                  bottom: 150,
                  right: 40,
                  color: const Color(0xFF8B3DB3).withOpacity(0.2),
                  size: 120,
                ),

                // Main content
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Animated logo with glow effect
                      Transform.scale(
                        scale: _logoScale.value,
                        child: Transform.rotate(
                          angle: _logoRotation.value * 0.1,
                          child: Container(
                            height: 120,
                            width: 120,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xFFFFD700),
                                  Color(0xFFB956D7),
                                  Color(0xFF8B3DB3),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(60),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFB956D7).withOpacity(0.6),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                                BoxShadow(
                                  color: const Color(0xFFFFD700).withOpacity(0.3),
                                  blurRadius: 30,
                                  spreadRadius: 10,
                                ),
                              ],
                            ),
                            child: Center(
                              child: Container(
                                height: 70,
                                width: 70,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(35),
                                ),
                                child: Center(
                                  child: Image.asset(
                                    'assets/images/app_logo_dpl.png',
                                    height: 50,
                                    width: 50,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Animated title
                      SlideTransition(
                        position: _titleSlide,
                        child: FadeTransition(
                          opacity: _titleOpacity,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white.withOpacity(0.1),
                                  Colors.white.withOpacity(0.05),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: ShaderMask(
                              shaderCallback: (bounds) => const LinearGradient(
                                colors: [
                                  Color(0xFFFFD700),
                                  Color(0xFFFFFFFF),
                                  Color(0xFFB956D7),
                                ],
                              ).createShader(bounds),
                              child: const Text(
                                'STAR25PRO',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  letterSpacing: 2,
                                  shadows: [
                                    Shadow(
                                      color: Color(0xFFB956D7),
                                      offset: Offset(0, 2),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Animated tagline
                      SlideTransition(
                        position: _taglineSlide,
                        child: FadeTransition(
                          opacity: _taglineOpacity,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0xFFB956D7).withOpacity(0.2),
                                  Colors.transparent,
                                  const Color(0xFFFFD700).withOpacity(0.2),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Play Hard! ',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.white.withOpacity(0.9),
                                      shadows: const [
                                        Shadow(
                                          color: Color(0xFF1A1D48),
                                          offset: Offset(1, 1),
                                          blurRadius: 2,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const TextSpan(
                                    text: 'Earn Daily!',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      fontStyle: FontStyle.italic,
                                      color: Color(0xFFFFD700),
                                      shadows: [
                                        Shadow(
                                          color: Color(0xFF1A1D48),
                                          offset: Offset(1, 1),
                                          blurRadius: 2,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Loading indicator
                      FadeTransition(
                        opacity: _taglineOpacity,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFFD700), Color(0xFFB956D7)],
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildParticle(int index) {
    final double animationOffset = (index * 0.2) % 1.0;
    final double adjustedAnimation = (_particleAnimation.value + animationOffset) % 1.0;

    return Positioned(
      left: (index * 50.0) % MediaQuery.of(context).size.width,
      top: MediaQuery.of(context).size.height * adjustedAnimation,
      child: Opacity(
        opacity: (1.0 - adjustedAnimation) * 0.7,
        child: Container(
          width: 4,
          height: 4,
          decoration: BoxDecoration(
            color: index % 2 == 0 ? const Color(0xFFFFD700) : const Color(0xFFB956D7),
            borderRadius: BorderRadius.circular(2),
            boxShadow: [
              BoxShadow(
                color: (index % 2 == 0 ? const Color(0xFFFFD700) : const Color(0xFFB956D7))
                    .withOpacity(0.5),
                blurRadius: 4,
                spreadRadius: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlowingOrb({
    double? top,
    double? bottom,
    double? left,
    double? right,
    required Color color,
    required double size,
  }) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [
              color,
              color.withOpacity(0.3),
              Colors.transparent,
            ],
          ),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}