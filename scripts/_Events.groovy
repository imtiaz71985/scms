
eventCreateWarStart = { warName, stagingDir ->
    if (grailsEnv == "xproduction") {
        def sharedLibsDir = "${grailsSettings.projectWorkDir}/sharedLibs"

        ant.mkdir dir: sharedLibsDir
        ant.move todir: sharedLibsDir, {
            fileset dir: "${stagingDir}/WEB-INF/lib", {
                include name: "*.jar"
                exclude name: "grails-*"
                exclude name: "mysql-*"
                exclude name: "tomcat-*"
            }
        }

        println "Shared JARs put into ${sharedLibsDir}"
    }
}