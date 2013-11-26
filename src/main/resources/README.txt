              DAISY Pipeline 2 - 1.7 - November 15, 2013
==============================================================================


 1. What is the DAISY Pipeline 2 ?
 2. Contents of the package
 3. Release notes
 4. Prerequisites
 5. Getting started
 6. Documentation
 7. Known limitations
 8. Contact



1. What is the DAISY Pipeline 2 ?
------------------------------------------------------------------------------

The DAISY Pipeline 2 is an ongoing project to develop a next generation
framework for automated production of accessible materials for people with
print disabilities. It is the follow-up and total redesign of the original
DAISY Pipeline 1 project.

For more information see:

 - the project page: http://www.daisy.org/pipeline2
 - the development site: http://code.google.com/p/daisy-pipeline/



2. Contents of the package
------------------------------------------------------------------------------

The package includes:

 - a modular runtime framework (based on OSGi) for the Pipeline 2 modules
 - a command line interface to execute pipeline scripts, in the "cli"
   directory
 - dedicated launchers for the Pipeline 2 Web Service, in the "bin" directory
 - a set of processing modules providing the following conversions:
   * daisy202-to-epub3 - Convert a DAISY 2.02 fileset to EPUB3
   * daisy3-to-epub3 - Convert a DAISY 3 fileset to EPUB 3 
   * dtbook-to-epub3 - Convert a DTBook XML document to EPUB 3
   * dtbook-to-html - Convert a DTBook XML document to XHTML5
   * dtbook-to-zedai - Convert a DTBook XML document to ZedAI XML
   * dtbook-validator - Validate a DTBook 2005-3 XML document
   * html-to-epub3 - Convert a single HTML document to EPUB 3
   * nimas-fileset-validator - Validate a NIMAS Fileset
   * zedai-to-epub3 - Convert a ZedAI document to EPUB 3
   * zedai-to-html - Convert a ZedAI document to XHTML5
 - a set of sample documents to test the provided conversions, in the
   "samples" directory



3. Release Notes
------------------------------------------------------------------------------

The package includes the 1.7 version of the project.

Changes since the last release:


