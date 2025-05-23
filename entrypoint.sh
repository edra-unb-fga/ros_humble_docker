#!/bin/bash

# Ativa o ambiente ROS 2
source /opt/ros/humble/setup.bash

# Faz o build se ainda não existir o setup
if [ ! -f /root/ros2_ws/install/local_setup.bash ]; then
    echo "[INFO] colcon build ainda não foi executado. Iniciando build..."
    cd /root/ros2_ws
    colcon build
fi

# Ativa o ambiente do workspace
source /root/ros2_ws/install/local_setup.bash

# Executa o comando passado no CMD
exec "$@"
