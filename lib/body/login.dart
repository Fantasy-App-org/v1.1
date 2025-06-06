import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../service/user_service.dart'; // Use UserService instead of login_api
import 'homescreen.dart';
import 'signup.dart'; // Add this import for SignupPage

class Dream11LoginPage extends StatefulWidget {
  const Dream11LoginPage({Key? key}) : super(key: key);

  @override
  State<Dream11LoginPage> createState() => _Dream11LoginPageState();
}

class _Dream11LoginPageState extends State<Dream11LoginPage> {
  bool isEmailLogin = false;
  bool isAgeVerified = false;
  bool isLoading = false;
  String? errorMessage;
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController referralController = TextEditingController();
  final UserService _userService = UserService(); // Use UserService

  @override
  void initState() {
    super.initState();
    _initializeService();
  }

  Future<void> _initializeService() async {
    // Initialize the service
    await _userService.initialize();
    // Check login status after initialization
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final bool isLoggedIn = await _userService.checkLoginStatus();
    if (isLoggedIn) {
      // Token is automatically available through UserService
      print('User is logged in with token: ${_userService.authToken}');
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  Future<void> _requestOtp() async {
    if (!isAgeVerified) {
      setState(() {
        errorMessage = "Please verify that you are above 18 years";
      });
      return;
    }

    String contact = isEmailLogin ? emailController.text : mobileController.text;

    if (contact.isEmpty) {
      setState(() {
        errorMessage = isEmailLogin
            ? "Please enter your email address"
            : "Please enter your mobile number";
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
          MaterialPageRoute(
            builder: (context) => OTPVerificationScreen(
              contact: contact,
              isEmail: isEmailLogin,
              userService: _userService,
            ),
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

                    //content
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

              //login Form Container
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

                      //login/register tabs
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

                      //input field
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

                      SizedBox(height: screenHeight * 0.02),

                      //referral field
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: TextField(
                          controller: referralController,
                          textCapitalization: TextCapitalization.characters,
                          style: TextStyle(fontSize: isTablet ? 18 : 16),
                          decoration: InputDecoration(
                            hintText: 'Referral Code (Optional)',
                            hintStyle: TextStyle(
                              color: Colors.grey[400],
                              fontSize: isTablet ? 18 : 16,
                            ),
                            prefixIcon: Icon(
                              Icons.card_giftcard_outlined,
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

                      SizedBox(height: screenHeight * 0.03),

                      //age verification and custom checkbox
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

                      //error message
                      if (errorMessage != null) ...[
                        SizedBox(height: screenHeight * 0.02),
                        Text(
                          errorMessage!,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: isTablet ? 14 : 12,
                          ),
                        ),
                      ],

                      SizedBox(height: screenHeight * 0.04),

                      GestureDetector(
                        onTap: isAgeVerified && !isLoading ? _requestOtp : null,
                        child: Container(
                          width: double.infinity,
                          height: screenHeight * 0.07,
                          decoration: BoxDecoration(
                            gradient: isAgeVerified && !isLoading
                                ? LinearGradient(
                              colors: [Color(0xFF1E3A8A), Color(0xFF1E293B)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                                : null,
                            color: isAgeVerified && !isLoading ? null : Colors.grey[300],
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: isAgeVerified && !isLoading
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
                            child: isLoading
                                ? CircularProgressIndicator(color: Colors.white)
                                : Text(
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

                      // Don't have an account? Sign up
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignupPage(),
                                ),
                              );
                            },
                            child: Text(
                              'Sign up',
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

class OTPVerificationScreen extends StatefulWidget {
  final String contact;
  final bool isEmail;
  final UserService userService;

  const OTPVerificationScreen({
    Key? key,
    required this.contact,
    required this.isEmail,
    required this.userService,
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
  bool isVerifying = false;
  String? errorMessage;
  int resendTimer = 30;

  @override
  void initState() {
    super.initState();
    startResendTimer();

    //check if otp is complete whenever text changes
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

  //verify otp with the service
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
        //home screen on success
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
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

  // resend otp
  Future<void> _resendOTP() async {
    if (resendTimer > 0) {
      return;
    }

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
          SnackBar(content: Text('OTP sent successfully')),
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

              //error message
              if (errorMessage != null) ...[
                SizedBox(height: screenHeight * 0.02),
                Text(
                  errorMessage!,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: isTablet ? 14 : 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],

              SizedBox(height: screenHeight * 0.04),

              //verify button
              GestureDetector(
                onTap: isOTPComplete && !isVerifying ? _verifyOTP : null,
                child: Container(
                  width: double.infinity,
                  height: screenHeight * 0.07,
                  decoration: BoxDecoration(
                    gradient: isOTPComplete && !isVerifying
                        ? LinearGradient(
                      colors: [Color(0xFF1E3A8A), Color(0xFF1E293B)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                        : null,
                    color: isOTPComplete && !isVerifying ? null : Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: isOTPComplete && !isVerifying
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
                    child: isVerifying
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
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

              //resend otp
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
                    onTap: (resendTimer == 0 && !isVerifying) ? _resendOTP : null,
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

              //change number/email
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