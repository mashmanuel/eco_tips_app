# Code Citations

## Android Gradle Build Configuration
Source: [GMusic-Java-Samples](https://github.com/SakurajimaMaii/GMusic-Java-Samples/blob/c01bbb2c08f6ebe900c864b90f794cbeeb9343aa/build.gradle.kts)
License: MIT

```kotlin
buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath("com.android.tools.build:gradle:7.3.0")
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:1.7.10")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}
```

