# Flutter and Dart rules
-keep class io.flutter.** { *; }
-keep class com.example.** { *; }

# Keep annotations
-keepattributes *Annotation*

# Keep serialized classes
-keepclassmembers class * implements java.io.Serializable { *; }

# Fix issues with reflection
-keep class * { @Keep *; }
-keepclassmembers class * { @Keep *; }
