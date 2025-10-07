//auth/signup.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../body/homescreen.dart';
import 'login.dart';
import 'package:fantasy/api/signup_api.dart'; // Backend APIf

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

  // Animation controllers
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeSignupApi();
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

  Future<void> _initializeSignupApi() async {
    await SignupApi.initialize();
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

  // Backend signup function with enhanced UI feedback
  Future<void> _handleSignup() async {
    if (!areFieldsValid()) {
      setState(() {
        errorMessage = "Please fill all required fields and verify your age";
      });
      return;
    }

    String contact = isEmailSignup ? emailController.text.trim() : mobileController.text.trim();
    String userName = nameController.text.trim();
    String inviteCode = referralController.text.trim().toUpperCase();

    // Basic validation
    if (userName.length < 2) {
      setState(() {
        errorMessage = "Name must be at least 2 characters long";
      });
      return;
    }

    if (!isEmailSignup && contact.length < 10) {
      setState(() {
        errorMessage = "Please enter a valid mobile number";
      });
      return;
    }

    if (isEmailSignup && !contact.contains('@')) {
      setState(() {
        errorMessage = "Please enter a valid email address";
      });
      return;
    }

    if (inviteCode.length < 5) {
      setState(() {
        errorMessage = "Please enter a valid referral code";
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      print('Starting signup process...');
      print('Contact: $contact');
      print('UserName: $userName');
      print('InviteCode: $inviteCode');

      // Request OTP from backend
      Map<String, dynamic> response = await SignupApi.requestSignupOtp(
        contact,
        userName,
        inviteCode,
      );

      print('Signup response: $response');

      if (response['success'] == true) {
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

        // Handle specific error cases
        if (errorMessage.toLowerCase().contains('user already exist') ||
            errorMessage.toLowerCase().contains('already registered')) {
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
        } else if (errorMessage.toLowerCase().contains('invalid') &&
            errorMessage.toLowerCase().contains('invite')) {
          errorMessage = 'Invalid referral code. Please check and try again.';
        }

        setState(() {
          this.errorMessage = errorMessage;
        });
      }
    } catch (e) {
      print('Signup error: $e');
      String errorMessage = "An error occurred. Please try again.";

      if (e.toString().contains('user already exist')) {
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
      } else if (e.toString().contains('invalid invite code')) {
        errorMessage = 'Invalid referral code. Please check and try again.';
      } else if (e.toString().contains('network') || e.toString().contains('connection')) {
        errorMessage = 'Network error. Please check your internet connection.';
      }

      setState(() {
        this.errorMessage = errorMessage;
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
            child: SlideTransition(
              position: _slideAnimation,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.06,
                    vertical: isSmallScreen ? 16 : screenHeight * 0.03,
                  ),
                  child: Column(
                    children: [
                      // Header Section
                      Container(
                        width: double.infinity,
                        child: Column(
                          children: [
                            SizedBox(
                              height: isSmallScreen ? 20 : screenHeight * 0.02,
                            ),

                            // Logo with animated glow
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
                                padding: EdgeInsets.all(0),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [Colors.white, Colors.amber],
                                  ),
                                ),
                                child: ClipOval(
                                  child: Image.asset(
                                    'assets/images/star 20 pro logo mark blue (1).png',
                                    width: isTablet ? 60 : 40,
                                    height: isTablet ? 60 : 50,
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) {
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

                            SizedBox(
                              height: isSmallScreen ? 16 : screenHeight * 0.025,
                            ),

                            // Title with gradient
                            ShaderMask(
                              shaderCallback: (bounds) => LinearGradient(
                                colors: [
                                  Colors.orange,
                                  Colors.amber,
                                  Colors.orange,
                                ],
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

                      SizedBox(height: isSmallScreen ? 20 : screenHeight * 0.03),

                      // Form Section
                      Container(
                        width: double.infinity,
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
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.1),
                                  ),
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

                              // Input Fields
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

                              _buildReferralField(isTablet, isSmallScreen),

                              SizedBox(height: isSmallScreen ? 16 : 20),

                              // Age Verification
                              _buildAgeVerification(isTablet, isSmallScreen),

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
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: isSmallScreen ? 20 : screenHeight * 0.03),

                      // Sign Up Button
                      _buildSignUpButton(isTablet, isSmallScreen, screenHeight),

                      SizedBox(height: isSmallScreen ? 12 : 16),

                      // Terms Text
                      _buildTermsText(isTablet, isSmallScreen),

                      SizedBox(height: isSmallScreen ? 16 : 20),

                      // Login Link
                      _buildLoginLink(isTablet, isSmallScreen),

                      SizedBox(height: isSmallScreen ? 30 : 40), // Extra padding at bottom
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

  Widget _buildToggleButton(
      String text,
      bool isSelected,
      VoidCallback onTap,
      bool isTablet,
      bool isSmallScreen,
      ) {
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
            Colors.white.withOpacity(0.15),
            Colors.white.withOpacity(0.10),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: TextStyle(
          color: Colors.white,
          fontSize: isTablet ? 18 : (isSmallScreen ? 14 : 16),
          fontWeight: FontWeight.w500,
          shadows: [
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
            color: Colors.white.withOpacity(0.6),
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
            color: Colors.white.withOpacity(0.8),
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

  Widget _buildReferralField(bool isTablet, bool isSmallScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.15),
                Colors.white.withOpacity(0.10),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: !isReferralValid() && referralController.text.isNotEmpty
                  ? Colors.red.withOpacity(0.6)
                  : Colors.white.withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: TextField(
            controller: referralController,
            textCapitalization: TextCapitalization.characters,
            style: TextStyle(
              color: Colors.white,
              fontSize: isTablet ? 18 : (isSmallScreen ? 14 : 16),
              fontWeight: FontWeight.w500,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.8),
                  offset: Offset(1, 1),
                  blurRadius: 2,
                ),
              ],
            ),
            decoration: InputDecoration(
              hintText: 'Referral Code *',
              hintStyle: TextStyle(
                color: Colors.white.withOpacity(0.6),
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
                Icons.card_giftcard_outlined,
                color: Colors.white.withOpacity(0.8),
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

  Widget _buildAgeVerification(bool isTablet, bool isSmallScreen) {
    return GestureDetector(
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
              boxShadow: isAgeVerified
                  ? [
                BoxShadow(
                  color: Colors.orange.withOpacity(0.3),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ]
                  : null,
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
    );
  }

  Widget _buildSignUpButton(bool isTablet, bool isSmallScreen, double screenHeight) {
    return GestureDetector(
      onTap: (areFieldsValid() && !isLoading) ? () {
        HapticFeedback.lightImpact();
        _handleSignup();
      } : null,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        width: double.infinity,
        height: isTablet ? 60 : (isSmallScreen ? 50 : 56),
        decoration: BoxDecoration(
          gradient: (areFieldsValid() && !isLoading)
              ? LinearGradient(
            colors: [Colors.orange, Colors.amber, Colors.orange.shade600],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          )
              : null,
          color: (areFieldsValid() && !isLoading) ? null : Colors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16),
          boxShadow: (areFieldsValid() && !isLoading)
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
          child: isLoading
              ? CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
              : Text(
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
    );
  }

  Widget _buildTermsText(bool isTablet, bool isSmallScreen) {
    return Padding(
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
    );
  }

  Widget _buildLoginLink(bool isTablet, bool isSmallScreen) {
    return Row(
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
    );
  }
}

// Enhanced OTP Verification Screen with Backend Integration
// Enhanced OTP Verification Screen with Proper Backend Integration

// Enhanced OTP Verification Screen with Keyboard Fix
class OTPVerificationScreen extends StatefulWidget {
  final String contact;
  final bool isEmail;
  final bool isSignup;
  final String userName;
  final String inviteCode;
  final String? otpToken;

  const OTPVerificationScreen({
    Key? key,
    required this.contact,
    required this.isEmail,
    this.isSignup = false,
    required this.userName,
    required this.inviteCode,
    this.otpToken,
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
  bool isVerifying = false;
  String? errorMessage;
  int resendTimer = 30;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    startResendTimer();

    print('OTP Screen initialized:');
    print('- isSignup: ${widget.isSignup}');
    print('- otpToken: ${widget.otpToken?.substring(0, 20)}...' ?? 'null');
    print('- contact: ${widget.contact}');

    _pulseController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Add listeners without frequent setState calls
    for (var controller in otpControllers) {
      controller.addListener(_checkOTPComplete);
    }
  }

  void _checkOTPComplete() {
    final bool newIsComplete = otpControllers.every(
          (controller) => controller.text.isNotEmpty,
    );

    // Only call setState if the completion state actually changed
    if (newIsComplete != isOTPComplete) {
      setState(() {
        isOTPComplete = newIsComplete;
      });
    }
  }

  void startResendTimer() {
    Future.delayed(Duration(seconds: 1), () {
      if (mounted && resendTimer > 0) {
        setState(() => resendTimer--);
        startResendTimer();
      }
    });
  }

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
      print('Verifying OTP: $otp for ${widget.isSignup ? 'signup' : 'login'}');

      bool success = false;

      if (widget.isSignup) {
        print('Using signup verification method');
        print('OTP Token: ${widget.otpToken?.substring(0, 20)}...' ?? 'null');

        success = await SignupApi.verifySignupOtpForSignup(
          otp,
          widget.otpToken,
          fcmToken: "test_fcm_token",
        );
      } else {
        print('Using login verification method');
        success = await SignupApi.verifySignupOtp(otp);
      }

      print('Verification result: $success');

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Verification successful!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 1),
          ),
        );

        await Future.delayed(Duration(milliseconds: 500));
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
        _clearOTPFields();
      }
    } catch (e) {
      print('OTP verification error: $e');
      setState(() {
        errorMessage = "Verification failed. Please try again.";
      });
      _clearOTPFields();
    } finally {
      setState(() {
        isVerifying = false;
      });
    }
  }

  void _clearOTPFields() {
    for (var controller in otpControllers) {
      controller.clear();
    }
    focusNodes[0].requestFocus();
  }

  Future<void> _resendOTP() async {
    if (resendTimer > 0) return;

    setState(() {
      isVerifying = true;
      errorMessage = null;
    });

    try {
      print('Resending OTP for ${widget.isSignup ? 'signup' : 'login'}');

      Map<String, dynamic> response;

      if (widget.isSignup) {
        response = await SignupApi.requestSignupOtp(
          widget.contact,
          widget.userName,
          widget.inviteCode,
        );
      } else {
        response = {
          'success': false,
          'message': 'Login OTP resend not implemented yet'
        };
        print('Login OTP resend needs to be implemented');
      }

      if (response['success'] == true) {
        setState(() {
          resendTimer = 30;
          startResendTimer();
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('OTP sent successfully'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        );
      } else {
        setState(() {
          errorMessage = response['message'] ?? 'Failed to resend OTP. Please try again.';
        });
      }
    } catch (e) {
      print('Resend OTP error: $e');
      setState(() {
        errorMessage = "Failed to resend OTP. Please try again.";
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
    final bool isSmallScreen = screenHeight < 700;

    // Get keyboard height
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final bool isKeyboardVisible = keyboardHeight > 0;

    return Scaffold(
      backgroundColor: Color(0xFF0f1419),
      resizeToAvoidBottomInset: true,
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
            // Simplified scroll physics - no conditional changes
            physics: AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.06,
              vertical: 20,
            ),
            child: Column(
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
                      icon: Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),

                SizedBox(height: isKeyboardVisible ? 20 : 60),

                // Animated icon (only show when keyboard is hidden)
                if (!isKeyboardVisible) ...[
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
                  SizedBox(height: 40),
                ],

                // Title
                Text(
                  'Verify Your ${widget.isEmail ? 'Email' : 'Phone'}',
                  style: TextStyle(
                    fontSize: isTablet ? 28 : 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                SizedBox(height: 16),

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
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: Text(
                    widget.isEmail
                        ? widget.contact
                        : '+91 ${widget.contact}',
                    style: TextStyle(
                      fontSize: isTablet ? 18 : 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFFFD700),
                    ),
                  ),
                ),

                SizedBox(height: 40),

                // OTP Input Fields - FIXED VERSION
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
                          return Container(
                            width: isTablet ? 55 : 45,
                            height: isTablet ? 65 : 60,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9), // Better background
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: otpControllers[index].text.isNotEmpty
                                    ? Color(0xFFFFD700)
                                    : Colors.grey.withOpacity(0.5),
                                width: 2,
                              ),
                              boxShadow: otpControllers[index].text.isNotEmpty
                                  ? [
                                BoxShadow(
                                  color: Color(0xFFFFD700).withOpacity(0.3),
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
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(1),
                              ],
                              style: TextStyle(
                                fontSize: isTablet ? 24 : 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: '•',
                                hintStyle: TextStyle(
                                  color: Colors.grey.withOpacity(0.5),
                                  fontSize: isTablet ? 24 : 20,
                                ),
                                counterText: '', // Hide counter
                                contentPadding: EdgeInsets.zero,
                              ),
                              onChanged: (value) {
                                // Handle navigation between fields
                                if (value.isNotEmpty && index < 5) {
                                  focusNodes[index + 1].requestFocus();
                                } else if (value.isEmpty && index > 0) {
                                  focusNodes[index - 1].requestFocus();
                                }

                                // Clear error message when user starts typing
                                if (errorMessage != null) {
                                  setState(() {
                                    errorMessage = null;
                                  });
                                }

                                // Note: _checkOTPComplete is called via listener, no setState here
                              },
                              onTap: () {
                                // Select all text instead of clearing
                                otpControllers[index].selection = TextSelection(
                                  baseOffset: 0,
                                  extentOffset: otpControllers[index].text.length,
                                );
                              },
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),

                // Error message display
                if (errorMessage != null) ...[
                  SizedBox(height: 16),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
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

                SizedBox(height: 32),

                // Verify Button
                GestureDetector(
                  onTap: (isOTPComplete && !isVerifying) ? () {
                    HapticFeedback.lightImpact();
                    _verifyOTP();
                  } : null,
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    width: double.infinity,
                    height: isTablet ? 60 : 56,
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
                          : null,
                      color: (isOTPComplete && !isVerifying) ? null : Colors.grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: (isOTPComplete && !isVerifying)
                          ? [
                        BoxShadow(
                          color: Color(0xFFFFD700).withOpacity(0.4),
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

                SizedBox(height: 24),

                // Resend Code
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
                        _resendOTP();
                      } : null,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                          resendTimer > 0 ? 'Resend in ${resendTimer}s' : 'Resend',
                          style: TextStyle(
                            color: resendTimer > 0 ? Colors.white.withOpacity(0.4) : Color(0xFFFFD700),
                            fontSize: isTablet ? 16 : 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
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
                          fontSize: isTablet ? 16 : 14,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),

                // Extra bottom padding for keyboard
                SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}