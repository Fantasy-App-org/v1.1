import 'package:flutter/material.dart';

class FantasyPointsPage extends StatelessWidget {
  const FantasyPointsPage({super.key});

  // Define all points data structure
  static const Map<String, Map<String, dynamic>> pointsData = {
    'basic': {
      'title': 'Basic Points',
      'data': [
        {'category': 'Being part of starting XI', 'T20': '2', 'ODI': '2', 'TEST': '2', 'T10': '2'},
        {'category': 'Every run scored', 'T20': '0.5', 'ODI': '0.5', 'TEST': '0.5', 'T10': '0.5'},
        {'category': 'Every wicket taken (excluding run out)', 'T20': '10', 'ODI': '12', 'TEST': '8', 'T10': '12'},
        {'category': 'Catch taken', 'T20': '4', 'ODI': '4', 'TEST': '4', 'T10': '4'},
        {'category': 'Caught & Bowled', 'T20': '14', 'ODI': '16', 'TEST': '12', 'T10': '16'},
        {'category': 'Stumping/Run Out (direct)', 'T20': '6', 'ODI': '6', 'TEST': '6', 'T10': '6'},
        {'category': 'Run Out (Thrower/Catcher)', 'T20': '4/2', 'ODI': '4/2', 'TEST': '4/2', 'T10': '4/2'},
        {'category': 'Dismissal for Duck (batsmen, WK, all-rounders)', 'T20': '-2', 'ODI': '-3', 'TEST': '-4', 'T10': '-2'},
      ]
    },
    'bonus': {
      'title': 'Bonus Points',
      'data': [
        {'category': 'Every boundary hit', 'T20': '0.5', 'ODI': '0.5', 'TEST': '0.5', 'T10': '0.5'},
        {'category': 'Every six hit', 'T20': '1', 'ODI': '1', 'TEST': '1', 'T10': '1'},
        {'category': 'Half Century (50 runs)', 'T20': '4', 'ODI': '2', 'TEST': '2', 'T10': 'NA'},
        {'category': 'Century (100 runs)', 'T20': '8', 'ODI': '4', 'TEST': '4', 'T10': 'NA'},
        {'category': 'Maiden Over', 'T20': '4', 'ODI': '2', 'TEST': 'NA', 'T10': '8'},
        {'category': '4 wickets', 'T20': '4', 'ODI': '2', 'TEST': '2', 'T10': 'NA'},
        {'category': '5 wickets', 'T20': '4', 'ODI': '4', 'TEST': '4', 'T10': 'NA'},
        {'category': '2 wickets', 'T20': 'NA', 'ODI': 'NA', 'TEST': 'NA', 'T10': '4'},
        {'category': '3 wickets', 'T20': 'NA', 'ODI': 'NA', 'TEST': 'NA', 'T10': '8'},
        {'category': '30 runs scored', 'T20': 'NA', 'ODI': 'NA', 'TEST': 'NA', 'T10': '4'},
        {'category': '50 runs scored', 'T20': 'NA', 'ODI': 'NA', 'TEST': 'NA', 'T10': '8'},
      ]
    },
    'economy': {
      'title': 'Economy Rate',
      'data': [
        {'category': 'Minimum overs requirement', 'T20': '2 overs', 'ODI': '5 overs', 'TEST': 'NA', 'T10': '1 over'},
        {'category': 'Between 6-5 runs/over', 'T20': '+1', 'ODI': 'NA', 'TEST': 'NA', 'T10': 'NA'},
        {'category': 'Between 4.99-4 runs/over', 'T20': '+2', 'ODI': 'NA', 'TEST': 'NA', 'T10': 'NA'},
        {'category': 'Below 4 runs/over', 'T20': '+3', 'ODI': 'NA', 'TEST': 'NA', 'T10': 'NA'},
        {'category': 'Between 9-10 runs/over', 'T20': '-1', 'ODI': 'NA', 'TEST': 'NA', 'T10': 'NA'},
        {'category': 'Between 10.01-11 runs/over', 'T20': '-2', 'ODI': 'NA', 'TEST': 'NA', 'T10': 'NA'},
        {'category': 'Above 11 runs/over', 'T20': '-3', 'ODI': 'NA', 'TEST': 'NA', 'T10': 'NA'},
        {'category': 'Between 4.5-3.5 runs/over', 'T20': 'NA', 'ODI': '+1', 'TEST': 'NA', 'T10': 'NA'},
        {'category': 'Between 3.49-2.5 runs/over', 'T20': 'NA', 'ODI': '+2', 'TEST': 'NA', 'T10': 'NA'},
        {'category': 'Below 2.5 runs/over', 'T20': 'NA', 'ODI': '+3', 'TEST': 'NA', 'T10': 'NA'},
        {'category': 'Between 7-8 runs/over', 'T20': 'NA', 'ODI': '-1', 'TEST': 'NA', 'T10': 'NA'},
        {'category': 'Between 8.01-9 runs/over', 'T20': 'NA', 'ODI': '-2', 'TEST': 'NA', 'T10': 'NA'},
        {'category': 'Above 9 runs/over', 'T20': 'NA', 'ODI': '-3', 'TEST': 'NA', 'T10': 'NA'},
        {'category': 'Below 6 runs/over', 'T20': 'NA', 'ODI': 'NA', 'TEST': 'NA', 'T10': '+3'},
        {'category': 'Between 6-6.99 runs/over', 'T20': 'NA', 'ODI': 'NA', 'TEST': 'NA', 'T10': '+2'},
        {'category': 'Between 7-8 runs/over', 'T20': 'NA', 'ODI': 'NA', 'TEST': 'NA', 'T10': '+1'},
        {'category': 'Between 11-12 runs/over', 'T20': 'NA', 'ODI': 'NA', 'TEST': 'NA', 'T10': '-1'},
        {'category': 'Between 12.01-13 runs/over', 'T20': 'NA', 'ODI': 'NA', 'TEST': 'NA', 'T10': '-2'},
        {'category': 'Above 13 runs/over', 'T20': 'NA', 'ODI': 'NA', 'TEST': 'NA', 'T10': '-3'},
      ]
    },
    'strikeRate': {
      'title': 'Strike Rate (Except Bowlers)',
      'data': [
        {'category': 'Minimum balls requirement', 'T20': '10 balls', 'ODI': '20 balls', 'TEST': 'NA', 'T10': '5 balls'},
        {'category': 'Between 60-70 runs/100 balls', 'T20': '-1', 'ODI': 'NA', 'TEST': 'NA', 'T10': 'NA'},
        {'category': 'Between 50-59.99 runs/100 balls', 'T20': '-2', 'ODI': 'NA', 'TEST': 'NA', 'T10': 'NA'},
        {'category': 'Below 50 runs/100 balls', 'T20': '-3', 'ODI': 'NA', 'TEST': 'NA', 'T10': 'NA'},
        {'category': 'Between 50-60 runs/100 balls', 'T20': 'NA', 'ODI': '-1', 'TEST': 'NA', 'T10': 'NA'},
        {'category': 'Between 40-49.99 runs/100 balls', 'T20': 'NA', 'ODI': '-2', 'TEST': 'NA', 'T10': 'NA'},
        {'category': 'Below 40 runs/100 balls', 'T20': 'NA', 'ODI': '-3', 'TEST': 'NA', 'T10': 'NA'},
        {'category': 'Between 90-100 runs/100 balls', 'T20': 'NA', 'ODI': 'NA', 'TEST': 'NA', 'T10': '-1'},
        {'category': 'Between 80-89.99 runs/100 balls', 'T20': 'NA', 'ODI': 'NA', 'TEST': 'NA', 'T10': '-2'},
        {'category': 'Below 80 runs/100 balls', 'T20': 'NA', 'ODI': 'NA', 'TEST': 'NA', 'T10': '-3'},
      ]
    }
  };

