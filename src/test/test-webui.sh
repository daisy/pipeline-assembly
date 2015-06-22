#!/bin/bash
(
    cd $(dirname "$0")
    COMPOSE=docker-compose
    export COMPOSE_PROJECT_NAME=pipeline-assembly-test-webui
    export COMPOSE_FILE=test-webui.yml
    $COMPOSE up
)
