import java.io.FileInputStream
import java.util.Properties

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// ── Load signing config from key.properties (not committed to git) ───────────
val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()
var hasSigningConfig = false

if (keystorePropertiesFile.exists()) {
    FileInputStream(keystorePropertiesFile).use { input ->
        keystoreProperties.load(input)
    }
    val storeFilePath = keystoreProperties.getProperty("storeFile")
    if (storeFilePath != null) {
        val keystoreFile = file(storeFilePath) // resolves relative to android/app
        val keystoreFileRoot = rootProject.file(storeFilePath) // resolves relative to android/
        if (keystoreFile.exists() || keystoreFileRoot.exists()) {
            hasSigningConfig = true
        }
    }
}

android {
    namespace = "com.flowspaceapp.flowspace"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = "11"
    }

    // ── Signing configs ───────────────────────────────────────────────────────
    signingConfigs {
        if (hasSigningConfig) {
            create("release") {
                keyAlias = keystoreProperties.getProperty("keyAlias")
                keyPassword = keystoreProperties.getProperty("keyPassword")
                val storeFilePath = keystoreProperties.getProperty("storeFile")
                val f = file(storeFilePath)
                storeFile = if (f.exists()) f else rootProject.file(storeFilePath)
                storePassword = keystoreProperties.getProperty("storePassword")
            }
        }
    }

    defaultConfig {
        applicationId = "com.flowspaceapp.flowspace"
        minSdk = flutter.minSdkVersion        // Android 5.0+
        targetSdk = 34     // Android 14
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // Use release signing only if keystore is present, otherwise fallback to debug config
            signingConfig = if (hasSigningConfig) {
                signingConfigs.getByName("release")
            } else {
                signingConfigs.getByName("debug")
            }
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro",
            )
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
}
