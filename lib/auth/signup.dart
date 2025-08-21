import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../body/homescreen.dart';
import 'login.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> with TickerProviderStateMixin {
  bool isEmailSignup = false;
  bool isAgeVerified = false;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController referralController = TextEditingController();

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    _fadeController.forward();
  }

  @override
  void dispose() {
    nameController.dispose();
    mobileController.dispose();
    emailController.dispose();
    referralController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  bool areFieldsValid() {
    if (isEmailSignup) {
      return emailController.text.isNotEmpty &&
          nameController.text.isNotEmpty &&
          referralController.text.isNotEmpty &&
          isAgeVerified;
    } else {
      return mobileController.text.isNotEmpty &&
          nameController.text.isNotEmpty &&
          referralController.text.isNotEmpty &&
          isAgeVerified;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenHeight = screenSize.height;
    final double screenWidth = screenSize.width;
    final bool isTablet = screenWidth > 600;
    final bool isSmallScreen = screenHeight < 700;

    return Scaffold(
      backgroundColor: Color(0xFF0f1419),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1a1c2e),
              Color(0xFF16213e),
              Color(0xFF0f3460),
              Color(0xFF0a2744),
            ],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SingleChildScrollView(
              physics: isSmallScreen ? AlwaysScrollableScrollPhysics() : NeverScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: screenHeight - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.06,
                    vertical: isSmallScreen ? 16 : screenHeight * 0.03,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Header Section
                      Container(
                        width: double.infinity,
                        child: Column(
                          children: [
                            SizedBox(height: isSmallScreen ? 20 : screenHeight * 0.02),

                            // Logo with animated glow - UPDATED TO USE ASSET IMAGE
                            Container(
                              width: isTablet ? 100 : 80,
                              height: isTablet ? 100 : 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    Colors.orange.withOpacity(0.3),
                                    Colors.orange.withOpacity(0.1),
                                    Colors.transparent,
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.orange.withOpacity(0.4),
                                    blurRadius: 30,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: Container(
                                padding: EdgeInsets.all(0), // Add padding around the logo
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [Colors.white, Colors.amber],
                                  ),
                                ),
                                child: ClipOval(
                                  child: Image.asset(
                                    'assets/images/star 20 pro logo mark blue (1).png', // REPLACE with your actual logo path
                                    width: isTablet ? 60 : 40,
                                    height: isTablet ? 60 : 50,
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) {
                                      // Fallback to star icon if logo fails to load
                                      return Icon(
                                        Icons.star_rounded,
                                        size: isTablet ? 60 : 50,
                                        color: Colors.white,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: isSmallScreen ? 16 : screenHeight * 0.025),

                            // Title with gradient
                            ShaderMask(
                              shaderCallback: (bounds) => LinearGradient(
                                colors: [Colors.orange, Colors.amber, Colors.orange],
                              ).createShader(bounds),
                              child: Text(
                                'Star 25 Pro',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: isTablet ? 32 : (isSmallScreen ? 24 : 28),
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ),

                            SizedBox(height: 8),

                            Text(
                              'Create • Compete • Conquer',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: isTablet ? 16 : (isSmallScreen ? 12 : 14),
                                letterSpacing: 2.0,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Form Section
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(vertical: isSmallScreen ? 20 : screenHeight * 0.03),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withOpacity(0.12),
                              Colors.white.withOpacity(0.08),
                              Colors.white.withOpacity(0.05),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.15),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 20,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(isTablet ? 32 : 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Toggle Buttons
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(25),
                                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: _buildToggleButton(
                                        'Mobile',
                                        !isEmailSignup,
                                            () => setState(() => isEmailSignup = false),
                                        isTablet,
                                        isSmallScreen,
                                      ),
                                    ),
                                    Expanded(
                                      child: _buildToggleButton(
                                        'Email',
                                        isEmailSignup,
                                            () => setState(() => isEmailSignup = true),
                                        isTablet,
                                        isSmallScreen,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(height: isSmallScreen ? 20 : 24),

                              // Input Fields with improved text visibility
                              _buildInputField(
                                controller: nameController,
                                hint: 'Full Name',
                                icon: Icons.person_outline_rounded,
                                isTablet: isTablet,
                                isSmallScreen: isSmallScreen,
                              ),

                              SizedBox(height: isSmallScreen ? 12 : 16),

                              _buildInputField(
                                controller: isEmailSignup ? emailController : mobileController,
                                hint: isEmailSignup ? 'Email address' : 'Mobile number',
                                icon: isEmailSignup ? Icons.email_outlined : Icons.phone_outlined,
                                keyboardType: isEmailSignup ? TextInputType.emailAddress : TextInputType.phone,
                                isTablet: isTablet,
                                isSmallScreen: isSmallScreen,
                              ),

                              SizedBox(height: isSmallScreen ? 12 : 16),

                              _buildInputField(
                                controller: referralController,
                                hint: 'Referral Code *',
                                icon: Icons.card_giftcard_outlined,
                                isTablet: isTablet,
                                isSmallScreen: isSmallScreen,
                              ),

                              SizedBox(height: isSmallScreen ? 16 : 20),

                              // Age Verification
                              GestureDetector(
                                onTap: () => setState(() => isAgeVerified = !isAgeVerified),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    AnimatedContainer(
                                      duration: Duration(milliseconds: 200),
                                      width: isTablet ? 26 : 24,
                                      height: isTablet ? 26 : 24,
                                      decoration: BoxDecoration(
                                        gradient: isAgeVerified
                                            ? LinearGradient(colors: [Colors.orange, Colors.amber])
                                            : null,
                                        color: isAgeVerified ? null : Colors.transparent,
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(
                                          color: isAgeVerified
                                              ? Colors.transparent
                                              : Colors.white.withOpacity(0.4),
                                          width: 2,
                                        ),
                                        boxShadow: isAgeVerified ? [
                                          BoxShadow(
                                            color: Colors.orange.withOpacity(0.3),
                                            blurRadius: 8,
                                            offset: Offset(0, 2),
                                          ),
                                        ] : null,
                                      ),
                                      child: isAgeVerified
                                          ? Icon(Icons.check_rounded, color: Colors.white, size: 16)
                                          : null,
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        'I certify that I am above 18 years',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.9),
                                          fontSize: isTablet ? 16 : (isSmallScreen ? 13 : 14),
                                          fontWeight: FontWeight.w400,
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

                      // Bottom Section
                      Column(
                        children: [
                          // Sign Up Button
                          GestureDetector(
                            onTap: areFieldsValid()
                                ? () {
                              HapticFeedback.lightImpact();
                              String contact = isEmailSignup ? emailController.text : mobileController.text;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OTPVerificationScreen(
                                    contact: contact,
                                    isEmail: isEmailSignup,
                                    isSignup: true,
                                  ),
                                ),
                              );
                            }
                                : null,
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 200),
                              width: double.infinity,
                              height: isTablet ? 60 : (isSmallScreen ? 50 : 56),
                              decoration: BoxDecoration(
                                gradient: areFieldsValid()
                                    ? LinearGradient(
                                  colors: [Colors.orange, Colors.amber, Colors.orange.shade600],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                )
                                    : null,
                                color: areFieldsValid() ? null : Colors.grey.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: areFieldsValid()
                                    ? [
                                  BoxShadow(
                                    color: Colors.orange.withOpacity(0.5),
                                    blurRadius: 20,
                                    offset: Offset(0, 8),
                                  ),
                                ]
                                    : null,
                              ),
                              child: Center(
                                child: Text(
                                  'CREATE ACCOUNT',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: isTablet ? 18 : (isSmallScreen ? 14 : 16),
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: isSmallScreen ? 12 : 16),

                          // Terms Text
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                text: 'By signing up, you agree to our ',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: isTablet ? 14 : (isSmallScreen ? 11 : 12),
                                  height: 1.4,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Terms & Conditions',
                                    style: TextStyle(
                                      color: Colors.orange,
                                      fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                  TextSpan(text: ' and '),
                                  TextSpan(
                                    text: 'Privacy Policy',
                                    style: TextStyle(
                                      color: Colors.orange,
                                      fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(height: isSmallScreen ? 16 : 20),

                          // Login Link
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Already have an account? ',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: isTablet ? 16 : (isSmallScreen ? 13 : 14),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => Dream11LoginPage()),
                                  );
                                },
                                child: Text(
                                  'Login',
                                  style: TextStyle(
                                    color: Colors.orange,
                                    fontSize: isTablet ? 16 : (isSmallScreen ? 13 : 14),
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: isSmallScreen ? 16 : 20),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildToggleButton(String text, bool isSelected, VoidCallback onTap, bool isTablet, bool isSmallScreen) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(
          vertical: isTablet ? 16 : (isSmallScreen ? 12 : 14),
        ),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
            colors: [Colors.orange, Colors.amber],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          )
              : null,
          borderRadius: BorderRadius.circular(25),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: Colors.orange.withOpacity(0.4),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ]
              : null,
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              fontSize: isTablet ? 16 : (isSmallScreen ? 13 : 14),
            ),
          ),
        ),
      ),
    );
  }

  // UPDATED INPUT FIELD WITH BETTER TEXT VISIBILITY
  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    required bool isTablet,
    required bool isSmallScreen,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.15), // Increased opacity for better background
            Colors.white.withOpacity(0.10), // Increased opacity
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.3), // Increased border opacity
          width: 1.5, // Slightly thicker border
        ),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: TextStyle(
          color: Colors.white, // Keep white but we'll add text shadow
          fontSize: isTablet ? 18 : (isSmallScreen ? 14 : 16),
          fontWeight: FontWeight.w500, // Slightly bolder text
          shadows: [
            // Add text shadow for better visibility
            Shadow(
              color: Colors.black.withOpacity(0.8),
              offset: Offset(1, 1),
              blurRadius: 2,
            ),
          ],
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.6), // Increased hint opacity
            fontSize: isTablet ? 18 : (isSmallScreen ? 14 : 16),
            fontWeight: FontWeight.w400,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.6),
                offset: Offset(1, 1),
                blurRadius: 2,
              ),
            ],
          ),
          prefixIcon: Icon(
            icon,
            color: Colors.white.withOpacity(0.8), // Increased icon opacity
            size: isTablet ? 24 : 20,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: isTablet ? 20 : (isSmallScreen ? 14 : 16),
          ),
        ),
        onChanged: (value) => setState(() {}),
      ),
    );
  }
}

