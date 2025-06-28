import 'package:flutter/material.dart';


class FantasyPointsPage extends StatelessWidget {
  const FantasyPointsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Fantasy Cricket Points System'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'T20'),
              Tab(text: 'ODI'),
              Tab(text: 'TEST'),
              Tab(text: 'T10'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildPointsTable('T20'),
            _buildPointsTable('ODI'),
            _buildPointsTable('TEST'),
            _buildPointsTable('T10'),
          ],
        ),
      ),
    );
  }

  Widget _buildPointsTable(String format) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Batting Points',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildDataTable(
              'Strike Rate (Except Bowlers)',
              [
                {'Minimum balls faced': format == 'T20' ? '10 balls' : format == 'ODI' ? '20 balls' : format == 'T10' ? '5 balls' : 'NA'},
                {'Between 60-70 runs/100 balls': format == 'T20' ? '-1' : format == 'ODI' ? '-2' : 'NA'},
                {'Between 50-59.99 runs/100 balls': format == 'T20' ? '-3' : format == 'ODI' ? '-4' : 'NA'},
                {'Below 50 runs/100 balls': format == 'T20' ? '-5' : format == 'ODI' ? '-6' : 'NA'},
              ],
            ),
            const SizedBox(height: 20),
            _buildDataTable(
              'Runs Scored',
              [
                {'Per run scored': '1'},
                {'Half Century (50 runs)': format == 'T20' ? '4' : format == 'ODI' || format == 'TEST' ? '2' : 'NA'},
                {'Century (100 runs)': format == 'T20' ? '8' : format == 'ODI' || format == 'TEST' ? '4' : 'NA'},
                {'30 runs (T10 only)': format == 'T10' ? '4' : 'NA'},
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Bowling Points',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildDataTable(
              'Wickets Taken',
              [
                {'Per wicket': '10'},
                {'2 wickets (T10 only)': format == 'T10' ? '4' : 'NA'},
                {'3 wickets (T10 only)': format == 'T10' ? '8' : 'NA'},
                {'4 wickets': format != 'T10' ? (format == 'T20' ? '4' : '2') : 'NA'},
                {'5 wickets': format != 'T10' ? '4' : 'NA'},
              ],
            ),
            const SizedBox(height: 20),
            _buildDataTable(
              'Economy Rate',
              [
                {'Min overs bowled': format == 'T20' ? '2 overs' : format == 'ODI' ? '5 overs' : format == 'T10' ? '1 over' : 'NA'},
                {'6-5 runs/over': format == 'T20' ? '1' : 'NA'},
                {'4.99-4 runs/over': format == 'T20' ? '2' : 'NA'},
                {'Below 4 runs/over': format == 'T20' ? '3' : 'NA'},
                {'9-10 runs/over': format == 'T20' ? '-1' : 'NA'},
                {'Above 10 runs/over': format == 'T20' ? '-2' : 'NA'},
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Fielding Points',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildDataTable(
              'Fielding',
              [
                {'Catch': '4'},
                {'Stumping': '6'},
                {'Run out (direct)': '6'},
                {'Run out (indirect)': '4'},
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Bonus Points',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildDataTable(
              'Bonus',
              [
                {'Every boundary': '0.5'},
                {'Every six': '1'},
                {'Maiden over': format == 'T20' ? '4' : format == 'ODI' ? '2' : format == 'T10' ? '8' : 'NA'},
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Multipliers',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildDataTable(
              'Multipliers',
              [
                {'Captain': '2x'},
                {'Vice-captain': '1.5x'},
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataTable(String title, List<Map<String, String>> rows) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        DataTable(
          columns: const [
            DataColumn(label: Text('Category')),
            DataColumn(label: Text('Points')),
          ],
          rows: rows.map((row) {
            final key = row.keys.first;
            final value = row.values.first;
            return DataRow(
              cells: [
                DataCell(Text(key)),
                DataCell(Text(value)),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}