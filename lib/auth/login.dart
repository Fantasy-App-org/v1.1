import 'package:fantasy/auth/signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../body/homescreen.dart';

class Dream11LoginPage extends StatefulWidget {
  const Dream11LoginPage({Key? key}) : super(key: key);

  @override
  State<Dream11LoginPage> createState() => _Dream11LoginPageState();
}

class _Dream11LoginPageState extends State<Dream11LoginPage> {
  bool isEmailLogin = false;
  bool isAgeVerified = false;
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController referralController = TextEditingController();

  @override
  void dispose() {
    mobileController.dispose();
    emailController.dispose();
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Premium Header with Gradient - Using same colors as drawer
              Container(
                height: screenHeight * 0.35,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1E3A8A), Color(0xFF1E293B)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    // Pattern Background
                    Positioned(
                      right: -50,
                      top: -50,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                    ),
                    Positioned(
                      left: -30,
                      bottom: -30,
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.05),
                        ),
                      ),
                    ),

                    // Content
                    Padding(
                      padding: EdgeInsets.all(screenWidth * 0.05),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                          ),
                          Spacer(),
                          Text(
                            'Welcome to',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: isTablet ? 18 : 16,
                            ),
                          ),
                          Text(
                            'Fantasy Cricket',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isTablet ? 36 : 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          Text(
                            'Play, Win & Celebrate',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: isTablet ? 16 : 14,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.03),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Login Form Container
              Container(
                transform: Matrix4.translationValues(0, -30, 0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: Offset(0, -5),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(screenWidth * 0.06),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: screenHeight * 0.02),

                      // Login/Register Tabs
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: () => setState(() => isEmailLogin = false),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.06,
                                    vertical: screenHeight * 0.015,
                                  ),
                                  decoration: BoxDecoration(
                                    color: !isEmailLogin ? Color(0xFF1E3A8A) : Colors.transparent,
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Text(
                                    'Mobile',
                                    style: TextStyle(
                                      color: !isEmailLogin ? Colors.white : Colors.grey[600],
                                      fontWeight: FontWeight.w600,
                                      fontSize: isTablet ? 16 : 14,
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => setState(() => isEmailLogin = true),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.06,
                                    vertical: screenHeight * 0.015,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isEmailLogin ? Color(0xFF1E3A8A) : Colors.transparent,
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Text(
                                    'Email',
                                    style: TextStyle(
                                      color: isEmailLogin ? Colors.white : Colors.grey[600],
                                      fontWeight: FontWeight.w600,
                                      fontSize: isTablet ? 16 : 14,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.04),

                      // Input Field
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: TextField(
                          controller: isEmailLogin ? emailController : mobileController,
                          keyboardType: isEmailLogin ? TextInputType.emailAddress : TextInputType.phone,
                          style: TextStyle(fontSize: isTablet ? 18 : 16),
                          decoration: InputDecoration(
                            hintText: isEmailLogin ? 'Email address' : 'Mobile number',
                            hintStyle: TextStyle(
                              color: Colors.grey[400],
                              fontSize: isTablet ? 18 : 16,
                            ),
                            prefixIcon: Icon(
                              isEmailLogin ? Icons.email_outlined : Icons.phone_outlined,
                              color: Colors.grey[400],
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.04,
                              vertical: screenHeight * 0.02,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.0),

                      // Referral Code Field

                      SizedBox(height: screenHeight * 0.02),

                      // Age Verification with Custom Checkbox
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => setState(() => isAgeVerified = !isAgeVerified),
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: isAgeVerified ? Color(0xFF1E3A8A) : Colors.white,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: isAgeVerified ? Color(0xFF1E3A8A) : Colors.grey[300]!,
                                  width: 2,
                                ),
                              ),
                              child: isAgeVerified
                                  ? Icon(Icons.check, color: Colors.white, size: 16)
                                  : null,
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.03),
                          Expanded(
                            child: Text(
                              'I certify that I am above 18 years',
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: isTablet ? 16 : 14,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: screenHeight * 0.04),

                      // Continue Button
                      GestureDetector(
                        onTap: isAgeVerified
                            ? () {
                          String contact = isEmailLogin ? emailController.text : mobileController.text;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OTPVerificationScreen(
                                contact: contact,
                                isEmail: isEmailLogin,
                              ),
                            ),
                          );
                        }
                            : null,
                        child: Container(
                          width: double.infinity,
                          height: screenHeight * 0.07,
                          decoration: BoxDecoration(
                            gradient: isAgeVerified
                                ? LinearGradient(
                              colors: [Color(0xFF1E3A8A), Color(0xFF1E293B)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                                : null,
                            color: isAgeVerified ? null : Colors.grey[300],
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: isAgeVerified
                                ? [
                              BoxShadow(
                                color: Color(0xFF1E3A8A).withOpacity(0.3),
                                blurRadius: 12,
                                offset: Offset(0, 6),
                              ),
                            ]
                                : null,
                          ),
                          child: Center(
                            child: Text(
                              'CONTINUE',
                              style: TextStyle(
                                color: isAgeVerified ? Colors.white : Colors.grey[500],
                                fontSize: isTablet ? 18 : 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.02),

                      // Terms Text
                      Center(
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: 'By continuing, you agree to our ',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: isTablet ? 14 : 12,
                            ),
                            children: [
                              TextSpan(
                                text: 'Terms & Conditions',
                                style: TextStyle(
                                  color: Color(0xFF1E3A8A),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextSpan(text: ' and '),
                              TextSpan(
                                text: 'Privacy Policy',
                                style: TextStyle(
                                  color: Color(0xFF1E3A8A),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.03),

                      // Divider
                      Row(
                        children: [
                          Expanded(child: Divider(color: Colors.grey[300])),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                            child: Text(
                              'OR',
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: isTablet ? 14 : 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Expanded(child: Divider(color: Colors.grey[300])),
                        ],
                      ),

                      SizedBox(height: screenHeight * 0.03),

                      // Social Login Options
                      Column(
                        children: [
                          _buildSocialButton(
                            'Continue with Google',
                            'assets/images/google_icon.png',
                            Colors.white,
                            screenWidth,
                            screenHeight,
                            isTablet,
                          ),
                          SizedBox(height: screenHeight * 0.015),
                          _buildSocialButton(
                            'Continue with Facebook',
                            'assets/images/facebook_icon.png',
                            Color(0xFF1877F2),
                            screenWidth,
                            screenHeight,
                            isTablet,
                            isWhiteText: true,
                          ),
                        ],
                      ),

                      SizedBox(height: screenHeight * 0.03),

                      // Register Now Option (replaced "Have an invite code?")
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: isTablet ? 16 : 14,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // Navigate to SignUp page
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignupPage()
                                ),
                              );
                            },
                            child: Text(
                              'Register Now',
                              style: TextStyle(
                                color: Color(0xFF1E3A8A),
                                fontSize: isTablet ? 16 : 14,
                                fontWeight: FontWeight.w600,
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton(
      String text,
      String imagePath,
      Color bgColor,
      double screenWidth,
      double screenHeight,
      bool isTablet, {
        bool isWhiteText = false,
      }) {
    return Container(
      width: double.infinity,
      height: screenHeight * 0.06,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imagePath,
            width: 24,
            height: 24,
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                text.contains('Google') ? Icons.g_mobiledata : Icons.facebook,
                color: text.contains('Google') ? Colors.red : Colors.white,
                size: 24,
              );
            },
          ),
          SizedBox(width: screenWidth * 0.03),
          Text(
            text,
            style: TextStyle(
              color: isWhiteText ? Colors.white : Colors.black87,
              fontSize: isTablet ? 16 : 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// OTP Verification Screen
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

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final List<TextEditingController> otpControllers = List.generate(
    6,
        (index) => TextEditingController(),
  );
  final List<FocusNode> focusNodes = List.generate(
    6,
        (index) => FocusNode(),
  );

  bool isOTPComplete = false;
  int resendTimer = 30;

  @override
  void initState() {
    super.initState();
    startResendTimer();

    // Check if OTP is complete whenever text changes
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

  @override
  void dispose() {
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(screenWidth * 0.06),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // OTP Icon
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Color(0xFF1E3A8A).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.lock_clock,
                  size: 60,
                  color: Color(0xFF1E3A8A),
                ),
              ),

              SizedBox(height: screenHeight * 0.03),

              // Title
              Text(
                'OTP Verification',
                style: TextStyle(
                  fontSize: isTablet ? 28 : 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[900],
                ),
              ),

              SizedBox(height: screenHeight * 0.02),

              // Description
              Text(
                'We have sent a verification code to',
                style: TextStyle(
                  fontSize: isTablet ? 16 : 14,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: screenHeight * 0.01),

              // Contact Display
              Text(
                widget.isEmail ? widget.contact : '+91 ${widget.contact}',
                style: TextStyle(
                  fontSize: isTablet ? 18 : 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),

              SizedBox(height: screenHeight * 0.04),

              // OTP Input Fields
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: isTablet ? 60 : 45,
                    height: isTablet ? 60 : 50,
                    child: TextField(
                      controller: otpControllers[index],
                      focusNode: focusNodes[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      style: TextStyle(
                        fontSize: isTablet ? 24 : 20,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Color(0xFF1E3A8A), width: 2),
                        ),
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

              SizedBox(height: screenHeight * 0.04),

              // Verify Button
              GestureDetector(
                onTap: isOTPComplete
                    ? () {
                  // Navigate to home screen after OTP verification
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const HomeScreen(),
                    ),
                  );
                }
                    : null,
                child: Container(
                  width: double.infinity,
                  height: screenHeight * 0.07,
                  decoration: BoxDecoration(
                    gradient: isOTPComplete
                        ? LinearGradient(
                      colors: [Color(0xFF1E3A8A), Color(0xFF1E293B)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                        : null,
                    color: isOTPComplete ? null : Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: isOTPComplete
                        ? [
                      BoxShadow(
                        color: Color(0xFF1E3A8A).withOpacity(0.3),
                        blurRadius: 12,
                        offset: Offset(0, 6),
                      ),
                    ]
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      'VERIFY OTP',
                      style: TextStyle(
                        color: isOTPComplete ? Colors.white : Colors.grey[500],
                        fontSize: isTablet ? 18 : 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: screenHeight * 0.03),

              // Resend OTP
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Didn't receive the code? ",
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: isTablet ? 16 : 14,
                    ),
                  ),
                  GestureDetector(
                    onTap: resendTimer == 0
                        ? () {
                      setState(() {
                        resendTimer = 30;
                        startResendTimer();
                      });
                      // Resend OTP logic here
                    }
                        : null,
                    child: Text(
                      resendTimer > 0 ? 'Resend in ${resendTimer}s' : 'Resend OTP',
                      style: TextStyle(
                        color: resendTimer > 0 ? Colors.grey[600] : Color(0xFF1E3A8A),
                        fontSize: isTablet ? 16 : 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: screenHeight * 0.03),

              // Change Number/Email Option
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Text(
                  'Change ${widget.isEmail ? 'Email' : 'Mobile Number'}?',
                  style: TextStyle(
                    color: Color(0xFF1E3A8A),
                    fontSize: isTablet ? 16 : 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}