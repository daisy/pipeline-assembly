Assembly for the DAISY Pipeline 2 distribution
==============================================

The default Pipeline 2 distribution is assembled with the [Maven Assembly Plugin](http://maven.apache.org/plugins/maven-assembly-plugin/). 

The library dependencies and list of Pipeline 2 modules are configured in the main `pom.xml` and copied in a set of goals of the `maven-dependency-plugin`. The project defines the following assemblies:

 - `dist`: the default distribution, packaged as a ZIP
 - `webui`: distribution that includes the Braille modules and Web UI (optional)
 - `dev-launcher`: configuration files and launcher script for a development environment
 - `deb`: packaged as a DEB (will disable the default distribution)

Each of these assemblies can be build either with or without the braille modules. To include them, active the `incl-braille` profile.

ZIP
---
Build the default distribution with:

	mvn clean package
	mvn clean package -P incl-braille

WebUI
-----

The `webui` assembly is optional. To activate:

    mvn clean package -DincludeWebUI

To generate the windows nsis installer for the webui build with:

    mvn clean package -DincludeWebUI -DincludeInstaller


Develop
-------
Build the development environment with:

    mvn clean package -P dev-launcher
    mvn clean package -P dev-launcher,incl-braille
    
Debian
------
Build a Debian package with:

    mvn clean package -P deb
    mvn clean package -P deb,incl-braille
    
Inspect package contents and metadata:

    dpkg-deb -c target/*.deb
    dpkg-deb -f target/*.deb

Install the package:

    dpkg -i target/*.deb

Uninstall:

    dpkg -r daisy-pipeline
