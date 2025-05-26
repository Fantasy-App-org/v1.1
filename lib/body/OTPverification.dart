import 'package:flutter/material.dart';
import '../service/user_service.dart';
import 'homescreen.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String contact;
  final bool isEmail;
  final UserService userService; //add user_service parameter

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
  bool isVerifying = false; //add loading state
  String? errorMessage; //add error message state
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

  //resend OTP
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
              // otp icon
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

              Text(
                'OTP Verification',
                style: TextStyle(
                  fontSize: isTablet ? 28 : 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[900],
                ),
              ),

              SizedBox(height: screenHeight * 0.02),

              Text(
                'We have sent a verification code to',
                style: TextStyle(
                  fontSize: isTablet ? 16 : 14,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: screenHeight * 0.01),

              Text(
                widget.isEmail ? widget.contact : '+91 ${widget.contact}',
                style: TextStyle(
                  fontSize: isTablet ? 18 : 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),

              SizedBox(height: screenHeight * 0.04),

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

              // error message
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

              // verify button
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

              // resend otp
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

              // change number/ email
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