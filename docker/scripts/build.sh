# !/bin/bash
CURR_DIR=$(echo $(cd "$(dirname "$0")";pwd))

REPO_DIR=$(echo $(cd "$(dirname "$0")/../../";pwd))

source "${CURR_DIR}/../../repo"

echo $REPO_DIR

docker build -f ${REPO_DIR}/docker/DockerFile -t nics/${REPO_NAME} ${REPO_DIR}

exit 0