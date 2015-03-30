FROM  ubuntu:trusty
RUN   apt-get update
RUN   apt-get install -y openjdk-7-jre
ADD   maven/target/daisy-pipeline2_1.10-SNAPSHOT_all.deb /tmp/debs/daisy-pipeline2_1.10-SNAPSHOT_all.deb
RUN   dpkg -i /tmp/debs/daisy-pipeline2_1.10-SNAPSHOT_all.deb
CMD   service pipeline2d start && tail -f /var/log/daisy-pipeline2/daisy-pipeline.log
