# Flutter wrapper
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.embedding.** { *; }
-dontwarn io.flutter.embedding.**

# Firebase (optional, only if using Firebase)
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

# Prevent stripping of Kotlin metadata
-keep class kotlin.** { *; }
-keep class kotlinx.** { *; }
-dontwarn kotlin.**

# Add rules for any plugins you use (e.g. Glide, Retrofit, etc.)
