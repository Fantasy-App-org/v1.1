// lib/widgets/match_header_widget.dart
import 'package:flutter/material.dart';

class MatchHeaderWidget extends StatelessWidget {
  final Map<String, dynamic> scorecardData;

  const MatchHeaderWidget({
    Key? key,
    required this.scorecardData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final data = scorecardData['data'] ?? {};
    final teams = data['teams'] ?? {};
    final teamA = teams['teamA'] ?? {};
    final teamB = teams['teamB'] ?? {};
    final toss = data['toss'] ?? {};

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Match Type and Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  data['fixtureType'] ?? 'ODI',
                  style: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getStatusColor(data['fixtureStatus']),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      data['fixtureStatus'] ?? 'Live',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Teams and Scores
          Row(
            children: [
              Expanded(
                child: _buildTeamCard(
                  teamName: teamA['name'] ?? 'England',
                  shortName: teamA['shortName'] ?? 'ENG',
                  logo: teamA['logo'],
                  score: teamA['scores_full'] ?? '',
                  isActive: false,
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: const Text(
                  'vs',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
              ),
              Expanded(
                child: _buildTeamCard(
                  teamName: teamB['name'] ?? 'South Africa',
                  shortName: teamB['shortName'] ?? 'SA',
                  logo: teamB['logo'],
                  score: teamB['scores_full'] ?? '*16/0 (3.1 ov)',
                  isActive: true,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Toss Information
          if (toss['text'] != null) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.casino_outlined,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      toss['text'] ?? '',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTeamCard({
    required String teamName,
    required String shortName,
    String? logo,
    required String score,
    required bool isActive,
  }) {
    return Column(
      children: [
        // Team Logo and Name
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(16),
              ),
              child: logo != null
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  logo,
                  width: 32,
                  height: 32,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildFallbackLogo(shortName);
                  },
                ),
              )
                  : _buildFallbackLogo(shortName),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                shortName,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isActive ? Colors.blue : Colors.black,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        // Team Score
        if (score.isNotEmpty) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isActive ? Colors.blue.withOpacity(0.1) : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              score,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isActive ? Colors.blue : Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ] else ...[
          Text(
            'Yet to bat',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }

  Widget _buildFallbackLogo(String shortName) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Text(
          shortName.substring(0, 1),
          style: const TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'live':
        return Colors.green;
      case 'completed':
        return Colors.grey;
      case 'upcoming':
        return Colors.orange;
      default:
        return Colors.green;
    }
  }
}