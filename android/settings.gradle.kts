import java.util.Properties as JProperties
import java.io.FileInputStream as JFileInputStream

pluginManagement {
    val flutterSdkPath =
        run {
            val properties = JProperties()
            val localPropertiesFile = file("local.properties")
            if (localPropertiesFile.exists()) {
                val stream = JFileInputStream(localPropertiesFile)
                properties.load(stream)
                stream.close()
            }
            val path = properties.getProperty("flutter.sdk")
            require(path != null) { "flutter.sdk not set in local.properties" }
            path
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
    id("com.android.application") version "9.0.1" apply false
    id("org.jetbrains.kotlin.android") version "2.3.20" apply false
    id("com.google.gms.google-services") version "4.4.2" apply false
}

include(":app")
