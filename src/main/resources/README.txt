
              DAISY Pipeline 2 - 1.5 - April ??, 2012
===============================================================================


 1. What is the DAISY Pipeline 2 ?
 2. Contents of the package
 3. Release notes
 4. Prerequisites
 5. Getting started
 6. Documentation
 7. Known limitations
 8. Contact



1. What is the DAISY Pipeline 2 ?
-------------------------------------------------------------------------------

The DAISY Pipeline 2 is an ongoing project to develop a next generation
framework for automated production of accessible materials for people with
print disabilities. It is the follow-up and total redesign of the original
DAISY Pipeline 1 project.

For more information see:

 - the project page: http://www.daisy.org/pipeline2
 - the development site: http://code.google.com/p/daisy-pipeline/



2. Contents of the package
-------------------------------------------------------------------------------

The package includes:

 - a modular runtime framework (based on OSGi) for the Pipeline 2 modules
 - a command line interface to execute pipeline scripts, in the "cli" directory
 - dedicated launchers for the Pipeline 2 Web Service, in the "bin" directory
 - a set of processing modules providing the following conversions:
   * daisy202-to-epub3 - Convert a DAISY 2.02 fileset to EPUB3
   * daisy3-to-epub3 - Convert a DAISY 3 fileset to EPUB 3 
   * dtbook-to-epub3 - Convert a DTBook XML document to EPUB 3
   * dtbook-to-html - Convert a DTBook XML document to XHTML5
   * dtbook-to-zedai - Convert a DTBook XML document to ZedAI XML
   * dtbook-validator - Validate a DTBook 2005-3 XML document
   * nimas-fileset-validator - Validate a NIMAS Fileset
   * zedai-to-epub3 - Convert a ZedAI document to EPUB 3
   * zedai-to-html - Convert a ZedAI document to XHTML5
 - a set of sample documents to test the provided conversions, in the "samples"
   directory



3. Release Notes
-------------------------------------------------------------------------------

The package includes the 1.5 version of the project.

Changes since the last release:


* Command-line tool
  * TBD
* Web API
  * TBD
* Framework
  * TBD
* Modules
  * [braille] ...
  * [braille] various bug fixes and improvements. See also
    http://code.google.com/p/daisy-pipeline/wiki/BraillePrototypeFeatureSet
* Web UI
  * Various UI tweaks. See also:
    http://code.google.com/p/daisy-pipeline/wiki/WebUIDev


The full list of changes can be found at:
 http://code.google.com/p/daisy-pipeline/w/ReleaseNotes



4. Prerequisites                   
-------------------------------------------------------------------------------

Modules already include their dependent libraries and only require a recent
Java environment (Java SE 6 or later).

To get the latest version of Java, go to http://www.java.com/

The "bin" directory of the Java Runtime Environment installation must be on the
system PATH. Refer to the documentation for more details on how to configure
this on your operating system.

On Mac and Linux, the command line tool requires a Ruby runtime environment
(version 1.8 or above). A Ruby runtime is already bundled in the executable on
Windows.


5. Getting Started
-------------------------------------------------------------------------------

### Command line tool ###

 1. get the short help by running the launcher script 'dp2' on
 Mac/Linux or 'dp2.exe' on Windows from the "cli" directory
 2. run 'dp2 help a-script-name' to get the detailed description of a script
 4. execute a job with the 'dp2 a-script-name' subcommand and specify the
 required options (as given with the 'dp2 help a-script-name' command)

For instance:

	> cli\dp2.exe dtbook-to-zedai --i-source samples\dtbook\hauy_valid.xml
	--x-output-dir "C:\Users\John Doe\Desktop\out"


will run the DTBook to ZedAI converter on Windows and will output the result in
the "out" directory on the desktop of the user named "John Doe".


### RESTful Web Service ###

 1. start the web service by running 'bin/pipeline' on Mac/Linux or
 'bin/pipeline.bat' on Windows
 2. the web service is available on http://localhost:8181/ws/
 3. For example, get the list of scripts by issuing a GET request on
 http://localhost:8181/ws/scripts




6. Documentation
-------------------------------------------------------------------------------

	Usage: dp2 command [options]
	
	Script commands:
	
	dtbook-to-zedai			Transforms DTBook XML into ZedAI XML.
	zedai-to-epub3			Transforms a ZedAI (DAISY 4 XML) document into an
							EPUB 3 publication.
	daisy202-to-epub3		Transforms a DAISY 2.02 publication into an EPUB3
							publication.
	dtbook-to-epub3			Converts multiple dtbooks to epub3 format
	
	General commands:
	
	halt				Stops the WS
	delete				Deletes a job
	result				Gets the zip file containing the job results
	jobs				Shows the status for every job
	status				Shows the detailed status for a single job
	help				Shows this message or the command help 
	version				Shows version and exits
	
	To list the global options type:  	dp2 help -g
	To get help for a command type:  	dp2 help COMMAND


The Web service API is documented on the Pipeline 2 development wiki:
 http://code.google.com/p/daisy-pipeline/wiki/WebServiceAPI

A complete user guide is available on the Pipeline 2 development wiki:
 http://code.google.com/p/daisy-pipeline/wiki/UserGuideIntro



7. Known limitations
-------------------------------------------------------------------------------

Please refer to the issue tracker:
 http://code.google.com/p/daisy-pipeline/issues/list


8. Contact 
-------------------------------------------------------------------------------

If you want to join the effort and contribute to the Pipeline 2 project, feel
free to join us on the developers discussion list hosted on Google Groups:
 http://groups.google.com/group/daisy-pipeline-dev

or contact the project lead (Romain Deltour) via email at
 `rdeltour (at) gmail (dot) com`
