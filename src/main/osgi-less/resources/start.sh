#!/bin/bash

CURDIR=$(cd $(dirname "$0") && pwd)

home=( $CURDIR/../pipeline2-${project.version}_{mac,linux,windows}/daisy-pipeline/ )

export DP2_HOME="${home[0]}"
export DP2_DATA=$CURDIR/data

java  -Dorg.daisy.pipeline.ws.authentication=false \
      -Dorg.daisy.pipeline.ws.localfs=true \
      -Dorg.daisy.pipeline.home="$DP2_HOME" \
      -Dorg.daisy.pipeline.data="$DP2_DATA" \
      -jar $CURDIR/assembly-${project.version}.jar