  static const List<String> formats = ['T20', 'ODI', 'TEST', 'T10'];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: formats.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('DPL11 Fantasy Points System'),
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          bottom: TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: formats.map((format) => Tab(text: format)).toList(),
          ),
        ),
        body: TabBarView(
          children: formats.map((format) => _buildFormatView(format)).toList(),
        ),
      ),
    );
  }

  Widget _buildFormatView(String format) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFormatHeader(format),
            const SizedBox(height: 20),
            ...pointsData.entries.map((entry) =>
                _buildPointsSection(entry.key, entry.value, format)
            ).toList(),
            const SizedBox(height: 20),
            _buildMultipliersSection(),
            const SizedBox(height: 20),
            _buildRememberSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildFormatHeader(String format) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepPurple, Colors.purple.shade300],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            '$format Format',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Complete Points Breakdown',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPointsSection(String key, Map<String, dynamic> section, String format) {
    List<Map<String, String>> relevantData = (section['data'] as List<Map<String, String>>)
        .where((item) => item[format] != 'NA')
        .toList();

    if (relevantData.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: _getSectionColor(key),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
          child: Text(
            section['title'],
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: _getSectionColor(key), width: 2),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(8),
              bottomRight: Radius.circular(8),
            ),
          ),
          child: Column(
            children: relevantData.asMap().entries.map((entry) {
              int index = entry.key;
              Map<String, String> item = entry.value;

              return Container(
                decoration: BoxDecoration(
                  color: index % 2 == 0 ? Colors.grey.shade50 : Colors.white,
                ),
                child: _buildPointRow(
                  item['category']!,
                  item[format]!,
                  _getPointsColor(item[format]!),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildPointRow(String category, String points, Color pointsColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              category,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: pointsColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: pointsColor, width: 1),
              ),
              child: Text(
                points,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: pointsColor,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMultipliersSection() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.amber.shade400, Colors.orange.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.amber.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: const Text(
              '🏆 Multipliers',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            color: Colors.white,
            child: Column(
              children: [
                _buildMultiplierRow('Captain', '2x', Colors.pink),
                Container(height: 1, color: Colors.grey.shade300),
                _buildMultiplierRow('Vice-Captain', '1.5x', Colors.red),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMultiplierRow(String role, String multiplier, Color color) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            role,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              multiplier,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRememberSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blue.shade700),
              const SizedBox(width: 8),
              Text(
                'Points to Remember',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ..._getRememberPoints().map((point) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('• ', style: TextStyle(color: Colors.blue.shade700, fontSize: 16)),
                Expanded(
                  child: Text(
                    point,
                    style: const TextStyle(fontSize: 14, height: 1.4),
                  ),
                ),
              ],
            ),
          )).toList(),
        ],
      ),
    );
  }

  List<String> _getRememberPoints() {
    return [
      'Captain receives 2x points, Vice-Captain receives 1.5x points',
      'Strike rate scoring applies only for rates below 70 runs per 100 balls',
      'Substitutes do not earn points, except concussion substitutes',
      'Player transfers are reflected only after scheduled updates',
      'Transferred players earn no points during intervening contests',
    ];
  }

  Color _getSectionColor(String key) {
    switch (key) {
      case 'basic':
        return Colors.deepPurple;
      case 'bonus':
        return Colors.green;
      case 'economy':
        return Colors.orange;
      case 'strikeRate':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  Color _getPointsColor(String points) {
    if (points.startsWith('-')) {
      return Colors.red;
    } else if (points.startsWith('+') || (points != 'NA' && !points.contains('over') && !points.contains('ball'))) {
      return Colors.green;
    }
    return Colors.blue;
  }
}

// Extension for custom colors
extension CustomColors on Colors {
  static const Color gold = Color(0xFFFFD700);
  static const Color silver = Color(0xFFC0C0C0);
}
// import 'package:flutter/material.dart';
//
// class FantasyPointsPage extends StatelessWidget {
//   const FantasyPointsPage({super.key});
//
//   // Define all points data structure
//   static const Map<String, Map<String, dynamic>> pointsData = {
//     'basic': {
//       'title': 'Basic Points',
//       'data': [
//         {'category': 'Being part of starting XI', 'T20': '2', 'ODI': '2', 'TEST': '2', 'T10': '2'},
//         {'category': 'Every run scored', 'T20': '0.5', 'ODI': '0.5', 'TEST': '0.5', 'T10': '0.5'},
//         {'category': 'Every wicket taken (excluding run out)', 'T20': '10', 'ODI': '12', 'TEST': '8', 'T10': '12'},
//         {'category': 'Catch taken', 'T20': '4', 'ODI': '4', 'TEST': '4', 'T10': '4'},
//         {'category': 'Caught & Bowled', 'T20': '14', 'ODI': '16', 'TEST': '12', 'T10': '16'},
//         {'category': 'Stumping/Run Out (direct)', 'T20': '6', 'ODI': '6', 'TEST': '6', 'T10': '6'},
//         {'category': 'Run Out (Thrower/Catcher)', 'T20': '4/2', 'ODI': '4/2', 'TEST': '4/2', 'T10': '4/2'},
//         {'category': 'Dismissal for Duck (batsmen, WK, all-rounders)', 'T20': '-2', 'ODI': '-3', 'TEST': '-4', 'T10': '-2'},
//       ]
//     },
//     'bonus': {
//       'title': 'Bonus Points',
//       'data': [
//         {'category': 'Every boundary hit', 'T20': '0.5', 'ODI': '0.5', 'TEST': '0.5', 'T10': '0.5'},
//         {'category': 'Every six hit', 'T20': '1', 'ODI': '1', 'TEST': '1', 'T10': '1'},
//         {'category': 'Half Century (50 runs)', 'T20': '4', 'ODI': '2', 'TEST': '2', 'T10': 'NA'},
//         {'category': 'Century (100 runs)', 'T20': '8', 'ODI': '4', 'TEST': '4', 'T10': 'NA'},
//         {'category': 'Maiden Over', 'T20': '4', 'ODI': '2', 'TEST': 'NA', 'T10': '8'},
//         {'category': '4 wickets', 'T20': '4', 'ODI': '2', 'TEST': '2', 'T10': 'NA'},
//         {'category': '5 wickets', 'T20': '4', 'ODI': '4', 'TEST': '4', 'T10': 'NA'},
//         {'category': '2 wickets', 'T20': 'NA', 'ODI': 'NA', 'TEST': 'NA', 'T10': '4'},
//         {'category': '3 wickets', 'T20': 'NA', 'ODI': 'NA', 'TEST': 'NA', 'T10': '8'},
//         {'category': '30 runs scored', 'T20': 'NA', 'ODI': 'NA', 'TEST': 'NA', 'T10': '4'},
//         {'category': '50 runs scored', 'T20': 'NA', 'ODI': 'NA', 'TEST': 'NA', 'T10': '8'},
//       ]
//     },
//     'economy': {
//       'title': 'Economy Rate',
//       'data': [
//         {'category': 'Minimum overs requirement', 'T20': '2 overs', 'ODI': '5 overs', 'TEST': 'NA', 'T10': '1 over'},
//         {'category': 'Between 6-5 runs/over', 'T20': '+1', 'ODI': 'NA', 'TEST': 'NA', 'T10': 'NA'},
//         {'category': 'Between 4.99-4 runs/over', 'T20': '+2', 'ODI': 'NA', 'TEST': 'NA', 'T10': 'NA'},
//         {'category': 'Below 4 runs/over', 'T20': '+3', 'ODI': 'NA', 'TEST': 'NA', 'T10': 'NA'},
//         {'category': 'Between 9-10 runs/over', 'T20': '-1', 'ODI': 'NA', 'TEST': 'NA', 'T10': 'NA'},
//         {'category': 'Between 10.01-11 runs/over', 'T20': '-2', 'ODI': 'NA', 'TEST': 'NA', 'T10': 'NA'},
//         {'category': 'Above 11 runs/over', 'T20': '-3', 'ODI': 'NA', 'TEST': 'NA', 'T10': 'NA'},
//         {'category': 'Between 4.5-3.5 runs/over', 'T20': 'NA', 'ODI': '+1', 'TEST': 'NA', 'T10': 'NA'},
//         {'category': 'Between 3.49-2.5 runs/over', 'T20': 'NA', 'ODI': '+2', 'TEST': 'NA', 'T10': 'NA'},
//         {'category': 'Below 2.5 runs/over', 'T20': 'NA', 'ODI': '+3', 'TEST': 'NA', 'T10': 'NA'},
//         {'category': 'Between 7-8 runs/over', 'T20': 'NA', 'ODI': '-1', 'TEST': 'NA', 'T10': 'NA'},
//         {'category': 'Between 8.01-9 runs/over', 'T20': 'NA', 'ODI': '-2', 'TEST': 'NA', 'T10': 'NA'},
//         {'category': 'Above 9 runs/over', 'T20': 'NA', 'ODI': '-3', 'TEST': 'NA', 'T10': 'NA'},
//         {'category': 'Below 6 runs/over', 'T20': 'NA', 'ODI': 'NA', 'TEST': 'NA', 'T10': '+3'},
//         {'category': 'Between 6-6.99 runs/over', 'T20': 'NA', 'ODI': 'NA', 'TEST': 'NA', 'T10': '+2'},
//         {'category': 'Between 7-8 runs/over', 'T20': 'NA', 'ODI': 'NA', 'TEST': 'NA', 'T10': '+1'},
//         {'category': 'Between 11-12 runs/over', 'T20': 'NA', 'ODI': 'NA', 'TEST': 'NA', 'T10': '-1'},
//         {'category': 'Between 12.01-13 runs/over', 'T20': 'NA', 'ODI': 'NA', 'TEST': 'NA', 'T10': '-2'},
//         {'category': 'Above 13 runs/over', 'T20': 'NA', 'ODI': 'NA', 'TEST': 'NA', 'T10': '-3'},
//       ]
//     },
//     'strikeRate': {
//       'title': 'Strike Rate (Except Bowlers)',
//       'data': [
//         {'category': 'Minimum balls requirement', 'T20': '10 balls', 'ODI': '20 balls', 'TEST': 'NA', 'T10': '5 balls'},
//         {'category': 'Between 60-70 runs/100 balls', 'T20': '-1', 'ODI': 'NA', 'TEST': 'NA', 'T10': 'NA'},
//         {'category': 'Between 50-59.99 runs/100 balls', 'T20': '-2', 'ODI': 'NA', 'TEST': 'NA', 'T10': 'NA'},
//         {'category': 'Below 50 runs/100 balls', 'T20': '-3', 'ODI': 'NA', 'TEST': 'NA', 'T10': 'NA'},
//         {'category': 'Between 50-60 runs/100 balls', 'T20': 'NA', 'ODI': '-1', 'TEST': 'NA', 'T10': 'NA'},
//         {'category': 'Between 40-49.99 runs/100 balls', 'T20': 'NA', 'ODI': '-2', 'TEST': 'NA', 'T10': 'NA'},
//         {'category': 'Below 40 runs/100 balls', 'T20': 'NA', 'ODI': '-3', 'TEST': 'NA', 'T10': 'NA'},
//         {'category': 'Between 90-100 runs/100 balls', 'T20': 'NA', 'ODI': 'NA', 'TEST': 'NA', 'T10': '-1'},
//         {'category': 'Between 80-89.99 runs/100 balls', 'T20': 'NA', 'ODI': 'NA', 'TEST': 'NA', 'T10': '-2'},
//         {'category': 'Below 80 runs/100 balls', 'T20': 'NA', 'ODI': 'NA', 'TEST': 'NA', 'T10': '-3'},
//       ]
//     }
//   };
//
//   static const List<String> formats = ['T20', 'ODI', 'TEST', 'T10'];
//
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: formats.length,
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('DPL11 Fantasy Points System'),
//           backgroundColor: Colors.indigo,
//           foregroundColor: Colors.white,
//           bottom: TabBar(
//             indicatorColor: Colors.white,
//             labelColor: Colors.white,
//             unselectedLabelColor: Colors.white70,
//             tabs: formats.map((format) => Tab(text: format)).toList(),
//           ),
//         ),
//         body: TabBarView(
//           children: formats.map((format) => _buildFormatView(format)).toList(),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildFormatView(String format) {
//     return SingleChildScrollView(
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildFormatHeader(format),
//             const SizedBox(height: 20),
//             ...pointsData.entries.map((entry) =>
//                 _buildPointsSection(entry.key, entry.value, format)
//             ).toList(),
//             const SizedBox(height: 20),
//             _buildMultipliersSection(),
//             const SizedBox(height: 20),
//             _buildRememberSection(),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildFormatHeader(String format) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [Colors.indigo, Colors.indigo.shade400],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.indigo.withOpacity(0.3),
//             blurRadius: 8,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Text(
//             '$format Format',
//             style: const TextStyle(
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             'Complete Points Breakdown',
//             style: TextStyle(
//               fontSize: 16,
//               color: Colors.white.withOpacity(0.9),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildPointsSection(String key, Map<String, dynamic> section, String format) {
//     List<Map<String, String>> relevantData = (section['data'] as List<Map<String, String>>)
//         .where((item) => item[format] != 'NA')
//         .toList();
//
//     if (relevantData.isEmpty) return const SizedBox.shrink();
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           width: double.infinity,
//           padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//           decoration: BoxDecoration(
//             color: _getSectionColor(key),
//             borderRadius: const BorderRadius.only(
//               topLeft: Radius.circular(8),
//               topRight: Radius.circular(8),
//             ),
//           ),
//           child: Text(
//             section['title'],
//             style: const TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//             ),
//           ),
//         ),
//         Container(
//           decoration: BoxDecoration(
//             border: Border.all(color: _getSectionColor(key), width: 2),
//             borderRadius: const BorderRadius.only(
//               bottomLeft: Radius.circular(8),
//               bottomRight: Radius.circular(8),
//             ),
//           ),
//           child: Column(
//             children: relevantData.asMap().entries.map((entry) {
//               int index = entry.key;
//               Map<String, String> item = entry.value;
//
//               return Container(
//                 decoration: BoxDecoration(
//                   color: index % 2 == 0 ? Colors.grey.shade50 : Colors.white,
//                 ),
//                 child: _buildPointRow(
//                   item['category']!,
//                   item[format]!,
//                   _getPointsColor(item[format]!),
//                 ),
//               );
//             }).toList(),
//           ),
//         ),
//         const SizedBox(height: 16),
//       ],
//     );
//   }
//
//   Widget _buildPointRow(String category, String points, Color pointsColor) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       child: Row(
//         children: [
//           Expanded(
//             flex: 3,
//             child: Text(
//               category,
//               style: const TextStyle(fontSize: 14),
//             ),
//           ),
//           Expanded(
//             flex: 1,
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//               decoration: BoxDecoration(
//                 color: pointsColor.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(color: pointsColor, width: 1),
//               ),
//               child: Text(
//                 points,
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   color: pointsColor,
//                   fontSize: 14,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildMultipliersSection() {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [Colors.indigo.shade600, Colors.indigo.shade400],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.indigo.withOpacity(0.3),
//             blurRadius: 8,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.all(16),
//             child: const Text(
//               '🏆 Multipliers',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ),
//           Container(
//             color: Colors.white,
//             child: Column(
//               children: [
//                 _buildMultiplierRow('Captain', '2x', Colors.indigo.shade700),
//                 Container(height: 1, color: Colors.grey.shade300),
//                 _buildMultiplierRow('Vice-Captain', '1.5x', Colors.indigo.shade500),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildMultiplierRow(String role, String multiplier, Color color) {
//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             role,
//             style: const TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//             decoration: BoxDecoration(
//               color: color,
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: Text(
//               multiplier,
//               style: const TextStyle(
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//                 fontSize: 16,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildRememberSection() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.indigo.shade50,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.indigo.shade200),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(Icons.info_outline, color: Colors.indigo.shade700),
//               const SizedBox(width: 8),
//               Text(
//                 'Points to Remember',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.indigo.shade700,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           ..._getRememberPoints().map((point) => Padding(
//             padding: const EdgeInsets.only(bottom: 8),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text('• ', style: TextStyle(color: Colors.indigo.shade700, fontSize: 16)),
//                 Expanded(
//                   child: Text(
//                     point,
//                     style: const TextStyle(fontSize: 14, height: 1.4),
//                   ),
//                 ),
//               ],
//             ),
//           )).toList(),
//         ],
//       ),
//     );
//   }
//
//   List<String> _getRememberPoints() {
//     return [
//       'Captain receives 2x points, Vice-Captain receives 1.5x points',
//       'Strike rate scoring applies only for rates below 70 runs per 100 balls',
//       'Substitutes do not earn points, except concussion substitutes',
//       'Player transfers are reflected only after scheduled updates',
//       'Transferred players earn no points during intervening contests',
//     ];
//   }
//
//   Color _getSectionColor(String key) {
//     switch (key) {
//       case 'basic':
//         return Colors.indigo;
//       case 'bonus':
//         return Colors.indigo.shade600;
//       case 'economy':
//         return Colors.indigo.shade700;
//       case 'strikeRate':
//         return Colors.indigo.shade800;
//       default:
//         return Colors.indigo;
//     }
//   }
//
//   Color _getPointsColor(String points) {
//     if (points.startsWith('-')) {
//       return Colors.red;
//     } else if (points.startsWith('+') || (points != 'NA' && !points.contains('over') && !points.contains('ball'))) {
//       return Colors.green;
//     }
//     return Colors.indigo;
//   }
// }