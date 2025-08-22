import 'package:flutter/material.dart';

class HowToPlayPage extends StatelessWidget {
  const HowToPlayPage({super.key});

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(content, style: const TextStyle(fontSize: 15, height: 1.4)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("How to Play")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              "Deposited Amount",
              "The amount that has been added by you via different payment methods "
                  "such as Credit Card, Debit Card, Net Banking, and different wallets. "
                  "The unutilized amount in your account cannot be withdrawn.",
            ),
            _buildSection(
              "Winnings",
              "Your winnings amount in your Fame11 account is the amount that you have "
                  "achieved or won by participating in different league(s) or contest(s). "
                  "Your winnings amount present in your Fame11 account can be easily "
                  "withdrawn by clicking on the \"Withdraw\" button. Also, you can join "
                  "various leagues with the amount you win.",
            ),
            _buildSection(
              "Bonus",
              "The cash bonus amount in your Fame11 account can be defined as the amount "
                  "awarded to the users by Fame11 under various schemes and different promotional "
                  "offers. The cash bonus available in your Fame11 can only be used to pay 10% "
                  "of the total entry fee.",
            ),
            _buildSection(
              "Total Balance",
              "The Total Balance displayed in your Fame11 account is the sum of all other "
                  "amounts i.e. Deposited, Winnings, and the Bonus received.",
            ),
          ],
        ),
      ),
    );
  }
}