// OTP Verification Screen remains the same
class OTPVerificationScreen extends StatefulWidget {
  final String contact;
  final bool isEmail;
  final bool isSignup;

  const OTPVerificationScreen({
    Key? key,
    required this.contact,
    required this.isEmail,
    this.isSignup = false,
  }) : super(key: key);

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen>
    with TickerProviderStateMixin {
  final List<TextEditingController> otpControllers = List.generate(6, (index) => TextEditingController());
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
      duration: Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    for (var controller in otpControllers) {
      controller.addListener(_checkOTPComplete);
    }
  }

  void _checkOTPComplete() {
    setState(() {
      isOTPComplete = otpControllers.every((controller) => controller.text.isNotEmpty);
    });
  }

  void startResendTimer() {
    Future.delayed(Duration(seconds: 1), () {
      if (mounted && resendTimer > 0) {
        setState(() => resendTimer--);
        startResendTimer();
      }
    });
  }

  @override
  void dispose() {
    for (var controller in otpControllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenHeight = screenSize.height;
    final double screenWidth = screenSize.width;
    final bool isTablet = screenWidth > 600;
    final bool isSmallScreen = screenHeight < 700;

    return Scaffold(
      backgroundColor: Color(0xFF0f1419),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1a1c2e), Color(0xFF16213e), Color(0xFF0f3460)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(screenWidth * 0.06),
            child: Column(
              children: [
                // Back Button
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.white.withOpacity(0.1), Colors.white.withOpacity(0.05)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white.withOpacity(0.2)),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),

                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Animated OTP Icon
                      ScaleTransition(
                        scale: _pulseAnimation,
                        child: Container(
                          padding: EdgeInsets.all(isTablet ? 35 : 30),
                          decoration: BoxDecoration(
                            gradient: RadialGradient(
                              colors: [
                                Colors.orange.withOpacity(0.3),
                                Colors.orange.withOpacity(0.1),
                                Colors.transparent,
                              ],
                            ),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.orange.withOpacity(0.3)),
                          ),
                          child: Icon(Icons.security, size: isTablet ? 70 : 60, color: Colors.orange),
                        ),
                      ),

                      SizedBox(height: isSmallScreen ? 30 : 40),

                      // Title
                      ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: [Colors.orange, Colors.amber],
                        ).createShader(bounds),
                        child: Text(
                          'Verify Your Account',
                          style: TextStyle(
                            fontSize: isTablet ? 28 : (isSmallScreen ? 20 : 24),
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      SizedBox(height: 16),

                      Text(
                        'Enter the 6-digit verification code sent to',
                        style: TextStyle(
                          fontSize: isTablet ? 16 : (isSmallScreen ? 12 : 14),
                          color: Colors.white.withOpacity(0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: 8),

                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.white.withOpacity(0.1), Colors.white.withOpacity(0.05)],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white.withOpacity(0.2)),
                        ),
                        child: Text(
                          widget.isEmail ? widget.contact : '+91 ${widget.contact}',
                          style: TextStyle(
                            fontSize: isTablet ? 18 : (isSmallScreen ? 14 : 16),
                            fontWeight: FontWeight.w600,
                            color: Colors.orange,
                          ),
                        ),
                      ),

