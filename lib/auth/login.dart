import 'package:fantasy/auth/signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../body/homescreen.dart';

class Dream11LoginPage extends StatefulWidget {
  const Dream11LoginPage({Key? key}) : super(key: key);

  @override
  State<Dream11LoginPage> createState() => _Dream11LoginPageState();
}

class _Dream11LoginPageState extends State<Dream11LoginPage>
    with TickerProviderStateMixin {
  bool isAgeVerified = false;
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController referralController = TextEditingController();

  late AnimationController _slideController;
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();

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

    _fadeController.forward();
    _slideController.forward();
    _scaleController.forward();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    String? loginTimeStr = prefs.getString('loginTime');
    if (loginTimeStr != null) {
      DateTime loginTime = DateTime.parse(loginTimeStr);
      DateTime now = DateTime.now();

      if (now.difference(loginTime).inDays > 30) {
        await _clearLoginState();
        isLoggedIn = false;
      }
    }

    if (isLoggedIn && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    }
  }

  Future<void> _clearLoginState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    await prefs.remove('userMobile');
    await prefs.remove('loginTime');
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    _scaleController.dispose();
    mobileController.dispose();
    referralController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenHeight = screenSize.height;
    final double screenWidth = screenSize.width;

    // Enhanced responsive breakpoints
    final bool isSmallPhone = screenHeight < 700;
    final bool isMediumPhone = screenHeight >= 700 && screenHeight < 800;
    final bool isLargePhone = screenHeight >= 800 && screenHeight < 900;
    final bool isTablet = screenWidth > 600;

    // Dynamic sizing based on screen size
    final double headerHeight =
        isSmallPhone
            ? screenHeight * 0.25
            : isMediumPhone
            ? screenHeight * 0.28
            : isLargePhone
            ? screenHeight * 0.32
            : screenHeight * 0.35;

    final double logoSize =
        isSmallPhone
            ? 48
            : isMediumPhone
            ? 56
            : isTablet
            ? 72
            : 64;

    final double titleFontSize =
        isSmallPhone
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
                minHeight:
                    screenHeight -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    // Compact Premium Header
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
                              top:
                                  isSmallPhone
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // Logo - now supports custom asset
                                      Container(
                                        padding: EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.0),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: _buildLogo(logoSize),
                                      ),
                                      SizedBox(height: isSmallPhone ? 8 : 12),
                                      Text(
                                        'Welcome Back',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.9),
                                          fontSize:
                                              isSmallPhone
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
                                        shaderCallback:
                                            (bounds) => LinearGradient(
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
                                          fontSize:
                                              isSmallPhone
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
                                          color: Color(
                                            0xFFFFD700,
                                          ).withOpacity(0.4),
                                          blurRadius: 15,
                                          offset: Offset(0, 5),
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      'Mobile Number',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                            isSmallPhone
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

                                // Input Field
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

                                // Compact Checkbox
                                _buildCompactGlassCheckbox(
                                  screenWidth,
                                  isSmallPhone,
                                  isTablet,
                                ),

                                SizedBox(height: isSmallPhone ? 20 : 24),

                                // Continue Button
                                _buildCompactPremiumButton(
                                  screenWidth,
                                  screenHeight,
                                  isSmallPhone,
                                  isTablet,
                                ),

                                SizedBox(height: isSmallPhone ? 12 : 16),

                                // Compact Terms Text
                                Center(
                                  child: RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      text:
                                          'By continuing, You agree to get updates via SMS, Email & Whatsapp. ',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.7),
                                        fontSize:
                                            isSmallPhone
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

                                // Compact Divider
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
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
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
                                            color: Colors.white.withOpacity(
                                              0.8,
                                            ),
                                            fontSize:
                                                isSmallPhone
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
                                        fontSize:
                                            isSmallPhone
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
                                            pageBuilder:
                                                (
                                                  context,
                                                  animation,
                                                  secondaryAnimation,
                                                ) => SignupPage(),
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
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                          gradient: LinearGradient(
                                            colors: [
                                              Color(
                                                0xFFFFD700,
                                              ).withOpacity(0.3),
                                              Color(
                                                0xFFFFD700,
                                              ).withOpacity(0.1),
                                            ],
                                          ),
                                        ),
                                        child: Text(
                                          'Register Now',
                                          style: TextStyle(
                                            color: Color(0xFFFFD700),
                                            fontSize:
                                                isSmallPhone
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

  // Logo widget that tries to load custom asset first, falls back to icon
  Widget _buildLogo(double size) {
    final double newSize = size * 1.8; // increase by 50%
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
          fontSize:
              isSmallPhone
                  ? 14
                  : isTablet
                  ? 18
                  : 16,
          color: Colors.black, // Changed to white for better visibility
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: '$hint ',
          hintStyle: TextStyle(
            color: Colors.black.withOpacity(0.6),
            fontSize:
                isSmallPhone
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
              gradient:
                  isAgeVerified
                      ? LinearGradient(
                        colors: [Color(0xFFFFD700), Color(0xFFFF6B35)],
                      )
                      : null,
              border: Border.all(
                color:
                    isAgeVerified
                        ? Colors.transparent
                        : Colors.white.withOpacity(0.5),
                width: 2,
              ),
              boxShadow:
                  isAgeVerified
                      ? [
                        BoxShadow(
                          color: Color(0xFFFFD700).withOpacity(0.4),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ]
                      : null,
            ),
            child:
                isAgeVerified
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
              fontSize:
                  isSmallPhone
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

  Widget _buildCompactPremiumButton(
    double screenWidth,
    double screenHeight,
    bool isSmallPhone,
    bool isTablet,
  ) {
    return GestureDetector(
      onTap:
          isAgeVerified
              ? () {
                HapticFeedback.lightImpact();
                if (mobileController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please enter your mobile number'),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  );
                  return;
                }
                String contact = mobileController.text;
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder:
                        (context, animation, secondaryAnimation) =>
                            OTPVerificationScreen(
                              contact: contact,
                              isEmail: false,
                            ),
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
              }
              : null,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        width: double.infinity,
        height: isSmallPhone ? 48 : screenHeight * 0.06,
        decoration: BoxDecoration(
          gradient:
              isAgeVerified
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
          boxShadow:
              isAgeVerified
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
          child: Text(
            'CONTINUE',
            style: TextStyle(
              color:
                  isAgeVerified ? Colors.white : Colors.white.withOpacity(0.5),
              fontSize:
                  isSmallPhone
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

// OTP Verification Screen with improved visibility
class OTPVerificationScreen extends StatefulWidget {
  final String contact;
  final bool isEmail;

  const OTPVerificationScreen({
    Key? key,
    required this.contact,
    required this.isEmail,
  }) : super(key: key);

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen>
    with TickerProviderStateMixin {
  final List<TextEditingController> otpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> focusNodes = List.generate(6, (index) => FocusNode());

  bool isOTPComplete = false;
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

  Future<void> _saveLoginState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('userMobile', widget.contact);
    await prefs.setString('loginTime', DateTime.now().toIso8601String());
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

                // OTP Input Fields
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

                SizedBox(height: screenHeight * 0.04),

                // Verify Button
                GestureDetector(
                  onTap: isOTPComplete ? _verifyOTP : null,
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    width: double.infinity,
                    height: screenHeight * 0.07,
                    decoration: BoxDecoration(
                      gradient:
                          isOTPComplete
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
                      boxShadow:
                          isOTPComplete
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
                      child: Text(
                        'VERIFY OTP',
                        style: TextStyle(
                          color:
                              isOTPComplete
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

                // Resend OTP Section
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
                      onTap: resendTimer == 0 ? _resendOTP : null,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color:
                              resendTimer == 0
                                  ? Color(0xFFFFD700).withOpacity(0.2)
                                  : Colors.transparent,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color:
                                resendTimer == 0
                                    ? Color(0xFFFFD700)
                                    : Colors.white.withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          resendTimer == 0
                              ? 'Resend OTP'
                              : 'Resend in ${resendTimer}s',
                          style: TextStyle(
                            color:
                                resendTimer == 0
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

  Widget _buildOTPField(int index, bool isTablet) {
    return Container(
      width: isTablet ? 55 : 45,
      height: isTablet ? 55 : 45,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(
          0.15,
        ), // Increased opacity for better visibility
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              otpControllers[index].text.isNotEmpty
                  ? Color(0xFFFFD700)
                  : Colors.white.withOpacity(0.4),
          width: 2,
        ),
        boxShadow:
            otpControllers[index].text.isNotEmpty
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
          color: Colors.black, // White text for visibility on dark background
        ),
        cursorColor: Color(0xFFFFD700), // Gold cursor to match theme
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
          hintText: '•', // Optional: faint dot to indicate empty field
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

  void _verifyOTP() async {
    String otp = otpControllers.map((controller) => controller.text).join();

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => Center(
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.white.withOpacity(0.3)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFFFFD700),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Verifying OTP...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
    );

    // Simulate API call
    await Future.delayed(Duration(seconds: 2));

    // Close loading dialog
    Navigator.pop(context);

    // For demo purposes, accept any 6-digit OTP
    if (otp.length == 6) {
      // Save login state
      await _saveLoginState();
      // Show success message
      _showSuccessDialog();
    } else {
      // Show error message
      _showErrorDialog();
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: Colors.black.withOpacity(0.85),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Color(0xFFFFD700), Color(0xFFFF6B35)],
                      ),
                    ),
                    child: Icon(Icons.check, color: Colors.white, size: 45),
                  ),
                  SizedBox(height: 25),
                  Text(
                    'Success!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Your account has been verified successfully.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFF6B35),
                      padding: EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                        (route) => false,
                      );
                    },
                    child: Text(
                      'Continue to Home',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder:
          (context) => Center(
            child: Container(
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.3)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Colors.red, Colors.redAccent],
                      ),
                    ),
                    child: Icon(
                      Icons.error_outline,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Verification Failed',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Invalid OTP. Please check and try again.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 30),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      for (var controller in otpControllers) {
                        controller.clear();
                      }
                      focusNodes[0].requestFocus();
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.red, Colors.redAccent],
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: Text(
                          'Try Again',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  void _resendOTP() {
    setState(() {
      resendTimer = 30;
    });
    startResendTimer();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('OTP has been resent to ${widget.contact}'),
        backgroundColor: Color(0xFFFFD700),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );

    // In real app, trigger API call to resend OTP
    // _apiService.resendOTP(widget.contact);
  }
}

// Placeholder classes for missing dependencies
