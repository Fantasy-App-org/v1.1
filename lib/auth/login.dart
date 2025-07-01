import 'package:fantasy/auth/signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
            child: Column(
              children: [
                // Premium Animated Header
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Container(
                    height: screenHeight * 0.4,
                    width: double.infinity,
                    child: Stack(
                      children: [
                        // Floating Orbs Background
                        ...List.generate(6, (index) {
                          return AnimatedBuilder(
                            animation: _fadeController,
                            builder: (context, child) {
                              return Positioned(
                                left: (index * 80.0) % screenWidth,
                                top: (index * 60.0) % (screenHeight * 0.4),
                                child: Container(
                                  width: 20 + (index * 10.0),
                                  height: 20 + (index * 10.0),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: RadialGradient(
                                      colors: [
                                        Colors.white.withOpacity(0.3),
                                        Colors.transparent,
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }),

                        // Glassmorphism Header Content
                        Positioned(
                          top: screenHeight * 0.1,
                          left: screenWidth * 0.1,
                          right: screenWidth * 0.1,
                          child: SlideTransition(
                            position: _slideAnimation,
                            child: Container(
                              padding: EdgeInsets.all(screenWidth * 0.05),
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
                                children: [
                                  // Centered and larger logo
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.0),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Image.asset(
                                      'assets/images/star 20 pro logo mark blue (1).png',
                                      height: 64, // increased size
                                      width: 64,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.015),
                                  Text(
                                    'Welcome Back',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.9),
                                      fontSize: isTablet ? 16 : 14,
                                      fontWeight: FontWeight.w300,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                  SizedBox(height: 4),
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
                                        fontSize: isTablet ? 30 : 28,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 1.5,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.008),
                                  Text(
                                    'Where Champions Rise ⚡',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.8),
                                      fontSize: isTablet ? 14 : 12,
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

                // Glassmorphism Login Form
                ScaleTransition(
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
                      padding: EdgeInsets.all(screenWidth * 0.06),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: screenHeight * 0.02),

                          // Mobile Number Title
                          Center(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
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
                                    color: Color(0xFFFFD700).withOpacity(0.4),
                                    blurRadius: 15,
                                    offset: Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Text(
                                'Mobile Number',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: isTablet ? 16 : 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: screenHeight * 0.04),

                          // Glassmorphism Input Field
                          _buildGlassInput(
                            controller: mobileController,
                            hint: 'Mobile number',
                            icon: Icons.phone_outlined,
                            keyboardType: TextInputType.phone,
                            screenWidth: screenWidth,
                            screenHeight: screenHeight,
                            isTablet: isTablet,
                          ),

                          SizedBox(height: screenHeight * 0.03),

                          // Animated Checkbox
                          _buildGlassCheckbox(
                            screenWidth,
                            screenHeight,
                            isTablet,
                          ),

                          SizedBox(height: screenHeight * 0.04),

                          // Premium Continue Button
                          _buildPremiumButton(
                            screenWidth,
                            screenHeight,
                            isTablet,
                          ),

                          SizedBox(height: screenHeight * 0.02),

                          // Terms Text with Gradient
                          Center(
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                text: 'By continuing,You agree to get all updates via SMS, RCS, Email, Whatsapp and any other marketing Communications. ',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: isTablet ? 14 : 12,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Terms & Conditions',
                                    style: TextStyle(
                                      color: Color(0xFFFFD700),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  TextSpan(text: ' and '),
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

                          SizedBox(height: screenHeight * 0.03),

                          // Animated Divider
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
                                    horizontal: 16,
                                    vertical: 8,
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
                                      fontSize: isTablet ? 14 : 12,
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

                          SizedBox(height: screenHeight * 0.03),

                          SizedBox(height: screenHeight * 0.03),

                          // Register Link with Animation
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account? ",
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: isTablet ? 16 : 14,
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
                                    horizontal: 12,
                                    vertical: 6,
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
                                      fontSize: isTablet ? 16 : 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: screenHeight * 0.03),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.05),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGlassInput({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required TextInputType keyboardType,
    required double screenWidth,
    required double screenHeight,
    required bool isTablet,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
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
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      // Option 1: Using TextFormField (Recommended for validation)
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        style: TextStyle(
          fontSize: isTablet ? 18 : 16,
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: '$hint ', // Added asterisk to indicate required field
          hintStyle: TextStyle(
            color: Colors.black.withOpacity(0.6),
            fontSize: isTablet ? 18 : 16,
          ),
          prefixIcon: Container(
            margin: EdgeInsets.all(12),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.4),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white.withOpacity(0.8), size: 20),
          ),
          // Add a red asterisk suffix to emphasize required field
          suffixIcon: Padding(
            padding: EdgeInsets.only(right: 16, top: 14),
            child: Text(
              '',
              style: TextStyle(
                color: Colors.red,
                fontSize: isTablet ? 20 : 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Add border styling for different states
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.grey.withOpacity(0.3),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.blue, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red, width: 2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red, width: 2),
          ),
          errorStyle: TextStyle(
            color: Colors.red,
            fontSize: isTablet ? 14 : 12,
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04,
            vertical: screenHeight * 0.02,
          ),
        ),
        // Validation logic
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'This field is required';
          }
          // Add additional validation rules as needed
          // if (value.length < 3) {
          //   return 'Must be at least 3 characters';
          // }
          return null;
        },
        // Auto-validate on user interaction
        autovalidateMode: AutovalidateMode.onUserInteraction,
      ),
    );
  }

  Widget _buildGlassCheckbox(
    double screenWidth,
    double screenHeight,
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
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
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
                          blurRadius: 10,
                          offset: Offset(0, 3),
                        ),
                      ]
                      : null,
            ),
            child:
                isAgeVerified
                    ? Icon(Icons.check, color: Colors.white, size: 18)
                    : null,
          ),
        ),
        SizedBox(width: screenWidth * 0.03),
        Expanded(
          child: Text(
            'I certify that I am above 18 years',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: isTablet ? 16 : 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPremiumButton(
    double screenWidth,
    double screenHeight,
    bool isTablet,
  ) {
    return GestureDetector(
      onTap:
          isAgeVerified
              ? () {
                HapticFeedback.lightImpact();
                String contact = mobileController.text;
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder:
                        (context, animation, secondaryAnimation) =>
                            OTPVerificationScreen(
                              contact: contact,
                              isEmail: false,
                            ), // Always false since we removed email
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
        height: screenHeight * 0.07,
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
          borderRadius: BorderRadius.circular(20),
          boxShadow:
              isAgeVerified
                  ? [
                    BoxShadow(
                      color: Color(0xFFFFD700).withOpacity(0.4),
                      blurRadius: 20,
                      offset: Offset(0, 8),
                    ),
                    BoxShadow(
                      color: Color(0xFFFF6B35).withOpacity(0.3),
                      blurRadius: 15,
                      offset: Offset(0, 4),
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
              fontSize: isTablet ? 18 : 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPremiumSocialButton(
    String text,
    IconData icon,
    Color bgColor,
    Color textColor,
    double screenWidth,
    double screenHeight,
    bool isTablet,
  ) {
    return Container(
      width: double.infinity,
      height: screenHeight * 0.06,
      decoration: BoxDecoration(
        color: bgColor.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: bgColor.withOpacity(0.3),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: textColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: textColor, size: 20),
          ),
          SizedBox(width: screenWidth * 0.03),
          Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: isTablet ? 16 : 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// Enhanced OTP Verification Screen
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

                SizedBox(height: screenHeight * 0.04),

                // Animated OTP Icon
                AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _pulseAnimation.value,
                      child: Container(
                        padding: EdgeInsets.all(25),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFFFFD700).withOpacity(0.3),
                              Color(0xFFFF6B35).withOpacity(0.2),
                            ],
                          ),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFFFFD700).withOpacity(0.3),
                              blurRadius: 20,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.security,
                          size: 60,
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                ),

                SizedBox(height: screenHeight * 0.04),

                // Title with Gradient
                ShaderMask(
                  shaderCallback:
                      (bounds) => LinearGradient(
                        colors: [Colors.white, Color(0xFFFFD700)],
                      ).createShader(bounds),
                  child: Text(
                    'OTP Verification',
                    style: TextStyle(
                      fontSize: isTablet ? 32 : 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),

                SizedBox(height: screenHeight * 0.02),

                // Description
                Text(
                  'Enter the verification code sent to',
                  style: TextStyle(
                    fontSize: isTablet ? 16 : 14,
                    color: Colors.white.withOpacity(0.8),
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: screenHeight * 0.01),

                // Contact Display with Glass Effect
                // Contact Display with Glass Effect
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.2),
                        Colors.white.withOpacity(0.1),
                      ],
                    ),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: Text(
                    widget.contact,
                    style: TextStyle(
                      fontSize: isTablet ? 18 : 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFFFD700),
                    ),
                  ),
                ),

                SizedBox(height: screenHeight * 0.05),

                // OTP Input Fields
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(6, (index) {
                    return Container(
                      width: isTablet ? 60 : 50,
                      height: isTablet ? 60 : 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.2),
                            Colors.white.withOpacity(0.1),
                          ],
                        ),
                        border: Border.all(
                          color:
                              otpControllers[index].text.isNotEmpty
                                  ? Color(0xFFFFD700)
                                  : Colors.white.withOpacity(0.3),
                          width: 2,
                        ),
                        boxShadow:
                            otpControllers[index].text.isNotEmpty
                                ? [
                                  BoxShadow(
                                    color: Color(0xFFFFD700).withOpacity(0.3),
                                    blurRadius: 10,
                                    offset: Offset(0, 5),
                                  ),
                                ]
                                : null,
                      ),
                      child: TextField(
                        controller: otpControllers[index],
                        focusNode: focusNodes[index],
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        style: TextStyle(
                          fontSize: isTablet ? 24 : 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          counterText: '',
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          if (value.isNotEmpty && index < 5) {
                            focusNodes[index + 1].requestFocus();
                          } else if (value.isEmpty && index > 0) {
                            focusNodes[index - 1].requestFocus();
                          }
                        },
                      ),
                    );
                  }),
                ),

                SizedBox(height: screenHeight * 0.05),

                // Verify Button
                GestureDetector(
                  onTap:
                      isOTPComplete
                          ? () {
                            HapticFeedback.lightImpact();
                            // Navigate to home screen
                            Navigator.pushReplacement(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        HomeScreen(),
                                transitionsBuilder: (
                                  context,
                                  animation,
                                  secondaryAnimation,
                                  child,
                                ) {
                                  return FadeTransition(
                                    opacity: animation,
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
                                  Colors.grey.withOpacity(0.3),
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

                SizedBox(height: screenHeight * 0.04),

                // Resend OTP Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Didn't receive OTP? ",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: isTablet ? 16 : 14,
                      ),
                    ),
                    GestureDetector(
                      onTap:
                          resendTimer == 0
                              ? () {
                                HapticFeedback.selectionClick();
                                setState(() {
                                  resendTimer = 30;
                                  startResendTimer();
                                });
                              }
                              : null,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          gradient:
                              resendTimer == 0
                                  ? LinearGradient(
                                    colors: [
                                      Color(0xFFFFD700).withOpacity(0.3),
                                      Color(0xFFFFD700).withOpacity(0.1),
                                    ],
                                  )
                                  : null,
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

                SizedBox(height: screenHeight * 0.03),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
