plugins { id("dev.detekt") }

val libs = project.extensions.getByType<VersionCatalogsExtension>().named("libs")

dependencies { "detektPlugins"(libs.findLibrary("composeRules-detekt").get()) }

detekt {
    buildUponDefaultConfig = true
    config.setFrom(files("$rootDir/config/detekt/detekt.yml"))
    source.setFrom(
        "src/main/kotlin",
        "src/test/kotlin",
        "src/commonMain/kotlin",
        "src/commonTest/kotlin",
        "src/androidMain/kotlin",
        "src/iosMain/kotlin",
        "src/jvmMain/kotlin",
        "src/jvmTest/kotlin",
        "src/wasmJsMain/kotlin",
        "src/jsMain/kotlin",
    )
}
