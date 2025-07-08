import 'package:flutter/material.dart';
import '../auth/login.dart';
import '../drawe_pages/about_us.dart';
import '../drawe_pages/profile.dart';
import '../body/refral.dart';
import '../body/wallet.dart';
import '../drawe_pages/Legality_pages.dart';
import '../drawe_pages/fantasy point system.dart';
import '../drawe_pages/how_to_play.dart';
import '../drawe_pages/transection_history.dart';


class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          _buildDrawerHeader(context),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  context,
                  Icons.person_rounded,
                  'Profile',
                      () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfilePage()),
                    );
                  },
                ),
                _buildDrawerItem(
                  context,
                  Icons.share_rounded,
                  'Referral',
                      () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ReferralScreen()),
                    );
                  },
                ),
                _buildDrawerItem(
                  context,
                  Icons.account_balance_wallet_rounded,
                  'Wallet',
                      () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => WalletScreen()),
                    );
                  },
                ),
                _buildDrawerItem(
                  context,
                  Icons.history_rounded,
                  'Transaction History',
                      () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TransactionHistoryPage(),
                      ),
                    );
                  },
                ),
                _buildDrawerItem(
                  context,
                  Icons.stars_rounded,
                  'Fantasy Points',
                      () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FantasyPointsPage(),
                      ),
                    );
                  },
                ),
                _buildDrawerItem(
                  context,
                  Icons.help_outline_rounded,
                  'How To Play',
                      () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HowToPlayPage(),
                      ),
                    );
                  },
                ),
                _buildDrawerItem(
                  context,
                  Icons.info_rounded,
                  'About Us',
                      () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AboutUsPage(),
                      ),
                    );
                  },
                ),
                _buildDrawerItem(
                  context,
                  Icons.support_agent_rounded,
                  'Legality',
                      () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LegalityPage(),
                      ),
                    );
                  },
                ),
                _buildDrawerItem(
                  context,
                  Icons.help_center_rounded,
                  'FAQ',
                      () {
                    // Navigate to FAQ page when created
                  },
                ),
                Divider(height: 16),
                _buildDrawerItem(
                  context,
                  Icons.logout_rounded,
                  'Logout',
                      () {
                    _showLogoutDialog(context);
                  },
                  isDestructive: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context); // Close the drawer first
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage()),
        );
      },
      child: Container(
        height: 280,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF667eea),
              Color(0xFF764ba2),
              Color(0xFF667eea),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.0, 0.5, 1.0],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background pattern
            Positioned(
              top: -50,
              right: -50,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
            ),
            Positioned(
              top: 30,
              right: 20,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.05),
                ),
              ),
            ),
            // Main content
            SafeArea(
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Avatar with border and shadow
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 15,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 32,
                          backgroundColor: Color(0xFF4F46E5),
                          child: Text(
                            'JD',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          // If you have profile image, use this instead:
                          // backgroundImage: NetworkImage('your_image_url'),
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    // User name with better styling
                    Text(
                      'John Doe',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: 4),
                    // Role with icon
                    Row(
                      children: [
                        Icon(
                          Icons.sports_cricket,
                          color: Colors.white.withOpacity(0.9),
                          size: 16,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'Fantasy Cricket Player',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    // Premium badge or status
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.amber.withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 14,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Pro Player',
                            style: TextStyle(
                              color: Colors.amber,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12),
                    // Edit profile hint
                    Row(
                      children: [
                        Text(
                          'Tap to view profile',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        SizedBox(width: 6),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white.withOpacity(0.7),
                          size: 12,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
      BuildContext context,
      IconData icon,
      String title,
      VoidCallback onTap, {
        bool isDestructive = false,
      }) {
    return ListTile(
      leading: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDestructive
              ? Color(0xFFEF4444).withOpacity(0.1)
              : Color(0xFF3B82F6).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: isDestructive ? Color(0xFFEF4444) : Color(0xFF3B82F6),
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDestructive ? Color(0xFFEF4444) : Color(0xFF1E293B),
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 4),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.logout_rounded, color: Color(0xFFEF4444)),
              SizedBox(width: 12),
              Text(
                'Logout',
                style: TextStyle(
                  color: Color(0xFF1E293B),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: Text(
            'Are you sure you want to logout?',
            style: TextStyle(
              color: Color(0xFF64748B),
              fontSize: 16,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Color(0xFF64748B),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Dream11LoginPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFEF4444),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Logout',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}