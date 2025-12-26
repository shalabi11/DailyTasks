# Fix for flutter_local_notifications release crash:
# PlatformException(error, Missing type parameter.)
# Caused by R8 removing generic signatures used by Gson TypeToken.

-keepattributes Signature
-keepattributes *Annotation*

# Keep Gson TypeToken generic signatures.
-keep class com.google.gson.reflect.TypeToken { *; }
-keep class * extends com.google.gson.reflect.TypeToken

# Keep flutter_local_notifications internals (safe, small surface).
-keep class com.dexterous.flutterlocalnotifications.** { *; }

-dontwarn com.google.gson.**
