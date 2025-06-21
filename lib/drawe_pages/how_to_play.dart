import 'package:flutter/material.dart';

class HowToPlayPage extends StatefulWidget {
  @override
  _HowToPlayPageState createState() => _HowToPlayPageState();
}

class _HowToPlayPageState extends State<HowToPlayPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  int selectedStep = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'How to Play',
          style: TextStyle(
            color: Color(0xFF2E3192),
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Color(0xFF2E3192)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(),
              _buildStepsSection(),
              _buildTeamCombinationsSection(),
              _buildMultipleTeamsSection(),
              _buildWalletSection(),
              _buildStartButton(),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2E3192), Color(0xFF1BFFFF)],
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.sports_cricket,
            size: 60,
            color: Colors.white,
          ),
          SizedBox(height: 16),
          Text(
            'Your11 Fantasy Sports',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Create your dream team and show-off your skills!',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStepsSection() {
    final steps = [
      {
        'title': 'Select A Match',
        'description': 'Choose the match you want to play and show-off your skills.',
        'icon': Icons.sports_cricket,
        'color': Color(0xFF4CAF50),
      },
      {
        'title': 'Cleverly Pick Your Playing 11',
        'description': 'Create your own team by selecting different players within a defined virtual credit point using the best combination.',
        'icon': Icons.group_add,
        'color': Color(0xFF2196F3),
      },
      {
        'title': 'Choose Your Captain & Vice Captain',
        'description': '2x points for your Captain & 1.5x points for your Vice-Captain based on their on-field performance.',
        'icon': Icons.star,
        'color': Color(0xFFFF9800),
      },
      {
        'title': 'Become A Part of A League',
        'description': 'Join a league or contest to compete with other users or create private leagues with friends.',
        'icon': Icons.emoji_events,
        'color': Color(0xFF9C27B0),
      },
      {
        'title': 'Become A Winner',
        'description': 'Use your skills cleverly to choose the best team and win contests with the scores your created team achieves.',
        'icon': Icons.emoji_events,
        'color': Color(0xFFE91E63),
      },
    ];

    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How It Works',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E3192),
            ),
          ),
          SizedBox(height: 20),
          ...steps.asMap().entries.map((entry) {
            int index = entry.key;
            Map<String, dynamic> step = entry.value;
            return _buildStepCard(step, index);
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildStepCard(Map<String, dynamic> step, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedStep = selectedStep == index ? -1 : index;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        margin: EdgeInsets.only(bottom: 16),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: selectedStep == index ? step['color'].withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selectedStep == index ? step['color'] : Colors.grey.shade300,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: step['color'],
                borderRadius: BorderRadius.circular(30),
              ),
              child: Icon(
                step['icon'],
                color: Colors.white,
                size: 30,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: step['color'],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          step['title'],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E3192),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    step['description'],
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              selectedStep == index ? Icons.expand_less : Icons.expand_more,
              color: step['color'],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamCombinationsSection() {
    final combinations = [
      {'name': 'Combination 1', 'wk': 1, 'bat': 5, 'ar': 2, 'bowl': 3},
      {'name': 'Combination 2', 'wk': 1, 'bat': 5, 'ar': 1, 'bowl': 4},
      {'name': 'Combination 3', 'wk': 1, 'bat': 4, 'ar': 1, 'bowl': 5},
      {'name': 'Combination 4', 'wk': 1, 'bat': 4, 'ar': 2, 'bowl': 4},
      {'name': 'Combination 5', 'wk': 1, 'bat': 4, 'ar': 3, 'bowl': 3},
      {'name': 'Combination 6', 'wk': 1, 'bat': 3, 'ar': 2, 'bowl': 5},
      {'name': 'Combination 7', 'wk': 1, 'bat': 3, 'ar': 3, 'bowl': 4},
    ];

    return Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Team Combinations',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E3192),
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Use these combinations to create your best playing 11:',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: 16),
          // Header row
          Container(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            decoration: BoxDecoration(
              color: Color(0xFF2E3192),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(flex: 2, child: Text('Combination', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                Expanded(child: Text('WK', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
                Expanded(child: Text('BAT', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
                Expanded(child: Text('AR', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
                Expanded(child: Text('BOWL', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
              ],
            ),
          ),
          // Data rows
          ...combinations.map((combo) => Container(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Row(
              children: [
                Expanded(flex: 2, child: Text(combo['name'] as String, style: TextStyle(fontWeight: FontWeight.w500))),
                Expanded(child: Text('${combo['wk']}', textAlign: TextAlign.center)),
                Expanded(child: Text('${combo['bat']}', textAlign: TextAlign.center)),
                Expanded(child: Text('${combo['ar']}', textAlign: TextAlign.center)),
                Expanded(child: Text('${combo['bowl']}', textAlign: TextAlign.center)),
              ],
            ),
          )).toList(),
          SizedBox(height: 12),
          Text(
            'WK: Wicket-keeper, BAT: Batsmen, AR: All-rounder, BOWL: Bowler',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade500,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMultipleTeamsSection() {
    return Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF6A1B9A), Color(0xFF8E24AA)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.3),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.group_work, size: 30, color: Colors.white),
              SizedBox(width: 12),
              Text(
                'One Match, Multiple Teams',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            'Increase your winning chances with Multiple Entries. Join a "Multiple Entry" League with a maximum of 6 different teams.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          SizedBox(height: 16),
          _buildMultipleTeamPoint('You can create a maximum of 6 teams for joining a single "Multiple Entry(M)" contest'),
          _buildMultipleTeamPoint('You need to create the best team with efficient players within limited budget'),
          _buildMultipleTeamPoint('You can make changes to your team only until the match begins'),
          _buildMultipleTeamPoint('Your score depends on the on-field performance of your chosen players'),
        ],
      ),
    );
  }

  Widget _buildMultipleTeamPoint(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle, size: 16, color: Colors.white),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWalletSection() {
    return Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.account_balance_wallet, color: Color(0xFF2E3192), size: 28),
              SizedBox(width: 12),
              Text(
                'Your11 Wallet',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E3192),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          _buildWalletItem(
            'Deposited',
            'Amount added by you via Credit card, Debit Card, Net Banking, and wallets. Unutilized amount cannot be withdrawn.',
            Icons.credit_card,
            Color(0xFF4CAF50),
          ),
          _buildWalletItem(
            'Winnings',
            'Amount you have won by participating in different leagues. This amount can be easily withdrawn.',
            Icons.emoji_events,
            Color(0xFFFFD700),
          ),
          _buildWalletItem(
            'Bonus',
            'Cash bonus awarded under various schemes and promotional offers. Can only be used to pay 10% of total entry fee.',
            Icons.card_giftcard,
            Color(0xFFFF5722),
          ),
          _buildWalletItem(
            'Total Balance',
            'Sum of all amounts: Deposited + Winnings + Bonus.',
            Icons.account_balance,
            Color(0xFF2E3192),
          ),
        ],
      ),
    );
  }

  Widget _buildWalletItem(String title, String description, IconData icon, Color color) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E3192),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStartButton() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Let\'s create your dream team!'),
              backgroundColor: Color(0xFF4CAF50),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF2E3192),
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 8,
        ),
        child: Text(
          'Start Playing Now',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}