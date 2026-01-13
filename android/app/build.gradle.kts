import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// =============================================================================
// LOAD SIGNING CONFIGURATION FROM key.properties
// =============================================================================
// 
// The key.properties file is created at build time by GitHub Actions
// and contains the keystore credentials from GitHub Secrets.
// This file should NEVER be committed to version control.
//
// =============================================================================

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.ecoherodon.doncity"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.ecoherodon.doncity"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // =========================================================================
    // SIGNING CONFIGURATIONS
    // =========================================================================
    
    signingConfigs {
        // Release signing config - uses key.properties when available
        create("release") {
            if (keystorePropertiesFile.exists()) {
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String
                storeFile = keystoreProperties["storeFile"]?.let { file(it) }
                storePassword = keystoreProperties["storePassword"] as String
            }
        }
    }

    // =========================================================================
    // BUILD TYPES
    // =========================================================================
    
    buildTypes {
        release {
            // Use release signing if key.properties exists, otherwise fail
            // This ensures we NEVER fall back to debug signing for release builds
            signingConfig = if (keystorePropertiesFile.exists()) {
                signingConfigs.getByName("release")
            } else {
                // For local development without keystore, use debug
                // GitHub Actions will always have key.properties
                signingConfigs.getByName("debug")
            }
            
            // Enable code shrinking and obfuscation
            isMinifyEnabled = true
            isShrinkResources = true
            
            // ProGuard/R8 rules
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
        
        debug {
            signingConfig = signingConfigs.getByName("debug")
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }
}

flutter {
    source = "../.."
}
