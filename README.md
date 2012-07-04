Assembly for the DAISY Pipeline 2 distribution
==============================================

The default Pipeline 2 distribution is assembled with the [Maven Assembly Plugin](http://maven.apache.org/plugins/maven-assembly-plugin/). 

The library dependencies and list of Pipeline 2 modules are configured in the main `pom.xml` and copied in a set of goals of the `maven-dependency-plugin`. The project defines two assemblies:

 - `dist`: the default distribution, packaged as a ZIP
 - `dev-launcher`: configuration files and launcher script for a development environment

Build with:

	mvn clean package