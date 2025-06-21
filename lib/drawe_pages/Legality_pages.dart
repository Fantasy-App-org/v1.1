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
          'Legal Information',
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
            subtitle: 'Last updated: [Date]',
          ),
          const SizedBox(height: 24),

          _buildLegalSection(
            title: '1. Acceptance of Terms',
            content: 'By downloading, installing, or using our fantasy sports application ("the App"), you agree to be bound by these Terms of Service. If you do not agree to these terms, please do not use the App.',
          ),

          _buildLegalSection(
            title: '2. Fantasy Sports Gameplay',
            content: 'Our App provides fantasy sports entertainment where users can create virtual teams using real player statistics. This is a game of skill, not chance, and requires knowledge of sports and player performance.',
          ),

          _buildLegalSection(
            title: '3. User Eligibility',
            content: 'Users must be at least 18 years old to participate in paid contests. Free contests may be available to users 13+ with parental consent. Users must comply with local laws regarding fantasy sports participation.',
          ),

          _buildLegalSection(
            title: '4. Account Responsibilities',
            content: 'Users are responsible for maintaining account security, providing accurate information, and complying with all rules and regulations. Multiple accounts per person are prohibited.',
          ),

          _buildLegalSection(
            title: '5. Contest Rules',
            content: 'All contests have specific rules regarding lineup creation, scoring systems, and payout structures. Users must review contest rules before participating. Contest results are final.',
          ),

          _buildLegalSection(
            title: '6. Prohibited Activities',
            content: 'Users may not engage in collusion, use automated systems, share account information, or participate in any activity that compromises fair play or violates applicable laws.',
          ),

          _buildLegalSection(
            title: '7. Payments and Withdrawals',
            content: 'All financial transactions are processed through secure payment systems. Withdrawal requests are subject to verification procedures and may take 3-7 business days to process.',
          ),

          _buildLegalSection(
            title: '8. Limitation of Liability',
            content: 'The App is provided "as is" without warranty. We are not liable for any damages arising from use of the App, including but not limited to financial losses or technical issues.',
          ),

          _buildLegalSection(
            title: '9. Termination',
            content: 'We reserve the right to suspend or terminate accounts for violation of these terms, suspicious activity, or at our discretion. Users may close accounts at any time.',
          ),

          _buildLegalSection(
            title: '10. Changes to Terms',
            content: 'These terms may be updated periodically. Continued use of the App after changes constitutes acceptance of new terms. Users will be notified of significant changes.',
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
            content: 'We collect personal information including name, email, age, location, and payment information. We also collect usage data, device information, and gameplay statistics to improve our services.',
          ),

          _buildLegalSection(
            title: 'How We Use Your Information',
            content: 'Your information is used to provide services, process payments, verify identity, prevent fraud, improve the App, and communicate with you about contests and promotions.',
          ),

          _buildLegalSection(
            title: 'Information Sharing',
            content: 'We do not sell personal information. We may share data with service providers, legal authorities when required, and contest participants (username and performance only).',
          ),

          _buildLegalSection(
            title: 'Data Security',
            content: 'We implement industry-standard security measures including encryption, secure servers, and regular security audits to protect your personal information.',
          ),

          _buildLegalSection(
            title: 'Your Rights',
            content: 'You have the right to access, correct, or delete your personal information. You can also opt out of marketing communications and request data portability.',
          ),

          _buildLegalSection(
            title: 'Cookies and Tracking',
            content: 'We use cookies and similar technologies to enhance user experience, analyze usage patterns, and provide personalized content. You can manage cookie preferences in your browser.',
          ),

          _buildLegalSection(
            title: 'Third-Party Services',
            content: 'Our App integrates with third-party services for payments, analytics, and social features. These services have their own privacy policies.',
          ),

          _buildLegalSection(
            title: 'Children\'s Privacy',
            content: 'We do not knowingly collect personal information from children under 13. Parents can contact us to review or delete their child\'s information.',
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
            content: 'Fantasy sports is recognized as a game of skill requiring knowledge of sports, player performance, and strategic thinking. Success depends on research and decision-making, not chance.',
          ),

          _buildLegalSection(
            title: 'Anti-Collusion Measures',
            content: 'We actively monitor for collusion, including coordinated lineup strategies, information sharing, and suspicious betting patterns. Violators face immediate account suspension.',
          ),

          _buildLegalSection(
            title: 'Automated Systems Prohibition',
            content: 'Use of bots, scripts, or automated systems for lineup creation or contest entry is strictly prohibited. All entries must be made manually by individual users.',
          ),

          _buildLegalSection(
            title: 'Insider Information',
            content: 'Use of non-public information (injury reports, lineup changes, etc.) that provides unfair advantage is prohibited. All users must rely on publicly available information.',
          ),

          _buildLegalSection(
            title: 'Multi-Accounting',
            content: 'Each person is allowed only one account. Creating multiple accounts to circumvent contest limits or gain unfair advantage results in permanent suspension.',
          ),

          _buildLegalSection(
            title: 'Monitoring and Enforcement',
            content: 'We use advanced algorithms and manual review to detect violations. Our security team investigates suspicious activity and takes appropriate action.',
          ),

          _buildLegalSection(
            title: 'Reporting Violations',
            content: 'Users can report suspected violations through our support system. All reports are investigated confidentially and thoroughly.',
          ),

          _buildLegalSection(
            title: 'Penalties',
            content: 'Violations may result in warnings, contest disqualification, account suspension, or permanent bans. Repeat offenders face escalating penalties.',
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
            content: 'Users must be at least 18 years old to participate in paid contests. Free contests and practice modes are available to users 13+ with verified parental consent.',
          ),

          _buildLegalSection(
            title: 'Age Verification',
            content: 'We verify user age through government-issued ID, payment method verification, and third-party age verification services. False age information results in account termination.',
          ),

          _buildLegalSection(
            title: 'Parental Consent',
            content: 'Users under 18 require explicit parental consent for account creation. Parents can monitor and control their child\'s account activity through parental controls.',
          ),

          _buildLegalSection(
            title: 'State and Regional Restrictions',
            content: 'Age requirements may vary by state or region. Users must comply with local laws regarding fantasy sports participation and gambling age limits.',
          ),

          _buildLegalSection(
            title: 'Account Suspension',
            content: 'Accounts found to be underage for paid contests will be immediately suspended. Winnings from underage accounts are forfeited and may be donated to charity.',
          ),

          _buildLegalSection(
            title: 'Parental Controls',
            content: 'Parents can request account restrictions, spending limits, and activity reports for their minor children. We provide tools to help parents monitor usage.',
          ),

          _buildLegalSection(
            title: 'Educational Content',
            content: 'We provide educational resources about responsible gaming and the skills required for fantasy sports to help younger users understand the game.',
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
            title: 'No Gambling Guarantee',
            content: 'While we operate as a game of skill, fantasy sports laws vary by jurisdiction. Users are responsible for ensuring participation is legal in their location.',
          ),

          _buildLegalSection(
            title: 'Data Accuracy',
            content: 'We strive for accurate player statistics and real-time updates, but cannot guarantee 100% accuracy. Technical issues or data delays may occasionally occur.',
          ),

          _buildLegalSection(
            title: 'Financial Risk',
            content: 'Fantasy sports involves financial risk. Users should only participate with money they can afford to lose. We do not guarantee winnings or returns on entry fees.',
          ),

          _buildLegalSection(
            title: 'Technical Limitations',
            content: 'The App may experience downtime, technical issues, or service interruptions. We are not liable for losses due to technical problems beyond our control.',
          ),

          _buildLegalSection(
            title: 'Third-Party Content',
            content: 'We display content from third-party sources including news, statistics, and advertisements. We are not responsible for the accuracy or reliability of third-party content.',
          ),

          _buildLegalSection(
            title: 'Jurisdiction and Governing Law',
            content: 'These terms are governed by [State/Country] law. Disputes will be resolved through binding arbitration in [Location] unless prohibited by local law.',
          ),

          _buildLegalSection(
            title: 'Contact Information',
            content: 'For legal questions or concerns, contact our legal department at legal@fantasyapp.com or write to [Company Address]. We respond to inquiries within 5 business days.',
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
                    'This legal information is provided for reference only and does not constitute legal advice. Consult with a qualified attorney for specific legal questions.',
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
            style: TextStyle(
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