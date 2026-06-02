# Corin_Demo_Dockerised

This repo contains a dockerised form of the basic Corin demo. It imports several submodules including:

 - the source code for Corin itself ([commit 820e671](https://github.com/EEEManchester/corin/tree/820e671926b236b740b15547e5f516bfedd0d745))
 - the DynamixelSDK ([commit c7e1eb7](https://github.com/ROBOTIS-GIT/DynamixelSDK/tree/c7e1eb71c911b87f7bdeda3c2c9e92276c2b4627)), which is used to communicate with the motors
 - a fork of the robotis-framework ([commit 6ce52ce](https://github.com/EEEManchester/robotis-framework/tree/6ce52ced9b394c9e6127da31365a1d0ea2974271)), used for communications between processes
 - a ROS driver for the robot's Variense FSE103 force sensors ([commit a5df30d](https://github.com/DanSJohnson/variense_fse103/tree/a5df30de75fbaa05a478d763b6d60937a9f9f207)).

 This demo is being maintained by [Daniel Derwent](daniel.derwent@manchester.ac.uk). Please contact me if there are any issues.

## How to Use

To run the demo, first clone this repository and its submodules:

``` bash
git clone --recurse-submodules git://github.com/DanSJohnson/Corin_Demo_Dockerised.git
```

Then navigate to the `Corin_Demo_Dockerised` directory and build the docker image (this will take some time).

``` bash
docker compose build
```

Once this is complete, you will have a Docker image called `corin_demo`.

The container can be launched from the `Corin_Demo_Dockerised` directory using

```bash
docker compose up
```

This will start the container. Then, you should open two additional terminals and in both of them enter

```bash
docker exec -it corin_demo bash
```

to open an interactive session inside the container. At this stage, you should power the robot on and ensure it is connected to the PC via the USB umbilical.

> [!CAUTION]
> Once you enter the below commands, if the robot is powered on, it will start moving!

In one terminal, activate the manager:

```bash
source devel/setup.bash
roslaunch corin_manager corin_manager.launch
```

and in the other, run the controller

```bash
source devel/setup.bash
roslaunch corin_manager corin_manager.launch
```

The demo can be stopped at any time by cancelling any of the terminal processes using `Ctrl+C`.