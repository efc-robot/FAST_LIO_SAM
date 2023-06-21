# NICS FAST LIO SAM

## 依赖
```bash
sudo apt update && sudo apt-get install ros-noetic-desktop build-essential  python3-wstool python3-catkin-tools ros-noetic-perception-pcl  -y

sudo apt install -y libpcap-dev libyaml-cpp-dev ros-noetic-navigation ros-noetic-robot-localization ros-noetic-robot-state-publisher

# fix `Could not find a package configuration file provided by "GeographicLib"`  error
sudo ln -s /usr/share/cmake/geographiclib/FindGeographicLib.cmake /usr/share/cmake-3.16/Modules/
```

## 编译运行

``` bash
mkdir -p catkin_ws/src
cd catkin_ws/src
# fast_lio_sam 库
git clone git@github.com:efc-robot/FAST_LIO_SAM.git
# [optional] forsense imu 库
git clone git@github.com:efc-robot/forsense-driver-ros.git ./drivers/forsense-driver-ros/

cd ..

source /opt/ros/noetic/setup.bash

wstool init src ./src/FAST_LIO_SAM/dependence.rosinstall

wstool merge -t src ./src/FAST_LIO_SAM/drivers.rosinstall

wstool update -t src

catkin build

```
## 使用镜像

``` bash
cd <path_to_FAST_LIO_SAM>

bash ./docker/scripts/build.sh

# start dev image
# default image name : nics/fast_lio_sam
# default container name : dev_${USER}
# default container user : ${USER}

bash ./docker/scripts/start.sh

bash ./docker/scripts/into.sh

```
