import com.android.build.gradle.AppExtension

val android = project.extensions.getByType(AppExtension::class.java)

android.apply {
    flavorDimensions("flavor-type")

    productFlavors {
        create("dev") {
            dimension = "flavor-type"
            applicationId = "pub.brs.flbeacon.dev"
            resValue(type = "string", name = "app_name", value = "Beacon (Dev)")
        }
        create("prod") {
            dimension = "flavor-type"
            applicationId = "pub.brs.flbeacon"
            resValue(type = "string", name = "app_name", value = "Beacon")
        }
    }

    buildFeatures.resValues = true
}
