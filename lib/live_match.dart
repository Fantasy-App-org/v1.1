// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
//
// class LiveMatchScreen extends StatefulWidget {
//   final String team1;
//   final String team2;
//   final String team1Short;
//   final String team2Short;
//   final String matchId;
//
//   const LiveMatchScreen({
//     Key? key,
//     required this.team1,
//     required this.team2,
//     required this.team1Short,
//     required this.team2Short,
//     required this.matchId,
//   }) : super(key: key);
//
//   @override
//   State<LiveMatchScreen> createState() => _LiveMatchScreenState();
// }
//
// class _LiveMatchScreenState extends State<LiveMatchScreen>
//     with TickerProviderStateMixin, SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   int _currentInnings = 1;
//
//   // Mock live match data
//   final Map<String, dynamic> _matchData = {
//     'status': 'Live',
//     'venue': 'Wankhede Stadium, Mumbai',
//     'series': 'IPL 2024',
//     'format': 'T20',
//     'toss': 'MI won the toss and elected to bat first',
//     'currentInnings': 1,
//     'team1Score': {
//       'runs': 156,
//       'wickets': 4,
//       'overs': 16.3,
//       'runRate': 9.54,
//       'requiredRate': 0.0,
//     },
//     'team2Score': {
//       'runs': 0,
//       'wickets': 0,
//       'overs': 0.0,
//       'runRate': 0.0,
//       'requiredRate': 0.0,
//     },
//     'commentary': [
//       {
//         'over': 16.3,
//         'ball': '16.3',
//         'runs': 4,
//         'description': 'Rohit Sharma smashes it through covers for FOUR!',
//         'time': '2 min ago'
//       },
//       {
//         'over': 16.2,
//         'ball': '16.2',
//         'runs': 1,
//         'description': 'Quick single taken by Ishan Kishan',
//         'time': '3 min ago'
//       },
//       {
//         'over': 16.1,
//         'ball': '16.1',
//         'runs': 6,
//         'description': 'MASSIVE SIX! Rohit Sharma deposits it into the stands',
//         'time': '4 min ago'
//       },
//     ],
//     'currentBatsmen': [
//       {
//         'name': 'Rohit Sharma',
//         'runs': 67,
//         'balls': 42,
//         'fours': 8,
//         'sixes': 2,
//         'strikeRate': 159.52,
//         'isOnStrike': true,
//       },
//       {
//         'name': 'Ishan Kishan',
//         'runs': 23,
//         'balls': 18,
//         'fours': 3,
//         'sixes': 0,
//         'strikeRate': 127.78,
//         'isOnStrike': false,
//       },
//     ],
//     'currentBowler': {
//       'name': 'Jasprit Bumrah',
//       'overs': 3.3,
//       'maidens': 0,
//       'runs': 28,
//       'wickets': 1,
//       'economy': 8.0,
//     },
//   };
//
//   // Mock team squads with detailed stats
//   final Map<String, List<Map<String, dynamic>>> _teamSquads = {
//     'MI': [
//       {
//         'name': 'Rohit Sharma',
//         'role': 'Batsman',
//         'points': 67.5,
//         'credits': 12.0,
//         'isPlaying': true,
//         'isCaptain': true,
//         'stats': {
//           'runs': 67,
//           'balls': 42,
//           'fours': 8,
//           'sixes': 2,
//           'strikeRate': 159.52,
//           'status': 'Batting'
//         }
//       },
//       {
//         'name': 'Ishan Kishan',
//         'role': 'WK-Batsman',
//         'points': 34.0,
//         'credits': 10.5,
//         'isPlaying': true,
//         'isCaptain': false,
//         'stats': {
//           'runs': 23,
//           'balls': 18,
//           'fours': 3,
//           'sixes': 0,
//           'strikeRate': 127.78,
//           'status': 'Batting'
//         }
//       },
//       {
//         'name': 'Suryakumar Yadav',
//         'role': 'Batsman',
//         'points': 15.0,
//         'credits': 11.0,
//         'isPlaying': true,
//         'isCaptain': false,
//         'stats': {
//           'runs': 12,
//           'balls': 8,
//           'fours': 2,
//           'sixes': 0,
//           'strikeRate': 150.0,
//           'status': 'Out - c Dhoni b Thakur'
//         }
//       },
//       {
//         'name': 'Tilak Varma',
//         'role': 'Batsman',
//         'points': 8.0,
//         'credits': 8.5,
//         'isPlaying': true,
//         'isCaptain': false,
//         'stats': {
//           'runs': 6,
//           'balls': 4,
//           'fours': 1,
//           'sixes': 0,
//           'strikeRate': 150.0,
//           'status': 'Out - lbw b Jadeja'
//         }
//       },
//       {
//         'name': 'Hardik Pandya',
//         'role': 'All-rounder',
//         'points': 45.0,
//         'credits': 11.5,
//         'isPlaying': true,
//         'isCaptain': false,
//         'stats': {
//           'runs': 28,
//           'balls': 19,
//           'fours': 2,
//           'sixes': 2,
//           'strikeRate': 147.37,
//           'status': 'Out - b Chahar'
//         }
//       },
//     ],
//     'CSK': [
//       {
//         'name': 'MS Dhoni',
//         'role': 'WK-Batsman',
//         'points': 0.0,
//         'credits': 10.0,
//         'isPlaying': true,
//         'isCaptain': true,
//         'stats': {
//           'catches': 2,
//           'stumpings': 0,
//           'runs': 0,
//           'balls': 0,
//           'status': 'Yet to bat'
//         }
//       },
//       {
//         'name': 'Ravindra Jadeja',
//         'role': 'All-rounder',
//         'points': 35.0,
//         'credits': 10.5,
//         'isPlaying': true,
//         'isCaptain': false,
//         'stats': {
//           'overs': 3.0,
//           'maidens': 0,
//           'runs': 22,
//           'wickets': 1,
//           'economy': 7.33,
//           'status': 'Bowling'
//         }
//       },
//       {
//         'name': 'Deepak Chahar',
//         'role': 'Bowler',
//         'points': 42.0,
//         'credits': 9.0,
//         'isPlaying': true,
//         'isCaptain': false,
//         'stats': {
//           'overs': 3.0,
//           'maidens': 0,
//           'runs': 18,
//           'wickets': 1,
//           'economy': 6.0,
//           'status': 'Bowling'
//         }
//       },
//     ],
//   };
//
//   // Mock scorecard data
//   final Map<String, Map<String, dynamic>> _scorecardData = {
//     'team1': {
//       'innings': 1,
//       'battingCard': [
//         {
//           'name': 'Rohit Sharma',
//           'runs': 67,
//           'balls': 42,
//           'fours': 8,
//           'sixes': 2,
//           'strikeRate': 159.52,
//           'dismissal': 'Not Out',
//           'isNotOut': true,
//         },
//         {
//           'name': 'Ishan Kishan',
//           'runs': 23,
//           'balls': 18,
//           'fours': 3,
//           'sixes': 0,
//           'strikeRate': 127.78,
//           'dismissal': 'Not Out',
//           'isNotOut': true,
//         },
//         {
//           'name': 'Suryakumar Yadav',
//           'runs': 12,
//           'balls': 8,
//           'fours': 2,
//           'sixes': 0,
//           'strikeRate': 150.0,
//           'dismissal': 'c Dhoni b Thakur',
//           'isNotOut': false,
//         },
//         {
//           'name': 'Tilak Varma',
//           'runs': 6,
//           'balls': 4,
//           'fours': 1,
//           'sixes': 0,
//           'strikeRate': 150.0,
//           'dismissal': 'lbw b Jadeja',
//           'isNotOut': false,
//         },
//         {
//           'name': 'Hardik Pandya',
//           'runs': 28,
//           'balls': 19,
//           'fours': 2,
//           'sixes': 2,
//           'strikeRate': 147.37,
//           'dismissal': 'b Chahar',
//           'isNotOut': false,
//         },
//       ],
//       'bowlingCard': [],
//       'extras': {
//         'byes': 2,
//         'legByes': 3,
//         'wides': 8,
//         'noBalls': 2,
//         'penalties': 0,
//         'total': 15,
//       },
//       'fallOfWickets': [
//         {'wicket': 1, 'runs': 25, 'over': 3.2, 'batsman': 'Tilak Varma'},
//         {'wicket': 2, 'runs': 45, 'over': 6.4, 'batsman': 'Suryakumar Yadav'},
//         {'wicket': 3, 'runs': 89, 'over': 11.1, 'batsman': 'Hardik Pandya'},
//       ],
//     },
//     'team2': {
//       'innings': 2,
//       'battingCard': [],
//       'bowlingCard': [
//         {
//           'name': 'Deepak Chahar',
//           'overs': 3.0,
//           'maidens': 0,
//           'runs': 18,
//           'wickets': 1,
//           'economy': 6.0,
//           'wides': 2,
//           'noBalls': 0,
//         },
//         {
//           'name': 'Ravindra Jadeja',
//           'overs': 3.0,
//           'maidens': 0,
//           'runs': 22,
//           'wickets': 1,
//           'economy': 7.33,
//           'wides': 1,
//           'noBalls': 1,
//         },
//         {
//           'name': 'Shardul Thakur',
//           'overs': 2.0,
//           'maidens': 0,
//           'runs': 24,
//           'wickets': 1,
//           'economy': 12.0,
//           'wides': 3,
//           'noBalls': 0,
//         },
//         {
//           'name': 'Moeen Ali',
//           'overs': 4.0,
//           'maidens': 0,
//           'runs': 32,
//           'wickets': 0,
//           'economy': 8.0,
//           'wides': 1,
//           'noBalls': 1,
//         },
//       ],
//     },
//   };
//
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 4, vsync: this);
//   }
//
//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFFF8FAFC),
//       appBar: _buildAppBar(),
//       body: Column(
//         children: [
//           _buildLiveMatchHeader(),
//           _buildTabBar(),
//           Expanded(
//             child: TabBarView(
//               controller: _tabController,
//               children: [
//                 _buildLiveTab(),
//                 _buildScorecardTab(),
//                 _buildSquadsTab(),
//                 _buildCommentaryTab(),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   PreferredSizeWidget _buildAppBar() {
//     return AppBar(
//       backgroundColor: Colors.white,
//       elevation: 0,
//       systemOverlayStyle: SystemUiOverlayStyle.dark,
//       leading: Container(
//         margin: EdgeInsets.all(6),
//         decoration: BoxDecoration(
//           color: Color(0xFFF1F5F9),
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: IconButton(
//           onPressed: () => Navigator.pop(context),
//           icon: Icon(Icons.arrow_back_ios_rounded, color: Color(0xFF1E293B), size: 18),
//         ),
//       ),
//       title: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             '${widget.team1Short} vs ${widget.team2Short}',
//             style: TextStyle(
//               color: Color(0xFF0F172A),
//               fontWeight: FontWeight.w700,
//               fontSize: 16,
//             ),
//           ),
//           Text(
//             'Live Match',
//             style: TextStyle(
//               color: Color(0xFF64748B),
//               fontWeight: FontWeight.w400,
//               fontSize: 12,
//             ),
//           ),
//         ],
//       ),
//       actions: [
//         Container(
//           margin: EdgeInsets.only(right: 12),
//           decoration: BoxDecoration(
//             color: Color(0xFFF1F5F9),
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: IconButton(
//             icon: Icon(Icons.refresh, color: Color(0xFF475569), size: 18),
//             onPressed: () {},
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildLiveMatchHeader() {
//     return Container(
//       margin: EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Color(0xFF1E293B).withOpacity(0.06),
//             blurRadius: 15,
//             offset: Offset(0, 4),
//           ),
//         ],
//         border: Border.all(color: Color(0xFF10B981).withOpacity(0.3)),
//       ),
//       child: Column(
//           children: [
//       // Live Header
//       Container(
//       padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [Color(0xFFDCFDF7), Color(0xFFF0FDF4)],
//         ),
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(16),
//           topRight: Radius.circular(16),
//         ),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Container(
//             padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
//               ),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Container(
//                   width: 6,
//                   height: 6,
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     shape: BoxShape.circle,
//                   ),
//                 ),
//                 SizedBox(width: 4),
//                 Text(
//                   'LIVE',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 10,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Text(
//                 _matchData['series'],
//                 style: TextStyle(
//                   color: Color(0xFF059669),
//                   fontSize: 12,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               Text(
//                 _matchData['venue'],
//                 style: TextStyle(
//                   color: Color(0xFF64748B),
//                   fontSize: 10,
//                   fontWeight: FontWeight.w400,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     ),
//
//     // Teams and Scores
//     Padding(
//     padding: EdgeInsets.all(16),
//     child: Column(
//     children: [
//     // Team 1 Score
//     Row(
//     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//     children: [
//     Expanded(
//     child: Row(
//     children: [
//     Container(
//     width: 40,
//     height: 40,
//     decoration: BoxDecoration(
//     gradient: LinearGradient(
//     colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
//     ),
//     shape: BoxShape.circle,
//     ),
//     child: Center(
//     child: Text(
//     widget.team1Short,
//     style: TextStyle(
//     fontWeight: FontWeight.w600,
//     color: Colors.white,
//     fontSize: 12,
//     ),
//     ),
//     ),
//     ),
//     SizedBox(width: 12),
//     Expanded(
//     child: Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//     Text(
//     widget.team1,
//     style: TextStyle(
//     fontSize: 14,
//     fontWeight: FontWeight.w600,
//     color: Color(0xFF1E293B),
//     ),
//     ),
//     if (_currentInnings == 1)
//     Text(
//     'Innings 1',
//     style: TextStyle(
//     fontSize: 10,
//     color: Color(0xFF64748B),
//     ),
//     ),
//     ],
//     ),
//     ),
//     ],
//     ),
//     ),
//     Column(
//     crossAxisAlignment: CrossAxisAlignment.end,
//     children: [
//     Text(
//     '${_matchData['team1Score']['runs']}/${_matchData['team1Score']['wickets']}',
//     style: TextStyle(
//     fontSize: 20,
//     fontWeight: FontWeight.w700,
//     color: Color(0xFF0F172A),
//     ),
//     ),
//     Text(
//     '${_matchData['team1Score']['overs']} overs',
//     style: TextStyle(
//     fontSize: 12,
//     color: Color(0xFF64748B),
//     ),
//     ),
//     ],
//     ),
//     ],
//     ),
//
//     SizedBox(height: 12),
//     ],
//     ),
//     );
//   }
//
//   Widget _buildBowlingCard() {
//     final bowlingCard = _scorecardData['team2']!['bowlingCard'] as List;
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Color(0xFF1E293B).withOpacity(0.06),
//             blurRadius: 15,
//             offset: Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: EdgeInsets.all(16),
//             child: Text(
//               '${widget.team2} Bowling',
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w700,
//                 color: Color(0xFF0F172A),
//               ),
//             ),
//           ),
//           // Bowling Stats Header
//           Container(
//             padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             color: Color(0xFFF8FAFC),
//             child: Row(
//               children: [
//                 Expanded(flex: 3, child: Text('Bowler', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF64748B)))),
//                 Expanded(child: Text('O', textAlign: TextAlign.center, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF64748B)))),
//                 Expanded(child: Text('M', textAlign: TextAlign.center, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF64748B)))),
//                 Expanded(child: Text('R', textAlign: TextAlign.center, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF64748B)))),
//                 Expanded(child: Text('W', textAlign: TextAlign.center, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF64748B)))),
//                 Expanded(child: Text('Eco', textAlign: TextAlign.center, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF64748B)))),
//               ],
//             ),
//           ),
//           // Bowling Stats
//           ...bowlingCard.map<Widget>((bowler) {
//             return Container(
//               padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//               decoration: BoxDecoration(
//                 border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9), width: 1)),
//               ),
//               child: Row(
//                 children: [
//                   Expanded(flex: 3, child: Text(bowler['name'], style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)))),
//                   Expanded(child: Text('${bowler['overs']}', textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: Color(0xFF64748B)))),
//                   Expanded(child: Text('${bowler['maidens']}', textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: Color(0xFF64748B)))),
//                   Expanded(child: Text('${bowler['runs']}', textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: Color(0xFF64748B)))),
//                   Expanded(child: Text('${bowler['wickets']}', textAlign: TextAlign.center, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)))),
//                   Expanded(child: Text('${bowler['economy']}', textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: Color(0xFF64748B)))),
//                 ],
//               ),
//             );
//           }).toList(),
//           SizedBox(height: 12),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildExtrasAndFOW() {
//     final extras = _scorecardData['team1']!['extras'];
//     final fow = _scorecardData['team1']!['fallOfWickets'] as List;
//
//     return Column(
//       children: [
//         // Extras
//         Container(
//           width: double.infinity,
//           padding: EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(16),
//             boxShadow: [
//               BoxShadow(
//                 color: Color(0xFF1E293B).withOpacity(0.06),
//                 blurRadius: 15,
//                 offset: Offset(0, 4),
//               ),
//             ],
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Extras (${extras['total']})',
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w700,
//                   color: Color(0xFF0F172A),
//                 ),
//               ),
//               SizedBox(height: 8),
//               Text(
//                 'b ${extras['byes']}, lb ${extras['legByes']}, w ${extras['wides']}, nb ${extras['noBalls']}, p ${extras['penalties']}',
//                 style: TextStyle(
//                   fontSize: 12,
//                   color: Color(0xFF64748B),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         SizedBox(height: 16),
//         // Fall of Wickets
//         Container(
//           width: double.infinity,
//           padding: EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(16),
//             boxShadow: [
//               BoxShadow(
//                 color: Color(0xFF1E293B).withOpacity(0.06),
//                 blurRadius: 15,
//                 offset: Offset(0, 4),
//               ),
//             ],
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Fall of Wickets',
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w700,
//                   color: Color(0xFF0F172A),
//                 ),
//               ),
//               SizedBox(height: 12),
//               ...fow.map<Widget>((wicket) {
//                 return Padding(
//                   padding: EdgeInsets.only(bottom: 6),
//                   child: Text(
//                     '${wicket['wicket']}-${wicket['runs']} (${wicket['batsman']}, ${wicket['over']} ov)',
//                     style: TextStyle(
//                       fontSize: 12,
//                       color: Color(0xFF64748B),
//                     ),
//                   ),
//                 );
//               }).toList(),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildSquadsTab() {
//     return SingleChildScrollView(
//       padding: EdgeInsets.all(16),
//       child: Column(
//         children: [
//           _buildTeamSquad(widget.team1Short, _teamSquads[widget.team1Short]!),
//           SizedBox(height: 16),
//           _buildTeamSquad(widget.team2Short, _teamSquads[widget.team2Short]!),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTeamSquad(String teamName, List<Map<String, dynamic>> squad) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Color(0xFF1E293B).withOpacity(0.06),
//             blurRadius: 15,
//             offset: Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: EdgeInsets.all(16),
//             child: Text(
//               '$teamName Squad',
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w700,
//                 color: Color(0xFF0F172A),
//               ),
//             ),
//           ),
//           ...squad.map<Widget>((player) {
//             return Container(
//               margin: EdgeInsets.only(left: 16, right: 16, bottom: 12),
//               padding: EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: player['isPlaying'] ? Color(0xFF10B981).withOpacity(0.05) : Color(0xFFF8FAFC),
//                 borderRadius: BorderRadius.circular(12),
//                 border: player['isPlaying']
//                     ? Border.all(color: Color(0xFF10B981).withOpacity(0.2))
//                     : null,
//               ),
//               child: Column(
//                 children: [
//                   Row(
//                     children: [
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               children: [
//                                 Text(
//                                   player['name'],
//                                   style: TextStyle(
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.w600,
//                                     color: Color(0xFF1E293B),
//                                   ),
//                                 ),
//                                 if (player['isCaptain'])
//                                   Container(
//                                     margin: EdgeInsets.only(left: 6),
//                                     padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                                     decoration: BoxDecoration(
//                                       color: Color(0xFFFBBF24),
//                                       borderRadius: BorderRadius.circular(4),
//                                     ),
//                                     child: Text(
//                                       'C',
//                                       style: TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 10,
//                                         fontWeight: FontWeight.w600,
//                                       ),
//                                     ),
//                                   ),
//                               ],
//                             ),
//                             SizedBox(height: 4),
//                             Row(
//                               children: [
//                                 Text(
//                                   player['role'],
//                                   style: TextStyle(
//                                     fontSize: 11,
//                                     color: Color(0xFF64748B),
//                                   ),
//                                 ),
//                                 Text(
//                                   ' • ${player['credits']} Cr',
//                                   style: TextStyle(
//                                     fontSize: 11,
//                                     color: Color(0xFF64748B),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.end,
//                         children: [
//                           Text(
//                             '${player['points']} pts',
//                             style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w700,
//                               color: Color(0xFF10B981),
//                             ),
//                           ),
//                           if (!player['isPlaying'])
//                             Container(
//                               margin: EdgeInsets.only(top: 4),
//                               padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                               decoration: BoxDecoration(
//                                 color: Color(0xFF64748B),
//                                 borderRadius: BorderRadius.circular(4),
//                               ),
//                               child: Text(
//                                 'Bench',
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 9,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                             ),
//                         ],
//                       ),
//                     ],
//                   ),
//                   if (player['stats'] != null && player['isPlaying']) ...[
//                     SizedBox(height: 12),
//                     Container(
//                       padding: EdgeInsets.all(10),
//                       decoration: BoxDecoration(
//                         color: Color(0xFFF8FAFC),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: _buildPlayerStats(player['stats'], player['role']),
//                     ),
//                   ],
//                 ],
//               ),
//             );
//           }).toList(),
//           SizedBox(height: 8),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildPlayerStats(Map<String, dynamic> stats, String role) {
//     if (role.contains('Batsman') || role.contains('All-rounder')) {
//       return Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text('Status: ${stats['status']}', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
//             ],
//           ),
//           if (stats.containsKey('runs')) ...[
//             SizedBox(height: 6),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 _buildMiniStat('Runs', '${stats['runs']}'),
//                 _buildMiniStat('Balls', '${stats['balls']}'),
//                 _buildMiniStat('4s', '${stats['fours']}'),
//                 _buildMiniStat('6s', '${stats['sixes']}'),
//                 _buildMiniStat('SR', '${stats['strikeRate']}'),
//               ],
//             ),
//           ],
//         ],
//       );
//     } else if (role.contains('Bowler')) {
//       return Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text('Status: ${stats['status']}', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
//             ],
//           ),
//           if (stats.containsKey('overs')) ...[
//             SizedBox(height: 6),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 _buildMiniStat('Overs', '${stats['overs']}'),
//                 _buildMiniStat('Runs', '${stats['runs']}'),
//                 _buildMiniStat('Wickets', '${stats['wickets']}'),
//                 _buildMiniStat('Eco', '${stats['economy']}'),
//               ],
//             ),
//           ],
//         ],
//       );
//     } else {
//       return Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text('Status: ${stats['status']}', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
//             ],
//           ),
//           if (stats.containsKey('catches')) ...[
//             SizedBox(height: 6),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 _buildMiniStat('Catches', '${stats['catches']}'),
//                 _buildMiniStat('Stumpings', '${stats['stumpings']}'),
//               ],
//             ),
//           ],
//         ],
//       );
//     }
//   }
//
//   Widget _buildMiniStat(String label, String value) {
//     return Column(
//       children: [
//         Text(
//           value,
//           style: TextStyle(
//             fontSize: 12,
//             fontWeight: FontWeight.w600,
//             color: Color(0xFF1E293B),
//           ),
//         ),
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 9,
//             color: Color(0xFF64748B),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildCommentaryTab() {
//     return ListView.builder(
//       padding: EdgeInsets.all(16),
//       itemCount: _matchData['commentary'].length,
//       itemBuilder: (context, index) {
//         final comment = _matchData['commentary'][index];
//         return Container(
//           margin: EdgeInsets.only(bottom: 16),
//           padding: EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(12),
//             boxShadow: [
//               BoxShadow(
//                 color: Color(0xFF1E293B).withOpacity(0.06),
//                 blurRadius: 8,
//                 offset: Offset(0, 2),
//               ),
//             ],
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Container(
//                     padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                     decoration: BoxDecoration(
//                       color: _getRunsColor(comment['runs']).withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(6),
//                     ),
//                     child: Text(
//                       '${comment['ball']} • ${comment['runs']} run${comment['runs'] != 1 ? 's' : ''}',
//                       style: TextStyle(
//                         fontSize: 11,
//                         fontWeight: FontWeight.w600,
//                         color: _getRunsColor(comment['runs']),
//                       ),
//                     ),
//                   ),
//                   Text(
//                     comment['time'],
//                     style: TextStyle(
//                       fontSize: 10,
//                       color: Color(0xFF64748B),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 8),
//               Text(
//                 comment['description'],
//                 style: TextStyle(
//                   fontSize: 13,
//                   color: Color(0xFF1E293B),
//                   height: 1.4,
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   Color _getRunsColor(int runs) {
//     switch (runs) {
//       case 0:
//         return Color(0xFF64748B);
//       case 1:
//       case 2:
//       case 3:
//         return Color(0xFF3B82F6);
//       case 4:
//         return Color(0xFF10B981);
//       case 6:
//         return Color(0xFFF59E0B);
//       default:
//         return Color(0xFFEF4444); // For wickets or unusual runs
//     }
//   }
//
//   Widget _buildStatChip(String value, String label, Color color) {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(6),
//       ),
//       child: Column(
//         children: [
//           Text(
//             value,
//             style: TextStyle(
//               fontSize: 12,
//               fontWeight: FontWeight.w600,
//               color: color,
//             ),
//           ),
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: 9,
//               color: color,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildBallChip(String value, Color color) {
//     return Container(
//       width: 32,
//       height: 32,
//       decoration: BoxDecoration(
//         color: color,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Center(
//         child: Text(
//           value,
//           style: TextStyle(
//             fontSize: 12,
//             fontWeight: FontWeight.w600,
//             color: Colors.white,
//           ),
//         ),
//       ),
//     );
//   }
//
//   // Current Rate
//   Container(
//   width: double.infinity,
//   padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//   decoration: BoxDecoration(
//   gradient: LinearGradient(
//   colors: [
//   Color(0xFF10B981).withOpacity(0.1),
//   Color(0xFF059669).withOpacity(0.05),
//   ],
//   ),
//   borderRadius: BorderRadius.circular(8),
//   ),
//   child: Row(
//   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   children: [
//   Text(
//   'Current RR: ${_matchData['team1Score']['runRate']}',
//   style: TextStyle(
//   fontSize: 12,
//   color: Color(0xFF059669),
//   fontWeight: FontWeight.w500,
//   ),
//   ),
//   Text(
//   'Powerplay: 2/6 overs',
//   style: TextStyle(
//   fontSize: 12,
//   color: Color(0xFF059669),
//   fontWeight: FontWeight.w500,
//   ),
//   ),
//   ],
//   ),
//   ),
//   ],
//   ),
//   ),
//   ],
//   ),
//   );
// }
//
// Widget _buildTabBar() {
//   return Container(
//     margin: EdgeInsets.symmetric(horizontal: 16),
//     decoration: BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(12),
//       boxShadow: [
//         BoxShadow(
//           color: Color(0xFF1E293B).withOpacity(0.06),
//           blurRadius: 8,
//           offset: Offset(0, 2),
//         ),
//       ],
//     ),
//     child: TabBar(
//       controller: _tabController,
//       indicatorColor: Color(0xFF3B82F6),
//       indicatorWeight: 3,
//       indicatorSize: TabBarIndicatorSize.tab,
//       labelColor: Color(0xFF3B82F6),
//       unselectedLabelColor: Color(0xFF64748B),
//       labelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
//       unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
//       tabs: [
//         Tab(text: 'Live'),
//         Tab(text: 'Scorecard'),
//         Tab(text: 'Squads'),
//         Tab(text: 'Commentary'),
//       ],
//     ),
//   );
// }
//
// Widget _buildLiveTab() {
//   return SingleChildScrollView(
//     padding: EdgeInsets.all(16),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _buildCurrentBatsmenCard(),
//         SizedBox(height: 16),
//         _buildCurrentBowlerCard(),
//         SizedBox(height: 16),
//         _buildRecentBallsCard(),
//       ],
//     ),
//   );
// }
//
// Widget _buildCurrentBatsmenCard() {
//   return Container(
//     decoration: BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(16),
//       boxShadow: [
//         BoxShadow(
//           color: Color(0xFF1E293B).withOpacity(0.06),
//           blurRadius: 15,
//           offset: Offset(0, 4),
//         ),
//       ],
//     ),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: EdgeInsets.all(16),
//           child: Text(
//             'Current Partnership',
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w700,
//               color: Color(0xFF0F172A),
//             ),
//           ),
//         ),
//         ..._matchData['currentBatsmen'].map<Widget>((batsman) {
//           return Container(
//             margin: EdgeInsets.only(left: 16, right: 16, bottom: 12),
//             padding: EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: batsman['isOnStrike']
//                   ? Color(0xFF10B981).withOpacity(0.1)
//                   : Color(0xFFF8FAFC),
//               borderRadius: BorderRadius.circular(12),
//               border: batsman['isOnStrike']
//                   ? Border.all(color: Color(0xFF10B981).withOpacity(0.3))
//                   : null,
//             ),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Text(
//                             batsman['name'],
//                             style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w600,
//                               color: Color(0xFF1E293B),
//                             ),
//                           ),
//                           if (batsman['isOnStrike'])
//                             Container(
//                               margin: EdgeInsets.only(left: 6),
//                               padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                               decoration: BoxDecoration(
//                                 color: Color(0xFF10B981),
//                                 borderRadius: BorderRadius.circular(4),
//                               ),
//                               child: Text(
//                                 '*',
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 10,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                             ),
//                         ],
//                       ),
//                       SizedBox(height: 4),
//                       Text(
//                         '${batsman['runs']} (${batsman['balls']}) • SR: ${batsman['strikeRate']}',
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: Color(0xFF64748B),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Row(
//                   children: [
//                     _buildStatChip('${batsman['fours']}', '4s', Color(0xFF3B82F6)),
//                     SizedBox(width: 8),
//                     _buildStatChip('${batsman['sixes']}', '6s', Color(0xFF10B981)),
//                   ],
//                 ),
//               ],
//             ),
//           );
//         }).toList(),
//         SizedBox(height: 4),
//       ],
//     ),
//   );
// }
//
// Widget _buildCurrentBowlerCard() {
//   final bowler = _matchData['currentBowler'];
//   return Container(
//     padding: EdgeInsets.all(16),
//     decoration: BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(16),
//       boxShadow: [
//         BoxShadow(
//           color: Color(0xFF1E293B).withOpacity(0.06),
//           blurRadius: 15,
//           offset: Offset(0, 4),
//         ),
//       ],
//     ),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Current Bowler',
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.w700,
//             color: Color(0xFF0F172A),
//           ),
//         ),
//         SizedBox(height: 12),
//         Row(
//           children: [
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     bowler['name'],
//                     style: TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w600,
//                       color: Color(0xFF1E293B),
//                     ),
//                   ),
//                   SizedBox(height: 4),
//                   Text(
//                     '${bowler['overs']} overs • ${bowler['wickets']}-${bowler['runs']}',
//                     style: TextStyle(
//                       fontSize: 12,
//                       color: Color(0xFF64748B),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             _buildStatChip('${bowler['economy']}', 'Eco', Color(0xFFF59E0B)),
//           ],
//         ),
//       ],
//     ),
//   );
// }
//
// Widget _buildRecentBallsCard() {
//   return Container(
//     padding: EdgeInsets.all(16),
//     decoration: BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(16),
//       boxShadow: [
//         BoxShadow(
//           color: Color(0xFF1E293B).withOpacity(0.06),
//           blurRadius: 15,
//           offset: Offset(0, 4),
//         ),
//       ],
//     ),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Recent Balls',
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.w700,
//             color: Color(0xFF0F172A),
//           ),
//         ),
//         SizedBox(height: 12),
//         Wrap(
//           spacing: 8,
//           children: [
//             _buildBallChip('4', Color(0xFF3B82F6)),
//             _buildBallChip('1', Color(0xFF64748B)),
//             _buildBallChip('6', Color(0xFF10B981)),
//             _buildBallChip('0', Color(0xFF64748B)),
//             _buildBallChip('2', Color(0xFF64748B)),
//             _buildBallChip('W', Color(0xFFEF4444)),
//           ],
//         ),
//       ],
//     ),
//   );
// }
//
// Widget _buildScorecardTab() {
//   return SingleChildScrollView(
//     padding: EdgeInsets.all(16),
//     child: Column(
//       children: [
//         _buildBattingCard(),
//         SizedBox(height: 16),
//         _buildBowlingCard(),
//         SizedBox(height: 16),
//         _buildExtrasAndFOW(),
//       ],
//     ),
//   );
// }
//
// Widget _buildBattingCard() {
//   final battingCard = _scorecardData['team1']!['battingCard'] as List;
//   return Container(
//     decoration: BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(16),
//       boxShadow: [
//         BoxShadow(
//           color: Color(0xFF1E293B).withOpacity(0.06),
//           blurRadius: 15,
//           offset: Offset(0, 4),
//         ),
//       ],
//     ),
//     child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//     Padding(
//     padding: EdgeInsets.all(16),
//     child: Text(
//       '${widget.team1} Batting',
//       style: TextStyle(
//         fontSize: 16,
//         fontWeight: FontWeight.w700,
//         color: Color(0xFF0F172A),
//       ),
//     ),
//   ),
//   // Batting Stats Header
//   Container(
//   padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//   color: Color(0xFFF8FAFC),
//   child: Row(
//   children: [
//   Expanded(flex: 3, child: Text('Batsman', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF64748B)))),
//   Expanded(child: Text('R', textAlign: TextAlign.center, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF64748B)))),
//   Expanded(child: Text('B', textAlign: TextAlign.center, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF64748B)))),
//   Expanded(child: Text('4s', textAlign: TextAlign.center, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF64748B)))),
//   Expanded(child: Text('6s', textAlign: TextAlign.center, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF64748B)))),
//   Expanded(child: Text('SR', textAlign: TextAlign.center, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF64748B)))),
//   ],
//   ),
//   ),
//   // Batting Stats
//   ...battingCard.map<Widget>((batsman) {
//   return Container(
//   padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//   decoration: BoxDecoration(
//   border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9), width: 1)),
//   ),
//   child: Column(
//   children: [
//   Row(
//   children: [
//   Expanded(
//   flex: 3,
//   child: Column(
//   crossAxisAlignment: CrossAxisAlignment.start,
//   children: [
//   Text(
//   batsman['name'],
//   style: TextStyle(
//   fontSize: 13,
//   fontWeight: FontWeight.w600,
//   color: Color(0xFF1E293B),
//   ),
//   ),
//   if (!batsman['isNotOut'])
//   Text(
//   batsman['dismissal'],
//   style: TextStyle(
//   fontSize: 10,
//   color: Color(0xFF64748B),
//   ),
//   ),
//   ],
//   ),
//   ),
//   Expanded(child: Text('${batsman['runs']}${batsman['isNotOut'] ? '*' : ''}', textAlign: TextAlign.center, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)))),
//   Expanded(child: Text('${batsman['balls']}', textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: Color(0xFF64748B)))),
//   Expanded(child: Text('${batsman['fours']}', textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: Color(0xFF64748B)))),
//   Expanded(child: Text('${batsman['sixes']}', textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: Color(0xFF64748B)))),
//   Expanded(child: Text('${batsman['strikeRate']}', textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: Color(0xFF64748B)))),
//   ],
//   ),
//   ],
//   ),
//   );
//   }).toList(),
//   SizedBox(height: 12),
//         ],
//     ),
//   );
// }
//
// Widget _buildBowlingCard() {
//   final bowlingCard = _scorecardData['team2']!['bowlingCard'] as List;
//   return Container(
//     decoration: BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(16),
//       boxShadow: [
//         BoxShadow(
//           color: Color(0xFF1E293B).withOpacity(0.06),
//           blurRadius: 15,
//           offset: Offset(0, 4),
//         ),
//       ],
//     ),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: EdgeInsets.all(16),
//           child: Text(
//             '${widget.team2} Bowling',
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w700,
//               color: Color(0xFF0F172A),
//             ),
//           ),
//         ),
//         // Bowling Stats Header
//         Container(
//           padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//           color: Color(0xFFF8FAFC),
//           child: Row(
//             children: [
//               Expanded(flex: 3, child: Text('Bowler', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF64748B)))),
//               Expanded(child: Text('O', textAlign: TextAlign.center, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF64748B)))),
//               Expanded(child: Text('M', textAlign: TextAlign.center, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF64748B)))),
//               Expanded(child: Text('R', textAlign: TextAlign.center, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF64748B)))),
//               Expanded(child: Text('W', textAlign: TextAlign.center, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF64748B)))),
//               Expanded(child: Text('Eco', textAlign: TextAlign.center, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF64748B)))),
//             ],
//           ),
//         ),
//         // Bowling Stats
//         ...bowlingCard.map<Widget>((bowler) {
//           return Container(
//             padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//             decoration: BoxDecoration(
//               border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9), width: 1)),
//             ),
//             child: Row(
//               children: [
//                 Expanded(flex: 3, child: Text(bowler['name'], style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)))),
//                 Expanded(child: Text('${bowler['overs']}', textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: Color(0xFF64748B)))),
//                 Expanded(child: Text('${bowler['maidens']}', textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: Color(0xFF64748B)))),
//                 Expanded(child: Text('${bowler['runs']}', textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: Color(0xFF64748B)))),
//                 Expanded(child: Text('${bowler['wickets']}', textAlign: TextAlign.center, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)))),
//                 Expanded(child: Text('${bowler['economy']}', textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: Color(0xFF64748B)))),
//               ],
//             ),
//           );
//         }).toList(),
//         SizedBox(height: 12),
//       ],
//     ),
//   );
// }
//
// Widget _buildExtrasAndFOW() {
//   final extras = _scorecardData['team1']!['extras'];
//   final fow = _scorecardData['team1']!['fallOfWickets'] as List;
//
//   return Column(
//     children: [
//       // Extras
//       Container(
//         width: double.infinity,
//         padding: EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: Color(0xFF1E293B).withOpacity(0.06),
//               blurRadius: 15,
//               offset: Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Extras (${extras['total']})',
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w700,
//                 color: Color(0xFF0F172A),
//               ),
//             ),
//             SizedBox(height: 8),
//             Text(
//               'b ${extras['byes']}, lb ${extras['legByes']}, w ${extras['wides']}, nb ${extras['noBalls']}, p ${extras['penalties']}',
//               style: TextStyle(
//                 fontSize: 12,
//                 color: Color(0xFF64748B),
//               ),
//             ),
//           ],
//         ),
//       ),
//       SizedBox(height: 16),
//       // Fall of Wickets
//       Container(
//         width: double.infinity,
//         padding: EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: Color(0xFF1E293B).withOpacity(0.06),
//               blurRadius: 15,
//               offset: Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Fall of Wickets',
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w700,
//                 color: Color(0xFF0F172A),
//               ),
//             ),
//             SizedBox(height: 12),
//             ...fow.map<Widget>((wicket) {
//               return Padding(
//                 padding: EdgeInsets.only(bottom: 6),
//                 child: Text(
//                   '${wicket['wicket']}-${wicket['runs']} (${wicket['batsman']}, ${wicket['over']} ov)',
//                   style: TextStyle(
//                     fontSize: 12,
//                     color: Color(0xFF64748B),
//                   ),
//                 ),
//               );
//             }).toList(),
//           ],
//         ),
//       ),
//     ],
//   );
// }
//
// Widget _buildSquadsTab() {
//   return SingleChildScrollView(
//     padding: EdgeInsets.all(16),
//     child: Column(
//       children: [
//         _buildTeamSquad(widget.team1Short, _teamSquads[widget.team1Short]!),
//         SizedBox(height: 16),
//         _buildTeamSquad(widget.team2Short, _teamSquads[widget.team2Short]!),
//       ],
//     ),
//   );
// }
//
// Widget _buildTeamSquad(String teamName, List<Map<String, dynamic>> squad) {
//   return Container(
//     decoration: BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(16),
//       boxShadow: [
//         BoxShadow(
//           color: Color(0xFF1E293B).withOpacity(0.06),
//           blurRadius: 15,
//           offset: Offset(0, 4),
//         ),
//       ],
//     ),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: EdgeInsets.all(16),
//           child: Text(
//             '$teamName Squad',
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w700,
//               color: Color(0xFF0F172A),
//             ),
//           ),
//         ),
//         ...squad.map<Widget>((player) {
//           return Container(
//             margin: EdgeInsets.only(left: 16, right: 16, bottom: 12),
//             padding: EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: player['isPlaying'] ? Color(0xFF10B981).withOpacity(0.05) : Color(0xFFF8FAFC),
//               borderRadius: BorderRadius.circular(12),
//               border: player['isPlaying']
//                   ? Border.all(color: Color(0xFF10B981).withOpacity(0.2))
//                   : null,
//             ),
//             child: Column(
//               children: [
//                 Row(
//                   children: [
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               Text(
//                                 player['name'],
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w600,
//                                   color: Color(0xFF1E293B),
//                                 ),
//                               ),
//                               if (player['isCaptain'])
//                                 Container(
//                                   margin: EdgeInsets.only(left: 6),
//                                   padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                                   decoration: BoxDecoration(
//                                     color: Color(0xFFFBBF24),
//                                     borderRadius: BorderRadius.circular(4),
//                                   ),
//                                   child: Text(
//                                     'C',
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 10,
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   ),
//                                 ),
//                             ],
//                           ),
//                           SizedBox(height: 4),
//                           Row(
//                             children: [
//                               Text(
//                                 player['role'],
//                                 style: TextStyle(
//                                   fontSize: 11,
//                                   color: Color(0xFF64748B),
//                                 ),
//                               ),
//                               Text(
//                                 ' • ${player['credits']} Cr',
//                                 style: TextStyle(
//                                   fontSize: 11,
//                                   color: Color(0xFF64748B),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         Text(
//                           '${player['points']} pts',
//                           style: TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w700,
//                             color: Color(0xFF10B981),
//                           ),
//                         ),
//                         if (!player['isPlaying'])
//                           Container(
//                             margin: EdgeInsets.only(top: 4),
//                             padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                             decoration: BoxDecoration(
//                               color: Color(0xFF64748B),
//                               borderRadius: BorderRadius.circular(4),
//                             ),
//                             child: Text(
//                               'Bench',
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 9,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ),
//                       ],
//                     ),
//                   ],
//                 ),
//                 if (player['stats'] != null && player['isPlaying']) ...[
//                   SizedBox(height: 12),
//                   Container(
//                     padding: EdgeInsets.all(10),
//                     decoration: BoxDecoration(
//                       color: Color(0xFFF8FAFC),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: _buildPlayerStats(player['stats'], player['role']),
//                   ),
//                 ],
//               ],
//             ),
//           );
//         }).toList(),
//         SizedBox(height: 8),
//       ],
//     ),
//   );
// }
//
// Widget _buildPlayerStats(Map<String, dynamic> stats, String role) {
//   if (role.contains('Batsman') || role.contains('All-rounder')) {
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text('Status: ${stats['status']}', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
//           ],
//         ),
//         if (stats.containsKey('runs')) ...[
//           SizedBox(height: 6),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               _buildMiniStat('Runs', '${stats['runs']}'),
//               _buildMiniStat('Balls', '${stats['balls']}'),
//               _buildMiniStat('4s', '${stats['fours']}'),
//               _buildMiniStat('6s', '${stats['sixes']}'),
//               _buildMiniStat('SR', '${stats['strikeRate']}'),
//             ],
//           ),
//         ],
//       ],
//     );
//   } else if (role.contains('Bowler')) {
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text('Status: ${stats['status']}', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
//           ],
//         ),
//         if (stats.containsKey('overs')) ...[
//           SizedBox(height: 6),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               _buildMiniStat('Overs', '${stats['overs']}'),
//               _buildMiniStat('Runs', '${stats['runs']}'),
//               _buildMiniStat('Wickets', '${stats['wickets']}'),
//               _buildMiniStat('Eco', '${stats['economy']}'),
//             ],
//           ),
//         ],
//       ],
//     );
//   } else {
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text('Status: ${stats['status']}', style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
//           ],
//         ),
//         if (stats.containsKey('catches')) ...[
//           SizedBox(height: 6),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               _buildMiniStat('Catches', '${stats['catches']}'),
//               _buildMiniStat('Stumpings', '${stats['stumpings']}'),
//             ],
//           ),
//         ],
//       ],
//     );
//   }
// }
//
// Widget _buildMiniStat(String label, String value) {
//   return Column(
//     children: [
//       Text(
//         value,
//         style: TextStyle(
//           fontSize: 12,
//           fontWeight: FontWeight.w600,
//           color: Color(0xFF1E293B),
//         ),
//       ),
//       Text(
//         label,
//         style: TextStyle(
//           fontSize: 9,
//           color: Color(0xFF64748B),
//         ),
//       ),
//     ],
//   );
// }
//
// Widget _buildCommentaryTab() {
//   return ListView.builder(
//     padding: EdgeInsets.all(16),
//     itemCount: _matchData['commentary'].length,
//     itemBuilder: (context, index) {
//       final comment = _matchData['commentary'][index];
//       return Container(
//         margin: EdgeInsets.only(bottom: 16),
//         padding: EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: [
//             BoxShadow(
//               color: Color(0xFF1E293B).withOpacity(0.06),
//               blurRadius: 8,
//               offset: Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                   decoration: BoxDecoration(
//                     color: _getRunsColor(comment['runs']).withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(6),
//                   ),
//                   child: Text(
//                     '${comment['ball']} • ${comment['runs']} run${comment['runs'] != 1 ? 's' : ''}',
//                     style: TextStyle(
//                       fontSize: 11,
//                       fontWeight: FontWeight.w600,
//                       color: _getRunsColor(comment['runs']),
//                     ),
//                   ),
//                 ),
//                 Text(
//                   comment['time'],
//                   style: TextStyle(
//                     fontSize: 10,
//                     color: Color(0xFF64748B),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 8),
//             Text(
//               comment['description'],
//               style: TextStyle(
//                 fontSize: 13,
//                 color: Color(0xFF1E293B),
//                 height: 1.4,
//               ),
//             ),
//           ],
//         ),
//       );
//     },
//   );
// }
//
// Color _getRunsColor(int runs) {
//   switch (runs) {
//     case 0:
//       return Color(0xFF64748B);
//     case 1:
//     case 2:
//     case 3:
//       return Color(0xFF3B82F6);
//     case 4:
//       return Color(0xFF10B981);
//     case 6:
//       return Color(0xFFF59E0B);
//     default:
//       return Color(0xFFEF4444); // For wickets or unusual runs
//   }
// }
//
// Widget _buildStatChip(String value, String label, Color color) {
//   return Container(
//     padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//     decoration: BoxDecoration(
//       color: color.withOpacity(0.1),
//       borderRadius: BorderRadius.circular(6),
//     ),
//     child: Column(
//       children: [
//         Text(
//           value,
//           style: TextStyle(
//             fontSize: 12,
//             fontWeight: FontWeight.w600,
//             color: color,
//           ),
//         ),
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 9,
//             color: color,
//           ),
//         ),
//       ],
//     ),
//   );
// }
//
// Widget _buildBallChip(String value, Color color) {
//   return Container(
//     width: 32,
//     height: 32,
//     decoration: BoxDecoration(
//       color: color,
//       borderRadius: BorderRadius.circular(8),
//     ),
//     child: Center(
//       child: Text(
//         value,
//         style: TextStyle(
//           fontSize: 12,
//           fontWeight: FontWeight.w600,
//           color: Colors.white,
//         ),
//       ),
//     ),
//   );
// }
//
// Widget _buildCurrentBatsmenCard() {
//   return Container(
//     decoration: BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(16),
//       boxShadow: [
//         BoxShadow(
//           color: Color(0xFF1E293B).withOpacity(0.06),
//           blurRadius: 15,
//           offset: Offset(0, 4),
//         ),
//       ],
//     ),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: EdgeInsets.all(16),
//           child: Text(
//             'Current Partnership',
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w700,
//               color: Color(0xFF0F172A),
//             ),
//           ),
//         ),
//         ..._matchData['currentBatsmen'].map<Widget>((batsman) {
//           return Container(
//             margin: EdgeInsets.only(left: 16, right: 16, bottom: 12),
//             padding: EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: batsman['isOnStrike']
//                   ? Color(0xFF10B981).withOpacity(0.1)
//                   : Color(0xFFF8FAFC),
//               borderRadius: BorderRadius.circular(12),
//               border: batsman['isOnStrike']
//                   ? Border.all(color: Color(0xFF10B981).withOpacity(0.3))
//                   : null,
//             ),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Text(
//                             batsman['name'],
//                             style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w600,
//                               color: Color(0xFF1E293B),
//                             ),
//                           ),
//                           if (batsman['isOnStrike'])
//                             Container(
//                               margin: EdgeInsets.only(left: 6),
//                               padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                               decoration: BoxDecoration(
//                                 color: Color(0xFF10B981),
//                                 borderRadius: BorderRadius.circular(4),
//                               ),
//                               child: Text(
//                                 '*',
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 10,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                             ),
//                         ],
//                       ),
//                       SizedBox(height: 4),
//                       Text(
//                         '${batsman['runs']} (${batsman['balls']}) • SR: ${batsman['strikeRate']}',
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: Color(0xFF64748B),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Row(
//                   children: [
//                     _buildStatChip('${batsman['fours']}', '4s', Color(0xFF3B82F6)),
//                     SizedBox(width: 8),
//                     _buildStatChip('${batsman['sixes']}', '6s', Color(0xFF10B981)),
//                   ],
//                 ),
//               ],
//             ),
//           );
//         }).toList(),
//         SizedBox(height: 4),
//       ],
//     ),
//   );
// }
//
// Widget _buildCurrentBowlerCard() {
//   final bowler = _matchData['currentBowler'];
//   return Container(
//     padding: EdgeInsets.all(16),
//     decoration: BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(16),
//       boxShadow: [
//         BoxShadow(
//           color: Color(0xFF1E293B).withOpacity(0.06),
//           blurRadius: 15,
//           offset: Offset(0, 4),
//         ),
//       ],
//     ),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Current Bowler',
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.w700,
//             color: Color(0xFF0F172A),
//           ),
//         ),
//         SizedBox(height: 12),
//         Row(
//           children: [
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     bowler['name'],
//                     style: TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w600,
//                       color: Color(0xFF1E293B),
//                     ),
//                   ),
//                   SizedBox(height: 4),
//                   Text(
//                     '${bowler['overs']} overs • ${bowler['wickets']}-${bowler['runs']}',
//                     style: TextStyle(
//                       fontSize: 12,
//                       color: Color(0xFF64748B),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             _buildStatChip('${bowler['economy']}', 'Eco', Color(0xFFF59E0B)),
//           ],
//         ),
//       ],
//     ),
//   );
// }
//
// Widget _buildRecentBallsCard() {
//   return Container(
//     padding: EdgeInsets.all(16),
//     decoration: BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(16),
//       boxShadow: [
//         BoxShadow(
//           color: Color(0xFF1E293B).withOpacity(0.06),
//           blurRadius: 15,
//           offset: Offset(0, 4),
//         ),
//       ],
//     ),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Recent Balls',
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.w700,
//             color: Color(0xFF0F172A),
//           ),
//         ),
//         SizedBox(height: 12),
//         Wrap(
//           spacing: 8,
//           children: [
//             _buildBallChip('4', Color(0xFF3B82F6)),
//             _buildBallChip('1', Color(0xFF64748B)),
//             _buildBallChip('6', Color(0xFF10B981)),
//             _buildBallChip('0', Color(0xFF64748B)),
//             _buildBallChip('2', Color(0xFF64748B)),
//             _buildBallChip('W', Color(0xFFEF4444)),
//           ],
//         ),
//       ],
//     ),
//   );
// }
//
// Widget _buildLiveTab() {
//   return SingleChildScrollView(
//     padding: EdgeInsets.all(16),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _buildCurrentBatsmenCard(),
//         SizedBox(height: 16),
//         _buildCurrentBowlerCard(),
//         SizedBox(height: 16),
//         _buildRecentBallsCard(),
//       ],
//     ),
//   );
// }
//
// Widget _buildScorecardTab() {
//   return SingleChildScrollView(
//     padding: EdgeInsets.all(16),
//     child: Column(
//       children: [
//         _buildBattingCard(),
//         SizedBox(height: 16),
//         _buildBowlingCard(),
//         SizedBox(height: 16),
//         _buildExtrasAndFOW(),
//       ],
//     ),
//   );
// }
//
// Widget _buildBattingCard() {
//   final battingCard = _scorecardData['team1']!['battingCard'] as List;
//   return Container(
//     decoration: BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(16),
//       boxShadow: [
//         BoxShadow(
//           color: Color(0xFF1E293B).withOpacity(0.06),
//           blurRadius: 15,
//           offset: Offset(0, 4),
//         ),
//       ],
//     ),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: EdgeInsets.all(16),
//           child: Text(
//             '${widget.team1} Batting',
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w700,
//               color: Color(0xFF0F172A),
//             ),
//           ),
//         ),
//         // Batting Stats Header
//         Container(
//           padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//           color: Color(0xFFF8FAFC),
//           child: Row(
//             children: [
//               Expanded(flex: 3, child: Text('Batsman', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF64748B)))),
//               Expanded(child: Text('R', textAlign: TextAlign.center, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF64748B)))),
//               Expanded(child: Text('B', textAlign: TextAlign.center, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF64748B)))),
//               Expanded(child: Text('4s', textAlign: TextAlign.center, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF64748B)))),
//               Expanded(child: Text('6s', textAlign: TextAlign.center, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF64748B)))),
//               Expanded(child: Text('SR', textAlign: TextAlign.center, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF64748B)))),
//             ],
//           ),
//         ),
//         // Batting Stats
//         ...battingCard.map<Widget>((batsman) {
//           return Container(
//             padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//             decoration: BoxDecoration(
//               border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9), width: 1)),
//             ),
//             child: Column(
//               children: [
//                 Row(
//                   children: [
//                     Expanded(
//                       flex: 3,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             batsman['name'],
//                             style: TextStyle(
//                               fontSize: 13,
//                               fontWeight: FontWeight.w600,
//                               color: Color(0xFF1E293B),
//                             ),
//                           ),
//                           if (!batsman['isNotOut'])
//                             Text(
//                               batsman['dismissal'],
//                               style: TextStyle(
//                                 fontSize: 10,
//                                 color: Color(0xFF64748B),
//                               ),
//                             ),
//                         ],
//                       ),
//                     ),
//                     Expanded(child: Text('${batsman['runs']}${batsman['isNotOut'] ? '*' : ''}', textAlign: TextAlign.center, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)))),
//                     Expanded(child: Text('${batsman['balls']}', textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: Color(0xFF64748B)))),
//                     Expanded(child: Text('${batsman['fours']}', textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: Color(0xFF64748B)))),
//                     Expanded(child: Text('${batsman['sixes']}', textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: Color(0xFF64748B)))),
//                     Expanded(child: Text('${batsman['strikeRate']}', textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: Color(0xFF64748B)))),
//                   ],
//                 ),
//               ],
//             ),
//           );
//         }).toList(),
//         SizedBox(height: 12),
//       ],
//     ),
//   );
// }
// }