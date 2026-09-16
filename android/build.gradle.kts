allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

// media_store_plus 0.1.3 pins `compileSdkVersion 33`, but its AndroidX dependencies
// require 34+, which breaks release builds. Raise any plugin module that compiles
// against an older SDK. Reflection avoids needing AGP classes on this script's classpath.
fun Project.raiseCompileSdkIfOutdated() {
    val androidExtension = extensions.findByName("android") ?: return
    val current = runCatching {
        androidExtension.javaClass.getMethod("getCompileSdkVersion").invoke(androidExtension) as? String
    }.getOrNull()
    val currentApi = current?.removePrefix("android-")?.toIntOrNull()
    if (currentApi != null && currentApi < 34) {
        androidExtension.javaClass.getMethod("compileSdkVersion", Int::class.java).invoke(androidExtension, 36)
    }
}

subprojects {
    // :app is already evaluated by the block above, so afterEvaluate would throw for it.
    if (state.executed) raiseCompileSdkIfOutdated() else afterEvaluate { raiseCompileSdkIfOutdated() }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
