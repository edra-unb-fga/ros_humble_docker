#!/bin/bash

# Configure o ambiente ROS2
source /opt/ros/humble/setup.bash
source /root/ros2_ws/install/local_setup.bash

# Execute o nó ROS2
exec "$@"
