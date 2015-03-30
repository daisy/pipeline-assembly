FROM       ubuntu:trusty
RUN        apt-get update
RUN        apt-get install -y openjdk-7-jre
ADD        maven/target/daisy-pipeline2-cli_1.10-SNAPSHOT_all.deb /tmp/debs/daisy-pipeline2-cli_1.10-SNAPSHOT_all.deb
RUN        dpkg -i /tmp/debs/daisy-pipeline2-cli_1.10-SNAPSHOT_all.deb
ENV        PATH $PATH:/opt/daisy-pipeline2-cli
ENTRYPOINT ["dp2"]
