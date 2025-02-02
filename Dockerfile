# Use a imagem base oficial do ROS2 Humble compatível com ARM
FROM ros:humble-ros-base

# Atualize os pacotes e instale dependências necessárias
RUN apt-get update && apt-get install -y \
    python3-pip \
    python3-colcon-common-extensions \
    git \
    cmake \
    build-essential \
    wget \
    ros-humble-mavros \
    ros-humble-mavros-extras \
    ros-humble-mavros-msgs \
    && rm -rf /var/lib/apt/lists/*

# Configure o ambiente do ROS2
RUN echo "source /opt/ros/humble/setup.bash" >> /root/.bashrc

# Crie o diretório de trabalho para o workspace ROS2
WORKDIR /root/ros2_ws

# Clone o repositório contendo os pacotes ROS
RUN git clone --recursive https://github.com/edra-unb-fga/ROS2-T265-PX4-MAVROS.git /root/clone_ws

# Copie os pacotes ROS para o diretório src do workspace
RUN mkdir -p /root/ros2_ws/src && cp -r /root/clone_ws/src/* /root/ros2_ws/src/ && rm -rf /root/clone_ws

# Construa o workspace ROS2
RUN /bin/bash -c "source /opt/ros/humble/setup.bash && cd /root/ros2_ws && colcon build && source install/local_setup.bash"

# Instalar o dataset do GeographicLib (necessário para o MAVROS)
RUN /opt/ros/humble/lib/mavros/install_geographiclib_datasets.sh

# Copie o script de entrada para o contêiner
COPY entrypoint.sh /root/entrypoint.sh
RUN chmod +x /root/entrypoint.sh

# Defina o script de entrada
ENTRYPOINT ["/root/entrypoint.sh"]

# Defina o comando padrão para iniciar um shell
CMD ["/bin/bash"]

