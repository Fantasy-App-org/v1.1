import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'About Us',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black, Colors.grey[800]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.sports_cricket,
                    size: 60,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Star25Pro',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Showcase your cricket knowledge and win prizes',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // What We Do Section
            _buildSection(
              title: 'What We Do',
              icon: Icons.info_outline,
              content: 'Star25Pro is an online fantasy game owned and operated by Dayasara Entertainment Private Limited. Star25Pro allows users to showcase their knowledge and interest in Cricket, apply their skills, and win prizes. Users can create a team of eleven players of their choice, who will score runs, take wickets, and earn points.\n\nNot just as spectators, users can actively manage their teams. Star25Pro is managed by a team of skilled professionals.',
            ),

            const SizedBox(height: 24),

            // Our Contests Section
            _buildSection(
              title: 'Our Contests',
              icon: Icons.emoji_events,
              content: 'Users can install the application from Google Play and create multiple teams for a single cricket match. They can experiment with different team combinations, select captains, predict the best player of the match, and choose their favorite bowlers, all-rounders, and wicketkeepers.\n\nUsers can also invite their friends and family to participate in contests.',
            ),

            const SizedBox(height: 24),

            // Entry Fees & Rewards Section
            Row(
              children: [
                Expanded(
                  child: _buildInfoCard(
                    title: 'Entry Fees',
                    icon: Icons.payment,
                    content: 'Each contest has a fixed entry fee determined by our management team. While users can create teams for free, an entry fee is required to join a contest.',
                    color: Colors.grey[200]!,
                    iconColor: Colors.black,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildInfoCard(
                    title: 'Rewards',
                    icon: Icons.card_giftcard,
                    content: 'Simply play based on your skills! If your team wins and secures the first rank, you will receive the allocated prize.',
                    color: Colors.grey[300]!,
                    iconColor: Colors.black,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Consolation Prizes Section
            _buildSection(
              title: 'Consolation Prizes',
              icon: Icons.star,
              content: 'We appreciate every player who participates, even if they don\'t win a prize. Star25Pro values your skills, efforts, and trust. That\'s why we provide consolation prizes to users who join contests but don\'t secure a winning rank.\n\nWith us, there\'s nothing to lose—it\'s always a win-win!\n\nAll rewards, including winnings and consolation prizes, will be credited to the user\'s wallet, which they can withdraw anytime.',
            ),

            const SizedBox(height: 24),

            // Legal Position Section
            _buildSection(
              title: 'Legal Position',
              icon: Icons.gavel,
              content: '',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLegalItem(
                    title: 'Is playing Star25Pro legal?',
                    description: 'Yes, it is absolutely safe. Star25Pro is a game of skill. Indian law clearly distinguishes between games of skill and games of chance. Unlike gambling, games that require skill are completely legal.',
                  ),
                  const SizedBox(height: 16),
                  _buildLegalItem(
                    title: 'Compliance & Monitoring',
                    description: 'All contests hosted by Star25Pro are carefully designed, and we strictly monitor the jurisdiction of prize winners to ensure compliance with the relevant laws in India.',
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red[200]!),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.warning, color: Colors.red[600], size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Users from the states of Assam, Sikkim, Nagaland, Odisha, Telangana, Andhra Pradesh, and Tamil Nadu are not allowed to play Star25Pro.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.red[800],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Contact Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.contact_mail, color: Colors.black),
                      const SizedBox(width: 8),
                      const Text(
                        'Get In Touch',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildContactItem(Icons.email, 'support@Star25Pro.com'),
                  _buildContactItem(Icons.business, 'Dayasara Entertainment Private Limited'),
                  _buildContactItem(Icons.download, 'Available on Google Play Store'),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required String content,
    Widget? child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.black),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (content.isNotEmpty)
            Text(
              content,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
          if (child != null) child,
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required IconData icon,
    required String content,
    required Color color,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: iconColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegalItem({
    required String title,
    required String description,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          description,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildContactItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Example usage in main.dart