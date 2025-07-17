#!/bin/bash

xhost +local:docker

docker run -it \
  --name ros2_humble \
  --net=host \
  --env="DISPLAY=$DISPLAY" \
  --env="QT_X11_NO_MITSHM=1" \
  --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
  --volume="$HOME/ros2_humble_ws:/home/ros2_humble_ws" \
  ros2_humble