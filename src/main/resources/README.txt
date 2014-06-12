              DAISY Pipeline 2 - 1.8 - June 12, 2014
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
 - the development site: https://github.com/daisy



2. Contents of the package
------------------------------------------------------------------------------

The package includes:

 - a modular runtime framework for the Pipeline 2 modules
 - a command line interface to execute pipeline scripts, in the "cli"
   directory
 - dedicated launchers for the Pipeline 2 Web Service, in the "bin" directory
 - a set of processing modules providing the following conversions:
   * daisy202-to-epub3 - Convert a DAISY 2.02 fileset to EPUB3
   * daisy3-to-epub3 - Convert a DAISY 3 fileset to EPUB 3 
   * dtbook-to-daisy3 - Convert a DTBook XML document to DAISY 3 (with TTS audio)
   * dtbook-to-epub3 - Convert a DTBook XML document to EPUB 3
   * dtbook-to-html - Convert a DTBook XML document to XHTML5
   * dtbook-to-pef - Convert a DTBook XML document to PEF Braille
   * dtbook-to-zedai - Convert a DTBook XML document to ZedAI XML
   * dtbook-validator - Validate a DTBook 2005-3 XML document
   * html-to-epub3 - Convert (an) HTML document(s) to EPUB 3
   * nimas-fileset-validator - Validate a NIMAS Fileset
   * zedai-to-epub3 - Convert a ZedAI document to EPUB 3
   * zedai-to-html - Convert a ZedAI document to XHTML5
   * zedai-to-pef - Convert a ZedAI document to PEF Braille
 - a set of sample documents to test the provided conversions, in the
   "samples" directory

3. Release Notes
------------------------------------------------------------------------------

The package includes the 1.8 version of the project.

### Changes in v1.8
        
* Framework
  * Update Calabash (XProc engine) to version 1.0.18
  * Update Saxon (XSLT/XPath engine) to version 9.5.1.5
  * Reorganize the framework's packages and projects
  * The IP address the web service binds to is now configurable
  * Catch logging statements from EclipseLink libraries
  * Add a priority-management system to the job queue
  * New utility class `BinaryFinder` to find executables in `$PATH`

* Modules
  * [NEW] dtbook-to-daisy3 script with TTS-based audio production
  * [NEW] modules for TTS-based audio production, including adapters for:
    Acapela TTS (v7), eSpeak, Microsoft Windows SAPI5, Max OS X Speech.
    Note: the SAPI5 adapter requires the pre-installation of Visual C++
    Redistributable Packages runtime components.
  * [NEW] modules for NLP-based structure detection
  * [NEW] EpubCheck adapter module (script not included in this release)
  * [braille] Property for using an externally installed liblouisutdml only
  * [braille] Remove `-brl-` prefix from Braille CSS properties
  * [braille] Add CSS properties `border`, `margin`, `padding`, `left`, `right`
  * [braille] Deprecate CSS "display: toc-item"
  * [braille] Improve `pef:compare`
  * [braille] css-core: allow functions in 'content' declarations
  * [braille] liblouis-formatter: render TOC items more accurately
  * [braille] Update to liblouis 2.5.4 and liblouis-java 1.2.0
  * [braille] Add many tests
  * [common-utils] New `px:message` step that allows to set logging levels
  * [common-utils] New `px:i18n-translate` XPath function and XProc step used 
    for localization
  * [css-utils] New XSLT utility to retrieve a list of CSS stylesheet URIs from
    a document
  * [daisy202-to-epub3] New option to set the output file name
  * [daisy202-to-epub3] The default EPUB file nameuse is now only based on the
    identifier
  * [daisy202-to-epub3] Copy more of the metadata to the resulting EPUB3
  * [daisy202-to-epub3] Improved performance
  * [daisy3-to-epub3] temporary files are no longer included in the result
    directory
  * [dtbook-to-epub3] temporary files are no longer included in the result
    directory
  * [dtbook-to-zedai] Better conversion of image descriptions in prodnotes
  * [epub3-utils] Compatibility with the latest EPUB 3.0.1 specifications
  * [epub3-utils] Allow non-linear spine items in `px:epub3-opf-create`
  * [epub3-utils] Allow non-numbered page breaks (use a hyphen in the Nav Doc)
  * [file-utils] Expand 8.3 file names during URL normalization
  * [file-utils] Add a 2-args pf:normalize-uri that discards URI fragments
  * [fileset-utils] Add support for "file:/...zip!/..." URIs
  * [fileset-utils] Added "encode-as-base64" option to `px:unzip-fileset`
  * [fileset-utils] Various fixes and improvements to `px:fileset-store`
  * [html-utils] Rewrite of the HTML to XHTML5 upgrader + tests
  * [html-utils] Simplify and improve the `html-to-fileset` implementation
  * [html-to-epub3] Better conversion of `longdesc` and `aria-describedat`
    attributes
  * [html-to-epub3] DIAGRAM descriptions are now converted to HTML embedded
    in hidden `iframe` elements
  * [mediaoverlays-utils] improved performance
  * [validation-utils] Added support for message severity and report metadata
  * [zedai-to-epub3] temporary files are no longer included in the result
    directory
  * [zip-utils] don't create d:file elements for directories when unzipping
  * [all] Integration of XSpec testing
  * [all] Update custom XPath functions to the new Saxon 9.5 API
  * [all] reorganize Maven POMs and BoMs
  * [all] and other small fixes and improvements

* Web UI
  * The Web UI now must run on the same file system as the Pipeline engine
  * better file names for downloads
  * [FIXED] incorrect content type was returned when downloading single files
  * [FIXED] Unable to set password for newly created account
  * [FIXED] Missing submit button in "add user" section of admin settings
  * [FIXED] Web UI does not allow downloading results bigger than 100 MB

* CLI (Ruby implementation)
  * Add job priority option and print it in the job status
  * Add client priority options
  * Add queue command and resource
  * Add options to move jobs up and down the execution queue

* Installation
  * Change java version check from nsis installer
  * A Debian package can now be produced from the assembly project

See also 
  * https://github.com/daisy/pipeline-tasks/issues?milestone=1&state=closed
  * https://github.com/daisy/pipeline-issues/issues?milestone=1&state=closed

4. Prerequisites                   
------------------------------------------------------------------------------

Modules already include their dependent libraries and only require a recent
Java environment (Java SE 7 or later).

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
 https://github.com/daisy/pipeline-issues/issues


8. Contact 
------------------------------------------------------------------------------

If you want to join the effort and contribute to the Pipeline 2 project, feel
free to join us on the developers discussion list hosted on Google Groups:
 http://groups.google.com/group/daisy-pipeline-dev

or contact the project lead (Romain Deltour) via email at
 `rdeltour (at) gmail (dot) com`
