#!/usr/bin/env make -f

DOCKER := docker
MVN := mvn
TAG := daisy/daisy-pipeline2
DEB := target/daisy-pipeline2_1.9-SNAPSHOT_all.deb
CLI_DEB := target/daisy-pipeline2-cli_1.9-SNAPSHOT_all.deb

.PHONY: image

image : Dockerfile $(DEB) $(CLI_DEB)
	tar -cz $^ | $(DOCKER) build -t $(TAG) -

$(DEB) $(CLI_DEB) :
	$(MVN) clean package -Pdeb,incl-braille
