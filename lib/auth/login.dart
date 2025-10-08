import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../service/user_service.dart'; // Backend service from code-2
import '../body/homescreen.dart';
import '../auth/signup.dart';

class Dream11LoginPage extends StatefulWidget {
  const Dream11LoginPage({Key? key}) : super(key: key);

  @override
  State<Dream11LoginPage> createState() => _Dream11LoginPageState();
}

class _Dream11LoginPageState extends State<Dream11LoginPage>
    with TickerProviderStateMixin {
  bool isAgeVerified = false;
  bool isLoading = false; // Backend integration from code-2
  String? errorMessage; // Error handling from code-2
  final TextEditingController mobileController = TextEditingController();
  final UserService _userService = UserService(); // Backend service

  // Animation controllers from both codes
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeService(); // Backend initialization from code-2
  }

  void _initializeAnimations() {
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    // Start animations
    _fadeController.forward();
    _slideController.forward();
    _scaleController.forward();
  }

  // Backend initialization from code-2
  Future<void> _initializeService() async {
    await _userService.initialize();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final bool isLoggedIn = await _userService.checkLoginStatus();
    if (isLoggedIn && mounted) {
      print('User is logged in with token: ${_userService.authToken}');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    }
  }

  // OTP request functionality from code-2 with enhanced UI feedback
  Future<void> _requestOtp() async {
    if (!isAgeVerified) {
      setState(() {
        errorMessage = "Please verify that you are above 18 years";
      });
      return;
    }

    String contact = mobileController.text;

    if (contact.isEmpty) {
      setState(() {
        errorMessage = "Please enter your mobile number";
      });
      return;
    }

    setState(() {
      errorMessage = null;
      isLoading = true;
    });

    try {
      bool success = await _userService.requestOtp(contact);

      if (success) {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                OTPVerificationScreen(
                  contact: contact,
                  isEmail: false, // Always false since we only have mobile
                  userService: _userService, // Pass the service
                ),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            },
          ),
        );
      } else {
        setState(() {
          errorMessage = "Failed to send OTP. Please try again.";
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "An error occurred: ${e.toString()}";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    _scaleController.dispose();
    mobileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenHeight = screenSize.height;
    final double screenWidth = screenSize.width;

    // Enhanced responsive breakpoints from code-1
    final bool isSmallPhone = screenHeight < 700;
    final bool isMediumPhone = screenHeight >= 700 && screenHeight < 800;
    final bool isLargePhone = screenHeight >= 800 && screenHeight < 900;
    final bool isTablet = screenWidth > 600;

    // Dynamic sizing based on screen size from code-1
    final double headerHeight = isSmallPhone
        ? screenHeight * 0.25
        : isMediumPhone
        ? screenHeight * 0.28
        : isLargePhone
        ? screenHeight * 0.32
        : screenHeight * 0.35;

    final double logoSize = isSmallPhone
        ? 48
        : isMediumPhone
        ? 56
        : isTablet
        ? 72
        : 64;

    final double titleFontSize = isSmallPhone
        ? 22
        : isMediumPhone
        ? 25
        : isTablet
        ? 32
        : 28;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0F0C29),
              Color(0xFF24243e),
              Color(0xFF302B63),
              Color(0xFF4A00E0),
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: screenHeight -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    // Compact Premium Header from code-1
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Container(
                        height: headerHeight,
                        width: double.infinity,
                        child: Stack(
                          children: [
                            // Reduced floating orbs for smaller screens
                            if (!isSmallPhone)
                              ...List.generate(4, (index) {
                                return AnimatedBuilder(
                                  animation: _fadeController,
                                  builder: (context, child) {
                                    return Positioned(
                                      left: (index * 90.0) % screenWidth,
                                      top: (index * 50.0) % headerHeight,
                                      child: Container(
                                        width: 15 + (index * 8.0),
                                        height: 15 + (index * 8.0),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: RadialGradient(
                                            colors: [
                                              Colors.white.withOpacity(0.2),
                                              Colors.transparent,
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }),

                            // Compact Header Content
                            Positioned(
                              top: isSmallPhone
                                  ? screenHeight * 0.05
                                  : screenHeight * 0.08,
                              left: screenWidth * 0.1,
                              right: screenWidth * 0.1,
                              child: SlideTransition(
                                position: _slideAnimation,
                                child: Container(
                                  padding: EdgeInsets.all(
                                    isSmallPhone
                                        ? screenWidth * 0.03
                                        : screenWidth * 0.04,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Colors.black.withOpacity(0.2),
                                        Colors.white.withOpacity(0.1),
                                      ],
                                    ),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.3),
                                      width: 1,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 12,
                                        offset: Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // Logo with enhanced error handling from code-1
                                      Container(
                                        padding: EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.0),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: _buildLogo(logoSize),
                                      ),
                                      SizedBox(height: isSmallPhone ? 8 : 12),
                                      Text(
                                        'Welcome Back',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.9),
                                          fontSize: isSmallPhone
                                              ? 12
                                              : isTablet
                                              ? 16
                                              : 14,
                                          fontWeight: FontWeight.w300,
                                          letterSpacing: 1.2,
                                        ),
                                      ),
                                      SizedBox(height: 2),
                                      ShaderMask(
                                        shaderCallback: (bounds) => LinearGradient(
                                          colors: [
                                            Colors.white,
                                            Color(0xFFFFD700),
                                            Colors.white,
                                          ],
                                        ).createShader(bounds),
                                        child: Text(
                                          'STAR 25 PRO',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: titleFontSize,
                                            fontWeight: FontWeight.w800,
                                            letterSpacing: 1.5,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: isSmallPhone ? 4 : 8),
                                      Text(
                                        'Where Champions Rise ⚡',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.8),
                                          fontSize: isSmallPhone
                                              ? 10
                                              : isTablet
                                              ? 14
                                              : 12,
                                          fontWeight: FontWeight.w400,
                                          letterSpacing: 0.8,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Flexible space
                    if (isSmallPhone)
                      SizedBox(height: 16)
                    else
                      SizedBox(height: 24),

                    // Compact Login Form
                    Expanded(
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.05,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.black.withOpacity(0.25),
                                Colors.white.withOpacity(0.1),
                              ],
                            ),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 30,
                                offset: Offset(0, 15),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(
                              isSmallPhone
                                  ? screenWidth * 0.04
                                  : screenWidth * 0.06,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(height: isSmallPhone ? 12 : 16),

                                // Mobile Number Title
                                Center(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: isSmallPhone ? 20 : 24,
                                      vertical: isSmallPhone ? 10 : 12,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0xFFFFD700),
                                          Color(0xFFFF6B35),
                                        ],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color:
                                          Color(0xFFFFD700).withOpacity(0.4),
                                          blurRadius: 15,
                                          offset: Offset(0, 5),
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      'Mobile Number',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: isSmallPhone
                                            ? 12
                                            : isTablet
                                            ? 16
                                            : 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),

                                SizedBox(height: isSmallPhone ? 20 : 24),

                                // Enhanced Input Field with improved styling
                                _buildCompactGlassInput(
                                  controller: mobileController,
                                  hint: 'Mobile number',
                                  icon: Icons.phone_outlined,
                                  keyboardType: TextInputType.phone,
                                  screenWidth: screenWidth,
                                  screenHeight: screenHeight,
                                  isSmallPhone: isSmallPhone,
                                  isTablet: isTablet,
                                ),

                                SizedBox(height: isSmallPhone ? 16 : 20),

                                // Enhanced Checkbox with better styling
                                _buildCompactGlassCheckbox(
                                  screenWidth,
                                  isSmallPhone,
                                  isTablet,
                                ),

                                // Error message display with enhanced styling from code-2
                                if (errorMessage != null) ...[
                                  SizedBox(height: isSmallPhone ? 12 : 16),
                                  Container(
                                    padding: EdgeInsets.all(isSmallPhone ? 8 : 12),
                                    decoration: BoxDecoration(
                                      color: Colors.red.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color: Colors.red.withOpacity(0.3)),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.error_outline,
                                            color: Colors.red,
                                            size: isSmallPhone ? 16 : 20),
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            errorMessage!,
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontSize: isSmallPhone
                                                  ? 10
                                                  : isTablet
                                                  ? 14
                                                  : 12,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],

                                SizedBox(height: isSmallPhone ? 20 : 24),

                                // Enhanced Continue Button with loading state
                                _buildCompactPremiumButton(
                                  screenWidth,
                                  screenHeight,
                                  isSmallPhone,
                                  isTablet,
                                ),

                                SizedBox(height: isSmallPhone ? 12 : 16),

                                // Enhanced Terms Text from code-1
                                Center(
                                  child: RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      text:
                                      'By continuing, You agree to get updates via SMS, Email & Whatsapp. ',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.7),
                                        fontSize: isSmallPhone
                                            ? 10
                                            : isTablet
                                            ? 14
                                            : 12,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: 'T&C',
                                          style: TextStyle(
                                            color: Color(0xFFFFD700),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        TextSpan(text: ' & '),
                                        TextSpan(
                                          text: 'Privacy Policy',
                                          style: TextStyle(
                                            color: Color(0xFFFFD700),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                SizedBox(height: isSmallPhone ? 16 : 20),

                                // Enhanced Divider
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: 1,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.transparent,
                                              Colors.white.withOpacity(0.5),
                                              Colors.transparent,
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: screenWidth * 0.04,
                                      ),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: isSmallPhone ? 12 : 16,
                                          vertical: isSmallPhone ? 6 : 8,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.white.withOpacity(0.2),
                                              Colors.white.withOpacity(0.1),
                                            ],
                                          ),
                                        ),
                                        child: Text(
                                          'OR',
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(0.8),
                                            fontSize: isSmallPhone
                                                ? 10
                                                : isTablet
                                                ? 14
                                                : 12,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 2,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        height: 1,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.transparent,
                                              Colors.white.withOpacity(0.5),
                                              Colors.transparent,
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: isSmallPhone ? 16 : 20),

                                // Register Link
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Don't have an account? ",
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.7),
                                        fontSize: isSmallPhone
                                            ? 12
                                            : isTablet
                                            ? 16
                                            : 14,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        HapticFeedback.lightImpact();
                                        Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            pageBuilder: (
                                                context,
                                                animation,
                                                secondaryAnimation,
                                                ) =>
                                                SignupPage(),
                                            transitionsBuilder: (
                                                context,
                                                animation,
                                                secondaryAnimation,
                                                child,
                                                ) {
                                              return SlideTransition(
                                                position: Tween<Offset>(
                                                  begin: const Offset(1.0, 0.0),
                                                  end: Offset.zero,
                                                ).animate(animation),
                                                child: child,
                                              );
                                            },
                                          ),
                                        );
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: isSmallPhone ? 10 : 12,
                                          vertical: isSmallPhone ? 4 : 6,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                          gradient: LinearGradient(
                                            colors: [
                                              Color(0xFFFFD700).withOpacity(0.3),
                                              Color(0xFFFFD700).withOpacity(0.1),
                                            ],
                                          ),
                                        ),
                                        child: Text(
                                          'Register Now',
                                          style: TextStyle(
                                            color: Color(0xFFFFD700),
                                            fontSize: isSmallPhone
                                                ? 12
                                                : isTablet
                                                ? 16
                                                : 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: isSmallPhone ? 12 : 16),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Bottom spacing
                    SizedBox(height: isSmallPhone ? 16 : 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Enhanced Logo widget from code-1 with better sizing
  Widget _buildLogo(double size) {
    final double newSize = size * 1.8; // increase by 80%
    return Container(
      width: newSize,
      height: newSize,
      child: Image.asset(
        'assets/images/star 20 pro logo - blue.png',
        width: newSize,
        height: newSize,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Icon(
            Icons.sports_cricket,
            size: newSize,
            color: Color(0xFFFFD700),
          );
        },
      ),
    );
  }

  // Enhanced Input Field from code-1 with better styling
  Widget _buildCompactGlassInput({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required TextInputType keyboardType,
    required double screenWidth,
    required double screenHeight,
    required bool isSmallPhone,
    required bool isTablet,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.2),
            Colors.white.withOpacity(0.1),
          ],
        ),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        style: TextStyle(
          fontSize: isSmallPhone
              ? 14
              : isTablet
              ? 18
              : 16,
          color: Colors.black, // Better visibility
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: '$hint ',
          hintStyle: TextStyle(
            color: Colors.black.withOpacity(0.6),
            fontSize: isSmallPhone
                ? 14
                : isTablet
                ? 18
                : 16,
          ),
          prefixIcon: Container(
            margin: EdgeInsets.all(isSmallPhone ? 8 : 10),
            padding: EdgeInsets.all(isSmallPhone ? 6 : 8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.4),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: Colors.white.withOpacity(0.8),
              size: isSmallPhone ? 18 : 20,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.transparent, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Color(0xFFFFD700), width: 2),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04,
            vertical: isSmallPhone ? 12 : 16,
          ),
        ),
      ),
    );
  }

  // Enhanced Checkbox from code-1
  Widget _buildCompactGlassCheckbox(
      double screenWidth,
      bool isSmallPhone,
      bool isTablet,
      ) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            HapticFeedback.selectionClick();
            setState(() => isAgeVerified = !isAgeVerified);
          },
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            width: isSmallPhone ? 24 : 28,
            height: isSmallPhone ? 24 : 28,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              gradient: isAgeVerified
                  ? LinearGradient(
                colors: [Color(0xFFFFD700), Color(0xFFFF6B35)],
              )
                  : null,
              border: Border.all(
                color: isAgeVerified
                    ? Colors.transparent
                    : Colors.white.withOpacity(0.5),
                width: 2,
              ),
              boxShadow: isAgeVerified
                  ? [
                BoxShadow(
                  color: Color(0xFFFFD700).withOpacity(0.4),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ]
                  : null,
            ),
            child: isAgeVerified
                ? Icon(
              Icons.check,
              color: Colors.white,
              size: isSmallPhone ? 14 : 16,
            )
                : null,
          ),
        ),
        SizedBox(width: screenWidth * 0.03),
        Expanded(
          child: Text(
            'I certify that I am above 18 years',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: isSmallPhone
                  ? 12
                  : isTablet
                  ? 16
                  : 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  // Enhanced Button with backend integration
  Widget _buildCompactPremiumButton(
      double screenWidth,
      double screenHeight,
      bool isSmallPhone,
      bool isTablet,
      ) {
    return GestureDetector(
      onTap: (isAgeVerified && !isLoading)
          ? () {
        HapticFeedback.lightImpact();
        _requestOtp(); // Call backend function from code-2
      }
          : null,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        width: double.infinity,
        height: isSmallPhone ? 48 : screenHeight * 0.06,
        decoration: BoxDecoration(
          gradient: (isAgeVerified && !isLoading)
              ? LinearGradient(
            colors: [
              Color(0xFFFFD700),
              Color(0xFFFF6B35),
              Color(0xFFE91E63),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
              : LinearGradient(
            colors: [
              Colors.grey.withOpacity(0.3),
              Colors.grey.withOpacity(0.2),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: (isAgeVerified && !isLoading)
              ? [
            BoxShadow(
              color: Color(0xFFFFD700).withOpacity(0.4),
              blurRadius: 16,
              offset: Offset(0, 6),
            ),
          ]
              : null,
        ),
        child: Center(
          child: isLoading
              ? CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2,
          )
              : Text(
            'CONTINUE',
            style: TextStyle(
              color: (isAgeVerified && !isLoading)
                  ? Colors.white
                  : Colors.white.withOpacity(0.5),
              fontSize: isSmallPhone
                  ? 14
                  : isTablet
                  ? 18
                  : 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
        ),
      ),
    );
  }
}

// Enhanced OTP Verification Screen with Backend Integration and Latest UI
class OTPVerificationScreen extends StatefulWidget {
  final String contact;
  final bool isEmail;
  final UserService userService; // Backend service

  const OTPVerificationScreen({
    Key? key,
    required this.contact,
    required this.isEmail,
    required this.userService,
  }) : super(key: key);

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen>
    with TickerProviderStateMixin {
  final List<TextEditingController> otpControllers =
  List.generate(6, (index) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(6, (index) => FocusNode());

  bool isOTPComplete = false;
  bool isVerifying = false; // Backend loading state
  String? errorMessage; // Backend error handling
  int resendTimer = 30;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    startResendTimer();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    for (var controller in otpControllers) {
      controller.addListener(_checkOTPComplete);
    }
  }

  void _checkOTPComplete() {
    setState(() {
      isOTPComplete = otpControllers.every(
            (controller) => controller.text.isNotEmpty,
      );
    });
  }

  void startResendTimer() {
    Future.delayed(Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          if (resendTimer > 0) {
            resendTimer--;
            startResendTimer();
          }
        });
      }
    });
  }

  // Backend OTP verification from code-2
  Future<void> _verifyOTP() async {
    if (!isOTPComplete) {
      setState(() {
        errorMessage = "Please enter the complete OTP";
      });
      return;
    }

    setState(() {
      isVerifying = true;
      errorMessage = null;
    });

    try {
      final otp = getOTP();
      final bool success = await widget.userService.verifyOtp(widget.contact, otp);

      if (success) {
        // SAVE LOGIN STATE - ADD THESE LINES
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('userContact', widget.contact);

        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const HomeScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      } else {
        setState(() {
          errorMessage = "Invalid OTP. Please try again.";
          // Clear OTP fields on error
          for (var controller in otpControllers) {
            controller.clear();
          }
          focusNodes[0].requestFocus();
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "An error occurred: ${e.toString()}";
      });
    } finally {
      setState(() {
        isVerifying = false;
      });
    }
  }

  // Backend OTP resend from code-2
  Future<void> _resendOTP() async {
    if (resendTimer > 0) return;

    setState(() {
      isVerifying = true;
      errorMessage = null;
    });

    try {
      final bool success = await widget.userService.requestOtp(widget.contact);

      if (success) {
        setState(() {
          resendTimer = 30;
          startResendTimer();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('OTP has been resent to ${widget.contact}'),
            backgroundColor: Color(0xFFFFD700),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        );
      } else {
        setState(() {
          errorMessage = "Failed to resend OTP. Please try again.";
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "An error occurred: ${e.toString()}";
      });
    } finally {
      setState(() {
        isVerifying = false;
      });
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    for (var controller in otpControllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  String getOTP() {
    return otpControllers.map((e) => e.text).join();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenHeight = screenSize.height;
    final double screenWidth = screenSize.width;
    final bool isTablet = screenWidth > 600;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0F0C29),
              Color(0xFF24243e),
              Color(0xFF302B63),
              Color(0xFF4A00E0),
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.all(screenWidth * 0.06),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Back Button
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),

                SizedBox(height: screenHeight * 0.05),

                // OTP Header with Animation
                ScaleTransition(
                  scale: _pulseAnimation,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Color(0xFFFFD700), Color(0xFFFF6B35)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFFFFD700).withOpacity(0.4),
                          blurRadius: 20,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Icon(Icons.security, color: Colors.white, size: 60),
                  ),
                ),

                SizedBox(height: screenHeight * 0.04),

                // Title
                Text(
                  'Verify Your ${widget.isEmail ? 'Email' : 'Phone'}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isTablet ? 28 : 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: screenHeight * 0.02),

                // Subtitle
                Text(
                  'We have sent a verification code to',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: isTablet ? 16 : 14,
                  ),
                ),

                SizedBox(height: screenHeight * 0.01),

                // Contact Display
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: Text(
                    widget.contact,
                    style: TextStyle(
                      color: Color(0xFFFFD700),
                      fontSize: isTablet ? 18 : 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                SizedBox(height: screenHeight * 0.05),

                // OTP Input Fields with enhanced visibility
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        'Enter OTP Code',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isTablet ? 18 : 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(6, (index) {
                          return _buildOTPField(index, isTablet);
                        }),
                      ),
                    ],
                  ),
                ),

                // Error message display
                if (errorMessage != null) ...[
                  SizedBox(height: screenHeight * 0.02),
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline, color: Colors.red, size: 20),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            errorMessage!,
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: isTablet ? 14 : 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                SizedBox(height: screenHeight * 0.04),

                // Enhanced Verify Button with backend integration
                GestureDetector(
                  onTap: (isOTPComplete && !isVerifying)
                      ? () {
                    HapticFeedback.lightImpact();
                    _verifyOTP(); // Call backend verification
                  }
                      : null,
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    width: double.infinity,
                    height: screenHeight * 0.07,
                    decoration: BoxDecoration(
                      gradient: (isOTPComplete && !isVerifying)
                          ? LinearGradient(
                        colors: [
                          Color(0xFFFFD700),
                          Color(0xFFFF6B35),
                          Color(0xFFE91E63),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                          : LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.3),
                          Colors.grey.withOpacity(0.2),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: (isOTPComplete && !isVerifying)
                          ? [
                        BoxShadow(
                          color: Color(0xFFFFD700).withOpacity(0.4),
                          blurRadius: 20,
                          offset: Offset(0, 8),
                        ),
                      ]
                          : null,
                    ),
                    child: Center(
                      child: isVerifying
                          ? CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      )
                          : Text(
                        'VERIFY OTP',
                        style: TextStyle(
                          color: (isOTPComplete && !isVerifying)
                              ? Colors.white
                              : Colors.white.withOpacity(0.5),
                          fontSize: isTablet ? 18 : 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: screenHeight * 0.03),

                // Resend OTP Section with backend integration
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Didn't receive the code? ",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: isTablet ? 16 : 14,
                      ),
                    ),
                    GestureDetector(
                      onTap: (resendTimer == 0 && !isVerifying)
                          ? () {
                        HapticFeedback.selectionClick();
                        _resendOTP(); // Call backend resend
                      }
                          : null,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: resendTimer == 0
                              ? Color(0xFFFFD700).withOpacity(0.2)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: resendTimer == 0
                                ? Color(0xFFFFD700)
                                : Colors.white.withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          resendTimer == 0
                              ? 'Resend OTP'
                              : 'Resend in ${resendTimer}s',
                          style: TextStyle(
                            color: resendTimer == 0
                                ? Color(0xFFFFD700)
                                : Colors.white.withOpacity(0.5),
                            fontSize: isTablet ? 16 : 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: screenHeight * 0.05),

                // Help Text
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.white.withOpacity(0.7),
                        size: 20,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'If you don\'t receive the OTP within 2 minutes, please check your spam folder or try again.',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: isTablet ? 14 : 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Enhanced OTP Field with better visibility
  Widget _buildOTPField(int index, bool isTablet) {
    return Container(
      width: isTablet ? 55 : 45,
      height: isTablet ? 55 : 45,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15), // Enhanced visibility
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: otpControllers[index].text.isNotEmpty
              ? Color(0xFFFFD700)
              : Colors.white.withOpacity(0.4),
          width: 2,
        ),
        boxShadow: otpControllers[index].text.isNotEmpty
            ? [
          BoxShadow(
            color: Color(0xFFFFD700).withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ]
            : null,
      ),
      child: TextFormField(
        controller: otpControllers[index],
        focusNode: focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: TextStyle(
          fontSize: isTablet ? 24 : 20,
          fontWeight: FontWeight.bold,
          color: Colors.black, // Better visibility
        ),
        cursorColor: Color(0xFFFFD700),
        decoration: InputDecoration(
          counterText: '',
          border: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFFFD700), width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white.withOpacity(0.4),
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          hintText: '•',
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.4),
            fontSize: 20,
          ),
        ),
        onChanged: (value) {
          if (value.isNotEmpty) {
            if (index < 5) {
              focusNodes[index + 1].requestFocus();
            } else {
              focusNodes[index].unfocus();
            }
          } else if (index > 0) {
            focusNodes[index - 1].requestFocus();
          }
        },
        onTap: () {
          otpControllers[index].selection = TextSelection.fromPosition(
            TextPosition(offset: otpControllers[index].text.length),
          );
        },
      ),
    );
  }
}