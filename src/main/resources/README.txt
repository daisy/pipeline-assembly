              DAISY Pipeline 2 - 1.6 - July XX, 2013
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

The package includes the 1.6 version of the project.

Changes since the last release:


* Command-line tool
  * TODO

* Web API
  * TODO

* Framework
  * TODO

* Modules
  * [dtbook-to-zedai] [new] fix for issue 329: added option "copy-external-resources", true by default
  * [dtbook-to-zedai] fixed issue 328: adding dc:type to dtbook makes it fail
  * [dtbook-to-zedai] fixed issue 343: clean up console output of dtbook to zedai
  * [daisy202-to-epub3] fixed issue 297: compatibility-mode and mediaoverlay options
  * [daisy202-to-epub3] resources referenced from CSS-files are now included
  * [daisy202-to-epub3] HTML metadata are preserved
  * [daisy202-to-epub3] landmarks now has an epub:type and is hidden
  * [daisy202-to-epub3] page listing is now hidden in navigation document
  * [nimas-fileset-validator] 'check-images' option set as boolean type
  * [nimas-fileset-validator] validator checks that input documents are well-formed
  * [nimas-fileset-validator] fix for issue 341: NIMAS validator schema update
  * [dtbook-validator] validator checks that input documents are well-formed
  * [html-utils] fix for issue 310: make html5 upgrader copy through non-html elements
  * [html-utils] html-id-fixer: add IDs to headings and sections
  * [html-utils] html-to-fileset: compute the resource fileset of an XHTML document
  * [html-utils] better support for SVG and MathML
  * [html-utils] fix for issue 301: original URIs of CSS resources are resolved properly
  * [daisy202-utils] normalize input href
  * [epub3-nav-utils] fixed playOrder for NCX (navPoints, pageTargets and navTarget)
  * [epub3-nav-utils] always use full clock values in package doc
  * [epub3-nav-utils] added default navLabel in NCX based on language attribute
  * [epub3-nav-utils] relativized landmarks to package document base URI
  * [mediaoverlay-utils] preserve metadata when upgrading from older SMIL versions
  * [dtbook-utils] Add MathML resources to DTBook fileset
  * [html-utils] properly port Ruby content
  * [common-utils] [new] added logging steps: px:message/px:error/px:assert
  * [file-utils] new functions: pf:is-absolute, pf:is-relative, pf:get-path, pf:replace-path, pf:unescape-uri
  * [file-utils] new function: pf:file-exists (implemented in Java)
  * [file-utils] fix for issue 318: make pf:normalize-uri normalize inivalid characters
  * [file-utils] added URL normalization
  * [file-utils] added java-base copy-resource step and service
  * [file-utils] fixed issue 314: removed pf:percent-decode
  * [file-utils] added px:tempdir step for creating temporary directories inside a given directory
  * [fileset-utils] fix for issue 319: px:fileset-store should return the stored fileset
  * [fileset-utils] px:fileset-store: store binary files, don't omit xml declaration, don't store files with @media-type='text/xml' as text
  * [fileset-utils] make p:fileset-store indent XML docs
  * [fileset-utils] px:fileset-store: added a 'fail-on-error' option that can be set to false to keep processing the fileset if an error occurs
  * [fileset-utils] px:fileset-store: the returned fileset contains only the resources that have been stored successfully
  * [fileset-utils] px:fileset-add-entry: normalized input href. if the file already exists in the fileset; delete the existing entry
  * [fileset-utils] px:fileset-filter: support for the glob characters * and ? in the href option
  * [fileset-utils] px:fileset-load: normalized base URIs of in-memory documents
  * [mediatype-utils] improved px:mediatype-detect performance
  * [mediatype-utils] Added XSLT functions for mediatype detection
  * [validation-utils] added validation-status utility. Given one or more validation reports, it outputs validation status XML.
  * [validation-utils] Added utility to check for well-formed XML files
  * [metadata-utils] fix for issue 328: MODS metadata generation bug fix
  * [zip-utils] fix for issue 304: file entry names in zip files are now percent decoded
  * [zedai-to-pef] Added support for running headers and footers

* Web UI
  * [new] ability to delete jobs using a button in the jobs list
  * [new] customizable landing page and title like through appearance settings
  * [new] support for custom about pages (just create about.html in the root dir)
  * [new] "download log" button when web ui fails to start
  * fix for issue 300: web ui file upload under windows appears to hang
  * fix for issue 302: cancelled file uploads count negatively towards file upload count
  * fix for issue 303: web ui running daisy 202 to epub 3: temp files persist
  * fix for issue 307: namespaced script ids not working
  * fixed bug: first job execution message is not displayed
  * fixed bug: sequence input ports didn't work with multiple documents
  * filenames are no longer encoded using windows 8.3 encoding
  * fixed maintenance form (dynamic validation and disabled button)
  * fixed file uploads and file sizes in IE7
  * fixed boolean widget
  * fixes problems with createUser form
  * multiple file selection widget looks better on small screens

* Java Client Library
  * [new] support for deleting jobs
  * [new] support for output ports in job requests
  * [new] scripts list are now sorted


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
