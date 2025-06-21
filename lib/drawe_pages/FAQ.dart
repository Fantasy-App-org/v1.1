import 'package:flutter/material.dart';

class Start25ProFAQPage extends StatelessWidget {
  const Start25ProFAQPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Start25Pro FAQ',
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
              margin: const EdgeInsets.only(bottom: 20.0),
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

            // FAQ Items
            const FAQItem(
              question: '1. What is Fantasy Sports?',
              answer: 'Fantasy sports is a strategy-based online sports game where you can create a virtual team of real players participating in live matches worldwide. You earn points and win cash prizes based on the performance of these players in actual matches.',
            ),

            const FAQItem(
              question: '2. Is it safe to add money to Start25Pro?',
              answer: 'Yes! Adding money to your Start25Pro account is completely safe and hassle-free. We provide multiple secure payment options to ensure your personal details remain protected. Once your personal details are verified, you can easily withdraw your winnings directly to your bank account.',
            ),

            const FAQItem(
              question: '3. How are Start25Pro points calculated?',
              answer: 'Start25Pro points are calculated based on a player\'s performance in a real match. Check out the Start25Pro Fantasy Points System for more details on different sports.',
            ),

            const FAQItem(
              question: '4. When do I receive my winnings?',
              answer: 'If you request a withdrawal via IMPS, your winnings should be credited almost instantly or within 3 working days. Withdrawals via NEFT take up to 3 working days. For more details, visit our helpdesk.',
            ),

            const FAQItem(
              question: '5. How do I use a Start25Pro discount coupon code?',
              answer: 'Follow these simple steps to apply a discount coupon code:\n\n• Go to \'Rewards\' at the bottom right corner.\n• Click on \'My Rewards\' and tap on \'Have a discount coupon code?\'\n• Enter your code and tap \'Apply Now\'.\n• Enter any contest and enjoy your discount!',
            ),

            const FAQItem(
              question: '6. How can I download the Start25Pro app?',
              answer: 'There are three ways to download the Start25Pro app:\n\n1. Visit www.start25pro.com on your desktop or mobile browser and enter your mobile number to get the download link.\n2. Download the app from our official website.\n3. Follow the instructions provided in our app download section.',
            ),

            const FAQItem(
              question: '7. What types of contests can I join?',
              answer: 'You can participate in a variety of contests, including:\n\n• Public Contests – Compete against multiple players.\n• Private Contests – Create a contest and invite your friends.\n• Head-to-Head Contests – Challenge one other player.\n• Mega Contests – Join high-reward contests with multiple participants.\n• Practice Contests – Hone your skills before competing for real prizes.',
            ),

            const FAQItem(
              question: '8. How do I play on the Start25Pro app?',
              answer: 'Visit our How to Play section to get a step-by-step guide on how to create teams, join contests, and win exciting prizes.',
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
                    child:                     Text(
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
                    child:                     Icon(
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