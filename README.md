Assembly for the DAISY Pipeline 2 distribution
==============================================

The default Pipeline 2 distribution is assembled with the [Maven Assembly Plugin](http://maven.apache.org/plugins/maven-assembly-plugin/). 

The library dependencies and list of Pipeline 2 modules are configured in the main `pom.xml` and copied in a set of goals of the `maven-dependency-plugin`.

The project allows to build the following distributions:

 - the "CLI" distribution (with the command line user interface), packaged as a ZIP (_default_)
 - the "Desktop Web UI" distribution that includes the Braille modules and Web UI (optional)
 - the "Developers" distribution generates the configuration files and launcher scripts for a development environment
 - the "Debian" distribution build a DEB package (will disable the default distribution)

See the following sections for more details on how to enable these distributions and to know which optional Maven profiles can be activated.


CLI Distribution
----------------

Build the default distribution with:

	mvn clean package

The Braille modules can optionally be included by activating the `incl-braille` profile

	mvn clean package -P incl-braille

Desktop WebUI  Distribution
---------------------------

Build the Web UI distribution with:

    mvn clean package -P webui

This distribution does **not** disable the default CLI distribution. Both will be built.

The Braille modules can optionally be included by activating the `incl-braille` profile

    mvn clean package -P webui,incl-braille

A Windows installer (build with NSIS) can be generated by activating the `installer` profile:

    mvn clean package -P webui,installer


Developers Distribution
-----------------------

Build the development environment with:

    mvn clean package -P dev-launcher

This distribution includes a launcher script for the Pipeline engine, as well as configuration files to include
modules installed in the user's default Maven repository (in `~/.m2/`).

Configuration files are generated for all the POM modules, including the braille modules.
    
Debian Distribution
-------------------

Build a Debian package with:

    mvn clean package -P deb

The Braille modules can optionally be included by activating the `incl-braille` profile

    mvn clean package -P deb,incl-braille
    
Inspect package contents and metadata:

    dpkg-deb -c target/*.deb
    dpkg-deb -f target/*.deb

Install the package:

    dpkg -i target/*.deb

Uninstall:

    dpkg -r daisy-pipeline
