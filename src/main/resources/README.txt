              DAISY Pipeline 2 - 1.6 - July 19, 2013
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

The package includes the 1.6 version of the project.

Changes since the last release:


* Command-line tool
  * None 

* Web API
  * Fixed issue 254: ErrorWriter validates against wrong schema
  * Fixed issue 336: Mime-types are included in the job results

* Framework
  * Fixed issue 312: Handle folders in zip files properly
  * Fixed issue with empty 'select' attributes for output options
  * Fix: report Calabash pipeline-loading errors as job errors
  * Fix: Issues with push-notifer
  * [NEW] Closed issue 311: Accept sequenced input options  
  * [NEW] DB-less mode


* Modules
  * [NEW] Close issue 313: Added MathML support to `dtbook-to-epub3`,
    `daisy3-to-epub3` and `zedai-to-epub3`.
  * [common-utils] [NEW] Closed issue 242 / issue 265: added logging steps:
    `px:message`/`px:error`/`px:assert`
  * [daisy202-to-epub3] Fixed issue 297: compatibility-mode and mediaoverlay 
    options
  * [daisy202-to-epub3] resources referenced from CSS-files are now included
  * [daisy202-to-epub3] HTML metadata are preserved
  * [daisy202-to-epub3] landmarks now has an epub:type and is hidden
  * [daisy202-to-epub3] page listing is now hidden in navigation document
  * [daisy202-to-epub3] Fixed issue 304: URI encoding problem with spaces in
    file names
  * [daisy202-utils] normalize input href
  * [daisy3-to-epub3] Closed issue 273: DTBook validation is disabled by
    default and added a new `assert-valid` option is available.
  * [dtbook-to-zedai] [NEW] Fixed issue 329: added option 
    "copy-external-resources", true by default
  * [dtbook-to-zedai] Fixed issue 328: adding dc:type to dtbook makes it fail
  * [dtbook-to-zedai] Fixed issue 343: clean up console output of dtbook to 
    zedai
  * [dtbook-utils] Add MathML resources to DTBook fileset
  * [dtbook-validator] validator checks that input documents are well-formed
  * [epub3-nav-utils] fixed playOrder for NCX (navPoints, pageTargets and 
    navTarget)
  * [epub3-nav-utils] always use full clock values in package doc
  * [epub3-nav-utils] added default navLabel in NCX based on language 
    attribute
  * [epub3-nav-utils] relativized landmarks to package document base URI
  * [epub3-nav-utils] Fixed issue 352: Generated ToC was incomplete
  * [file-utils] new functions: `pf:is-absolute`, `pf:is-relative`,
    `pf:get-path`, 
    `pf:replace-path`, `pf:unescape-uri`
  * [file-utils] new function: `pf:file-exists` (implemented in Java)
  * [file-utils] Fixed issue 318: make `pf:normalize-uri` normalize invalid 
    characters
  * [file-utils] added URL normalization
  * [file-utils] added java-base copy-resource step and service
  * [file-utils] Fixed issue 314: removed `pf:percent-decode`
  * [file-utils] added `px:tempdir` step for creating temporary directories 
    inside a given directory
  * [file-utils] Fixed issue 354: `pf:file-exist` now returns `true` on an
    empty path
  * [fileset-utils] Fixed issue 319: `px:fileset-store` should return the 
    stored fileset
  * [fileset-utils] `px:fileset-store`: store binary files, don't omit xml 
    declaration, don't store files with @media-type='text/xml' as text
  * [fileset-utils] make p:fileset-store indent XML docs
  * [fileset-utils] `px:fileset-store`: added a 'fail-on-error' option that
    can be set to false to keep processing the fileset if an error occurs
  * [fileset-utils] `px:fileset-store`: the returned fileset contains only the 
    resources that have been stored successfully
  * [fileset-utils] `px:fileset-add-entry`: normalized input href. if the file 
    already exists in the fileset; delete the existing entry
  * [fileset-utils] `px:fileset-filter`: support for the glob characters `*`
    and `?` in the href option
  * [fileset-utils] `px:fileset-load`: normalized base URIs of in-memory 
    documents
  * [html-to-epub3] Fixed issue 316: the conversion ignores missing resources
  * [html-to-epub3] Fixed issue 347: properly port Ruby content
  * [html-to-epub3] Fixed issue 348: support `data:` URIs
  * [html-utils] html-id-fixer: add IDs to headings and sections
  * [html-utils] html-to-fileset: compute the resource fileset of an XHTML 
    document
  * [html-utils] better support for SVG and MathML
  * [html-utils] Fixed issue 301: original URIs of CSS resources are 
    resolved properly
  * [html-utils] Fixed issue 310: make html5 upgrader copy through non-html  
    elements
  * [html-utils] Fixed issue 349: `px:html-load` now performs namespace
    fixup
  * [html-utils] Fixed issue 355: `px:html-load` supports non-UTF-8 encodings
  * [mediaoverlay-utils] preserve metadata when upgrading from older SMIL 
    versions
  * [mediatype-utils] improved `px:mediatype-detect` performance
  * [mediatype-utils] Added XSLT functions for mediatype detection
  * [metadata-utils] Fixed issue 328: MODS metadata generation bug fix
  * [nimas-fileset-validator] 'check-images' option set as boolean type
  * [nimas-fileset-validator] validator checks that input documents are  
    well-formed
  * [nimas-fileset-validator] Fixed issue 341: NIMAS validator schema update
  * [validation-utils] added validation-status utility. Given one or more 
    validation reports, it outputs validation status XML.
  * [validation-utils] Added utility to check for well-formed XML files
  * [zedai-to-html] Fixed issue 356: correctly convert page breaks within 
    lists
  * [zedai-to-epub3] Fixed issue 309: use the revamped HTML chunking from
    `html-utils`. Also affects `dtbook-to-epub3` and `daisy3-to-epub3`.
  * [zedai-to-pef] Added support for running headers and footers
  * [zip-utils] Fixed issue 304: file entry names in zip files are now 
    percent decoded
  * Closed issue 238: ported XSLT unit tests to XSpec

* Web UI
  * [NEW] ability to delete jobs using a button in the jobs list
  * [NEW] customizable landing page and title like through appearance settings
  * [NEW] support for custom about pages (just create about.html in the root 
    dir)
  * [NEW] "download log" button when web ui fails to start
  * Fixed issue 300: web ui file upload under windows appears to hang
  * Fixed issue 302: cancelled file uploads count negatively towards file 
    upload count
  * Fixed issue 303: web ui running daisy 202 to epub 3: temp files persist
  * Fixed issue 307: namespaced script ids not working
  * Fixed bug: first job execution message is not displayed
  * Fixed bug: sequence input ports didn't work with multiple documents
  * Filenames are no longer encoded using windows 8.3 encoding
  * Fixed maintenance form (dynamic validation and disabled button)
  * Fixed file uploads and file sizes in IE7
  * Fixed boolean widget
  * Fixed problems with createUser form
  * Closed issue 291: Multiple file selection widget looks better on small
    screens

* Java Client Library
  * [NEW] support for deleting jobs
  * [NEW] support for output ports in job requests
  * [NEW] scripts list are now sorted


The full list of changes can be found at:
 http://code.google.com/p/daisy-pipeline/w/ReleaseNotes



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
 'bin/pipeline.bat' on Windows
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
