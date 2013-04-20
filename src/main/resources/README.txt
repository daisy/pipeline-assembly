
              DAISY Pipeline 2 - 1.5 - April 20, 2012
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
  * Closed issue 243: Support for jobs' nice names
  * Support for retrieving jobs' log files
  * Support for indexed results ( remote mode only)
  * Closed issue 141: Add support for output ports.
  * Closed issue 235: New script option layout

* Web API
  * Closed issue 244: New configuration entry for retrieving the job creation
    XML request.
  * Closed issue 243:  Support for jobs' nice name in various job related API
    entries ( job creation and status) 
  * New way of accessing jobs' results allowing total granularity. 
  * Close issue 274: Input fileset and output fileset definition for scripts. 

* Framework
  * Massive refactoring for job related classes.
  * Close issue 97: Complete job persistence support, allowing retrieval of
    status,logs and results (the later just in remote mode) after the framework
    is relunched. 
  * Closed issue 141: Add support for output ports.
  * Close issue 274: Input fileset and output fileset definition for scripts. 
  * Various bug fixes.
  * Various design improvements.

* Modules
  * [NEW] NIMAS Fileset Validator
  * [NEW] HTML to EPUB 3
  * [braille] dropped '.xml' from PEF file extension
  * [braille] space-normalization of CSS blocks
  * [braille] splitting document into sections based on CSS property 'page'
  * [braille] indicating emphasis based on CSS property 'typeform-indication'
  * [braille] deprecated CSS property `display:toc` (only toc-item is required)
  * [braille] more metadata in PEF
  * [braille] improved PEF preview: 1. more metadata, 2. ASCII view in the same
    charset as BRF output
  * [braille] support for embedded MathmL (through liblouis -- math codes are
    Nemeth, UKMaths, Marburg & Woluwe)
  * [braille] support for hyphenation
  * [braille] hyphenation tables from OpenOffice.org are included
  * [braille] improved 'translator' option now accepts: 1. simple file name, 2.
    absolute file path (in local mode), 3. comma separated list
  * [braille] deprecated 'preprocessor' concept (out of usability considerations
    -- everything is a 'translator')
  * [braille] default.css for a very basic default formatting (+ corresponding
    reset.css)
  * [braille] updated versions of dependency libraries and tables
  * [braille] speed optimization
  * [braille] various bug fixes and improvements. See also
    http://code.google.com/p/daisy-pipeline/wiki/BraillePrototypeFeatureSet
  * [daisy202-to-epub3] Fixed issue 171: Text content doc output from Daisy 2.02
    to EPUB 3 missing headings, classes
  * [daisy202-to-epub3] Fixed issue 181: the EPUB temporary directory is now
    discarded
  * [daisy202-to-epub3] Closed issue 257: Split daisy202-to-epub3 into the
    three-step load-convert-store pattern
  * [daisy202-to-epub3] Closed issue 279: Audio+NCC books are now supported
  * [daisy3-utils] Closed issue 268: extracted load/store steps to new module
  * [daisy3-utils] Fixed issue 276: use the correct OPF media type
  * [daisy3-to-epub3] Close issue 271: no longer generates invalid
    @clipBegin/@clipEnd attributes
  * [daisy3-to-epub3] Close issue 272: links in the Navigation Documents now
    resolve
  * [dtbook-validator] support for more DTBook versions (2005-2, 2005-1, 1.1.0)
  * [dtbook-validator] support for MathML3 in DTBook files
  * [dtbook-validator] pption to check if referenced images exist on disk
  * [dtbook-validator] report format improved
  * [fileset-utils] Closed issue 275: added a `method` option to `px:fileset-load`
  * [fileset-utils] Closed issue 277, issue 278: various fileset utils fixes and
    improvements
  * [zedai-to-epub3] Fixed issue 216: metada.xml and signature.xml no longer
    contain paths to the local file system.

* Web UI
  * Fixed issue 264: Issue with filenames with spaces
  * Close issue 281: Support for downloading individual files
  * New accordion widget for the Job creation form
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
