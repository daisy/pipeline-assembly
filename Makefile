ifneq ($(firstword $(sort $(MAKE_VERSION) 3.82)), 3.82)
$(error "GNU Make 3.82 is required to run this script")
endif

ifeq ($(OS),Windows_NT)
RUBY := ruby.exe
else
RUBY := ruby
endif

SHELL := $(RUBY)
.SHELLFLAGS := -e

ifneq ($(shell puts "x"), x)
$(error "Ruby is required to run this script")
endif

ifeq ($(shell                               \
    begin;                                  \
        gem 'os';                           \
        gem 'nokogiri';                     \
        gem 'rubyzip';                      \
    rescue LoadError => e;                  \
        STDERR.puts e.message;              \
        puts "x";                           \
    end;                                    ), x)
$(error "One or more Ruby gems are missing. Install them with `gem install os nokogiri rubyzip'")
endif

MVN ?= mvn
DOCKER := docker

.PHONY : default
ifeq ($(shell require 'os'; puts OS.windows?), true)
default : exe
else ifeq ($(shell require 'os'; puts OS.mac?), true)
default : dmg
else
default : zip-linux
endif

.PHONY : help
help :
	@STDERR.puts [                                                             \
		"make [default]:",                                                     \
		"	Builds the default package for the current platform",              \
		"make dmg:",                                                           \
		"	Builds a DMG image (Mac OS disk image)",                           \
		"make exe:",                                                           \
		"	Builds a EXE (Windows installer)",                                 \
		"make deb:",                                                           \
		"	Builds a DEB (Debian package)",                                    \
		"make rpm:",                                                           \
		"	Builds a RPM (RedHat package)",                                    \
		"make zip-linux:",                                                     \
		"	Builds a ZIP for Linux",                                           \
		"make all:",                                                           \
		"	Builds a DMG, a EXE, a DEB, a RPM and a ZIP for Linux",            \
		"make zip-mac:",                                                       \
		"	Builds a ZIP for Mac OS",                                          \
		"make zip-win:",                                                       \
		"	Builds a ZIP for Windows",                                         \
		"make zips:",                                                          \
		"	Builds a ZIP for each platform",                                   \
		"make zip-minimal:",                                                   \
		"	Builds a minimal ZIP that will complete itself upon first update"  ]
ifneq ($(shell require 'os'; puts OS.windows?), true)
	@STDERR.puts [                                                             \
		"make docker:",                                                        \
		"	Builds a Docker image",                                            \
		"make check|check-docker:",                                            \
		"	Tests the Docker image"                                            \
		"make dev-launcher:",                                                  \
		"	Builds a version that can be run directly on the current platform" ]
endif

assembly/VERSION     := $(shell require 'nokogiri'; \
                                puts Nokogiri::XML(File.new("pom.xml")).at_xpath("/*/*[local-name()='version']/text()"))
assembly/BASEDIR     := .
MVN_LOCAL_REPOSITORY ?= $(HOME)/.m2/repository

include deps.mk

.PHONY : all
all : dmg exe deb rpm zip-linux

.PHONY : zips
zips : zip-mac zip-linux zip-win

.PHONY : dmg exe deb rpm zip-linux zip-mac zip-win zip-minimal deb-cli rpm-cli

