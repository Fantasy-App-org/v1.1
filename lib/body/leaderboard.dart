import 'package:flutter/material.dart';
import 'package:fantasy/api/leaderboard_api.dart';

class LeaderboardPage extends StatefulWidget {
  final String? matchId;
  final String? contestId;

  const LeaderboardPage({
    Key? key,
    this.matchId,
    this.contestId,
  }) : super(key: key);

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  List<Map<String, dynamic>> leaderboardData = [];
  bool isLoading = true;
  String? error;
  int currentPage = 1;
  int totalPages = 1;
  bool hasMoreData = true;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchLeaderboard();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      if (hasMoreData && !isLoading && currentPage < totalPages) {
        print('Scroll detected - triggering load more data');
        _loadMoreData();
      }
    }
  }

  Future<void> _fetchLeaderboard() async {
    if (widget.matchId == null || widget.contestId == null) {
      setState(() {
        error = 'Match or contest information not available';
        isLoading = false;
      });
      return;
    }

    try {
      setState(() {
        isLoading = true;
        error = null;
        leaderboardData.clear(); // Clear existing data
        currentPage = 1;
      });

      print('Fetching leaderboard for match: ${widget.matchId}, contest: ${widget.contestId}');

      final response = await LeaderboardApi.getLeaderboard(
        matchId: widget.matchId!,
        contestId: widget.contestId!,
        page: 1,
        limit: 50,
      );

      print('Initial fetch response status: ${response['status']}');

      if (response['status'] == true) {
        final data = response['data'];
        if (data != null && data['data'] != null && data['data']['data'] != null) {
          final responseData = List<Map<String, dynamic>>.from(data['data']['data']);

          setState(() {
            leaderboardData = responseData;
            currentPage = 1;
            totalPages = data['data']['total_pages'] ?? data['data']['last_page'] ?? 1;
            hasMoreData = currentPage < totalPages && responseData.isNotEmpty;
            isLoading = false;
          });

          print('Loaded ${responseData.length} items, Page 1/$totalPages, Has more: $hasMoreData');
        } else {
          setState(() {
            error = 'No leaderboard data found';
            isLoading = false;
          });
        }
      } else {
        setState(() {
          error = response['error'] ?? 'Failed to load leaderboard';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Error loading leaderboard: $e';
        isLoading = false;
      });
      print('Fetch error: $e');
    }
  }

  Future<void> _loadMoreData() async {
    if (widget.matchId == null || widget.contestId == null || !hasMoreData) return;

    try {
      print('Loading more data - Current page: $currentPage, Total pages: $totalPages');

      final nextPage = currentPage + 1;

      setState(() {
        isLoading = true;
      });

      final response = await LeaderboardApi.getLeaderboard(
        matchId: widget.matchId!,
        contestId: widget.contestId!,
        page: nextPage,
        limit: 50,
      );

      print('Load more response status: ${response['status']}');

      if (response['status'] == true) {
        final data = response['data'];
        if (data != null && data['data'] != null && data['data']['data'] != null) {
          final newData = List<Map<String, dynamic>>.from(data['data']['data']);

          print('Loaded ${newData.length} new items for page $nextPage');

          setState(() {
            leaderboardData.addAll(newData);
            currentPage = nextPage;
            hasMoreData = currentPage < totalPages && newData.isNotEmpty;
            isLoading = false;
          });

          print('Updated state - Current page: $currentPage, Total items: ${leaderboardData.length}, Has more: $hasMoreData');
        } else {
          setState(() {
            hasMoreData = false;
            isLoading = false;
          });
          print('No more data available');
        }
      } else {
        setState(() {
          hasMoreData = false;
          isLoading = false;
        });
        print('API error: ${response['error']}');
      }
    } catch (e) {
      setState(() {
        hasMoreData = false;
        isLoading = false;
      });
      print('Error loading more data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1F2937)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Leaderboard',
          style: TextStyle(
            color: Color(0xFF1F2937),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Color(0xFF1F2937)),
            onPressed: _fetchLeaderboard,
          ),
        ],
      ),
      body: error != null
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red[300],
            ),
            const SizedBox(height: 16),
            Text(
              error!,
              style: const TextStyle(
                color: Color(0xFF6B7280),
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchLeaderboard,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B82F6),
                foregroundColor: Colors.white,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      )
          : RefreshIndicator(
        onRefresh: _fetchLeaderboard,
        color: const Color(0xFF3B82F6),
        child: leaderboardData.isEmpty && isLoading
            ? const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3B82F6)),
          ),
        )
            : ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(16),
          itemCount: leaderboardData.length + (hasMoreData && !isLoading ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == leaderboardData.length) {
              // Show loading indicator only if we have more data and not currently loading
              return hasMoreData ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3B82F6)),
                  ),
                ),
              ) : const SizedBox.shrink();
            }

            final entry = leaderboardData[index];
            final rank = entry['rank'] ?? index + 1;
            final isMyTeam = entry['is_yours'] == 1 || entry['is_yours'] == true;

            return _buildLeaderboardItem(entry, rank, isMyTeam);
          },
        ),
      ),
    );
  }

  Widget _buildLeaderboardItem(Map<String, dynamic> entry, int rank, bool isMyTeam) {
    final Color rankColor = _getRankColor(rank);
    final bool isInWinningZone = entry['in_winning_zone'] == true || entry['winning_zone'] == true;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isMyTeam
            ? const Color(0xFFF0F9FF)
            : isInWinningZone
            ? const Color(0xFFF0FDF4)
            : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isMyTeam
              ? const Color(0xFF3B82F6)
              : isInWinningZone
              ? const Color(0xFF10B981)
              : const Color(0xFFE5E7EB),
          width: isMyTeam ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Rank Badge
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: rankColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                '#$rank',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Team Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        entry['team_name'] ?? 'Team $rank',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isMyTeam ? const Color(0xFF3B82F6) : const Color(0xFF1F2937),
                        ),
                      ),
                    ),
                    if (isMyTeam) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3B82F6),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'YOU',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ] else if (isInWinningZone) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'WIN',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '${entry['point'] ?? entry['points'] ?? 0} pts',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    if (entry['winning_amount'] != null && entry['winning_amount'] > 0) ...[
                      const SizedBox(width: 8),
                      Text(
                        '• ₹${entry['winning_amount']}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF10B981),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          // Previous Rank (if available)
          if (entry['previous_rank'] != null && entry['previous_rank'] != rank) ...[
            const SizedBox(width: 8),
            Column(
              children: [
                Icon(
                  rank < entry['previous_rank'] ? Icons.arrow_upward : Icons.arrow_downward,
                  size: 16,
                  color: rank < entry['previous_rank'] ? Colors.green : Colors.red,
                ),
                Text(
                  '${entry['previous_rank']}',
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Color _getRankColor(int rank) {
    if (rank <= 3) {
      switch (rank) {
        case 1: return const Color(0xFFD97706); // Gold
        case 2: return const Color(0xFF6B7280); // Silver
        case 3: return const Color(0xFFF59E0B); // Bronze
        default: return const Color(0xFF3B82F6); // Blue
      }
    } else if (rank <= 10) {
      return const Color(0xFF10B981); // Green for top 10
    } else if (rank <= 50) {
      return const Color(0xFF3B82F6); // Blue for top 50
    } else {
      return const Color(0xFF6B7280); // Gray for others
    }
  }
}