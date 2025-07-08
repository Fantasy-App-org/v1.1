//
// // lib/utils/network_utils.dart
// import 'dart:io';
// import 'package:connectivity_plus/connectivity_plus.dart';
//
// class NetworkUtils {
//   static final Connectivity _connectivity = Connectivity();
//
//   /// Check if device has internet connection
//   static Future<bool> hasInternetConnection() async {
//     try {
//       final connectivityResult = await _connectivity.checkConnectivity();
//
//       if (connectivityResult == ConnectivityResult.none) {
//         return false;
//       }
//
//       // Additional check by trying to reach a reliable server
//       final result = await InternetAddress.lookup('google.com');
//       return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
//     } catch (e) {
//       print('Network check failed: $e');
//       return false;
//     }
//   }
//
//   /// Get connectivity status stream
//   static Stream<ConnectivityResult> get connectivityStream {
//     return _connectivity.onConnectivityChanged;
//   }
//
//   /// Check if connection is WiFi
//   static Future<bool> isWiFiConnection() async {
//     final connectivityResult = await _connectivity.checkConnectivity();
//     return connectivityResult == ConnectivityResult.wifi;
//   }
//
//   /// Check if connection is mobile data
//   static Future<bool> isMobileConnection() async {
//     final connectivityResult = await _connectivity.checkConnectivity();
//     return connectivityResult == ConnectivityResult.mobile;
//   }
// }