#!/bin/bash


BOLD='\033[1m'
RED='\033[0;31m'
BLUE='\033[1;34;48m'
GREEN='\033[32m'
WHITE='\033[34m'
YELLOW='\033[33m'
NO_COLOR='\033[0m'

function info() {
  (echo >&2 -e "[${WHITE}${BOLD}INFO${NO_COLOR}] $*")
}

function error() {
  (echo >&2 -e "[${RED}ERROR${NO_COLOR}] $*")
}

function warning() {
  (echo >&2 -e "${YELLOW}[WARNING] $*${NO_COLOR}")
}

function ok() {
  (echo >&2 -e "[${GREEN}${BOLD} OK ${NO_COLOR}] $*")
}

function build_docker_if_not_exist() {
    local img="$1"
    local DOCKER_SCRIPTS_DIR=$(echo $(cd "$(dirname "$0")/../";pwd))
    if docker images --format "{{.Repository}}:{{.Tag}}" | grep -q "${img}"; then
        info "Local image ${GREEN}${img}${NO_COLOR} found and will be used."
        return
    fi

    warning "Image ${img} not found locally. Trying to build from local."
    local DOCKER_SCRIPTS_DIR=$(echo $(cd "$(dirname "$0")/";pwd))
    set -x
    sudo bash ${DOCKER_SCRIPTS_DIR}/build.sh
    set +x

    if [ $? -ne 0 ]; then
        error "Failed to start docker container \"${DEV_CONTAINER}\" based on image: ${DEV_IMAGE}"
        exit 1
    fi
}

function remove_container_if_exists() {
    local container="$1"
    if docker ps -a --format '{{.Names}}' | grep -q "${container}"; then
        info "Removing existing Apollo container: ${container}"
        docker stop "${container}" >/dev/null
        docker rm -v -f "${container}" 2>/dev/null
    fi
}

function postrun_start_user() {
    local container="$1"
    if [ "${USER}" != "root" ]; then
        docker exec -u root "${container}" \
            bash -c '/catkin_ws/src/FAST_LIO_SAM/scripts/docker_start_user.sh'
    fi
}
