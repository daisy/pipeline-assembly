FROM   ubuntu:trusty
RUN    apt-get update
RUN    apt-get install -y openjdk-7-jre
ADD    target/daisy-pipeline2_1.9-SNAPSHOT_all.deb /tmp/debs/daisy-pipeline2_1.9-SNAPSHOT_all.deb
ADD    target/daisy-pipeline2-cli_1.9-SNAPSHOT_all.deb /tmp/debs/daisy-pipeline2-cli_1.9-SNAPSHOT_all.deb
RUN    dpkg -i /tmp/debs/*.deb
ADD    src/main/resources/samples/zedai/alice.xml /tmp/alice.xml
ENV    PATH $PATH:/opt/daisy-pipeline2-cli