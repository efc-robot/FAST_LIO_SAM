#!/usr/bin/env bash
CURR_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
source "${CURR_DIR}/../../repo"

DOCKER_USER="${USER}"
DEV_CONTAINER="dev_${USER}"

xhost +local:root 1>/dev/null 2>&1

docker exec \
    -u "${DOCKER_USER}" \
    -e HISTFILE=/apollo/.dev_bash_hist \
    -it "${DEV_CONTAINER}" \
    /bin/bash

xhost -local:root 1>/dev/null 2>&1