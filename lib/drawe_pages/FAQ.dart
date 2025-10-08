import 'package:flutter/material.dart';

class Start25ProFAQPage extends StatelessWidget {
  const Start25ProFAQPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Start25Pro FAQ (Entertainment Only)',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF16213E),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Header Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20.0),
              margin: const EdgeInsets.only(bottom: 12.0),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF16213E), Color(0xFF0F3460)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF16213E).withOpacity(0.3),
                    blurRadius: 8.0,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.help_outline,
                    size: 48,
                    color: Colors.white,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Frequently Asked Questions',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Get answers to common questions about Start25Pro',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Entertainment disclaimer
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info, color: Colors.blue.shade700, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Start25Pro is for entertainment purposes only. '
                          'Points are virtual and have no monetary (cash) value. '
                          'Any fee refers to access/participation for gameplay, not a stake or wager.',
                      style: TextStyle(color: Colors.blue.shade800, height: 1.35),
                    ),
                  ),
                ],
              ),
            ),

            // FAQ Items (updated copy)
            const FAQItem(
              question: '1. What is Fantasy Sports?',
              answer:
              'Fantasy sports on Start25Pro is a strategy-based, entertainment-only experience where you create a virtual team of real players in live matches. '
                  'You earn points based on real match performance. Points are virtual and cannot be redeemed for cash.',
            ),

            const FAQItem(
              question: '2. Is it safe to make payments on Start25Pro?',
              answer:
              'Yes. We use secure payment options for access/participation fees so you can play hassle-free. '
                  'Payments are solely for gameplay access. There are no cash withdrawals and no monetary winnings on Start25Pro.',
            ),

            const FAQItem(
              question: '3. How are Start25Pro points calculated?',
              answer:
              'Points are calculated based on a player’s performance in the real match. '
                  'Check out the Start25Pro Fantasy Points System to see the full breakdown across formats.',
            ),

            const FAQItem(
              question: '4. Are there cash winnings or withdrawals?',
              answer:
              'No. Start25Pro is for entertainment only. '
                  'Points and leaderboard ranks do not convert to cash, rupees, or any monetary reward, and cannot be withdrawn.',
            ),

            const FAQItem(
              question: '5. How do I use a Start25Pro discount coupon code?',
              answer:
              'Follow these steps to apply a discount coupon code:\n\n'
                  '• Go to “Rewards”.\n'
                  '• Tap “My Rewards” → “Have a discount coupon code?”\n'
                  '• Enter your code and tap “Apply Now”.\n'
                  '• Join a contest and enjoy your discount on participation fees.',
            ),

            const FAQItem(
              question: '6. How can I download the Start25Pro app?',
              answer:
              'You can:\n\n'
                  '1) Visit www.start25pro.com and enter your mobile number to get the download link.\n'
                  '2) Download from our official website.\n'
                  '3) Follow the instructions given in the app download section.',
            ),

            const FAQItem(
              question: '7. What types of contests can I join?',
              answer:
              'You can participate in:\n\n'
                  '• Public Contests – Compete with many players on a shared leaderboard.\n'
                  '• Private Contests – Create a contest and invite friends.\n'
                  '• Head-to-Head – Challenge one other player.\n'
                  '• Mega Contests – Larger leaderboards and higher point caps.\n'
                  '• Practice Contests – Hone your skills before playing public contests.',
            ),

            const FAQItem(
              question: '8. How do I play on the Start25Pro app?',
              answer:
              'Visit the “How to Play” section for a step-by-step guide on creating teams, joining contests, and competing on leaderboards. '
                  'Remember: it’s for entertainment only and points have no cash value.',
            ),

            // Footer
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20.0),
              margin: const EdgeInsets.only(top: 20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 4.0,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.support_agent,
                    size: 32,
                    color: const Color(0xFF16213E),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Need More Help?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF16213E),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'For further queries, feel free to contact our support team.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF16213E),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Add contact support functionality
                    },
                    icon: const Icon(Icons.message),
                    label: const Text('Contact Support'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF16213E),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Happy gaming on Start25Pro!',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF16213E),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FAQItem extends StatefulWidget {
  final String question;
  final String answer;

  const FAQItem({
    Key? key,
    required this.question,
    required this.answer,
  }) : super(key: key);

  @override
  State<FAQItem> createState() => _FAQItemState();
}

class _FAQItemState extends State<FAQItem>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _controller;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: _toggleExpanded,
            borderRadius: BorderRadius.circular(12.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.question,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF16213E),
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizeTransition(
            sizeFactor: _expandAnimation,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  widget.answer,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: Colors.grey[700],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}