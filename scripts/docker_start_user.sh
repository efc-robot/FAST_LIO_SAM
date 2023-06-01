#!/bin/bash

function _create_user_account() {
    local user_name="$1"
    local uid="$2"
    local group_name="$3"
    local gid="$4"
    addgroup --gid "${gid}" "${group_name}"
    
    # useradd --create-home --no-log-init --shell /bin/bash ${user_name} \
    #   && echo "${user_name}:${user_name}" | chpasswd
    adduser --disabled-password --force-badname --gecos '' \
    "${user_name}" --uid "${uid}" --gid "${gid}"
    
    # adduser --disabled-password --force-badname --gecos '' \
    #   "${user_name}" --uid "${uid}" --gid "${gid}" && echo "${user_name}:${user_name}" | chpasswd
    #   # 2>/dev/null
    
    # copy init scripts manually
    # cp /etc/skel/.* $(getent passwd ${user_name} | cut -d: -f6)/
    
    usermod -aG sudo "${user_name}"
    usermod -aG video "${user_name}"
}

function setup_user_account_if_not_exist() {
    local user_name="$1"
    local uid="$2"
    local group_name="$3"
    local gid="$4"
    if grep -q "^${user_name}:" /etc/passwd; then
        echo "User ${user_name} already exist. Skip setting user account."
        return
    fi
    _create_user_account "$@"
}

##===================== Main ==============================##
function main() {
    local user_name="$1"
    local uid="$2"
    local group_name="$3"
    local gid="$4"
    # echo "$@"
    
    # echo "user_name: $user_name, uid: $uid, group_name: $group_name, gid: $gid"
    
    if [ "${uid}" != "${gid}" ]; then
        echo "Warning: uid(${uid}) != gid(${gid}) found."
    fi
    if [ "${user_name}" != "${group_name}" ]; then
        echo "Warning: user_name(${user_name}) != group_name(${group_name}) found."
    fi
    setup_user_account_if_not_exist "$@"
    
    cp /root/.bashrc /home/${user_name}/
    cp /root/.bashrc /home/${user_name}/
    
    chown -R "${user_name}" /catkin_ws/
    chown -R "${user_name}" /home/${user_name}
}

main "${DOCKER_USER}" "${DOCKER_USER_ID}" "${DOCKER_GRP}" "${DOCKER_GRP_ID}"