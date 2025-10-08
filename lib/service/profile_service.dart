import '../model/user.dart';
import '../api/profile_api.dart';
import '../service/user_service.dart';

class ProfileService {
  static final ProfileService _instance = ProfileService._internal();
  User? _currentProfile;
  bool _isLoading = false;
  String? _lastError;
  List<Map<String, dynamic>> _referrals = []; // Store referrals separately
  bool _referralsLoaded = false;

  factory ProfileService() {
    return _instance;
  }

  ProfileService._internal();

  /// Get current cached profile data
  User? get currentProfile => _currentProfile;
  bool get isLoading => _isLoading;
  String? get lastError => _lastError;

  /// Load profile data from API
  Future<User?> loadProfile({bool forceRefresh = false}) async {
    if (_isLoading) return _currentProfile;

    // Return cached data if available and not forcing refresh
    if (_currentProfile != null && !forceRefresh) {
      return _currentProfile;
    }

    try {
      _isLoading = true;
      _lastError = null;

      print('Loading profile from API...');
      final response = await ProfileApi.getProfile();

      if (response['status'] == true && response['data'] != null) {
        final profileData = response['data'];
        _currentProfile = User.fromJson(profileData);

        // Update UserService with latest profile data
        final userService = UserService();
        await userService.setUserData(profileData, userService.authToken!);

        print('Profile loaded successfully: ${_currentProfile!.displayName}');

        // Also load referrals data
        await _loadReferrals(forceRefresh: forceRefresh);

        return _currentProfile;
      } else {
        throw Exception(response['message'] ?? 'Failed to load profile');
      }
    } catch (e) {
      _lastError = e.toString();
      print('ProfileService Error: $e');

      // Handle authentication errors specifically
      if (e.toString().contains('Authentication required') ||
          e.toString().contains('Authentication failed')) {
        throw Exception('Authentication required');
      }

      throw Exception('Service error: $e');
    } finally {
      _isLoading = false;
    }
  }

  /// Load referrals data from separate API endpoint
  Future<void> _loadReferrals({bool forceRefresh = false}) async {
    if (_referralsLoaded && !forceRefresh) return;

    try {
      print('Loading referrals from separate endpoint...');
      final response = await ProfileApi.getReferrals();

      if (response['status'] == true && response['data'] != null) {
        final referralsData = response['data']['data'] as List<dynamic>? ?? [];
        _referrals = referralsData.map<Map<String, dynamic>>((item) => {
          'name': item['name'] ?? 'Unknown',
          'image': item['image'] ?? '',
          'reffered_count': 0, // Default value since this API doesn't provide it
        }).toList();

        _referralsLoaded = true;
        print('Referrals loaded successfully: ${_referrals.length} friends');
      } else {
        print('Failed to load referrals: ${response['message']}');
        _referrals = [];
      }
    } catch (e) {
      print('Error loading referrals: $e');
      _referrals = [];
    }
  }

  /// Public method to refresh referrals data
  Future<void> refreshReferrals() async {
    await _loadReferrals(forceRefresh: true);
  }

  /// Update profile data
  Future<bool> updateProfile({
    String? name,
    String? email,
    String? dateOfBirth,
    int? gender,
    String? address,
    String? city,
    String? state,
    String? country,
    String? pincode,
  }) async {
    if (_isLoading) return false;

    try {
      _isLoading = true;
      _lastError = null;

      // Build update data - using correct API field names
      Map<String, dynamic> updateData = {};

      if (name != null) updateData['name'] = name;
      if (email != null) updateData['email'] = email;
      if (dateOfBirth != null) updateData['date_of_birth'] = dateOfBirth;
      if (gender != null) updateData['gender'] = gender;
      if (address != null) updateData['address'] = address;
      if (city != null) updateData['city'] = city;
      if (state != null) updateData['state'] = state;
      if (country != null) updateData['country'] = country;
      if (pincode != null) updateData['pincode'] = pincode;

      print('Updating profile with data: $updateData');
      final response = await ProfileApi.updateProfile(updateData);

      if (response['status'] == true && response['data'] != null) {
        final updatedProfileData = response['data'];
        _currentProfile = User.fromJson(updatedProfileData);

        // Update UserService with latest profile data
        final userService = UserService();
        await userService.setUserData(updatedProfileData, userService.authToken!);

        print('Profile updated successfully');
        return true;
      } else {
        throw Exception(response['message'] ?? 'Failed to update profile');
      }
    } catch (e) {
      _lastError = e.toString();
      print('ProfileService Update Error: $e');

      // Handle authentication errors specifically
      if (e.toString().contains('Authentication required') ||
          e.toString().contains('Authentication failed')) {
        throw Exception('Authentication required');
      }

      throw Exception('Service error: $e');
    } finally {
      _isLoading = false;
    }
  }

