// lib/team_creation/contest_detail_page.dart
import 'package:flutter/material.dart';
import '../model/fixture.dart';
import '../model/contest_details.dart';
import '../api/contest_api.dart';
import '../service/user_service.dart';

class ContestDetailPage extends StatefulWidget {
  final FixtureModel fixture;
  final int contestId;

  const ContestDetailPage({
    Key? key,
    required this.fixture,
    required this.contestId,
  }) : super(key: key);

  @override
  State<ContestDetailPage> createState() => _ContestDetailPageState();
}

class _ContestDetailPageState extends State<ContestDetailPage> {
  ContestDetail? _contestDetail;
  bool _isLoading = true;
  String? _errorMessage;
  final UserService _userService = UserService();

  @override
  void initState() {
    super.initState();
    _loadContestDetail();
  }

  Future<void> _loadContestDetail() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      // Use the same getContestList method with match_id
      final response = await ContestApi.getContestList(widget.fixture.id);
      final contestDetailResponse = ContestDetailResponse.fromJson(response);

      if (contestDetailResponse.status && contestDetailResponse.data.matchContest.isNotEmpty) {
        // Find the contest with matching ID
        ContestDetail? foundContest;
        for (var matchContest in contestDetailResponse.data.matchContest) {
          for (var contest in matchContest.contests) {
            if (contest.contestId == widget.contestId) {
              foundContest = contest;
              break;
            }
          }
          if (foundContest != null) break;
        }

        setState(() {
          _contestDetail = foundContest;
          _isLoading = false;
        });

        if (foundContest == null) {
          setState(() {
            _errorMessage = 'Contest not found';
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _errorMessage = 'Failed to load contest details';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading contest: $e';
        _isLoading = false;
      });
    }
  }

  void _showWinningBreakup() {
    if (_contestDetail == null || _contestDetail!.breakupDetails.isEmpty) return;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
            decoration: BoxDecoration(
              color: Color(0xFF16213E),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Color(0xFF22C55E).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.receipt_long,
                              color: Color(0xFF22C55E),
                              size: 24,
                            ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            width: 3,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Color(0xFF22C55E),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Winning Breakup',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  'Prize Pool — ',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  '₹${_contestDetail!.prizeMoney.toStringAsFixed(1)}',
                                  style: TextStyle(
                                    color: Color(0xFF22C55E),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Icon(Icons.close, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                // Breakup List
                Flexible(
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    shrinkWrap: true,
                    itemCount: _contestDetail!.breakupDetails.length,
                    itemBuilder: (context, index) {
                      final breakup = _contestDetail!.breakupDetails[index];
                      return Container(
                        margin: EdgeInsets.only(bottom: 12),
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                breakup.name,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Text(
                              '₹${breakup.prizeAmount.toStringAsFixed(2)}',
                              style: TextStyle(
                                color: Color(0xFF22C55E),
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatTimeRemaining() {
    // This would calculate time remaining until match starts
    // For now, showing a placeholder
    return "32m 42s";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF16213E),
      appBar: AppBar(
        backgroundColor: Color(0xFF16213E),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Contest Detail',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _isLoading
          ? _buildLoadingState()
          : _errorMessage != null
          ? _buildErrorState()
          : _buildContestDetailContent(),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF22C55E)),
          ),
          SizedBox(height: 16),
          Text(
            'Loading contest details...',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.white54),
            SizedBox(height: 16),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadContestDetail,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF22C55E),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContestDetailContent() {
    if (_contestDetail == null) return Container();

    return SingleChildScrollView(
      child: Column(
        children: [
          // Match Header
          _buildMatchHeader(),
          // Contest Info Card
          _buildContestInfoCard(),
          // Contest Features
          _buildContestFeatures(),
          // Teams Section
          _buildTeamsSection(),
        ],
      ),
    );
  }

  Widget _buildMatchHeader() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        widget.fixture.teamAShort,
                        style: TextStyle(
                          color: Color(0xFF16213E),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(width: 32),
              Column(
                children: [
                  Text(
                    'VS',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    _formatTimeRemaining(),
                    style: TextStyle(
                      color: Color(0xFF22C55E),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(width: 32),
              Column(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        widget.fixture.teamBShort,
                        style: TextStyle(
                          color: Color(0xFF16213E),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContestInfoCard() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF22C55E).withOpacity(0.1),
            Color(0xFF16213E),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFF22C55E), width: 1.5),
      ),
      child: Column(
        children: [
          // Top Row
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Winnings',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    Text(
                      '₹ ${_contestDetail!.prizeMoney.toInt()}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Winners',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    SizedBox(width: 8),
                    Text(
                      '${_contestDetail!.totalWinners}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 16),
                  ],
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Entry',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    Text(
                      '₹ ${_contestDetail!.entryFee.toInt()}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          // Progress section
          Row(
            children: [
              Text(
                'Only ${_contestDetail!.spotsLeft} spots left',
                style: TextStyle(
                  color: Color(0xFF22C55E),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Spacer(),
              Text(
                '${_contestDetail!.totalTeams} Spots',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
          SizedBox(height: 8),
          LinearProgressIndicator(
            value: _contestDetail!.fillPercentage,
            backgroundColor: Colors.white24,
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF22C55E)),
            minHeight: 4,
          ),
        ],
      ),
    );
  }

  Widget _buildContestFeatures() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildFeatureRow('M', 'Join with multiple teams', Color(0xFF22C55E)),
          SizedBox(height: 8),
          _buildFeatureRow('B', 'Usable Bonus percent', Colors.blue),
          SizedBox(height: 16),
          Text(
            'View the selected players of all teams after deadline. No Team changes post that.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
          SizedBox(height: 16),
          GestureDetector(
            onTap: _showWinningBreakup,
            child: Text(
              'View Winning Breakup',
              style: TextStyle(
                color: Color(0xFF22C55E),
                fontSize: 14,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureRow(String icon, String text, Color iconColor) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: iconColor,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
            child: Text(
              icon,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(width: 12),
        Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildTeamsSection() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '${_contestDetail!.teamsJoined} Teams',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          // Sample team entry (you'll need to fetch actual team data)
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Color(0xFF22C55E),
                child: Text(
                  'R',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Ramesh kumar p (T1)',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}