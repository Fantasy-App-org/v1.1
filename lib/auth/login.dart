import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../service/user_service.dart'; // Backend service from code-1
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
  bool isLoading = false; // Backend integration from code-1
  String? errorMessage; // Error handling from code-1
  final TextEditingController mobileController = TextEditingController();
  final UserService _userService = UserService(); // Backend service

  // Animation controllers from code-2
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
    _initializeService(); // Backend initialization from code-1
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

  // Backend initialization from code-1
  Future<void> _initializeService() async {
    await _userService.initialize();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final bool isLoggedIn = await _userService.checkLoginStatus();
    if (isLoggedIn) {
      print('User is logged in with token: ${_userService.authToken}');
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  // OTP request functionality from code-1 with enhanced UI feedback
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
                                  // Logo
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.0),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Image.asset(
                                      'assets/images/star 20 pro logo mark blue (1).png',
                                      height: 64,
                                      width: 64,
                                      fit: BoxFit.contain,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Icon(
                                          Icons.star,
                                          size: 64,
                                          color: Colors.white,
                                        );
                                      },
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

                          // Enhanced Input Field with validation
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
                          _buildGlassCheckbox(screenWidth, screenHeight, isTablet),

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

                          // Enhanced Continue Button with loading state
                          _buildPremiumButton(screenWidth, screenHeight, isTablet),

                          SizedBox(height: screenHeight * 0.02),

                          // Terms Text with Gradient - Updated text from code-2
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
                                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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

                          // Register Link with Animation - Updated text from code-2
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
                                      pageBuilder: (context, animation, secondaryAnimation) => SignupPage(),
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
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: TextStyle(
          fontSize: isTablet ? 18 : 16,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.6),
            fontSize: isTablet ? 18 : 16,
          ),
          prefixIcon: Container(
            margin: EdgeInsets.all(12),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFFD700).withOpacity(0.8), Color(0xFFFF6B35).withOpacity(0.8)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04,
            vertical: screenHeight * 0.02,
          ),
        ),
      ),
    );
  }

  Widget _buildGlassCheckbox(double screenWidth, double screenHeight, bool isTablet) {
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
              gradient: isAgeVerified
                  ? LinearGradient(colors: [Color(0xFFFFD700), Color(0xFFFF6B35)])
                  : null,
              border: Border.all(
                color: isAgeVerified ? Colors.transparent : Colors.white.withOpacity(0.5),
                width: 2,
              ),
              boxShadow: isAgeVerified
                  ? [
                BoxShadow(
                  color: Color(0xFFFFD700).withOpacity(0.4),
                  blurRadius: 10,
                  offset: Offset(0, 3),
                ),
              ]
                  : null,
            ),
            child: isAgeVerified ? Icon(Icons.check, color: Colors.white, size: 18) : null,
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

  Widget _buildPremiumButton(double screenWidth, double screenHeight, bool isTablet) {
    return GestureDetector(
      onTap: (isAgeVerified && !isLoading) ? () {
        HapticFeedback.lightImpact();
        _requestOtp(); // Call the backend function
      } : null,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        width: double.infinity,
        height: screenHeight * 0.07,
        decoration: BoxDecoration(
          gradient: (isAgeVerified && !isLoading)
              ? LinearGradient(
            colors: [Color(0xFFFFD700), Color(0xFFFF6B35), Color(0xFFE91E63)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
              : LinearGradient(
            colors: [Colors.grey.withOpacity(0.3), Colors.grey.withOpacity(0.2)],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: (isAgeVerified && !isLoading)
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
          child: isLoading
              ? CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2,
          )
              : Text(
            'CONTINUE',
            style: TextStyle(
              color: (isAgeVerified && !isLoading) ? Colors.white : Colors.white.withOpacity(0.5),
              fontSize: isTablet ? 18 : 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
        ),
      ),
    );
  }
}

// Enhanced OTP Verification Screen with Backend Integration
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

  // Backend OTP verification
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

  // Backend OTP resend
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
            content: Text('OTP sent successfully'),
            backgroundColor: Color(0xFFFFD700),
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
                        child: Icon(Icons.security, size: 60, color: Colors.white),
                      ),
                    );
                  },
                ),

                SizedBox(height: screenHeight * 0.04),

                // Title with Gradient
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
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

                // Contact Display
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: LinearGradient(
                      colors: [Colors.white.withOpacity(0.2), Colors.white.withOpacity(0.1)],
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
                          colors: [Colors.white.withOpacity(0.2), Colors.white.withOpacity(0.1)],
                        ),
                        border: Border.all(
                          color: otpControllers[index].text.isNotEmpty
                              ? Color(0xFFFFD700)
                              : Colors.white.withOpacity(0.3),
                          width: 2,
                        ),
                        boxShadow: otpControllers[index].text.isNotEmpty
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
                        colors: [Color(0xFFFFD700), Color(0xFFFF6B35), Color(0xFFE91E63)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                          : LinearGradient(
                        colors: [Colors.grey.withOpacity(0.3), Colors.grey.withOpacity(0.2)],
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
                          ? CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                          : Text(
                        'VERIFY OTP',
                        style: TextStyle(
                          color: (isOTPComplete && !isVerifying) ? Colors.white : Colors.white.withOpacity(0.5),
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
                      onTap: (resendTimer == 0 && !isVerifying) ? () {
                        HapticFeedback.selectionClick();
                        _resendOTP(); // Call backend resend
                      } : null,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          gradient: resendTimer == 0
                              ? LinearGradient(
                            colors: [Color(0xFFFFD700).withOpacity(0.3), Color(0xFFFFD700).withOpacity(0.1)],
                          )
                              : null,
                        ),
                        child: Text(
                          resendTimer == 0 ? 'Resend OTP' : 'Resend in ${resendTimer}s',
                          style: TextStyle(
                            color: resendTimer == 0 ? Color(0xFFFFD700) : Colors.white.withOpacity(0.5),
                            fontSize: isTablet ? 16 : 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: screenHeight * 0.03),

                // Change Contact Option
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Text(
                    'Change Mobile Number?',
                    style: TextStyle(
                      color: Color(0xFFFFD700),
                      fontSize: isTablet ? 16 : 14,
                      fontWeight: FontWeight.w600,
                    ),
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