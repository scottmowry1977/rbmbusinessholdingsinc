pluginManagement {
    val flutterSdkPath =
        run {
            val localPropertiesFile = file("local.properties")
            var path: String? = null
            if (localPropertiesFile.exists()) {
                localPropertiesFile.readLines().forEach { line ->
                    if (line.startsWith("flutter.sdk=")) {
                        path = line.substringAfter("=").trim()
                    }
                }
            }
            path ?: System.getenv("FLUTTER_ROOT") ?: System.getenv("FLUTTER_HOME")
        }

    if (flutterSdkPath == null) {
        throw GradleException("Flutter SDK not found. Define flutter.sdk in local.properties or set FLUTTER_ROOT environment variable.")
    }

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "8.5.2" apply false
    id("org.jetbrains.kotlin.android") version "2.0.21" apply false
    id("com.google.gms.google-services") version "4.4.2" apply false
}

include(":app")
