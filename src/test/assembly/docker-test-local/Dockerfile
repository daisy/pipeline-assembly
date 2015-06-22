FROM   daisy/daisy-pipeline2:1.10-SNAPSHOT
ADD   maven/target/daisy-pipeline2-cli_1.10-SNAPSHOT_all.deb /tmp/debs/daisy-pipeline2-cli_1.10-SNAPSHOT_all.deb
RUN   dpkg -i /tmp/debs/daisy-pipeline2-cli_1.10-SNAPSHOT_all.deb
ENV    PATH $PATH:/opt/daisy-pipeline2-cli
