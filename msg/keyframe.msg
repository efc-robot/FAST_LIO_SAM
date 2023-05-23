# std_msgs/Header header
int32 index         # key frame 在某个机器人内部的 ID
string robot_name
geometry_msgs/PoseStamped pose  # key frame的位姿
geometry_msgs/TransformStamped transform  # 相较于上一帧key frame的位姿变换
sensor_msgs/PointCloud2 pc      # key frame的点云