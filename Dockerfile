# Use a imagem base oficial do ROS2 Humble
FROM osrf/ros:humble-desktop

# Atualize os pacotes e instale dependências necessárias
RUN apt-get update && apt-get install -y \
    python3-pip \
    python3-colcon-common-extensions \
    git \
    cmake \
    build-essential \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Instalar Micro XRCE-DDS
RUN git clone https://github.com/eProsima/Micro-XRCE-DDS-Client.git /root/Micro-XRCE-DDS-Client
WORKDIR /root/Micro-XRCE-DDS-Client
RUN mkdir build && cd build && cmake .. && make && make install

# Configure o ambiente do ROS2
RUN echo "source /opt/ros/humble/setup.bash" >> /root/.bashrc

# Crie o diretório de trabalho para o workspace ROS2
WORKDIR /root/ros2_ws

# Clone o repositório contendo os pacotes ROS
RUN git clone --recursive https://github.com/mrodrigues14/ROS2-T265-PX4.git /root/clone_ws

# Copie os pacotes ROS para o diretório src do workspace
RUN mkdir -p /root/ros2_ws/src && cp -r /root/clone_ws/src/* /root/ros2_ws/src/

# Construa o workspace ROS2
RUN /bin/bash -c "source /opt/ros/humble/setup.bash"

RUN cd ~/ros2_ws/src

RUN colcon build

RUN cd ~/ros2_ws

RUN source install/local_setup.bash

# Defina o comando padrão para iniciar um shell
CMD ["/bin/bash"]
