import 'package:flutter/material.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({Key? key}) : super(key: key);

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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Wallet',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: screenWidth * 0.04),
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.035,
              vertical: screenHeight * 0.01,
            ),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green[200]!),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.account_balance_wallet_outlined,
                  size: isTablet ? 20 : 18,
                  color: Colors.green[700],
                ),
                SizedBox(width: screenWidth * 0.01),
                Text(
                  'Wallet',
                  style: TextStyle(
                    color: Colors.green[700],
                    fontWeight: FontWeight.w600,
                    fontSize: isTablet ? 16 : 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.02),

              // Wallet Balance Card
              Container(
                width: double.infinity,
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
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(screenWidth * 0.03),
                          decoration: BoxDecoration(
                            color: Colors.amber[50],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.account_balance_wallet,
                            color: Colors.amber[700],
                            size: isTablet ? 32 : 28,
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.04),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Withdrawable',
                                          style: TextStyle(
                                            fontSize: isTablet ? 14 : 12,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        Text(
                                          'Amount',
                                          style: TextStyle(
                                            fontSize: isTablet ? 14 : 12,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        SizedBox(height: screenHeight * 0.005),
                                        Text(
                                          '₹ 0.00',
                                          style: TextStyle(
                                            fontSize: isTablet ? 20 : 18,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 50,
                                    width: 1,
                                    color: Colors.grey[200],
                                    margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Non-Withdrawable',
                                          style: TextStyle(
                                            fontSize: isTablet ? 14 : 12,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        Text(
                                          'Amount',
                                          style: TextStyle(
                                            fontSize: isTablet ? 14 : 12,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        SizedBox(height: screenHeight * 0.005),
                                        Text(
                                          '₹ 0.00',
                                          style: TextStyle(
                                            fontSize: isTablet ? 20 : 18,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[600],
                        minimumSize: Size(double.infinity, screenHeight * 0.06),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'ADD CASH',
                        style: TextStyle(
                          fontSize: isTablet ? 16 : 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.025),

              // Balance Breakdown
              Container(
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
                    _buildBalanceItem('Cash Deposit', '₹ 0.0', screenWidth, isTablet),
                    Divider(color: Colors.grey[200], thickness: 1),
                    _buildBalanceItem('Winnings', '₹ 0.0', screenWidth, isTablet),
                    Divider(color: Colors.grey[200], thickness: 1),
                    _buildBalanceItem('CashBack Bonus', '₹ 0.0', screenWidth, isTablet),
                    Divider(color: Colors.grey[200], thickness: 1),
                    _buildBalanceItem('Referal Bonus', '₹ 0.0', screenWidth, isTablet),
                    Divider(color: Colors.grey[200], thickness: 1),
                    _buildBalanceItem('Bonus', '₹ 0.0', screenWidth, isTablet),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.025),

              // Action Items
              Column(
                children: [
                  _buildActionItem(
                    'Withdraw Amount',
                    'Withdrawable Cash Amount = ₹ 0.00',
                    Icons.arrow_forward_ios,
                        () {},
                    screenWidth,
                    isTablet,
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  _buildActionItem(
                    'My Recent Transactions',
                    null,
                    Icons.arrow_forward_ios,
                        () {},
                    screenWidth,
                    isTablet,
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  _buildActionItem(
                    'KYC Details',
                    null,
                    Icons.arrow_forward_ios,
                        () {},
                    screenWidth,
                    isTablet,
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  _buildActionItem(
                    'Refer and Earn',
                    'Invite a friends, Play & Win',
                    Icons.arrow_forward_ios,
                        () {},
                    screenWidth,
                    isTablet,
                    isHighlighted: true,
                  ),
                ],
              ),

              SizedBox(height: screenHeight * 0.03),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBalanceItem(String title, String amount, double screenWidth, bool isTablet) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenWidth * 0.03),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: isTablet ? 16 : 14,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: screenWidth * 0.02),
              Icon(
                Icons.info_outline,
                size: isTablet ? 18 : 16,
                color: Colors.grey[400],
              ),
            ],
          ),
          Text(
            amount,
            style: TextStyle(
              fontSize: isTablet ? 16 : 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem(
      String title,
      String? subtitle,
      IconData icon,
      VoidCallback onTap,
      double screenWidth,
      bool isTablet, {
        bool isHighlighted = false,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(screenWidth * 0.04),
        decoration: BoxDecoration(
          color: isHighlighted ? Colors.green[50] : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isHighlighted ? Colors.green[200]! : Colors.grey[200]!,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: isTablet ? 16 : 14,
                    fontWeight: FontWeight.w600,
                    color: isHighlighted ? Colors.green[700] : Colors.black87,
                  ),
                ),
                if (subtitle != null) ...[
                  SizedBox(height: screenWidth * 0.01),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: isTablet ? 14 : 12,
                      color: isHighlighted ? Colors.green[600] : Colors.grey[600],
                    ),
                  ),
                ],
              ],
            ),
            Icon(
              icon,
              color: isHighlighted ? Colors.green[600] : Colors.grey[400],
              size: isTablet ? 20 : 18,
            ),
          ],
        ),
      ),
    );
  }
}