import 'package:flutter/material.dart';

class LegalityPage extends StatefulWidget {
  const LegalityPage({Key? key}) : super(key: key);

  @override
  State<LegalityPage> createState() => _LegalityPageState();
}

class _LegalityPageState extends State<LegalityPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Legal Information (Entertainment Only)',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Terms of Service'),
            Tab(text: 'Privacy Policy'),
            Tab(text: 'Fair Play'),
            Tab(text: 'Age Restrictions'),
            Tab(text: 'Disclaimers'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTermsOfService(),
          _buildPrivacyPolicy(),
          _buildFairPlay(),
          _buildAgeRestrictions(),
          _buildDisclaimers(),
        ],
      ),
    );
  }

  Widget _buildTermsOfService() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLegalHeader(
            title: 'Terms of Service',
            icon: Icons.gavel,
            subtitle: 'Last updated: September 7, 2025',
          ),
          const SizedBox(height: 24),

          _buildLegalSection(
            title: '1. Acceptance of Terms',
            content:
            'By downloading, installing, or using our fantasy sports application ("the App"), you agree to be bound by these Terms of Service. '
                'If you do not agree to these terms, please do not use the App.',
          ),

          _buildLegalSection(
            title: '2. Fantasy Sports Gameplay (Entertainment Only)',
            content:
            'The App provides an entertainment-only fantasy sports experience where users create virtual teams using real player statistics. '
                'It is a game of skill that rewards knowledge and strategy. Points are virtual and have no monetary (cash) value and cannot be redeemed.',
          ),

          _buildLegalSection(
            title: '3. User Eligibility',
            content:
            'Users must be at least 18 years old to make payments or access any paid features. '
                'Free/practice modes may be available to users aged 13+ with verified parental consent. '
                'Users must comply with local laws regarding fantasy sports participation.',
          ),

          _buildLegalSection(
            title: '4. Account Responsibilities',
            content:
            'Users are responsible for maintaining account security, providing accurate information, and complying with all rules and regulations. '
                'Multiple accounts per person are prohibited.',
          ),

          _buildLegalSection(
            title: '5. Contest Rules',
            content:
            'Each contest may have specific rules for lineup creation and scoring. '
                'Leaderboards and point allocations are final. No monetary rewards are offered or distributed by the App.',
          ),

          _buildLegalSection(
            title: '6. Prohibited Activities',
            content:
            'Users may not engage in collusion, use automated systems, share account information, or participate in any activity that compromises fair play or violates applicable laws.',
          ),

          _buildLegalSection(
            title: '7. Payments & Access Fees (No Withdrawals)',
            content:
            'Any payment collected by the App is an access/participation fee for gameplay features and services. '
                'Fees are not stakes or wagers and are generally non-refundable except where required by law. '
                'The App does not support cash withdrawals, and points cannot be exchanged for cash or items of monetary value.',
          ),

          _buildLegalSection(
            title: '8. Limitation of Liability',
            content:
            'The App is provided "as is" without warranty. We are not liable for damages arising from use of the App, including but not limited to technical issues or perceived financial losses. '
                'No financial returns or monetary winnings are promised or provided.',
          ),

          _buildLegalSection(
            title: '9. Termination',
            content:
            'We reserve the right to suspend or terminate accounts for violations of these terms, suspicious activity, or at our discretion. '
                'Users may close accounts at any time.',
          ),

          _buildLegalSection(
            title: '10. Changes to Terms',
            content:
            'These terms may be updated periodically. Continued use of the App after changes constitutes acceptance of the new terms. '
                'Users will be notified of significant changes.',
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyPolicy() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLegalHeader(
            title: 'Privacy Policy',
            icon: Icons.privacy_tip,
            subtitle: 'Your privacy is important to us',
          ),
          const SizedBox(height: 24),

          _buildLegalSection(
            title: 'Information We Collect',
            content:
            'We may collect personal information such as name, email, age, location, and payment details for access/participation fees. '
                'We also collect usage data, device information, and gameplay statistics to improve our services.',
          ),

          _buildLegalSection(
            title: 'How We Use Your Information',
            content:
            'We use your information to provide and improve services, process access fees, verify identity, prevent fraud, '
                'operate leaderboards, and communicate with you about contests and non-monetary promotions.',
          ),

          _buildLegalSection(
            title: 'Information Sharing',
            content:
            'We do not sell personal information. We may share data with service providers, comply with legal requests, '
                'and display limited information (e.g., username and performance) to other participants.',
          ),

          _buildLegalSection(
            title: 'Data Security',
            content:
            'We implement industry-standard security measures including encryption, secure servers, and regular security audits to protect your personal information.',
          ),

          _buildLegalSection(
            title: 'Your Rights',
            content:
            'You may access, correct, or delete your personal information. You can opt out of marketing communications and request data portability where applicable.',
          ),

          _buildLegalSection(
            title: 'Cookies and Tracking',
            content:
            'We use cookies and similar technologies to enhance user experience, analyze usage patterns, and provide personalized content. '
                'You can manage cookie preferences in your browser.',
          ),

          _buildLegalSection(
            title: 'Third-Party Services',
            content:
            'The App integrates with third-party services for payments, analytics, and social features. These services have their own privacy policies.',
          ),

          _buildLegalSection(
            title: 'Children\'s Privacy',
            content:
            'We do not knowingly collect personal information from children under 13. Parents or guardians may contact us to review or delete their child’s information.',
          ),
        ],
      ),
    );
  }

  Widget _buildFairPlay() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLegalHeader(
            title: 'Fair Play Policy',
            icon: Icons.balance,
            subtitle: 'Ensuring integrity in fantasy sports',
          ),
          const SizedBox(height: 24),

          _buildLegalSection(
            title: 'Game of Skill',
            content:
            'Fantasy sports on the App is a game of skill requiring knowledge of sports, player performance, and strategic thinking. '
                'Success depends on research and decision-making, not chance.',
          ),

          _buildLegalSection(
            title: 'Anti-Collusion Measures',
            content:
            'We monitor for collusion, including coordinated lineup strategies, information sharing, and suspicious entry patterns. '
                'Violations may result in immediate account suspension.',
          ),

          _buildLegalSection(
            title: 'Automated Systems Prohibition',
            content:
            'Use of bots, scripts, or automated systems for lineup creation or contest entry is strictly prohibited. '
                'All entries must be made manually by individual users.',
          ),

          _buildLegalSection(
            title: 'Insider Information',
            content:
            'Use of non-public information that provides unfair advantage is prohibited. All users should rely on publicly available information.',
          ),

          _buildLegalSection(
            title: 'Multi-Accounting',
            content:
            'Each person may maintain only one account. Creating multiple accounts to circumvent limits or gain advantage leads to permanent suspension.',
          ),

          _buildLegalSection(
            title: 'Monitoring and Enforcement',
            content:
            'We use a combination of automated systems and manual review to detect violations. Our security team investigates suspicious activity and takes appropriate action.',
          ),

          _buildLegalSection(
            title: 'Reporting Violations',
            content:
            'Report suspected violations through our support system. Reports are investigated confidentially and thoroughly.',
          ),

          _buildLegalSection(
            title: 'Penalties',
            content:
            'Violations may result in warnings, contest disqualification, account suspension, or permanent bans. '
                'Repeat offenders face escalating penalties.',
          ),
        ],
      ),
    );
  }

  Widget _buildAgeRestrictions() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLegalHeader(
            title: 'Age Restrictions',
            icon: Icons.verified_user,
            subtitle: 'Age requirements and parental controls',
          ),
          const SizedBox(height: 24),

          _buildLegalSection(
            title: 'Minimum Age Requirements',
            content:
            'Users must be at least 18 years old to make payments or access paid features. '
                'Free/practice modes may be available to users aged 13+ with verified parental consent.',
          ),

          _buildLegalSection(
            title: 'Age Verification',
            content:
            'We may verify age through government-issued ID, payment method verification, and/or third-party verification services. '
                'Providing false age information will result in account termination.',
          ),

          _buildLegalSection(
            title: 'Parental Consent',
            content:
            'Users under 18 require explicit parental consent for account creation in free/practice modes. '
                'Parents/guardians can monitor and control the minor’s account activity through parental controls.',
          ),

          _buildLegalSection(
            title: 'Regional Restrictions',
            content:
            'Age and participation requirements may vary by state or region. Users are responsible for complying with local laws.',
          ),

          _buildLegalSection(
            title: 'Account Suspension',
            content:
            'Accounts found to be underage for paid features will be immediately suspended. '
                'Points and access privileges may be revoked; no monetary compensation is provided.',
          ),

          _buildLegalSection(
            title: 'Parental Controls',
            content:
            'Parents/guardians can request account restrictions, spending limits on access fees, and activity reports for minor accounts.',
          ),

          _buildLegalSection(
            title: 'Educational Content',
            content:
            'We provide educational resources about responsible play and the skills required for fantasy sports to help younger users understand the game.',
          ),
        ],
      ),
    );
  }

  Widget _buildDisclaimers() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLegalHeader(
            title: 'Legal Disclaimers',
            icon: Icons.warning,
            subtitle: 'Important legal notices and limitations',
          ),
          const SizedBox(height: 24),

          _buildLegalSection(
            title: 'Entertainment-Only / No Real-Money Gaming',
            content:
            'The App is for entertainment purposes only. Points are virtual and have no monetary (cash) value. '
                'Participation does not constitute gambling or wagering. Local laws still apply and may vary by jurisdiction.',
          ),

          _buildLegalSection(
            title: 'Data Accuracy',
            content:
            'We strive for accurate player statistics and timely updates, but we cannot guarantee 100% accuracy. '
                'Technical issues or data delays may occur.',
          ),

          _buildLegalSection(
            title: 'No Monetary Rewards or Returns',
            content:
            'The App does not offer monetary winnings or returns. Access fees, if any, are for gameplay features and are generally non-refundable except where required by law.',
          ),

          _buildLegalSection(
            title: 'Technical Limitations',
            content:
            'The App may experience downtime or service interruptions. We are not liable for losses due to technical problems beyond our control.',
          ),

          _buildLegalSection(
            title: 'Third-Party Content',
            content:
            'We may display content from third-party sources including news, statistics, and advertisements. '
                'We are not responsible for the accuracy or reliability of third-party content.',
          ),

          _buildLegalSection(
            title: 'Jurisdiction and Governing Law',
            content:
            'These terms are governed by [State/Country] law. Disputes will be resolved through binding arbitration in [Location], unless prohibited by local law.',
          ),

          _buildLegalSection(
            title: 'Contact Information',
            content:
            'For legal questions or concerns, contact our legal department at legal@fantasyapp.com or write to [Company Address]. '
                'We respond to inquiries within 5 business days.',
          ),

          Container(
            margin: const EdgeInsets.only(top: 24),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[400]!),
            ),
            child: Row(
              children: [
                Icon(Icons.info, color: Colors.grey[700]),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'This legal information is provided for reference only and does not constitute legal advice. '
                        'Consult a qualified attorney for specific legal questions.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[700],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegalHeader({
    required String title,
    required IconData icon,
    required String subtitle,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.black, Colors.grey[800]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 50, color: Colors.white),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLegalSection({
    required String title,
    required String content,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
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
            content,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

// Example usage in main.dart
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fantasy App Legal',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        fontFamily: 'Roboto',
      ),
      home: const LegalityPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

