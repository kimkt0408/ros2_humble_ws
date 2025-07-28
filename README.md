# ROS 2 Humble Workspace in Docker

This repository contains a ROS 2 Humble workspace (`ros2_humble_ws`) preconfigured to build and run in an isolated Docker container with GUI and volume sharing support.

---

## 📦 Requirements

- Ubuntu 20.04 or 22.04
- [Docker](https://docs.ros.org/en/humble/How-To-Guides/Setup-ROS-2-with-VSCode-and-Docker-Container.html)
- X11 support for GUI tools like `turtlesim` or `rviz2`

---

## 🔧 First-Time Docker Setup Tip

If you recently installed Docker and added your user to the `docker` group (to avoid needing `sudo`), **you must either**:

- Run this in your terminal to refresh group permissions:

  ```bash
  newgrp docker
  ```

- Or **log out and log back in**

Otherwise, you'll see a permission error like:

```
permission denied while trying to connect to the Docker daemon socket
```

---

## 🚀 1. Build the Docker Image

Run the following from the `.devcontainer/` folder inside this workspace:

```bash
cd ~/ros2_humble_ws/.devcontainer
docker build -t ros2_humble .
```

This will create a Docker image named `ros2_humble` using the `Dockerfile`.

---

## ▶️ 2. Run the Docker Container

To run the container with GUI and volume access, run the following:

```bash
cd ~/ros2_humble_ws/
./run_ros2_humble.sh
```

```bash
# ./run_ros2_humble.sh
xhost +local:docker  # Allow GUI display from Docker

docker run -it \
  --name ros2_humble_dev \
  --net=host \
  --env="DISPLAY=$DISPLAY" \
  --env="QT_X11_NO_MITSHM=1" \
  --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
  --volume="$HOME/ros2_humble_ws:/home/ros2_humble_ws" \
  ros2_humble
```

- Your workspace is accessible at `/home/ros2_humble_ws` inside the container
- Remove `--rm` to persist the container between sessions
- Open a second terminal and run the following to enter the same container again:

  ```bash
  docker exec -it ros2_humble bash
  ```

- If you want to list running containers, or stop/delete them, run the followings:

  ```bash
  docker ps # To list running containers
  docker ps -a # To list all containers (including stopped ones)
  docker stop <container_name_or_id> # To stop a running containers
  docker rm <container_name_or_id> # To delete (remove) a stopped container
  ```

---

## 🧪 3. Cloning ROS 2 Packages (on the Host)

The recommended way to add ROS 2 packages is:

### ✅ Clone into your workspace **from the host**:

```bash
cd ~/ros2_humble_ws/src
git clone https://github.com/<user>/<ros2-package>.git
```

For example:

```bash
git clone https://github.com/ros-perception/slam_toolbox.git
```

### ✅ Then build the workspace **inside the Docker container**:

```bash
cd /home/ros2_humble_ws
colcon build
source install/setup.bash
```

This way:

- You keep full control of the code from the host
- You edit and version it easily
- Docker sees the code through the mounted volume and can build it

---

## 🐢 Example: Run `turtlesim`

Inside the container:

```bash
source /opt/ros/humble/setup.bash
ros2 run turtlesim turtlesim_node
```

In another terminal (inside same container):

```bash
ros2 run turtlesim turtle_teleop_key
```

Use the arrow keys to control the turtle.

---

## 📂 Repository Structure

```
ros2_humble_ws/
├── .devcontainer/       # Dockerfile and devcontainer.json
│   └── Dockerfile
│   └── devcontainer.json
├── src/                 # Place ROS 2 packages here
│   └── <your packages>
├── .gitignore
└── README.md
```

---

## 📌 Tips

- Use `docker stop ros2_humble_dev` and `docker rm ros2_humble_dev` to stop and delete the container
- Add `source install/setup.bash` to `.bashrc` inside container if desired

---