                      SizedBox(height: isSmallScreen ? 30 : 40),

                      // OTP Input Fields with improved visibility
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(6, (index) {
                          return Container(
                            width: isTablet ? 55 : (isSmallScreen ? 40 : 45),
                            height: isTablet ? 65 : (isSmallScreen ? 50 : 60),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.white.withOpacity(0.15), Colors.white.withOpacity(0.08)],
                              ),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: otpControllers[index].text.isNotEmpty
                                    ? Colors.orange.withOpacity(0.8)
                                    : Colors.white.withOpacity(0.3),
                                width: 2,
                              ),
                              boxShadow: otpControllers[index].text.isNotEmpty
                                  ? [
                                BoxShadow(
                                  color: Colors.orange.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
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
                                fontSize: isTablet ? 24 : (isSmallScreen ? 18 : 20),
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(0.8),
                                    offset: Offset(1, 1),
                                    blurRadius: 2,
                                  ),
                                ],
                              ),
                              decoration: InputDecoration(
                                counterText: '',
                                border: InputBorder.none,
                                hintText: '•',
                                hintStyle: TextStyle(
                                  color: Colors.white.withOpacity(0.4),
                                  fontSize: isTablet ? 24 : 20,
                                ),
                              ),
                              onChanged: (value) {
                                if (value.isNotEmpty && index < 5) {
                                  focusNodes[index + 1].requestFocus();
                                } else if (value.isEmpty && index > 0) {
                                  focusNodes[index - 1].requestFocus();
                                }
                                setState(() {});
                              },
                            ),
                          );
                        }),
                      ),

                      SizedBox(height: isSmallScreen ? 24 : 32),

                      // Resend Code
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Didn\'t receive code? ',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: isTablet ? 16 : (isSmallScreen ? 12 : 14),
                            ),
                          ),
                          GestureDetector(
                            onTap: resendTimer == 0
                                ? () {
                              setState(() {
                                resendTimer = 30;
                                startResendTimer();
                              });
                            }
                                : null,
                            child: Text(
                              resendTimer > 0 ? 'Resend in ${resendTimer}s' : 'Resend',
                              style: TextStyle(
                                color: resendTimer > 0 ? Colors.white.withOpacity(0.4) : Colors.orange,
                                fontSize: isTablet ? 16 : (isSmallScreen ? 12 : 14),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Bottom Section
                Column(
                  children: [
                    // Verify Button
                    GestureDetector(
                      onTap: isOTPComplete
                          ? () {
                        HapticFeedback.lightImpact();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                              (route) => false,
                        );
                      }
                          : null,
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        width: double.infinity,
                        height: isTablet ? 60 : (isSmallScreen ? 50 : 56),
                        decoration: BoxDecoration(
                          gradient: isOTPComplete
                              ? LinearGradient(
                            colors: [Colors.orange, Colors.amber],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          )
                              : null,
                          color: isOTPComplete ? null : Colors.grey.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: isOTPComplete
                              ? [
                            BoxShadow(
                              color: Colors.orange.withOpacity(0.4),
                              blurRadius: 15,
                              offset: Offset(0, 8),
                            ),
                          ]
                              : null,
                        ),
                        child: Center(
                          child: Text(
                            'VERIFY & CONTINUE',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isTablet ? 18 : (isSmallScreen ? 14 : 16),
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 16),

                    // Edit Contact Option
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.edit_outlined,
                            color: Colors.white.withOpacity(0.6),
                            size: 16,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Edit ${widget.isEmail ? 'Email' : 'Mobile Number'}',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: isTablet ? 16 : (isSmallScreen ? 12 : 14),
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}