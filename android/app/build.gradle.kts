plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("com.google.gms.google-services")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Manual parsing of keystore properties to avoid naming conflicts with AGP 9.0
val keystoreProperties = mutableMapOf<String, String>()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystorePropertiesFile.readLines().forEach { line ->
        if (line.contains("=")) {
            val parts = line.split("=", limit = 2)
            if (parts.size == 2) {
                keystoreProperties[parts[0].trim()] = parts[1].trim()
            }
        }
    }
}

android {
    namespace = "com.rbmbusinessholdingsinc.app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_21
        targetCompatibility = JavaVersion.VERSION_21
    }

    defaultConfig {
        applicationId = "com.rbmbusinessholdingsinc.app"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"]
            keyPassword = keystoreProperties["keyPassword"]
            val storePath = keystoreProperties["storeFile"]
            if (storePath != null) {
                storeFile = file(storePath.replace("\\\\", "\\"))
            }
            storePassword = keystoreProperties["storePassword"]
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_21
    }
}

flutter {
    source = "../.."
}