* Command-line tool
        * Now the results are always get through a zipped file with the --output option
        * Handle VALIDATION_FAIL status 
        * Fix single result handling
        * Move .lastid to the appropriate folder ( "%APP_DATA%/Daisy Pipeline 2/dp2/" in windows; "~/.daisy-pipeline/dp2" in linux and "~/Library/Application Support/DAISY Pipeline 2/dp2" in OS X

* Web API
        * /scripts/$ID : All the outputs are filtered out
        * /scripts/$ID : Order of options preserved from the script when building the xml representation.
        * alive: @mode disappears in favor of @localfs=(true|false)
        * jobs/$ID : The file size is returned along with the result files (not for the zip files).
        * jobs/$ID :  When the local fs is accessible the actual location is returned in the result xml response. This can be used to fetch the results from disk bypassing the web ui.
        * MD5 and file size added to the http headers when a file is returned.

* Framework
        * When a validation fails during the job execution the VALIDATION_FAIL status is returned. (Currently only working with validation scripts but all the scripts that validate outputs could implement this functionality in the future).
        * Update to guava version 15.0
        * Custom logger avoids creating default log file and duplicating framework logging lines.
        * The framework controls all the outputs as it used to do in remote mode and they have to be fetched through the web api

* Modules

* Web UI
      * support for running behind proxies (no absolute URLs; the absolute URL to the webui must be set in e-mail settings if you want to enable e-mail support).
      * Added support for hiding scripts from guests and public users.
      * Support for the new job result API where you can download individual files. when there's only one file in the results, the main download button downloads that file directly. Otherwise it downloads the zip.
      * support for HTML reports that are displayed inline on the job status page when the job finishes.
      * Temporary and result directories are not handled by the Web UI anymore; they are handled by the Pipeline 2 engine. No need to configure them in the UI anymore.
      * Ability to compile the webui in a continous integration environment (i.e. Jenkins)
      * Renamed project from "pipeline2-webui" to "daisy-pipeline-webui"
      * Split desktop and server into separate maven projects (desktop depends on server)
      * Packaging of the distributables are now performed by the "pipeline-assembly" project

* Java Client Library

The full list of changes can be found at:
 http://code.google.com/p/daisy-pipeline/wiki/ReleaseNotes



4. Prerequisites                   
------------------------------------------------------------------------------

Modules already include their dependent libraries and only require a recent
Java environment (Java SE 6 or later).

To get the latest version of Java, go to http://www.java.com/

The "bin" directory of the Java Runtime Environment installation must be on 
the system PATH. Refer to the documentation for more details on how to 
configure this on your operating system.

On Mac and Linux, the command line tool requires a Ruby runtime environment
(version 1.8 or above). A Ruby runtime is already bundled in the executable on
Windows.


5. Getting Started
------------------------------------------------------------------------------

### Command line tool ###

 1. get the short help by running the launcher script 'dp2' on
 Mac/Linux or 'dp2.exe' on Windows from the "cli" directory
 2. run 'dp2 help a-script-name' to get the detailed description of a script
 4. execute a job with the 'dp2 a-script-name' subcommand and specify the
 required options (as given with the 'dp2 help a-script-name' command)

For instance:

	> cli\dp2.exe dtbook-to-zedai --i-source samples\dtbook\hauy_valid.xml
	--x-output-dir "C:\Users\John Doe\Desktop\out"


will run the DTBook to ZedAI converter on Windows and will output the result 
in the "out" directory on the desktop of the user named "John Doe".


### RESTful Web Service ###

 1. start the web service by running 'bin/pipeline' on Mac/Linux or
 'bin\pipeline.bat' on Windows
 2. the web service is available on http://localhost:8181/ws/
 3. For example, get the list of scripts by issuing a GET request on
 http://localhost:8181/ws/scripts




6. Documentation
------------------------------------------------------------------------------

	Usage: dp2 command [options]
	
	
	Script commands:
	
	daisy202-to-epub3       Transforms a DAISY 2.02 publication into an EPUB3
                            publication.
	daisy3-to-epub3         Transforms a DAISY 3 publication into an EPUB 3
                            publication.
	dtbook-to-epub3         Converts multiple dtbooks to epub3 format
	dtbook-to-html          Transforms DTBook XML into HTML.
	dtbook-to-zedai         Transforms DTBook XML into ZedAI XML.
	dtbook-validator        Validates DTBook documents. Supports inclusion of
                            MathML.
	html-to-epub3           Transforms an (X)HTML document into an EPUB 3
                            publication.
	nimas-fileset-validator Validate a NIMAS Fileset. Supports inclusion of
                            MathML.
	zedai-to-epub3          Transforms a ZedAI (DAISY 4 XML) document into an
                            EPUB 3 publication.
	zedai-to-html           Transforms ZedAI XML (ANSI/NISO Z39.98-2012
                            Authoring and Interchange) into HTML.
	
	General commands:
	
	delete              Deletes a job
	halt                Stops the WS
	jobs                Shows the status for every job
	log                 Gets the job's log file
    result              Gets the zip file containing the job results
	status              Shows the detailed status for a single job
	help                Shows this message or the command help 
	version             Shows version and exits
	
	To list the global options type:    dp2 help -g
	To get help for a command type:     dp2 help COMMAND


The Web service API is documented on the Pipeline 2 development wiki:
 http://code.google.com/p/daisy-pipeline/wiki/WebServiceAPI

A complete user guide is available on the Pipeline 2 development wiki:
 http://code.google.com/p/daisy-pipeline/wiki/UserGuideIntro



7. Known limitations
------------------------------------------------------------------------------

Please refer to the issue tracker:
 http://code.google.com/p/daisy-pipeline/issues/list


8. Contact 
------------------------------------------------------------------------------

If you want to join the effort and contribute to the Pipeline 2 project, feel
free to join us on the developers discussion list hosted on Google Groups:
 http://groups.google.com/group/daisy-pipeline-dev

or contact the project lead (Romain Deltour) via email at
 `rdeltour (at) gmail (dot) com`
