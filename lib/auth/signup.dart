import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../body/homescreen.dart';
import 'login.dart';
import '../api/signup_api.dart'; // Backend API from code-3

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> with TickerProviderStateMixin {
  bool isEmailSignup = false;
  bool isAgeVerified = false;
  bool isLoading = false; // Loading state for API calls
  String? errorMessage; // Error handling

  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController referralController = TextEditingController();

  // Animation controllers from code-4
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );
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

  // Backend signup function from code-3 with enhanced UI feedback
  Future<void> _handleSignup() async {
    if (!areFieldsValid()) {
      setState(() {
        errorMessage = "Please fill all required fields";
      });
      return;
    }

    String contact = isEmailSignup ? emailController.text : mobileController.text;
    String userName = nameController.text;
    String inviteCode = referralController.text;

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      // Request OTP from backend
      Map<String, dynamic> response = await SignupApi.requestSignupOtp(
        contact,
        userName,
        inviteCode,
      );

      if (response['success']) {
        // Navigate to OTP screen
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => OTPVerificationScreen(
              contact: contact,
              isEmail: isEmailSignup,
              isSignup: true,
              userName: userName,
              inviteCode: inviteCode,
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
        String errorMessage = response['message'] ?? 'Failed to send OTP. Please try again.';
        if (errorMessage.toLowerCase().contains('user already exist')) {
          errorMessage = 'This account already exists. Please login instead.';

          // Show snackbar with login option
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Colors.red,
              action: SnackBarAction(
                label: 'Login',
                textColor: Colors.white,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Dream11LoginPage()),
                  );
                },
              ),
            ),
          );
          return;
        }
        setState(() {
          this.errorMessage = errorMessage;
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
                    SizedBox(height: 20),

                    // Enhanced Header Section with new UI
                    Container(
                      height: screenHeight * 0.25,
                      width: screenWidth * 0.9,
                      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
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
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Logo
                                Container(
                                  width: 80,
                                  height: 80,
                                  child: Image.asset(
                                    'assets/images/star 20 pro logo mark blue (1).png',
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(Icons.star, size: 80, color: Colors.white);
                                    },
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
                                  shaderCallback: (bounds) => LinearGradient(
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
                                SizedBox(height: 16),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20),

                    // Glassmorphism Form Container
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
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
                        border: Border.all(color: Colors.white.withOpacity(0.2)),
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
                              _buildToggleButtons(screenWidth, screenHeight, isTablet),

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
                                controller: isEmailSignup ? emailController : mobileController,
                                hint: isEmailSignup ? 'Email address' : 'Mobile number',
                                icon: isEmailSignup ? Icons.email_outlined : Icons.phone_outlined,
                                keyboardType: isEmailSignup ? TextInputType.emailAddress : TextInputType.phone,
                                isTablet: isTablet,
                                screenWidth: screenWidth,
                                screenHeight: screenHeight,
                              ),

                              SizedBox(height: screenHeight * 0.025),

                              // Referral Code Field
                              _buildReferralField(screenWidth, screenHeight, isTablet),

                              SizedBox(height: screenHeight * 0.03),

                              // Age Verification Checkbox
                              _buildAgeVerification(screenWidth, isTablet),

                              // Error message display with enhanced styling
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
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],

                              SizedBox(height: screenHeight * 0.04),

                              // Enhanced Sign Up Button with loading state
                              _buildSignUpButton(screenWidth, screenHeight, isTablet),

                              SizedBox(height: screenHeight * 0.025),

                              // Terms Text
                              _buildTermsText(isTablet),

                              SizedBox(height: screenHeight * 0.03),

                              // Divider
                              _buildDivider(screenWidth, isTablet),

                              SizedBox(height: screenHeight * 0.03),

                              // Social Login Options
                              Column(
                                children: [
                                  _buildSocialButton(
                                    'Sign up with Google',
                                    Icons.g_mobiledata,
                                    Colors.white,
                                    Colors.black87,
                                    screenWidth,
                                    screenHeight,
                                    isTablet,
                                  ),
                                  SizedBox(height: screenHeight * 0.015),
                                  _buildSocialButton(
                                    'Sign up with Facebook',
                                    Icons.facebook,
                                    Color(0xFF1877F2),
                                    Colors.white,
                                    screenWidth,
                                    screenHeight,
                                    isTablet,
                                  ),
                                ],
                              ),

                              SizedBox(height: screenHeight * 0.03),

                              // Login Link
                              _buildLoginLink(isTablet),

                              // Have an invite code dialog option
                              SizedBox(height: 12),
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => _buildInviteCodeDialog(context, isTablet),
                                  );
                                },
                                child: Text(
                                  'Have an invite code?',
                                  style: TextStyle(
                                    color: Colors.orange,
                                    fontSize: isTablet ? 16 : 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),

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

  Widget _buildToggleButtons(double screenWidth, double screenHeight, bool isTablet) {
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
                () => setState(() => isEmailSignup = false),
            screenWidth,
            screenHeight,
            isTablet,
          ),
          _buildToggleButton(
            'Email',
            isEmailSignup,
                () => setState(() => isEmailSignup = true),
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
          gradient: isSelected
              ? LinearGradient(colors: [Colors.orange, Colors.amber])
              : null,
          borderRadius: BorderRadius.circular(25),
          boxShadow: isSelected
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

  Widget _buildReferralField(double screenWidth, double screenHeight, bool isTablet) {
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
              color: !isReferralValid() && referralController.text.isNotEmpty
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
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() => isAgeVerified = !isAgeVerified);
      },
      child: Row(
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              gradient: isAgeVerified
                  ? LinearGradient(colors: [Colors.orange, Colors.amber])
                  : null,
              color: isAgeVerified ? null : Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isAgeVerified ? Colors.transparent : Colors.white.withOpacity(0.3),
                width: 2,
              ),
              boxShadow: isAgeVerified
                  ? [
                BoxShadow(
                  color: Colors.orange.withOpacity(0.4),
                  blurRadius: 10,
                  offset: Offset(0, 3),
                ),
              ]
                  : null,
            ),
            child: isAgeVerified ? Icon(Icons.check, color: Colors.white, size: 18) : null,
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

  Widget _buildSignUpButton(double screenWidth, double screenHeight, bool isTablet) {
    return GestureDetector(
      onTap: (areFieldsValid() && !isLoading) ? () {
        HapticFeedback.lightImpact();
        _handleSignup(); // Call the backend function
      } : null,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        width: double.infinity,
        height: screenHeight * 0.07,
        decoration: BoxDecoration(
          gradient: (areFieldsValid() && !isLoading)
              ? LinearGradient(
            colors: [Colors.orange, Colors.amber],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
              : null,
          color: (areFieldsValid() && !isLoading) ? null : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          boxShadow: (areFieldsValid() && !isLoading)
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
          child: isLoading
              ? CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
              : Text(
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
                colors: [Colors.transparent, Colors.white.withOpacity(0.3), Colors.transparent],
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: LinearGradient(
                colors: [Colors.white.withOpacity(0.2), Colors.white.withOpacity(0.1)],
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
                colors: [Colors.transparent, Colors.white.withOpacity(0.3), Colors.transparent],
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
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => Dream11LoginPage(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(-1.0, 0.0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  );
                },
              ),
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

  // Invite code dialog from code-3
  Widget _buildInviteCodeDialog(BuildContext context, bool isTablet) {
    final TextEditingController inviteController = TextEditingController();

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [Colors.black.withOpacity(0.8), Colors.grey.withOpacity(0.6)],
          ),
          border: Border.all(color: Colors.white.withOpacity(0.3)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Enter Invite Code',
              style: TextStyle(
                fontSize: isTablet ? 20 : 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withOpacity(0.3)),
              ),
              child: TextField(
                controller: inviteController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Enter your invite code',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                ),
              ),
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'CANCEL',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    referralController.text = inviteController.text;
                    setState(() {});
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: Text(
                    'SUBMIT',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Enhanced OTP Verification Screen with Backend Integration and New UI
class OTPVerificationScreen extends StatefulWidget {
  final String contact;
  final bool isEmail;
  final bool isSignup;
  final String userName;
  final String inviteCode;

  const OTPVerificationScreen({
    Key? key,
    required this.contact,
    required this.isEmail,
    this.isSignup = false,
    required this.userName,
    required this.inviteCode,
  }) : super(key: key);

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen>
    with TickerProviderStateMixin {
  final List<TextEditingController> otpControllers = List.generate(6, (index) => TextEditingController());
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

  // Backend OTP verification from code-3
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
      bool success = await SignupApi.verifySignupOtp(getOTP());

      if (success) {
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
          errorMessage = 'Invalid OTP. Please try again.';
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

  // Backend OTP resend from code-3
  Future<void> _resendOTP() async {
    if (resendTimer > 0) return;

    setState(() {
      isVerifying = true;
      errorMessage = null;
    });

    try {
      Map<String, dynamic> response = await SignupApi.requestSignupOtp(
        widget.contact,
        widget.userName,
        widget.inviteCode,
      );

      if (response['success']) {
        setState(() {
          resendTimer = 30;
          startResendTimer();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('OTP sent successfully'),
            backgroundColor: Colors.orange,
          ),
        );
      } else {
        setState(() {
          errorMessage = 'Failed to resend OTP. Please try again.';
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
    for (var controller in otpControllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    _pulseController.dispose();
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
                      icon: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
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
                  shaderCallback: (bounds) => LinearGradient(
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

                // Error message
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
                            style: TextStyle(color: Colors.red, fontSize: isTablet ? 14 : 12),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

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
                      onTap: (resendTimer == 0 && !isVerifying) ? () {
                        HapticFeedback.selectionClick();
                        _resendOTP(); // Call backend resend
                      } : null,
                      child: Text(
                        resendTimer > 0 ? 'Resend in ${resendTimer}s' : 'Resend',
                        style: TextStyle(
                          color: resendTimer > 0 ? Colors.white.withOpacity(0.4) : Colors.orange,
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
                  onTap: (isOTPComplete && !isVerifying) ? () {
                    HapticFeedback.lightImpact();
                    _verifyOTP(); // Call backend verification
                  } : null,
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    width: double.infinity,
                    height: screenHeight * 0.07,
                    decoration: BoxDecoration(
                      gradient: (isOTPComplete && !isVerifying)
                          ? LinearGradient(
                        colors: [Colors.orange, Colors.amber],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                          : null,
                      color: (isOTPComplete && !isVerifying) ? null : Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: (isOTPComplete && !isVerifying)
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
                      child: isVerifying
                          ? CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                          : Text(
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