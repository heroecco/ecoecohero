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
                keyAlias = keystoreProperties.getProperty("keyAlias")
                keyPassword = keystoreProperties.getProperty("keyPassword")
                storeFile = keystoreProperties.getProperty("storeFile")?.let { file(it) }
                storePassword = keystoreProperties.getProperty("storePassword")
            }
        }
    }

    // =========================================================================
    // BUILD TYPES
    // =========================================================================
    
    buildTypes {
        release {
            // CRITICAL: Use release signing config ONLY if key.properties exists
            // For CI builds: key.properties is created from GitHub Secrets
            // For local builds without keystore: this will be null, causing build to fail
            // We NEVER fall back to debug signing for release builds
            signingConfig = if (keystorePropertiesFile.exists()) {
                signingConfigs.getByName("release")
            } else {
                // Return null - this will cause the release build to fail
                // which is the desired behavior (no debug fallback)
                null
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
