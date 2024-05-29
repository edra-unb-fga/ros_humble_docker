#!/bin/bash

# Nome da imagem Docker
IMAGE_NAME=ros2_humble_image

# Permitir conexões locais ao servidor X para aplicativos GUI no Docker
xhost +

# Configuração para encaminhamento X11 para habilitar aplicativos GUI
XAUTH=/tmp/.docker.xauth
touch $XAUTH
xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -

# Execute o container Docker com a imagem selecionada e configurações para aplicativos GUI
docker run -it --rm \
    --name ros2_humble_container \
    --privileged \
    --network=host \
    --env="DISPLAY=$DISPLAY" \
    --env="QT_X11_NO_MITSHM=1" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    --env="XAUTHORITY=$XAUTH" \
    --volume="$XAUTH:$XAUTH" \
    --volume /dev/:/dev/ \
    --env="ROS_LOCALHOST_ONLY=0" \
    --env="ROS_DOMAIN_ID=1" \
    $IMAGE_NAME
