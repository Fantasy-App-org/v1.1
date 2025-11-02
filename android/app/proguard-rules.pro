# Flutter specific rules
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-dontwarn io.flutter.**

# Keep shared preferences
-keep class androidx.preference.** { *; }

# Keep HTTP client
-keep class okhttp3.** { *; }
-keep class okio.** { *; }
-dontwarn okhttp3.**
-dontwarn okio.**

# Keep device info
-keep class io.flutter.plugins.deviceinfo.** { *; }

# Keep package info
-keep class io.flutter.plugins.packageinfo.** { *; }

# Keep image picker
-keep class io.flutter.plugins.imagepicker.** { *; }

# Keep permission handler
-keep class com.baseflow.permissionhandler.** { *; }

# Keep JSON serialization
-keepattributes *Annotation*
-keepattributes Signature
-keep class com.google.gson.** { *; }

# Keep your model classes
-keep class com.fantasy.cricket.model.** { *; }

# General Android rules
-keep public class * extends android.app.Activity
-keep public class * extends android.app.Application
-keep public class * extends android.app.Service
-keep public class * extends android.content.BroadcastReceiver
-keep public class * extends android.content.ContentProvider