  /// Get current user ID from profile data
  int? get userId {
    return _currentProfile?.userId;
  }

  /// Get user ID with automatic profile loading if not available
  Future<int?> getUserId() async {
    if (_currentProfile == null) {
      try {
        await loadProfile();
      } catch (e) {
        print('Error loading profile to get user ID: $e');
        return null;
      }
    }

    return _currentProfile?.userId;
  }

  /// Check if user ID is available
  bool get hasUserId {
    return _currentProfile?.userId != null;
  }

  /// Upload profile image
  Future<bool> uploadProfileImage(String imagePath) async {
    if (_isLoading) return false;

    try {
      _isLoading = true;
      _lastError = null;

      print('Uploading profile image: $imagePath');
      final response = await ProfileApi.uploadProfileImage(imagePath);

      if (response['status'] == true) {
        // Reload profile to get updated image URL
        await loadProfile(forceRefresh: true);
        print('Profile image uploaded successfully');
        return true;
      } else {
        throw Exception(response['message'] ?? 'Failed to upload image');
      }
    } catch (e) {
      _lastError = e.toString();
      print('ProfileService Upload Error: $e');

      // Handle authentication errors specifically
      if (e.toString().contains('Authentication required') ||
          e.toString().contains('Authentication failed')) {
        throw Exception('Authentication required');
      }

      throw Exception('Service error: $e');
    } finally {
      _isLoading = false;
    }
  }

  /// Get wallet balance information
  Map<String, double> getWalletBalances() {
    if (_currentProfile == null) {
      return {
        'cashBalance': 0.0,
        'winningAmount': 0.0,
        'bonusAmount': 0.0,
        'levelIncome': 0.0,
        'cashback': 0.0,
        'withdrawableAmount': 0.0,
        'nonWithdrawableAmount': 0.0,
        'totalBalance': 0.0,
      };
    }

    final cashBalance = _currentProfile!.cashDeposit ?? 0.0;
    final winningAmount = _currentProfile!.winnings ?? 0.0;
    final bonusAmount = _currentProfile!.bonus ?? 0.0;
    final levelIncome = _currentProfile!.levelIncome ?? 0.0;
    final cashback = _currentProfile!.cashback ?? 0.0;
    final withdrawableAmount = _currentProfile!.withdrawableAmount ?? 0.0;
    final nonWithdrawableAmount = _currentProfile!.nonWithdrawableAmount ?? 0.0;
    final totalBalance = cashBalance + winningAmount + bonusAmount + levelIncome + cashback;

    return {
      'cashBalance': cashBalance,
      'winningAmount': winningAmount,
      'bonusAmount': bonusAmount,
      'levelIncome': levelIncome,
      'cashback': cashback,
      'withdrawableAmount': withdrawableAmount,
      'nonWithdrawableAmount': nonWithdrawableAmount,
      'totalBalance': totalBalance,
    };
  }

  /// Get user verification status
  Map<String, dynamic> getVerificationStatus() {
    if (_currentProfile == null) {
      return {
        'isVerified': false,
        'isProfileUpdated': false,
        'hasProfileImage': false,
        'isPanVerified': false,
        'isBankVerified': false,
        'completionPercentage': 0,
      };
    }

    final isVerified = (_currentProfile!.accountVerified ?? 0) == 1;
    final isProfileUpdated = _currentProfile!.teamNameUpdated ?? false;
    final hasProfileImage = _currentProfile!.image?.isNotEmpty == true;
    final isPanVerified = (_currentProfile!.panVerify ?? 0) == 2;
    final isBankVerified = (_currentProfile!.bankVerify ?? 0) == 2;

    // Calculate profile completion percentage
    int completedFields = 0;
    int totalFields = 10;

    if (_currentProfile!.name?.isNotEmpty == true) completedFields++;
    if (_currentProfile!.email?.isNotEmpty == true) completedFields++;
    if (_currentProfile!.dateOfBirth?.isNotEmpty == true) completedFields++;
    if (_currentProfile!.gender != null) completedFields++;
    if (_currentProfile!.address?.isNotEmpty == true) completedFields++;
    if (_currentProfile!.city?.isNotEmpty == true) completedFields++;
    if (_currentProfile!.state?.isNotEmpty == true) completedFields++;
    if (_currentProfile!.country?.isNotEmpty == true) completedFields++;
    if (_currentProfile!.pinCode?.isNotEmpty == true) completedFields++;
    if (hasProfileImage) completedFields++;

    final completionPercentage = (completedFields / totalFields * 100).round();

    return {
      'isVerified': isVerified,
      'isProfileUpdated': isProfileUpdated,
      'hasProfileImage': hasProfileImage,
      'isPanVerified': isPanVerified,
      'isBankVerified': isBankVerified,
      'completionPercentage': completionPercentage,
      'completedFields': completedFields,
      'totalFields': totalFields,
    };
  }

