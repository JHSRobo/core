#!/bin/bash

# Check sudo perms
if [[ "$(id -u)" != 0 ]]
  then echo "Please run as root"
  exit
fi

# Edit Ubuntu Files
rm -rf /home/jhsrobo/ROVMIND/tcu_repo_clone.sh
rm -rf /home/jhsrobo/ROVMIND/tcu_bringup.sh

# Add helpful stuff to ~/.bashrc
echo "source /opt/ros/humble/setup.bash" >> /home/jhsrobo/.bashrc
echo "source /home/jhsrobo/corews/install/setup.bash" >> /home/jhsrobo/.bashrc
echo "alias bottomside=\"ros2 launch core bottomside.yaml\"" >> /home/jhsrobo/.bashrc

# Add Network Shortcuts
echo "192.168.1.100 topside" >> /etc/hosts
echo "192.168.1.110 opside" >> /etc/hosts
echo "192.168.1.111 bottomside" >> /etc/hosts

# Install ROS
curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null
apt update
apt install ros-humble-ros-base ros-dev-tools python3-pip python-dev-is-python3 python3-rpi.gpio -y
pip install setuptools==58.2.0
rosdep init

# Call the update script
bash /home/jhsrobo/corews/scripts/rov/rov_update.bash