dmg         : $(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/assembly/$(assembly/VERSION)/assembly-$(assembly/VERSION).dmg
exe         : $(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/assembly/$(assembly/VERSION)/assembly-$(assembly/VERSION).exe
deb         : $(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/assembly/$(assembly/VERSION)/assembly-$(assembly/VERSION).deb
rpm         : $(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/assembly/$(assembly/VERSION)/assembly-$(assembly/VERSION)-linux.rpm
zip-linux   : $(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/assembly/$(assembly/VERSION)/assembly-$(assembly/VERSION)-linux.zip
zip-mac     : $(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/assembly/$(assembly/VERSION)/assembly-$(assembly/VERSION)-mac.zip
zip-win     : $(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/assembly/$(assembly/VERSION)/assembly-$(assembly/VERSION)-win.zip
zip-minimal : $(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/assembly/$(assembly/VERSION)/assembly-$(assembly/VERSION)-minimal.zip
deb-cli     : $(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/assembly/$(assembly/VERSION)/assembly-$(assembly/VERSION)-cli.deb
rpm-cli     : $(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/assembly/$(assembly/VERSION)/assembly-$(assembly/VERSION)-cli.rpm

.PHONY : release-descriptor
release-descriptor : target/release-descriptor/releaseDescriptor.xml
target/release-descriptor/releaseDescriptor.xml : mvn -Pgenerate-release-descriptor

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/assembly/$(assembly/VERSION)/assembly-$(assembly/VERSION).exe         : mvn -Pcopy-artifacts \
                                                                                                                       -Pgenerate-release-descriptor \
                                                                                                                       -Punpack-cli-win \
                                                                                                                       -Punpack-updater-win \
                                                                                                                       -Punpack-updater-gui-win \
                                                                                                                       -Passemble-win-dir \
                                                                                                                       -Ppackage-exe
$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/assembly/$(assembly/VERSION)/assembly-$(assembly/VERSION).deb         : mvn -Pcopy-artifacts \
                                                                                                                       -Pgenerate-release-descriptor \
                                                                                                                       -Punpack-updater-linux \
                                                                                                                       -Ppackage-deb
$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/assembly/$(assembly/VERSION)/assembly-$(assembly/VERSION)-linux.zip   : mvn -Pcopy-artifacts \
                                                                                                                       -Pgenerate-release-descriptor \
                                                                                                                       -Punpack-cli-linux \
                                                                                                                       -Punpack-updater-linux \
                                                                                                                       -Passemble-linux-zip
$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/assembly/$(assembly/VERSION)/assembly-$(assembly/VERSION)-mac.zip     : mvn -Pcopy-artifacts \
                                                                                                                       -Pgenerate-release-descriptor \
                                                                                                                       -Punpack-cli-mac \
                                                                                                                       -Punpack-updater-mac \
                                                                                                                       -Passemble-mac-zip
$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/assembly/$(assembly/VERSION)/assembly-$(assembly/VERSION)-win.zip     : mvn -Pcopy-artifacts \
                                                                                                                       -Pgenerate-release-descriptor \
                                                                                                                       -Punpack-cli-win \
                                                                                                                       -Punpack-updater-win \
                                                                                                                       -Punpack-updater-gui-win \
                                                                                                                       -Passemble-win-zip
$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/assembly/$(assembly/VERSION)/assembly-$(assembly/VERSION)-minimal.zip : mvn -Pcopy-artifacts \
                                                                                                                       -Pgenerate-release-descriptor \
                                                                                                                       -Punpack-updater-mac \
                                                                                                                       -Punpack-updater-linux \
                                                                                                                       -Punpack-updater-win \
                                                                                                                       -Passemble-minimal-zip
$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/assembly/$(assembly/VERSION)/assembly-$(assembly/VERSION)-cli.deb     : mvn -Pcopy-artifacts \
                                                                                                                       -Pgenerate-release-descriptor \
                                                                                                                       -Punpack-cli-linux \
                                                                                                                       -Ppackage-deb-cli
ifeq ($(shell require 'os'; puts OS.mac?), true)
$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/assembly/$(assembly/VERSION)/assembly-$(assembly/VERSION).dmg         : mvn -Pcopy-artifacts \
                                                                                                                       -Pgenerate-release-descriptor \
                                                                                                                       -Punpack-cli-mac \
                                                                                                                       -Punpack-updater-mac \
                                                                                                                       -Passemble-mac-dir \
                                                                                                                       -Ppackage-mac-app
	# we run package-dmg in a subsequent mvn call to avoid execution
	# order issues when the package-mac-app and package-dmg profiles
	# are activated together
	exit(system("$(MVN) install -Ppackage-dmg"))
	exit(File.exists?("$@"))
else
$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/assembly/$(assembly/VERSION)/assembly-$(assembly/VERSION).dmg         :
	@SDTERR.puts "Can not build DMG because not running MacOS"; \
	exit(1)
endif
ifeq ($(shell puts File.file?("/etc/redhat-release")), true)
$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/assembly/$(assembly/VERSION)/assembly-$(assembly/VERSION)-linux.rpm   : mvn -Pcopy-artifacts \
                                                                                                                       -Pgenerate-release-descriptor \
                                                                                                                       -Passemble-linux-dir \
                                                                                                                       -Ppackage-rpm
	exit(File.exists?("$@"))
$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/assembly/$(assembly/VERSION)/assembly-$(assembly/VERSION)-cli.rpm     : mvn -Pcopy-artifacts \
                                                                                                                       -Pgenerate-release-descriptor \
                                                                                                                       -Punpack-cli-linux \
                                                                                                                       -Ppackage-rpm-cli
	exit(File.exists?("$@"))
else
$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/assembly/$(assembly/VERSION)/assembly-$(assembly/VERSION)-linux.rpm \
$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/assembly/$(assembly/VERSION)/assembly-$(assembly/VERSION)-cli.rpm :
	@STDERR.puts "Can not build RPM because not running RedHat/CentOS"; \
	exit(1)
endif

ifneq ($(shell require 'os'; puts OS.windows?), true)

.PHONY : docker
docker : mvn -Pwithout-gui -Pwithout-osgi \
         target/maven-jlink/classifiers/jre-linux target/assembly-$(assembly/VERSION)-linux/daisy-pipeline/bin/pipeline2
	require 'fileutils';               \
	FileUtils.mkdir_p("target/docker")
	exit(system("cp Dockerfile.without_builder target/docker/Dockerfile"))
	exit(system("cp -r target/assembly-$(assembly/VERSION)-linux/daisy-pipeline target/docker/"))
	exit(system("cp -r $(word 4,$^) target/docker/jre"))
	Dir.chdir("target/docker") { exit(system("$(DOCKER) build -t daisyorg/pipeline-assembly .")) }

src/main/jre/OpenJDK11-jdk_x64_linux_hotspot_11_28/jdk-11+28 : src/main/jre/OpenJDK11-jdk_x64_linux_hotspot_11_28.tar.gz
	require 'fileutils';                       \
	FileUtils.mkdir_p("$@");                   \
	exit(system("tar -zxvf $< -C $(dir $@)/"))

src/main/docker/OpenJDK11-jdk_x64_linux_hotspot_11_28.tar.gz :
	require 'fileutils';                                                                                                            \
	require 'open-uri';                                                                                                             \
	FileUtils.mkdir_p("$(dir $@)");                                                                                                 \
	IO.copy_stream(URI.open('https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-11%2B28/$(notdir $@)'), '$@');

.PHONY : dev-launcher
dev-launcher : target/dev-launcher/pipeline2
target/dev-launcher/pipeline2 : pom.xml
ifeq ($(shell require 'os'; puts OS.mac?), true)
target/dev-launcher/pipeline2 : target/maven-jlink/classifiers/jre target/assembly-$(assembly/VERSION)-mac/daisy-pipeline/bin/pipeline2
else
target/dev-launcher/pipeline2 : target/maven-jlink/classifiers/jre target/assembly-$(assembly/VERSION)-linux/daisy-pipeline/bin/pipeline2
endif
	require 'fileutils';                                                  \
	FileUtils.mkdir_p("$(dir $@)");                                       \
	File.write("$@", "#!/usr/bin/env bash\n");                            \
	File.write("$@", "JAVA_HOME=$(CURDIR)/$(word 1,$^) \\\n", mode: "a"); \
	File.write("$@", "$(CURDIR)/$(word 2,$^) \"\$$@\"\n", mode: "a");     \
	exit(system("chmod +x $@"))

target/maven-jlink/classifiers/jre                                     : mvn -Pbuild-jre
target/maven-jlink/classifiers/jre-linux                               : src/main/jre/OpenJDK11-jdk_x64_linux_hotspot_11_28/jdk-11+28 \
                                                                         mvn -Pbuild-jre-linux

target/assembly-$(assembly/VERSION)-mac/daisy-pipeline/bin/pipeline2   : mvn -Pcopy-artifacts \
                                                                             -Pcompile-simple-api \
                                                                             -Pgenerate-release-descriptor \
                                                                             -Punpack-cli-mac \
                                                                             -Punpack-updater-mac \
                                                                             -Passemble-mac-dir
target/assembly-$(assembly/VERSION)-linux/daisy-pipeline/bin/pipeline2 : mvn -Pcopy-artifacts \
                                                                             -Pcompile-simple-api \
                                                                             -Pgenerate-release-descriptor \
                                                                             -Punpack-cli-linux \
                                                                             -Punpack-updater-linux \
                                                                             -Passemble-linux-dir

endif

$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/assembly/$(assembly/VERSION)/assembly-$(assembly/VERSION).exe \
$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/assembly/$(assembly/VERSION)/assembly-$(assembly/VERSION).deb \
$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/assembly/$(assembly/VERSION)/assembly-$(assembly/VERSION)-linux.zip \
$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/assembly/$(assembly/VERSION)/assembly-$(assembly/VERSION)-mac.zip \
$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/assembly/$(assembly/VERSION)/assembly-$(assembly/VERSION)-win.zip \
$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/assembly/$(assembly/VERSION)/assembly-$(assembly/VERSION)-minimal.zip \
$(MVN_LOCAL_REPOSITORY)/org/daisy/pipeline/assembly/$(assembly/VERSION)/assembly-$(assembly/VERSION)-cli.deb \
target/assembly-$(assembly/VERSION)-mac/daisy-pipeline/bin/pipeline2 \
target/assembly-$(assembly/VERSION)-linux/daisy-pipeline/bin/pipeline2 :
	exit(File.exists?("$@"))

ifneq ($(shell require 'os'; puts OS.windows?), true)
.PHONY : check
check : check-docker

.PHONY : check-docker
check-docker :
	exit(system("bash", "src/test/resources/test-docker-image.sh"))
endif

.PHONY : --without-persistence
--without-persistence : -Pwithout-persistence

.PHONY : --without-osgi
--without-osgi : -Pwithout-osgi

.PHONY : --without-gui
--without-gui : -Pwithout-gui

.PHONY : --without-webservice
--without-webservice : -Pwithout-webservice

.PHONY : --without-cli
--without-cli : -Pwithout-cli

.PHONY : --without-updater
--without-updater : -Pwithout-updater

#                         process-sources      generate-resources      process-resources      prepare-package       package
#                         ---------------      ---------------         -----------------      ---------------       -------
# copy-artifacts          copy-felix-launcher
#                         copy-felix-bundles
#                         copy-felix-gogo
#                         copy-framework
#                         copy-framework-osgi
#                         copy-framework-no-osgi
#                         copy-volatile
#                         copy-persistence
#                         copy-persistence-osgi
#                         copy-persistence-no-osgi
#                         copy-webservice
#                         copy-gui
#                         copy-javafx-linux
#                         copy-javafx-mac
#                         copy-javafx-win
#                         copy-modules
#                         copy-modules-osgi
#                         copy-modules-linux
#                         copy-modules-mac
#                         copy-modules-win
# generate-release-descriptor                  generate-effective-pom
#                                              generate-release-descriptor
# build-jre                                                                                                         jlink
# build-jre-linux                                                                                                   jlink-linux
# unpack-cli-mac                               unpack-cli-mac
# unpack-cli-linux                             unpack-cli-linux
# unpack-cli-win                               unpack-cli-win
# unpack-updater-mac                           unpack-updater-mac
# unpack-updater-linux                         unpack-updater-linux
# unpack-updater-win                           unpack-updater-win
# unpack-updater-gui-win                       unpack-updater-gui-win
# assemble-mac-dir                                                                            assemble-mac-dir
# assemble-linux-dir                                                                          assemble-linux-dir
# assemble-win-dir                                                                            assemble-win-dir
# assemble-mac-zip                                                                                                  assemble-mac-zip
# assemble-linux-zip                                                                                                assemble-linux-zip
# assemble-win-zip                                                                                                  assemble-win-zip
# assemble-minimal-zip                                                                                              assemble-minimal-zip
# package-mac-app                                                                                                   javapackager
# package-dmg                                                                                 install-node
#                                                                                             install-appdmg        package-appdmg
#                                                                                             parse-version         attach-dmg
# package-exe                                                                                 copy-nsis-resources   package-exe
# package-deb                                                          filter-deb-resources                         package-deb
# package-deb-cli                                                                                                   package-deb-cli
# package-rpm                                                                                                       package-rpm
# package-rpm-cli                                                                                                   package-rpm-cli

PROFILES :=                     \
	copy-artifacts              \
	compile-simple-api          \
	generate-release-descriptor \
	build-jre                   \
	build-jre-linux             \
	assemble-linux-dir          \
	assemble-linux-zip          \
	assemble-mac-dir            \
	assemble-mac-zip            \
	assemble-win-dir            \
	assemble-win-zip            \
	assemble-minimal-zip        \
	package-deb                 \
	package-deb-cli             \
	package-mac-app             \
	package-dmg                 \
	package-exe                 \
	package-rpm                 \
	package-rpm-cli             \
	unpack-cli-linux            \
	unpack-cli-mac              \
	unpack-cli-win              \
	unpack-updater-linux        \
	unpack-updater-mac          \
	unpack-updater-win          \
	unpack-updater-gui-win      \
	without-persistence         \
	without-osgi                \
	without-gui                 \
	without-webservice          \
	without-cli                 \
	without-updater

.PHONY : mvn
mvn :
ifndef DUMP_PROFILES
	profiles = %x( $(MAKE) -qs --no-print-directory DUMP_PROFILES=true -- $(MAKECMDGOALS) ).split(/\n/).grep(/^\-P/); \
	exit($$?.exitstatus) if !$$?.exitstatus;                                                                          \
	exit(system("$(MVN) clean install #{profiles.join(' ')}"))
endif

.PHONY : $(addprefix -P,$(PROFILES))
ifdef DUMP_PROFILES
$(addprefix -P,$(PROFILES)) :
	+puts "$@"
endif

ifndef VERBOSE
.SILENT:
endif
