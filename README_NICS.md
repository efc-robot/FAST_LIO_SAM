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

cd ..

source /opt/ros/noetic/setup.bash

wstool init src ./src/FAST_LIO_SAM/dependence.rosinstall

# [optional] 仅当实车部署时需要配置
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


## 实车配置

多车之间通过自组网模块连接，ip段为`192.168.10.xxx`，其中网卡ip为小于100的数字

建议车载NX的有线网络IP设置为100-199直接的任意ip，且不要冲突

两车雷达配置文件在代码库中的`config/pandarXTM_*****.yaml`，命名规则为依照安装在雷达顶端的UWB模组上标记的数字。
两车雷达IP不同，33971的雷达为`192.168.10.202`,33413的雷达为`192.168.10.201`，需要在启动前分别配置


``` bash
source <path_to_ws>/devel/setup.bash
# 启动驱动（雷达、IMU）
launch fast_lio_sam drviers.launch server_ip:=${lidar_ip} robot_id:=${robot_id}
# 启动Fast Lio Sam单机节点
launch fast_lio_sam mapping_pandar.launch robot_id:=${robot_id} config_file:=<path_to_config_file>

# 启动后端
launch mrb two_robot_velodyne16.launch

```

