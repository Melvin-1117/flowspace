# ProGuard rules for FlowSpace
# Generated for Play Store release build

# ── Flutter core ─────────────────────────────────────────────────────────────
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.embedding.** { *; }

# ── Isar database ─────────────────────────────────────────────────────────────
-keep class dev.isar.** { *; }
-keep class isar.** { *; }
-dontwarn dev.isar.**

# ── flutter_foreground_task ───────────────────────────────────────────────────
-keep class com.pravera.flutter_foreground_task.** { *; }
-dontwarn com.pravera.flutter_foreground_task.**

# ── flutter_local_notifications ───────────────────────────────────────────────
-keep class com.dexterous.flutterlocalnotifications.** { *; }
-dontwarn com.dexterous.flutterlocalnotifications.**

# ── audioplayers ──────────────────────────────────────────────────────────────
-keep class xyz.luan.audioplayers.** { *; }
-dontwarn xyz.luan.audioplayers.**

# ── sensors_plus ──────────────────────────────────────────────────────────────
-keep class dev.fluttercommunity.plus.sensors.** { *; }
-dontwarn dev.fluttercommunity.plus.sensors.**

# ── battery_plus ──────────────────────────────────────────────────────────────
-keep class dev.fluttercommunity.plus.battery.** { *; }
-dontwarn dev.fluttercommunity.plus.battery.**

# ── path_provider ─────────────────────────────────────────────────────────────
-keep class io.flutter.plugins.pathprovider.** { *; }

# ── shared_preferences ────────────────────────────────────────────────────────
-keep class io.flutter.plugins.sharedpreferences.** { *; }

# ── Kotlin / Coroutines ───────────────────────────────────────────────────────
-keep class kotlin.** { *; }
-keep class kotlinx.coroutines.** { *; }
-dontwarn kotlin.**
-dontwarn kotlinx.coroutines.**

# ── Gson / JSON (used internally by some packages) ────────────────────────────
-keepattributes Signature
-keepattributes *Annotation*
-dontwarn sun.misc.**

# ── General Android ───────────────────────────────────────────────────────────
-keepattributes SourceFile,LineNumberTable
-keep public class * extends android.app.Activity
-keep public class * extends android.app.Service
-keep public class * extends android.content.BroadcastReceiver

# ── Play Store Deferred Components (Play Core) ───────────────────────────────
-dontwarn com.google.android.play.core.**

