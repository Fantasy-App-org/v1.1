// lib/config/api_config.dart
class ApiConfig {
  // TODO: Replace with your actual API domain
  // Examples:
  // static const String baseUrl = 'https://api.dpl11.com';
  // static const String baseUrl = 'https://dpl11backend.herokuapp.com';
  // static const String baseUrl = 'http://192.168.1.100:3000'; // For local testing
  static const String baseUrl = 'https://your-actual-domain.com';

  // ============================================
  // AUTH ENDPOINTS
  // ============================================
  static const String checkEndpoint = '/check';
  static const String logoutEndpoint = '/logout';
  static const String resendOtpEndpoint = '/resend-otp';
  static const String signinEndpoint = '/signin';
  static const String signupEndpoint = '/signup';
  static const String verifyOtpEndpoint = '/verify-otp';

  // ============================================
  // USER ENDPOINTS
  // ============================================
  static const String mlmWalletEndpoint = '/MLMWallet';
  static const String editUserTeamNameEndpoint = '/edit-user-team-name';
  static const String getReferralCodeEndpoint = '/getrefferalcode';
  static const String notifyEndpoint = '/notify';
  static const String playerDetailsEndpoint = '/player_details';
  static const String profileEndpoint = '/profile';
  static const String referralsEndpoint = '/referrals';
  static const String teamProfileComparisonEndpoint = '/team-profile-comparision';
  static const String transactionHistoryNewEndpoint = '/transation-history-new';
  static const String updateUserImageEndpoint = '/updateUserImage';
  static const String updatePersonalDetailsEndpoint = '/update_personal_details';
  static const String verifyBankDetailEndpoint = '/verify-bank-detail';
  static const String verifyPanDetailEndpoint = '/verify-pan-detail';
  static const String withdrawCashEndpoint = '/withdraw-cash';
  static const String withdrawDetailEndpoint = '/withdraw-detail';

  // ============================================
  // CONTEST ENDPOINTS
  // ============================================
  static const String allContestEndpoint = '/all_contest';
  static const String contestListEndpoint = '/contest_list';
  static const String getFilterTypeEndpoint = '/get-filter-type';
  static const String joinContestWalletAmountEndpoint = '/join-contest-wallet-amount';
  static const String joinContestEndpoint = '/joinContest';
  static const String joinedContestDetailEndpoint = '/joined-contest-detail';
  static const String joinedContestDetailsEndpoint = '/joined-contest-details';
  static const String joinedContestListEndpoint = '/joined-contest-list';
  static const String joinedContestMatchesEndpoint = '/joined-contest-matches';
  static const String leaderboardEndpoint = '/leader_board';
  static const String levelIncomeDetailsEndpoint = '/level_income_details';
  static const String myMatchesEndpoint = '/my-matches';
  static const String userCashBackEndpoint = '/user_cash_back';

  // ============================================
  // FIXTURE ENDPOINTS
  // ============================================
  static const String activateFixtureEndpoint = '/activatefixtures';
  static const String fixturesEndpoint = '/fixtures';

  // ============================================
  // USER TEAM ENDPOINTS
  // ============================================
  static const String createUserTeamEndpoint = '/creatuserteam';
  static const String getPlayerStatsEndpoint = '/getplayerstats';
  static const String getUserTeamEndpoint = '/getuserteam';
  static const String getUserTeamByIdEndpoint = '/getuserteambyid';
  static const String seriesPlayerDetailsEndpoint = '/seriesplayerdetails';
  static const String switchTeamEndpoint = '/switchteam';
  static const String updateRankEndpoint = '/updaterank';

  // ============================================
  // SCORECARD ENDPOINTS
  // ============================================
  static const String getFullScorecardEndpoint = '/getfullscoredata';
  static const String getScorecardEndpoint = '/getscorecard';

  // ============================================
  // SQUAD ENDPOINTS
  // ============================================
  static const String squadListEndpoint = '/squadlist';

  // ============================================
  // PAYMENT GATEWAY ENDPOINTS
  // ============================================
  static const String checkPaymentStatusEndpoint = '/checkpaymentstatus';
  static const String newPaymentEndpoint = '/newpayment';
  static const String paymentStatusEndpoint = '/paymentstatus';
  static const String withdrawRequestEndpoint = '/withdrawrequest';

  // ============================================
  // LEVEL INCOME ENDPOINTS
  // ============================================
  static const String getLevelIncomeEndpoint = '/getlevelincome';
  static const String joinedContestBySeriesEndpoint = '/joinedcontestbyseries';
  static const String joinedContestEarningsEndpoint = '/joinedcontestearnings';

  // ============================================
  // NOTIFICATION ENDPOINTS
  // ============================================
  static const String clearNotificationEndpoint = '/clear-notification';
  static const String notificationListEndpoint = '/notification-list';

  // ============================================
  // BANNER ENDPOINTS
  // ============================================
  static const String bannerListEndpoint = '/banner-list';

  // ============================================
  // DEPRECATED/LEGACY ENDPOINTS (keeping for compatibility)
  // ============================================
  static const String contestDetailEndpoint = '/all_contest'; // Same as allContestEndpoint
  static const String teamDetailsEndpoint = '/getuserteambyid'; // Same as getUserTeamByIdEndpoint
  static const String uploadProfileImageEndpoint = '/updateUserImage'; // Same as updateUserImageEndpoint
}