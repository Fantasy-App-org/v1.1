import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:fantasy/service/user_service.dart'; // Update path as needed

class ReferralScreen extends StatefulWidget {
  const ReferralScreen({Key? key}) : super(key: key);

  @override
  State<ReferralScreen> createState() => _ReferralScreenState();
}

class _ReferralScreenState extends State<ReferralScreen> {
  final UserService _userService = UserService();
  String? _inviteCode;
  int _referredCount = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Add a small delay to ensure the screen is fully built before making API calls
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadReferralData();
    });
  }

  Future<void> _loadReferralData() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {

      // Check if user is logged in first
      final isLoggedIn = await _userService.checkLoginStatus();
      print('👤 Login status: $isLoggedIn');

      if (!isLoggedIn) {
        print('❌ User not logged in, cannot fetch referral data');
        if (mounted) {
          setState(() {
            _inviteCode = 'Please login first';
            _referredCount = 0;
            _isLoading = false;
          });
        }
        return;
      }

      // Try to get referral data from API
      print('📡 Fetching referral data from API...');
      final referralData = await _userService.getReferralData();
      print('📥 Referral data received: $referralData');

      if (referralData != null && mounted) {
        print('✅ Using API data - invite_code: ${referralData['invite_code']}, referred_count: ${referralData['referred_count']}');
        setState(() {
          _inviteCode = referralData['invite_code'];
          _referredCount = referralData['referred_count'] ?? 0;
          _isLoading = false;
        });
      } else {
        print('⚠️ API failed or returned null, trying fallback from user data');
        // Fallback to user data if API fails
        final fallbackCode = _userService.inviteFriendCode;
        print('🔄 Fallback invite code: $fallbackCode');

        if (mounted) {
          setState(() {
            _inviteCode = fallbackCode ?? 'N/A';
            _referredCount = 0;
            _isLoading = false;
          });

          // Show error message if no invite code found
          if (fallbackCode == null || fallbackCode == 'N/A') {
            _showSnackBar(
              'Unable to load referral code. Please try again.',
              Colors.orange[600]!,
              showRetry: true,
            );
          }
        }
      }
    } catch (e) {
      print('❌ Error loading referral data: $e');

      if (mounted) {
        // Try fallback on error
        final fallbackCode = _userService.inviteFriendCode;
        setState(() {
          _inviteCode = fallbackCode ?? 'Error loading code';
          _referredCount = 0;
          _isLoading = false;
        });

        // Show error message
        _showSnackBar(
          'Error loading referral data: ${e.toString()}',
          Colors.red[600]!,
          showRetry: true,
        );
      }
    }
  }

  void _showSnackBar(String message, Color backgroundColor, {bool showRetry = false}) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        action: showRetry ? SnackBarAction(
          label: 'Retry',
          textColor: Colors.white,
          onPressed: _loadReferralData,
        ) : null,
        duration: Duration(seconds: showRetry ? 5 : 3),
      ),
    );
  }

  void _shareOnWhatsApp() {
    if (_inviteCode != null &&
        _inviteCode != 'Loading...' &&
        _inviteCode != 'N/A' &&
        _inviteCode != 'Please login first' &&
        _inviteCode != 'Error loading code') {
      final message = "Download the exciting gaming app Star 25 pro from https://start25pro.com/ and use my invite code $_inviteCode to Play.";

      Share.share(
        message,
        subject: 'Join Star 25 Pro and Win!',
      );
    } else {
      _showSnackBar('Please wait for invite code to load', Colors.orange[600]!);
    }
  }

  void _shareMoreOptions() {
    if (_inviteCode != null &&
        _inviteCode != 'Loading...' &&
        _inviteCode != 'N/A' &&
        _inviteCode != 'Please login first' &&
        _inviteCode != 'Error loading code') {
      final message = "Download the exciting gaming app Star 25 pro from https://start25pro.com/ and use my invite code $_inviteCode to Play.";

      Share.share(
        message,
        subject: 'Join Star 25 Pro and Win!',
      );
    } else {
      _showSnackBar('Please wait for invite code to load', Colors.orange[600]!);
    }
  }

  void _copyInviteCode() {
    if (_inviteCode != null &&
        _inviteCode != 'Loading...' &&
        _inviteCode != 'N/A' &&
        _inviteCode != 'Please login first' &&
        _inviteCode != 'Error loading code') {
      Clipboard.setData(ClipboardData(text: _inviteCode!));
      _showSnackBar('Code copied successfully', Colors.green[600]!);
    } else {
      _showSnackBar('No valid invite code to copy', Colors.orange[600]!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenHeight = screenSize.height;
    final double screenWidth = screenSize.width;
    final bool isTablet = screenWidth > 600;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Invite Friends',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: screenWidth * 0.04),
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.035,
                  vertical: screenHeight * 0.01,
                ),
                decoration: BoxDecoration(
                  color: Colors.amber[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.amber[200]!),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.stars_rounded,
                      size: isTablet ? 18 : 16,
                      color: Colors.amber[700],
                    ),
                    Text(
                      ' 100 pts',
                      style: TextStyle(
                        color: Colors.amber[800],
                        fontWeight: FontWeight.w700,
                        fontSize: isTablet ? 16 : 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
            ),
            SizedBox(height: 16),
            Text(
              'Loading referral data...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      )
          : RefreshIndicator(
        onRefresh: _loadReferralData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // Header Section
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(screenWidth * 0.04),
                color: Colors.white,
                child: Column(
                  children: [
                    // Illustration and Text
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Get your friends to sign up',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: isTablet ? 16 : 14,
                                  ),
                                ),
                                SizedBox(height: screenHeight * 0.01),
                                Text(
                                  'Play & Win',
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: isTablet ? 30 : 26,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Premium Illustration
                          Container(
                            width: screenWidth * 0.3,
                            height: screenWidth * 0.25,
                            child: Stack(
                              children: [
                                Positioned(
                                  right: 0,
                                  child: Container(
                                    width: screenWidth * 0.2,
                                    height: screenWidth * 0.2,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          blurRadius: 15,
                                          offset: const Offset(0, 5),
                                        ),
                                      ],
                                      border: Border.all(color: Colors.grey[100]!),
                                    ),
                                    child: Icon(
                                      Icons.person_outline,
                                      size: screenWidth * 0.12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  child: Container(
                                    width: screenWidth * 0.15,
                                    height: screenWidth * 0.15,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [Colors.amber[400]!, Colors.amber[700]!],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.amber.withOpacity(0.3),
                                          blurRadius: 15,
                                          offset: const Offset(0, 5),
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      Icons.stars_rounded,
                                      size: screenWidth * 0.08,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03),

                    // Referral Code Section
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(screenWidth * 0.04),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Your Referral Code',
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: isTablet ? 16 : 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text('Referral Code Info'),
                                      content: Text('Share your referral code with friends. When they sign up using your code, you both earn bonus points!'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context),
                                          child: Text('Got it'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.info_outline,
                                    size: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: screenHeight * 0.015),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.04,
                              vertical: screenHeight * 0.02,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    _inviteCode ?? 'Loading...',
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: isTablet ? 20 : 18,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1.5,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(width: 8),
                                GestureDetector(
                                  onTap: _copyInviteCode,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: screenWidth * 0.03,
                                      vertical: screenHeight * 0.01,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.green[600],
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.copy_rounded,
                                          color: Colors.white,
                                          size: isTablet ? 18 : 16,
                                        ),
                                        SizedBox(width: screenWidth * 0.01),
                                        Text(
                                          'COPY',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: isTablet ? 14 : 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.015),

              // Share Buttons
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                child: Column(
                  children: [
                    // WhatsApp Button
                    GestureDetector(
                      onTap: _shareOnWhatsApp,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.green[600]!, Colors.green[700]!],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.green.withOpacity(0.2),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.phone_android,
                              color: Colors.white,
                              size: isTablet ? 22 : 20,
                            ),
                            SizedBox(width: screenWidth * 0.025),
                            Text(
                              'SHARE ON WHATSAPP',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: isTablet ? 16 : 14,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.015),

                    // More Options Button
                    GestureDetector(
                      onTap: _shareMoreOptions,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[300]!),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.share_outlined,
                              color: Colors.grey[700],
                              size: isTablet ? 22 : 20,
                            ),
                            SizedBox(width: screenWidth * 0.025),
                            Text(
                              'MORE OPTIONS',
                              style: TextStyle(
                                color: Colors.grey[800],
                                fontSize: isTablet ? 16 : 14,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.025),

              // Benefits Section
              Container(
                margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                padding: EdgeInsets.all(screenWidth * 0.04),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildBenefitItem(
                      icon: Icons.stars_rounded,
                      color: Colors.amber[700]!,
                      title: 'Earn 100 Points',
                      subtitle: 'For each friend that joins',
                      screenWidth: screenWidth,
                      isTablet: isTablet,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.015),
                      child: Divider(color: Colors.grey[200], thickness: 1),
                    ),
                    _buildBenefitItem(
                      icon: Icons.stars_rounded,
                      color: Colors.indigo[600]!,
                      title: 'They get 50 Points too!',
                      subtitle: 'Your friends also get a joining bonus',
                      screenWidth: screenWidth,
                      isTablet: isTablet,
                    ),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.025),

              // Progress Tracker - UPDATED WITH REAL DATA
              Container(
                margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                padding: EdgeInsets.all(screenWidth * 0.04),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Referral Progress',
                          style: TextStyle(
                            fontSize: isTablet ? 18 : 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        GestureDetector(
                          onTap: _loadReferralData,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: Colors.blue[200]!),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.refresh,
                                  size: 12,
                                  color: Colors.blue[600],
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Refresh',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.blue[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildProgressItem(
                          label: 'Invited',
                          value: _referredCount.toString(),
                          icon: Icons.send_outlined,
                          color: Colors.orange[600]!,
                          screenWidth: screenWidth,
                          isTablet: isTablet,
                        ),
                        _buildProgressItem(
                          label: 'Joined',
                          value: _referredCount.toString(), // Assuming all invited users joined
                          icon: Icons.person_add_outlined,
                          color: Colors.green[600]!,
                          screenWidth: screenWidth,
                          isTablet: isTablet,
                        ),
                        _buildProgressItem(
                          label: 'Earned',
                          value: '${_referredCount * 100} pts', // 100 points per referral
                          icon: Icons.stars_rounded,
                          color: Colors.amber[700]!,
                          screenWidth: screenWidth,
                          isTablet: isTablet,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.025),

              // Footer Links
              Container(
                padding: EdgeInsets.all(screenWidth * 0.04),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'To know about How it Works ',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: isTablet ? 14 : 12,
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            'Click Here',
                            style: TextStyle(
                              color: Colors.green[600],
                              fontWeight: FontWeight.w600,
                              fontSize: isTablet ? 14 : 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'To know about the Rules of FairPlay ',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: isTablet ? 14 : 12,
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            'Click Here',
                            style: TextStyle(
                              color: Colors.green[600],
                              fontWeight: FontWeight.w600,
                              fontSize: isTablet ? 14 : 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.015),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBenefitItem({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required double screenWidth,
    required bool isTablet,
  }) {
    return Row(
      children: [
        Container(
          width: isTablet ? 44 : 40,
          height: isTablet ? 44 : 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
            size: isTablet ? 24 : 22,
          ),
        ),
        SizedBox(width: screenWidth * 0.03),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: isTablet ? 16 : 14,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: isTablet ? 14 : 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProgressItem({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
    required double screenWidth,
    required bool isTablet,
  }) {
    return Column(
      children: [
        Container(
          width: isTablet ? 60 : 50,
          height: isTablet ? 60 : 50,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
            size: isTablet ? 28 : 24,
          ),
        ),
        SizedBox(height: screenWidth * 0.02),
        Text(
          value,
          style: TextStyle(
            fontSize: isTablet ? 18 : 16,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: isTablet ? 14 : 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}