  /// Get contest and gaming statistics
  Map<String, dynamic> getContestStats() {
    if (_currentProfile == null) {
      return {
        'paidContestCount': 0,
        'contestFinished': 0,
        'totalMatch': 0,
        'totalSeries': 0,
        'seriesWins': '',
      };
    }

    return {
      'paidContestCount': _currentProfile!.paidContestCount ?? 0,
      'contestFinished': _currentProfile!.contestFinished ?? 0,
      'totalMatch': _currentProfile!.totalMatch ?? 0,
      'totalSeries': _currentProfile!.totalSeries ?? 0,
      'seriesWins': _currentProfile!.seriesWins ?? '',
    };
  }

  /// Get referral information - Updated to use separate API
  Map<String, dynamic> getReferralInfo() {
    return {
      'inviteFriendCode': _currentProfile?.inviteFriendCode ?? '',
      'referredFriendsCount': _referrals.length,
      'referredToFriend': _referrals, // Use data from separate API
      'referralBonus': _currentProfile?.referralBonus ?? '',
    };
  }

  /// Clear cached profile data
  void clearCache() {
    _currentProfile = null;
    _lastError = null;
    _referrals = [];
    _referralsLoaded = false;
  }

  /// Check if user needs to re-authenticate
  bool needsAuthentication() {
    final userService = UserService();
    return !userService.isLoggedIn || userService.authToken == null;
  }

  /// Get current profile status
  Map<String, dynamic> getProfileStatus() {
    return {
      'hasProfile': _currentProfile != null,
      'isLoading': _isLoading,
      'lastError': _lastError,
      'userName': _currentProfile?.name,
      'teamName': _currentProfile?.teamName,
      'email': _currentProfile?.email,
      'mobileNo': _currentProfile?.mobileNo,
      'isVerified': (_currentProfile?.accountVerified ?? 0) == 1,
      'currentLevel': _currentProfile?.currentLevel ?? 0,
      'userId': _currentProfile?.userId,
      'referralsLoaded': _referralsLoaded,
      'referralsCount': _referrals.length,
    };
  }

  /// Get formatted profile display data
  Map<String, String> getDisplayData() {
    if (_currentProfile == null) {
      return {
        'displayName': 'User',
        'teamName': '',
        'email': 'Not provided',
        'mobileNo': 'Not provided',
        'address': 'Not provided',
        'city': 'Not provided',
        'state': 'Not provided',
        'country': 'Not provided',
        'dateOfBirth': 'Not provided',
        'genderText': 'Not specified',
        'profileImage': '',
      };
    }

    String genderText = 'Not specified';
    switch (_currentProfile!.gender) {
      case 1:
        genderText = 'Male';
        break;
      case 2:
        genderText = 'Female';
        break;
      case 3:
        genderText = 'Other';
        break;
    }

    return {
      'displayName': _currentProfile!.displayName,
      'teamName': _currentProfile!.teamName ?? '',
      'email': _currentProfile!.email?.isNotEmpty == true ? _currentProfile!.email! : 'Not provided',
      'mobileNo': _currentProfile!.mobileNo?.isNotEmpty == true ? _currentProfile!.mobileNo! : 'Not provided',
      'address': _currentProfile!.address?.isNotEmpty == true ? _currentProfile!.address! : 'Not provided',
      'city': _currentProfile!.city?.isNotEmpty == true ? _currentProfile!.city! : 'Not provided',
      'state': _currentProfile!.state?.isNotEmpty == true ? _currentProfile!.state! : 'Not provided',
      'country': _currentProfile!.country?.isNotEmpty == true ? _currentProfile!.country! : 'Not provided',
      'dateOfBirth': _currentProfile!.dateOfBirth?.isNotEmpty == true ? _currentProfile!.dateOfBirth! : 'Not provided',
      'genderText': genderText,
      'profileImage': _currentProfile!.profileImage,
    };
  }
}