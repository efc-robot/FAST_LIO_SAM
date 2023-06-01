#!/bin/bash

CURR_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
source "${CURR_DIR}/includes/docker_base.sh"
source "${CURR_DIR}/../../repo"

DEV_CONTAINER="dev_${USER}"
DOCKER_REPO="nics/${REPO_NAME}"
DEV_INSIDE="in-dev-docker"

build_docker_if_not_exist ${DOCKER_REPO}

info "Starting Docker container \"${DEV_CONTAINER}\" ..."

local_host="$(hostname)"
user="${USER}"
uid="$(id -u)"
group="$(id -g -n)"
gid="$(id -g)"

info "Remove existing Apollo Development container ..."
remove_container_if_exists ${DEV_CONTAINER}


function start_docker(){
    set -x
    
    docker run -it -d \
    --privileged \
    -v /etc/localtime:/etc/localtime:ro \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -e DISPLAY=$DISPLAY \
    -e USER="${user}" \
    -e DOCKER_USER="${user}" \
    -e DOCKER_USER_ID="${uid}" \
    -e DOCKER_GRP="${group}" \
    -e DOCKER_GRP_ID="${gid}" \
    -e DOCKER_IMG="${DEV_IMAGE}" \
    --net=host \
    -v ${CURR_DIR}/../../:/catkin_ws/src/FAST_LIO_SAM \
    --name ${DEV_CONTAINER} \
    ${DOCKER_REPO} \
    /bin/bash
    
    set +x
    
    if [ $? -ne 0 ]; then
        error "Failed to start docker container \"${DEV_CONTAINER}\" based on image: ${DEV_IMAGE}"
        exit 1
    fi
    
    postrun_start_user "${DEV_CONTAINER}"
    
    ok "Congratulations! You have successfully finished setting up ${DOCKER_REPO} Environment."
    ok "To login into the newly created ${DEV_CONTAINER} container, please run the following command:"
    ok "  bash docker/scripts/dev_into.sh"
    ok "Enjoy!"
}

start_docker


