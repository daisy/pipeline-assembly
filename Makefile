#!/usr/bin/env make -f

DOCKER := docker
TAG := daisy/daisy-pipeline2
DEB := target/daisy-pipeline2_1.9-SNAPSHOT_all.deb
CLI_DEB := target/daisy-pipeline2-cli_1.9-SNAPSHOT_all.deb
SAMPLE := src/main/resources/samples/zedai/alice.xml

.PHONY: image check

image : Dockerfile $(DEB) $(CLI_DEB) $(SAMPLE)
	tar -cz $^ | $(DOCKER) build -t $(TAG) -

check :
	$(DOCKER) run -it $(TAG) /bin/bash -c "service pipeline2d start && dp2 zedai-to-pef --i-source /tmp/alice.xml --output /tmp/alice"
