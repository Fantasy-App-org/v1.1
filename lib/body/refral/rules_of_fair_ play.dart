import 'package:flutter/material.dart';

class FairPlaySecurityPage extends StatelessWidget {
  const FairPlaySecurityPage({super.key});

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            content,
            style: const TextStyle(fontSize: 15, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildBulletSection(String title, List<String> bullets) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          ...bullets.map((b) => Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Text("• $b", style: const TextStyle(fontSize: 15)),
          )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Fair Play & Security Measures")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              "Fair Play & Security Measures",
              "At DPL11, we prioritize fairness, transparency, and security to provide users with a trustworthy gaming experience. "
                  "Our Fair Play Policy ensures equal opportunities for all participants while maintaining the integrity of the platform.",
            ),
            _buildSection(
              "Match Data Transparency",
              "To ensure transparency, DPL11 publishes a detailed contest report (PDF) after each match, listing all users with their team names. "
                  "This report is accessible to all participants, reinforcing fairness and credibility.",
            ),
            _buildSection(
              "Equal Opportunity for All",
              "All users in DPL11 contests have the same virtual budget and selection criteria. "
                  "Every participant follows the same Terms & Conditions, ensuring an equal and competitive environment.",
            ),
            _buildBulletSection(
              "Verified Users Only",
              [
                "PAN details (for tax compliance)",
                "Bank details (before processing withdrawals)",
                "Identity verification (to prevent duplicate accounts and fraud)",
                "Any user found engaging in unfair practices will face account suspension and fund forfeiture."
              ],
            ),
            _buildBulletSection(
              "Secure Transactions & Payment Protection",
              [
                "128-bit SSL encryption for all transactions",
                "Two-factor authentication (2FA) for account security",
                "100+ risk detection algorithms to monitor every payment",
                "User data is stored in a highly secure environment and is never shared with third parties"
              ],
            ),
            _buildBulletSection(
              "Advanced Security Measures",
              [
                "Users cannot use multiple IDs to participate in the same contest (prevents money transfer/syndicate play)",
                "Automated fraud detection tracks unusual activity",
                "AI-based monitoring detects collusion between players",
                "Any user found violating fair play rules will have their account suspended and funds seized.",
                "If collusion is detected, affected users will receive a full refund of their entry fees."
              ],
            ),
            _buildSection(
              "Transparent Winner Declaration",
              "DPL11 follows an open-winner declaration policy. The list of winners is publicly accessible after every contest to maintain fairness and trust among users.",
            ),
            _buildBulletSection(
              "24/7 Customer Support",
              [
                "Account verification & security issues",
                "Withdrawal & payment-related queries",
                "Game rules and technical support",
                "For any assistance, reach out to our expert support team at support@DPL11.com."
              ],
            ),
          ],
        ),
      ),
    );
  }
}
