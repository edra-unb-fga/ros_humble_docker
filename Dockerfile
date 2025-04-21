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
    && rm -rf /var/lib/apt/lists/*

# Configure o ambiente do ROS2
RUN echo "source /opt/ros/humble/setup.bash" >> /root/.bashrc

# Crie o diretório de trabalho para o workspace ROS2
WORKDIR /root/ros2_ws

# Crie o diretório src dentro do workspace
RUN mkdir -p /root/ros2_ws/src

# Construa o workspace vazio (para já deixar tudo configurado)
RUN /bin/bash -c "source /opt/ros/humble/setup.bash && cd /root/ros2_ws && colcon build && source install/local_setup.bash"

# Copie o script de entrada para o contêiner
COPY entrypoint.sh /root/entrypoint.sh
RUN chmod +x /root/entrypoint.sh

# Defina o script de entrada
ENTRYPOINT ["/root/entrypoint.sh"]

# Defina o comando padrão para iniciar um shell
CMD ["/bin/bash"]
