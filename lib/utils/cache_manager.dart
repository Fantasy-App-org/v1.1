// lib/utils/cache_manager.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CacheManager {
  static const String _cachePrefix = 'fantasy_cache_';
  static const Duration _defaultCacheDuration = Duration(minutes: 10);

  /// Save data to cache with expiry
  static Future<void> saveToCache(
      String key,
      Map<String, dynamic> data, {
        Duration? cacheDuration,
      }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheKey = '$_cachePrefix$key';
      final expiryTime = DateTime.now().add(cacheDuration ?? _defaultCacheDuration);

      final cacheData = {
        'data': data,
        'expiry': expiryTime.millisecondsSinceEpoch,
      };

      await prefs.setString(cacheKey, jsonEncode(cacheData));
      print('Cached data for key: $key');
    } catch (e) {
      print('Failed to cache data for key $key: $e');
    }
  }

  /// Load data from cache if not expired
  static Future<Map<String, dynamic>?> loadFromCache(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheKey = '$_cachePrefix$key';
      final cachedString = prefs.getString(cacheKey);

      if (cachedString == null) return null;

      final cacheData = jsonDecode(cachedString);
      final expiryTime = DateTime.fromMillisecondsSinceEpoch(cacheData['expiry']);

      if (DateTime.now().isAfter(expiryTime)) {
        // Cache expired, remove it
        await prefs.remove(cacheKey);
        print('Cache expired for key: $key');
        return null;
      }

      print('Loaded cached data for key: $key');
      return cacheData['data'];
    } catch (e) {
      print('Failed to load cached data for key $key: $e');
      return null;
    }
  }

  /// Clear specific cache
  static Future<void> clearCache(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheKey = '$_cachePrefix$key';
      await prefs.remove(cacheKey);
      print('Cleared cache for key: $key');
    } catch (e) {
      print('Failed to clear cache for key $key: $e');
    }
  }

  /// Clear all caches
  static Future<void> clearAllCaches() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys().where((key) => key.startsWith(_cachePrefix));

      for (final key in keys) {
        await prefs.remove(key);
      }

      print('Cleared all caches');
    } catch (e) {
      print('Failed to clear all caches: $e');
    }
  }
}
