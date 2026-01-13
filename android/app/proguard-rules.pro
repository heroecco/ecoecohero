# =============================================================================
# ECO HERO - PROGUARD RULES
# =============================================================================
# 
# These rules are applied during the Android release build to:
# - Suppress warnings for missing Play Core classes (not used by this app)
# - Optimize and shrink the APK/AAB
#
# =============================================================================

# -----------------------------------------------------------------------------
# FLUTTER RULES
# -----------------------------------------------------------------------------

# Keep Flutter engine classes
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# -----------------------------------------------------------------------------
# PLAY CORE LIBRARY - DONTWARN RULES
# -----------------------------------------------------------------------------
# 
# Flutter's Android build may reference Google Play Core classes for deferred
# components (dynamic feature modules). Since this app does NOT use this feature
# and does NOT include the Play Core library, R8 will fail during release build
# because it cannot find those classes.
#
# These -dontwarn rules tell R8 to ignore the missing classes, which is safe
# because the deferred components functionality will not be used at runtime.
#
# -----------------------------------------------------------------------------

# Play Core - All packages (comprehensive coverage)
-dontwarn com.google.android.play.core.**

# Play Core - Split Install (explicit for clarity)
-dontwarn com.google.android.play.core.splitcompat.**
-dontwarn com.google.android.play.core.splitinstall.**

# Play Core - Tasks
-dontwarn com.google.android.play.core.tasks.**

# Play Core - Common
-dontwarn com.google.android.play.core.common.**
-dontwarn com.google.android.play.core.listener.**

# Play Core - Review
-dontwarn com.google.android.play.core.review.**

# Play Core - App Update
-dontwarn com.google.android.play.core.appupdate.**

# Play Core - Asset Packs
-dontwarn com.google.android.play.core.assetpacks.**

# Play Core - Install State
-dontwarn com.google.android.play.core.install.**

# Play Core - Integrity
-dontwarn com.google.android.play.core.integrity.**

# -----------------------------------------------------------------------------
# GENERAL ANDROID RULES
# -----------------------------------------------------------------------------

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep Parcelable implementations
-keepclassmembers class * implements android.os.Parcelable {
    public static final android.os.Parcelable$Creator *;
}

# Keep Serializable implementations
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

# Keep annotations
-keepattributes *Annotation*

# Keep source file names and line numbers for crash reports
-keepattributes SourceFile,LineNumberTable

# -----------------------------------------------------------------------------
# FLAME ENGINE RULES (if needed)
# -----------------------------------------------------------------------------

# Keep Flame classes
-keep class flame.** { *; }
-dontwarn flame.**

# -----------------------------------------------------------------------------
# AUDIO PLAYERS RULES
# -----------------------------------------------------------------------------

-keep class xyz.luan.audioplayers.** { *; }
-dontwarn xyz.luan.audioplayers.**
