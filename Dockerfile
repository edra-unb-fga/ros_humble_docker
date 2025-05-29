# Use a imagem base oficial do ROS2 Humble compatível com ARM
FROM ros:humble

# Atualize e instale dependências essenciais do ROS2 e do Picamera2/libcamera/OpenCV
RUN apt update && apt install -y --no-install-recommends \
    gnupg \
    python3-pip \
    python3-colcon-common-extensions \
    git \
    cmake \
    build-essential \
    wget \
    meson \
    ninja-build \
    pkg-config \
    libyaml-dev \
    python3-yaml \
    python3-ply \
    python3-jinja2 \
    libevent-dev \
    libdrm-dev \
    libcap-dev \
    libgl1 \
    python3-opencv \
    ros-humble-cv-bridge \
    ros-humble-py-trees-ros \
    ros-humble-sensor-msgs \
    && apt-get clean \
    && apt-get autoremove \
    && rm -rf /var/cache/apt/archives/* \
    && rm -rf /var/lib/apt/lists/*

# Instale OpenCV via pip para garantir disponibilidade no Python usado
RUN pip3 install --upgrade pip
RUN pip3 install opencv-python
RUN pip3 install numpy
RUN pip3 install py_trees

# Configure o ambiente do ROS2
RUN echo "source /opt/ros/humble/setup.bash" >> /root/.bashrc

# Instale libcamera a partir do código-fonte
WORKDIR /app
RUN git clone https://github.com/raspberrypi/libcamera.git && cd libcamera && git checkout 6ddd79b && cd ..
RUN meson setup libcamera/build libcamera/
RUN ninja -C libcamera/build/ install

# Instale kmsxx a partir do código-fonte
RUN git clone https://github.com/tomba/kmsxx.git
RUN meson setup kmsxx/build kmsxx/
RUN ninja -C kmsxx/build/ install 

# Adicione as novas instalações ao PYTHONPATH para o Picamera2 encontrar
ENV PYTHONPATH $PYTHONPATH:/usr/local/lib/aarch64-linux-gnu/python3.10/site-packages:/app/kmsxx/build/py

# Instale Picamera2 via pip
RUN pip3 install --upgrade pip
RUN pip3 install picamera2

# Crie o diretório de trabalho para o workspace ROS2
WORKDIR /root/ros2_ws
RUN mkdir -p /root/ros2_ws/src

# Construa o workspace vazio (para já deixar tudo configurado)
RUN /bin/bash -c "source /opt/ros/humble/setup.bash && cd /root/ros2_ws && colcon build && source install/setup.bash"

# Copie o script de entrada para o contêiner (se existir)
COPY entrypoint.sh /root/entrypoint.sh
RUN chmod +x /root/entrypoint.sh

# Copie o diretório de testes da câmera
# COPY camera_test /app/camera_test


# Defina o entrypoint padrão
ENTRYPOINT ["/root/entrypoint.sh"]

# Comando padrão: iniciar um shell (pode ser sobrescrito)
CMD ["/bin/bash"]