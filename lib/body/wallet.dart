import 'package:fantasy/service/payment_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fantasy/service/wallet_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fantasy/body/refral.dart'; // Added import for ReferralScreen
import 'package:fantasy/drawe_pages/transection_history.dart'; // Added import for TransactionHistoryPage

import '../model/payment_models.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  late WalletService _walletService;
  late PaymentService _paymentService;

  @override
  void initState() {
    super.initState();
    _walletService = WalletService();
    _paymentService = PaymentService();
    _loadWalletData();
  }

  Future<void> _loadWalletData() async {
    if (!mounted) return;
    await _walletService.fetchWalletData();
  }

  Future<void> _refreshWalletData() async {
    if (!mounted) return;
    await _walletService.refreshWalletData();
  }

  // Check network connectivity
  Future<bool> _checkConnectivity() async {
    try {
      final connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        if (mounted) {
          _showErrorSnackbar('No internet connection. Please check your network.');
        }
        return false;
      }
      return true;
    } catch (e) {
      if (mounted) {
        _showErrorSnackbar('Failed to check network connection.');
      }
      return false;
    }
  }

  // Show loading dialog
  void _showLoadingDialog() {
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false,
        child: const Center(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Processing payment...'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Show error snackbar
  void _showErrorSnackbar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 5),
      ),
    );
  }

  // Show success snackbar
  void _showSuccessSnackbar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // Helper method to remove currency symbol from formatted amounts
  String _removeCurrencySymbol(String formattedAmount) {
    return formattedAmount.replaceAll('₹', '').trim();
  }

  @override
  void dispose() {
    _walletService.dispose();
    _paymentService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _walletService),
        ChangeNotifierProvider.value(value: _paymentService),
      ],
      child: Consumer<WalletService>(
        builder: (context, walletService, child) {
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
            body: _buildBody(walletService, screenSize, screenHeight, screenWidth, isTablet),
          );
        },
      ),
    );
  }

  Widget _buildBody(WalletService walletService, Size screenSize, double screenHeight, double screenWidth, bool isTablet) {
    if (walletService.isLoading && !walletService.hasData) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
        ),
      );
    }

    if (walletService.hasError && !walletService.hasData) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red[400],
              ),
              SizedBox(height: screenHeight * 0.02),
              Text(
                'Oops! Something went wrong',
                style: TextStyle(
                  fontSize: isTablet ? 20 : 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: screenHeight * 0.01),
              Text(
                walletService.errorMessage ?? 'Unknown error occurred',
                style: TextStyle(
                  fontSize: isTablet ? 16 : 14,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: screenHeight * 0.03),
              ElevatedButton(
                onPressed: _loadWalletData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[600],
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.08,
                    vertical: screenHeight * 0.015,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Retry',
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
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshWalletData,
      color: Colors.green[600],
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.02),

              // Loading indicator for refresh
              if (walletService.isLoading)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(screenWidth * 0.02),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.green[600]!),
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.02),
                      Text(
                        'Updating...',
                        style: TextStyle(
                          fontSize: isTablet ? 14 : 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),

              // Wallet Balance Card
              _buildWalletBalanceCard(walletService, screenWidth, screenHeight, isTablet),

              SizedBox(height: screenHeight * 0.025),

              // Balance Breakdown
              _buildBalanceBreakdown(walletService, screenWidth, isTablet),

              SizedBox(height: screenHeight * 0.025),

              // Action Items
              _buildActionItems(walletService, screenWidth, screenHeight, isTablet),

              SizedBox(height: screenHeight * 0.03),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWalletBalanceCard(WalletService walletService, double screenWidth, double screenHeight, bool isTablet) {
    return Container(
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
      child: Row(
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
                            _removeCurrencySymbol(walletService.getWithdrawableAmountFormatted()),
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
                            _removeCurrencySymbol(walletService.getNonWithdrawableAmountFormatted()),
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
    );
  }

  Widget _buildBalanceBreakdown(WalletService walletService, double screenWidth, bool isTablet) {
    return Container(
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
          _buildBalanceItem('Cash Deposit', _removeCurrencySymbol(walletService.getCashDepositFormatted()), screenWidth, isTablet),
          Divider(color: Colors.grey[200], thickness: 1),
          _buildBalanceItem('Winnings', _removeCurrencySymbol(walletService.getWinningsFormatted()), screenWidth, isTablet),
          Divider(color: Colors.grey[200], thickness: 1),
          _buildBalanceItem('CashBack Bonus', _removeCurrencySymbol(walletService.getCashbackFormatted()), screenWidth, isTablet),
          Divider(color: Colors.grey[200], thickness: 1),
          _buildBalanceItem('Referal Bonus', _removeCurrencySymbol(walletService.getLevelIncomeFormatted()), screenWidth, isTablet),
          Divider(color: Colors.grey[200], thickness: 1),
          _buildBalanceItem('Bonus', _removeCurrencySymbol(walletService.getBonusFormatted()), screenWidth, isTablet),
        ],
      ),
    );
  }

  Widget _buildActionItems(WalletService walletService, double screenWidth, double screenHeight, bool isTablet) {
    return Column(
      children: [
        _buildActionItem(
          'My Recent Transactions',
          null,
          Icons.arrow_forward_ios,
              () {
            _navigateToTransactions();
          },
          screenWidth,
          isTablet,
        ),
        SizedBox(height: screenHeight * 0.01),
        _buildActionItem(
          'Refer and Earn',
          'Invite a friends, Play & Win',
          Icons.arrow_forward_ios,
              () {
            _navigateToReferral();
          },
          screenWidth,
          isTablet,
          isHighlighted: true,
        ),
      ],
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
              GestureDetector(
                onTap: () => _showInfoDialog(title),
                child: Icon(
                  Icons.info_outline,
                  size: isTablet ? 18 : 16,
                  color: Colors.grey[400],
                ),
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
            Expanded(
              child: Column(
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

  void _showPaymentTrackingDialog() {
    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Consumer<PaymentService>(
          builder: (context, paymentService, child) {
            final transaction = paymentService.currentTransaction;

            return PopScope(
              canPop: !paymentService.isProcessing,
              child: AlertDialog(
                title: const Text('Payment Status'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (transaction != null) ...[
                      Text('Amount: ${transaction.amount}'),
                      Text('Transaction ID: ${transaction.txnId}'),
                      const SizedBox(height: 16),
                    ],

                    if (paymentService.isProcessing) ...[
                      const CircularProgressIndicator(),
                      const SizedBox(height: 16),
                      const Text('Opening payment gateway...'),
                    ] else if (paymentService.errorMessage != null) ...[
                      const Icon(Icons.error, color: Colors.red, size: 48),
                      const SizedBox(height: 16),
                      Text(
                        paymentService.errorMessage!,
                        textAlign: TextAlign.center,
                      ),
                    ] else if (paymentService.successMessage != null) ...[
                      const Icon(Icons.check_circle, color: Colors.green, size: 48),
                      const SizedBox(height: 16),
                      Text(
                        paymentService.successMessage!,
                        textAlign: TextAlign.center,
                      ),
                    ] else if (transaction?.status == PaymentStatus.success) ...[
                      const Icon(Icons.check_circle, color: Colors.green, size: 48),
                      const SizedBox(height: 16),
                      const Text('Payment successful!'),
                    ] else if (transaction?.status == PaymentStatus.initiated) ...[
                      const Icon(Icons.info, color: Colors.blue, size: 48),
                      const SizedBox(height: 16),
                      const Text('Payment gateway opened. Complete your payment and return to the app.'),
                    ] else ...[
                      const Icon(Icons.info, color: Colors.blue, size: 48),
                      const SizedBox(height: 16),
                      const Text('Waiting for payment confirmation...'),
                    ],
                  ],
                ),
                actions: [
                  if (!paymentService.isProcessing)
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        // Refresh wallet data when closing
                        _refreshWalletData();
                      },
                      child: const Text('Close'),
                    ),

                  if (transaction != null &&
                      paymentService.errorMessage == null &&
                      paymentService.successMessage == null)
                    TextButton(
                      onPressed: () async {
                        await paymentService.checkPaymentStatusManually(
                          transaction.txnId,
                          _walletService,
                        );
                      },
                      child: const Text('Check Status'),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showInfoDialog(String title) {
    if (!mounted) return;

    String content = '';
    switch (title) {
      case 'Cash Deposit':
        content = 'Money added to your wallet through various payment methods.';
        break;
      case 'Winnings':
        content = 'Amount won from contests and games.';
        break;
      case 'CashBack Bonus':
        content = 'Cashback received from various offers and promotions.';
        break;
      case 'Referal Bonus':
        content = 'Bonus earned by referring friends to the platform.';
        break;
      case 'Bonus':
        content = 'Additional bonus amounts credited to your account.';
        break;
      default:
        content = 'Information about $title';
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Updated navigation methods with proper navigation
  void _navigateToTransactions() {
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TransactionHistoryPage(),
      ),
    );
  }

  void _navigateToReferral() {
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ReferralScreen(),
      ),
    );
  }
}