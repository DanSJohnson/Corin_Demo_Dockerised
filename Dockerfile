# Start from the image containing the right Ubuntu and ROS distributions
FROM ros:melodic

SHELL ["/bin/bash", "-c"]

# Install dependencies
RUN apt-get update && apt-get install -y \
    python-rosdep \
    python-rosinstall \
    python-catkin-tools \
    build-essential \
    git \
    ros-melodic-robot-state-publisher \
    ros-melodic-control-msgs \
    ros-melodic-gazebo-msgs \
    ros-melodic-xacro \
    ros-melodic-angles \
    ros-melodic-gazebo-plugins \
    ros-melodic-gazebo-ros-control \
    libyaml-cpp-dev \
    && rm -rf /var/lib/apt/lists/*

# Copy the source files in Corin_Demo_Dockerised/src into the container
WORKDIR /catkin_ws
COPY src src

# Run catkin make
RUN source /opt/ros/melodic/setup.bash && \
    catkin_make

# Source the environment
RUN source devel/setup.bash

# Now add python packages
RUN apt-get update && apt-get install -y \
    python-scipy \
    python-numpy \
    python-matplotlib \
    python-networkx

# Define the command, in this case just open a terminal.
CMD ["bash"]