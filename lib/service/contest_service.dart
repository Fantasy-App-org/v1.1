// lib/service/contest_service.dart
import '../model/contest.dart';
import '../model/joined_contest.dart';
import '../api/contest_api.dart';
import '../service/user_service.dart';

class ContestService {
  static final ContestService _instance = ContestService._internal();
  static final UserService _userService = UserService();

  List<Contest> _contests = [];
  List<ContestCategory> _contestCategories = [];
  List<JoinedContest> _joinedContests = [];
  bool _isLoading = false;
  String? _lastError;

  factory ContestService() {
    return _instance;
  }

  ContestService._internal();

  /// Getters
  List<Contest> get contests => _contests;
  List<ContestCategory> get contestCategories => _contestCategories;
  List<JoinedContest> get joinedContests => _joinedContests;
  bool get isLoading => _isLoading;
  String? get lastError => _lastError;

  /// Load contests for a specific match
  Future<List<Contest>> getContestsForMatch(int matchId) async {
    try {
      _isLoading = true;
      _lastError = null;

      // Ensure user is authenticated
      await _ensureAuthenticated();

      print('Loading contests for match ID: $matchId');
      final response = await ContestApi.getContestList(matchId);

      if (response['status'] == true && response['data'] != null) {
        final List<dynamic> categoriesData = response['data']['match_contest'] ?? [];

        // Parse categories
        _contestCategories = categoriesData.map((categoryJson) =>
            ContestCategory.fromJson(categoryJson)
        ).toList();

        // Flatten all contests from all categories
        _contests = [];
        for (final category in _contestCategories) {
          for (final contest in category.contests) {
            // Add category info to contest
            final contestWithCategory = Contest(
              confirmWinning: contest.confirmWinning,
              entryFee: contest.entryFee,
              prizeMoney: contest.prizeMoney,
              totalTeams: contest.totalTeams,
              totalWinners: contest.totalWinners,
              contestId: contest.contestId,
              teamsJoined: contest.teamsJoined,
              isJoined: contest.isJoined,
              multipleTeams: contest.multipleTeams,
              inviteCode: contest.inviteCode,
              useBonus: contest.useBonus,
              breakupDetails: contest.breakupDetails,
              myTeams: contest.myTeams,
              isInfinite: contest.isInfinite,
              infiniteBreakup: contest.infiniteBreakup,
              categoryTitle: category.categoryTitle,
              categoryId: category.categoryId,
            );
            _contests.add(contestWithCategory);
          }
        }

        print('Successfully loaded ${_contests.length} contests from ${_contestCategories.length} categories');
        return _contests;
      } else {
        throw Exception(response['message'] ?? 'Failed to load contests');
      }
    } catch (e) {
      _lastError = e.toString();
      print('ContestService.getContestsForMatch Error: $e');

      // Handle authentication errors
      if (e.toString().contains('Authentication required') ||
          e.toString().contains('Authentication failed')) {
        throw Exception('Authentication required');
      }

      throw Exception('Service error: $e');
    } finally {
      _isLoading = false;
    }
  }

  /// Load joined contests for a specific match
  Future<List<JoinedContest>> getJoinedContestsForMatch({
    required int matchId,
    int filterKey = 1,
    int filterType = 1,
  }) async {
    try {
      _isLoading = true;
      _lastError = null;

      // Ensure user is authenticated
      await _ensureAuthenticated();

      print('Loading joined contests for match ID: $matchId');
      final response = await ContestApi.getJoinedContestList(
        matchId: matchId,
        filterKey: filterKey,
        filterType: filterType,
      );

      if (response['status'] == true && response['data'] != null) {
        final List<dynamic> contestsData = response['data']['joined_contest'] ?? [];
        _joinedContests = contestsData.map((json) => JoinedContest.fromJson(json)).toList();

        print('Successfully loaded ${_joinedContests.length} joined contests');
        return _joinedContests;
      } else {
        throw Exception(response['message'] ?? 'Failed to load joined contests');
      }
    } catch (e) {
      _lastError = e.toString();
      print('ContestService.getJoinedContestsForMatch Error: $e');

      // Handle authentication errors
      if (e.toString().contains('Authentication required') ||
          e.toString().contains('Authentication failed')) {
        throw Exception('Authentication required');
      }

      throw Exception('Service error: $e');
    } finally {
      _isLoading = false;
    }
  }

  /// Get joined contest details
  Future<Map<String, dynamic>> getJoinedContestDetails(Map<String, dynamic> requestData) async {
    try {
      await _ensureAuthenticated();
      return await ContestApi.getJoinedContestDetails(requestData);
    } catch (e) {
      print('ContestService.getJoinedContestDetails Error: $e');
      throw Exception('Service error: $e');
    }
  }

  /// Get joined contest detail (singular)
  Future<Map<String, dynamic>> getJoinedContestDetail(Map<String, dynamic> requestData) async {
    try {
      await _ensureAuthenticated();
      return await ContestApi.getJoinedContestDetail(requestData);
    } catch (e) {
      print('ContestService.getJoinedContestDetail Error: $e');
      throw Exception('Service error: $e');
    }
  }

  /// Get joined contest matches
  Future<Map<String, dynamic>> getJoinedContestMatches() async {
    try {
      await _ensureAuthenticated();
      return await ContestApi.getJoinedContestMatches();
    } catch (e) {
      print('ContestService.getJoinedContestMatches Error: $e');
      throw Exception('Service error: $e');
    }
  }

  /// Get my matches
  Future<Map<String, dynamic>> getMyMatches() async {
    try {
      await _ensureAuthenticated();
      return await ContestApi.getMyMatches();
    } catch (e) {
      print('ContestService.getMyMatches Error: $e');
      throw Exception('Service error: $e');
    }
  }

  /// Helper method to ensure authentication
  Future<void> _ensureAuthenticated() async {
    if (!_userService.isLoggedIn) {
      final isLoggedIn = await _userService.checkLoginStatus();
      if (!isLoggedIn) {
        throw Exception('Authentication required. Please login first.');
      }
    }

    if (_userService.authToken == null) {
      throw Exception('Authentication token not available. Please login again.');
    }
  }

  /// Clear cached data
  void clearCache() {
    _contests.clear();
    _contestCategories.clear();
    _joinedContests.clear();
    _lastError = null;
  }
}