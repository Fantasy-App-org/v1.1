import 'package:flutter/material.dart';
import 'package:fantasy/pages/homescreen.dart';

class Dream11LoginPage extends StatefulWidget {
  const Dream11LoginPage({Key? key}) : super(key: key);

  @override
  State<Dream11LoginPage> createState() => _Dream11LoginPageState();
}

class _Dream11LoginPageState extends State<Dream11LoginPage> {
  // Define state variables with proper initialization
  bool isEmailLogin = false; // Changed from _isEmailLogin to isEmailLogin
  bool isAgeVerified = false; // Changed from _isAgeVerified to isAgeVerified
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    // Clean up controllers
    mobileController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get device dimensions for responsive design
    final Size screenSize = MediaQuery.of(context).size;
    final double screenHeight = screenSize.height;
    final double screenWidth = screenSize.width;

    // Calculate responsive dimensions
    final double headerHeight = screenHeight * 0.15;
    final double buttonHeight = screenHeight * 0.06;
    final double horizontalPadding = screenWidth * 0.05;
    final double verticalSpacing = screenHeight * 0.02;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // App bar with gradient background
            Container(
              height: headerHeight,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF8B0000), Color(0xFF9A0000)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            // Handle back button
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              isEmailLogin ? 'Welcome Back!' : 'Login/Register',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            // Handle help button
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Help'),
                                content: const Text('Need help with logging in? Contact our support team at support@dream11.com'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: const Icon(
                            Icons.help_outline,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: verticalSpacing * 0.5),
                    Text(
                      isEmailLogin ? 'Ready to play and win?' : 'Let\'s get you started',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(horizontalPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: verticalSpacing * 1.5),

                        // Input field
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF2F2F2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TextField(
                            controller: isEmailLogin ? emailController : mobileController,
                            keyboardType: isEmailLogin ? TextInputType.emailAddress : TextInputType.phone,
                            decoration: InputDecoration(
                              hintText: isEmailLogin ? 'Email address' : 'Mobile number',
                              hintStyle: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 18,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: horizontalPadding,
                                  vertical: verticalSpacing
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: verticalSpacing * 1.5),

                        // Age verification checkbox
                        Row(
                          children: [
                            SizedBox(
                              width: 24,
                              height: 24,
                              child: Checkbox(
                                value: isAgeVerified,
                                onChanged: (value) {
                                  setState(() {
                                    isAgeVerified = value ?? false;
                                  });
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                side: BorderSide(
                                  color: Colors.grey[400]!,
                                  width: 1.5,
                                ),
                              ),
                            ),
                            SizedBox(width: screenWidth * 0.03),
                            const Text(
                              'I certify that I am above 18 years',
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: verticalSpacing * 1.5),

                        // Continue button
                        GestureDetector(
                          onTap: isAgeVerified
                              ? () {
                            // Navigate to home screen
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => const HomeScreen(),
                              ),
                            );
                          }
                              : null,
                          child: Container(
                            width: double.infinity,
                            height: buttonHeight,
                            decoration: BoxDecoration(
                              color: isAgeVerified
                                  ? const Color(0xFF8B0000)
                                  : const Color(0xFFE8F0F2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                'CONTINUE',
                                style: TextStyle(
                                  color: isAgeVerified
                                      ? Colors.white
                                      : const Color(0xFFA0A0A0),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: verticalSpacing),

                        // Terms and conditions text
                        Center(
                          child: RichText(
                            text: const TextSpan(
                              text: 'By continuing, I agree to Dream11\'s ',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 14,
                              ),
                              children: [
                                TextSpan(
                                  text: 'T&C',
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                TextSpan(
                                  text: '.',
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: verticalSpacing * 1.5),

                        // Handle different options based on login mode
                        isEmailLogin
                            ? buildEmailLoginOptions(screenWidth, verticalSpacing)
                            : buildMobileLoginOptions(screenWidth, verticalSpacing),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Removed the underscore from all method names to make them public
  Widget buildEmailLoginOptions(double screenWidth, double verticalSpacing) {
    return Column(
      children: [
        // Divider with OR
        buildDividerWithText('OR'),

        SizedBox(height: verticalSpacing * 1.5),

        // Social login buttons
        Row(
          children: [
            Expanded(
              child: buildSocialButton(
                icon: Icons.facebook,
                text: 'FACEBOOK',
                iconColor: Colors.blue[800]!,
              ),
            ),
            SizedBox(width: screenWidth * 0.04),
            Expanded(
              child: buildSocialButton(
                icon: Icons.g_mobiledata,
                text: 'GOOGLE',
                iconColor: Colors.red,
              ),
            ),
          ],
        ),

        SizedBox(height: verticalSpacing * 2),

        // Mobile number option
        Center(
          child: GestureDetector(
            onTap: () {
              setState(() {
                isEmailLogin = false;
              });
            },
            child: Column(
              children: [
                const Text(
                  'Use Mobile Number',
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: verticalSpacing * 0.3),
                Container(
                  height: 1,
                  width: screenWidth * 0.4,
                  color: Colors.black87,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget buildMobileLoginOptions(double screenWidth, double verticalSpacing) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildLoginOption(
          text: 'Have an invite Code?',
          isHighlighted: true,
          onTap: () {
            // Handle invite code
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Enter Invite Code'),
                content: TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter your invite code',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('CANCEL'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('SUBMIT'),
                  ),
                ],
              ),
            );
          },
        ),
        Container(
          width: 1,
          height: 24,
          color: Colors.grey[300],
          margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
        ),
        buildLoginOption(
          text: 'Other login options',
          isHighlighted: false,
          onTap: () {
            setState(() {
              isEmailLogin = true;
            });
          },
        ),
      ],
    );
  }

  Widget buildDividerWithText(String text) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            color: Colors.grey[300],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            text,
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            color: Colors.grey[300],
          ),
        ),
      ],
    );
  }

  Widget buildSocialButton({
    required IconData icon,
    required String text,
    required Color iconColor,
  }) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: iconColor,
            size: 24,
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLoginOption({
    required String text,
    required bool isHighlighted,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            text,
            style: TextStyle(
              color: isHighlighted ? const Color(0xFFB8860B) : Colors.black87,
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 5),
          Container(
            height: 1,
            width: 140,
            color: Colors.grey[400],
          ),
        ],
      ),
    );
  }
}