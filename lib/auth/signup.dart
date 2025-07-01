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
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    nameController.dispose();
    mobileController.dispose();
    emailController.dispose();
    referralController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  bool isReferralValid() {
    return referralController.text.isNotEmpty;
  }

  bool areFieldsValid() {
    if (isEmailSignup) {
      return emailController.text.isNotEmpty &&
          nameController.text.isNotEmpty &&
          isReferralValid() &&
          isAgeVerified;
    } else {
      return mobileController.text.isNotEmpty &&
          nameController.text.isNotEmpty &&
          isReferralValid() &&
          isAgeVerified;
    }
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
            colors: [Color(0xFF1a1c2e), Color(0xFF16213e), Color(0xFF0f3460)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  children: [
                    // Header Section
                    Container(
                      height:
                          screenHeight * 0.25, // Reduced height for smaller box
                      width: screenWidth * 0.9, // Added width constraint
                      margin: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.05,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF1a1a2e),
                            Color(0xFF16213e),
                            Color(0xFF0f3460),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 15,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          // Animated background circles
                          Positioned(
                            top: -60,
                            right: -60,
                            child: Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    Colors.orange.withOpacity(0.3),
                                    Colors.orange.withOpacity(0.0),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 30,
                            left: -30,
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    Colors.amber.withOpacity(0.2),
                                    Colors.amber.withOpacity(0.0),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // Content
                          Padding(
                            padding: EdgeInsets.all(screenWidth * 0.05),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Logo and back button row
                                Center(
                                  child: Container(
                                    width: 80,
                                    height: 80,
                                    child: Padding(
                                      padding: const EdgeInsets.all(0.0),
                                      child: Image.asset(
                                        'assets/images/star 20 pro logo mark blue (1).png',
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ),

                                Spacer(),

                                // Title section
                                Text(
                                  'Join the Elite',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: isTablet ? 16 : 14,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                SizedBox(height: 6),
                                ShaderMask(
                                  shaderCallback:
                                      (bounds) => LinearGradient(
                                        colors: [Colors.orange, Colors.amber],
                                      ).createShader(bounds),
                                  child: Text(
                                    'Star 25 Pro',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: isTablet ? 28 : 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  'Create • Compete • Conquer',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.7),
                                    fontSize: isTablet ? 14 : 12,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                                SizedBox(height: screenHeight * 0.02),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Glassmorphism Form Container
                    Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.05,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withOpacity(0.25),
                            Colors.white.withOpacity(0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                          ),
                          padding: EdgeInsets.all(screenWidth * 0.06),
                          child: Column(
                            children: [
                              SizedBox(height: 20),

                              // Mobile/Email Toggle
                              _buildToggleButtons(
                                screenWidth,
                                screenHeight,
                                isTablet,
                              ),

                              SizedBox(height: screenHeight * 0.04),

                              // Input Fields
                              _buildInputField(
                                controller: nameController,
                                hint: 'Full Name',
                                icon: Icons.person_outline,
                                isTablet: isTablet,
                                screenWidth: screenWidth,
                                screenHeight: screenHeight,
                              ),

                              SizedBox(height: screenHeight * 0.025),

                              _buildInputField(
                                controller:
                                    isEmailSignup
                                        ? emailController
                                        : mobileController,
                                hint:
                                    isEmailSignup
                                        ? 'Email address'
                                        : 'Mobile number',
                                icon:
                                    isEmailSignup
                                        ? Icons.email_outlined
                                        : Icons.phone_outlined,
                                keyboardType:
                                    isEmailSignup
                                        ? TextInputType.emailAddress
                                        : TextInputType.phone,
                                isTablet: isTablet,
                                screenWidth: screenWidth,
                                screenHeight: screenHeight,
                              ),

                              SizedBox(height: screenHeight * 0.025),

                              // Referral Code Field
                              _buildReferralField(
                                screenWidth,
                                screenHeight,
                                isTablet,
                              ),

                              SizedBox(height: screenHeight * 0.03),

                              // Age Verification Checkbox
                              _buildAgeVerification(screenWidth, isTablet),

                              SizedBox(height: screenHeight * 0.04),

                              // Sign Up Button
                              _buildSignUpButton(
                                screenWidth,
                                screenHeight,
                                isTablet,
                              ),

                              SizedBox(height: screenHeight * 0.025),

                              // Terms Text
                              _buildTermsText(isTablet),

                              SizedBox(height: screenHeight * 0.03),

                              // Divider
                              _buildDivider(screenWidth, isTablet),

                              SizedBox(height: screenHeight * 0.03),

                              // Social Login
                              SizedBox(height: screenHeight * 0.03),

                              // Login Link
                              _buildLoginLink(isTablet),

                              SizedBox(height: 20),
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
        ),
      ),
    );
  }

  Widget _buildToggleButtons(
    double screenWidth,
    double screenHeight,
    bool isTablet,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildToggleButton(
            'Mobile',
            !isEmailSignup,
            () {
              setState(() => isEmailSignup = false);
            },
            screenWidth,
            screenHeight,
            isTablet,
          ),
          _buildToggleButton(
            'Email',
            isEmailSignup,
            () {
              setState(() => isEmailSignup = true);
            },
            screenWidth,
            screenHeight,
            isTablet,
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton(
    String text,
    bool isSelected,
    VoidCallback onTap,
    double screenWidth,
    double screenHeight,
    bool isTablet,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.08,
          vertical: screenHeight * 0.015,
        ),
        decoration: BoxDecoration(
          gradient:
              isSelected
                  ? LinearGradient(colors: [Colors.orange, Colors.amber])
                  : null,
          borderRadius: BorderRadius.circular(25),
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.3),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ]
                  : null,
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: isTablet ? 16 : 14,
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    required bool isTablet,
    required double screenWidth,
    required double screenHeight,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: TextStyle(color: Colors.black, fontSize: isTablet ? 18 : 16),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.black.withOpacity(0.6),
            fontSize: isTablet ? 18 : 16,
          ),
          prefixIcon: Icon(
            icon,
            color: Colors.black.withOpacity(0.7),
            size: isTablet ? 24 : 20,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04,
            vertical: screenHeight * 0.02,
          ),
        ),
        onChanged: (value) => setState(() {}),
      ),
    );
  }

  Widget _buildReferralField(
    double screenWidth,
    double screenHeight,
    bool isTablet,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Referral Code *',
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: isTablet ? 16 : 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color:
                  !isReferralValid() && referralController.text.isNotEmpty
                      ? Colors.red.withOpacity(0.6)
                      : Colors.white.withOpacity(0.3),
            ),
          ),
          child: TextField(
            controller: referralController,
            textCapitalization: TextCapitalization.characters,
            style: TextStyle(color: Colors.black, fontSize: isTablet ? 18 : 16),
            decoration: InputDecoration(
              hintText: 'Enter referral code',
              hintStyle: TextStyle(
                color: Colors.black.withOpacity(0.6),
                fontSize: isTablet ? 18 : 16,
              ),
              prefixIcon: Icon(
                Icons.card_giftcard_outlined,
                color: Colors.black.withOpacity(0.7),
                size: isTablet ? 24 : 20,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04,
                vertical: screenHeight * 0.02,
              ),
            ),
            onChanged: (value) => setState(() {}),
          ),
        ),
        if (!isReferralValid() && referralController.text.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              'Valid referral code is required',
              style: TextStyle(
                color: Colors.red.withOpacity(0.8),
                fontSize: isTablet ? 14 : 12,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildAgeVerification(double screenWidth, bool isTablet) {
    return GestureDetector(
      onTap: () => setState(() => isAgeVerified = !isAgeVerified),
      child: Row(
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 200),
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              gradient:
                  isAgeVerified
                      ? LinearGradient(colors: [Colors.orange, Colors.amber])
                      : null,
              color: isAgeVerified ? null : Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color:
                    isAgeVerified
                        ? Colors.transparent
                        : Colors.white.withOpacity(0.3),
                width: 2,
              ),
            ),
            child:
                isAgeVerified
                    ? Icon(Icons.check, color: Colors.white, size: 16)
                    : null,
          ),
          SizedBox(width: screenWidth * 0.03),
          Expanded(
            child: Text(
              'I certify that I am above 18 years',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: isTablet ? 16 : 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignUpButton(
    double screenWidth,
    double screenHeight,
    bool isTablet,
  ) {
    return GestureDetector(
      onTap:
          areFieldsValid()
              ? () {
                HapticFeedback.lightImpact();
                String contact =
                    isEmailSignup
                        ? emailController.text
                        : mobileController.text;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => OTPVerificationScreen(
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
        height: screenHeight * 0.07,
        decoration: BoxDecoration(
          gradient:
              areFieldsValid()
                  ? LinearGradient(
                    colors: [Colors.orange, Colors.amber],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                  : null,
          color: areFieldsValid() ? null : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          boxShadow:
              areFieldsValid()
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
            'CREATE ACCOUNT',
            style: TextStyle(
              color: Colors.white,
              fontSize: isTablet ? 18 : 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTermsText(bool isTablet) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: 'By signing up, you agree to our ',
        style: TextStyle(
          color: Colors.white.withOpacity(0.6),
          fontSize: isTablet ? 14 : 12,
        ),
        children: [
          TextSpan(
            text: 'Terms & Conditions',
            style: TextStyle(color: Colors.orange, fontWeight: FontWeight.w600),
          ),
          TextSpan(text: ' and '),
          TextSpan(
            text: 'Privacy Policy',
            style: TextStyle(color: Colors.orange, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(double screenWidth, bool isTablet) {
    return Row(
      children: [
        Expanded(
          child: Container(
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
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
          child: Text(
            'OR',
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: isTablet ? 14 : 12,
              fontWeight: FontWeight.w600,
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
                  Colors.white.withOpacity(0.3),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButton(
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
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: textColor, size: 20),
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

  Widget _buildLoginLink(bool isTablet) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have an account? ',
          style: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: isTablet ? 16 : 14,
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
              fontSize: isTablet ? 16 : 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

// Enhanced OTP Verification Screen
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

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1a1c2e), Color(0xFF16213e), Color(0xFF0f3460)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(screenWidth * 0.06),
            child: Column(
              children: [
                // Back Button
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white.withOpacity(0.2)),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),

                SizedBox(height: screenHeight * 0.05),

                // Animated OTP Icon
                ScaleTransition(
                  scale: _pulseAnimation,
                  child: Container(
                    padding: EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        colors: [
                          Colors.orange.withOpacity(0.3),
                          Colors.orange.withOpacity(0.1),
                        ],
                      ),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.orange.withOpacity(0.3)),
                    ),
                    child: Icon(Icons.security, size: 60, color: Colors.orange),
                  ),
                ),

                SizedBox(height: screenHeight * 0.04),

                // Title
                ShaderMask(
                  shaderCallback:
                      (bounds) => LinearGradient(
                        colors: [Colors.orange, Colors.amber],
                      ).createShader(bounds),
                  child: Text(
                    'Verify Your Account',
                    style: TextStyle(
                      fontSize: isTablet ? 28 : 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),

                SizedBox(height: screenHeight * 0.02),

                // Description
                Text(
                  'Enter the 6-digit verification code sent to',
                  style: TextStyle(
                    fontSize: isTablet ? 16 : 14,
                    color: Colors.white.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 8),

                // Contact Display
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  child: Text(
                    widget.isEmail ? widget.contact : '+91 ${widget.contact}',
                    style: TextStyle(
                      fontSize: isTablet ? 18 : 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.orange,
                    ),
                  ),
                ),

                SizedBox(height: screenHeight * 0.05),

                // OTP Input Fields
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(6, (index) {
                    return Container(
                      width: isTablet ? 60 : 45,
                      height: isTablet ? 70 : 60,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color:
                              otpControllers[index].text.isNotEmpty
                                  ? Colors.orange.withOpacity(0.8)
                                  : Colors.white.withOpacity(0.3),
                          width: 2,
                        ),
                        boxShadow:
                            otpControllers[index].text.isNotEmpty
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
                          fontSize: isTablet ? 24 : 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          counterText: '',
                          border: InputBorder.none,
                          hintText: '•',
                          hintStyle: TextStyle(
                            color: Colors.white.withOpacity(0.3),
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

                SizedBox(height: screenHeight * 0.04),

                // Resend Code Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Didn\'t receive code? ',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: isTablet ? 16 : 14,
                      ),
                    ),
                    GestureDetector(
                      onTap:
                          resendTimer == 0
                              ? () {
                                setState(() {
                                  resendTimer = 30;
                                  startResendTimer();
                                });
                                // Add resend OTP logic here
                              }
                              : null,
                      child: Text(
                        resendTimer > 0
                            ? 'Resend in ${resendTimer}s'
                            : 'Resend',
                        style: TextStyle(
                          color:
                              resendTimer > 0
                                  ? Colors.white.withOpacity(0.4)
                                  : Colors.orange,
                          fontSize: isTablet ? 16 : 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: screenHeight * 0.05),

                // Verify Button
                GestureDetector(
                  onTap:
                      isOTPComplete
                          ? () {
                            HapticFeedback.lightImpact();
                            // Navigate to home screen after successful verification
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomeScreen(),
                              ),
                              (route) => false,
                            );
                          }
                          : null,
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    width: double.infinity,
                    height: screenHeight * 0.07,
                    decoration: BoxDecoration(
                      gradient:
                          isOTPComplete
                              ? LinearGradient(
                                colors: [Colors.orange, Colors.amber],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                              : null,
                      color:
                          isOTPComplete ? null : Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow:
                          isOTPComplete
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
                          fontSize: isTablet ? 18 : 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: screenHeight * 0.03),

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
                          fontSize: isTablet ? 16 : 14,
                          decoration: TextDecoration.underline,
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
}
