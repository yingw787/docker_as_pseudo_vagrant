#!/usr/bin/env bash
#
# Shell script for building and configuring the complete environment for
# `dummy`.
#
# Assumptions:
#   - `docker` is installed and available as $(which docker)
#   - `git` is installed and available as $(which git)

DOCKER=$(which docker)
GIT=$(which git)

GIT_REPO_ROOT=$(git rev-parse --show-toplevel)
DOCKER_IMAGE_NAME='dummy:latest'
DOCKER_CONTAINER_NAME='dummy'

$DOCKER build $GIT_REPO_ROOT/conf \
    --tag $DOCKER_IMAGE_NAME

CONTAINER_EXISTS=$($DOCKER ps -a --format '{{ .Names }}' --filter name=$DOCKER_CONTAINER_NAME)
if [ -n "$CONTAINER_EXISTS" ];
then
    $DOCKER stop $DOCKER_CONTAINER_NAME && $DOCKER rm $DOCKER_CONTAINER_NAME
fi

$DOCKER run \
    --name $DOCKER_CONTAINER_NAME \
    --network=host \
    --volume=$(pwd):/app \
    --volume=$GIT_REPO_ROOT/src:/root \
    -itd $DOCKER_IMAGE_NAME
