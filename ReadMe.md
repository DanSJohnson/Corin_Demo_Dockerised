# Corin_Demo_Dockerised

> [!CAUTION]
> This commit is a work in progress! Use the previous commit for all demonstrations!

This repo contains a dockerised form of the basic Corin demo. It imports several submodules including:

- the source code for Corin itself ([commit 820e671](https://github.com/EEEManchester/corin/tree/820e671926b236b740b15547e5f516bfedd0d745))
- the DynamixelSDK ([commit c7e1eb7](https://github.com/ROBOTIS-GIT/DynamixelSDK/tree/c7e1eb71c911b87f7bdeda3c2c9e92276c2b4627)), which is used to communicate with the motors
- a fork of the robotis-framework ([commit 6ce52ce](https://github.com/EEEManchester/robotis-framework/tree/6ce52ced9b394c9e6127da31365a1d0ea2974271)), used for communications between processes
- a ROS driver for the robot's Variense FSE103 force sensors ([commit a5df30d](https://github.com/DanSJohnson/variense_fse103/tree/a5df30de75fbaa05a478d763b6d60937a9f9f207)).

 This demo is being maintained by [Daniel Derwent](mailto:daniel.derwent@manchester.ac.uk). Please contact me if there are any issues.

## How to Use

To run the demo, first clone this repository and its submodules:

``` bash
git clone --recurse-submodules git@github.com:DanSJohnson/Corin_Demo_Dockerised.git
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

> [!NOTE]
> At this point you may encounter Problems 1 or 2, see below.

In the other terminal, run the controller:

```bash
source devel/setup.bash
roslaunch corin_manager corin_manager.launch
```

The demo can be stopped at any time by cancelling any of the terminal processes using `Ctrl+C`.

## Possible problems on launch

The following is a list of common problems on launch and some resolutions. If you are encountering problems that are not in this list, please contact [Daniel](mailto:daniel.derwent@manchester.ac.uk) or open an issue.

### Problem 1: Error opening serial port

When you execute `roslaunch corin_manager corin_manager.launch` you may encounter the terminal message:

```bash
PORT [/dev/ttyUSB0] SETUP ERROR! (baudrate: 1000000)
[corin_manager_node-2] process has died
```

or words to that effect. If you scroll up, you may also see:

```bash
...
/dev/ttyUSB0 added. (baudrate: 1000000)
[PortHandlerLinux::SetupPort] Error opening serial port!
/dev/ttyUSB0 added. (baudrate: 1000000)
[PortHandlerLinux::SetupPort] Error opening serial port!
/dev/ttyUSB0 added. (baudrate: 1000000)
[PortHandlerLinux::SetupPort] Error opening serial port!
/dev/ttyUSB0 added. (baudrate: 1000000)
[PortHandlerLinux::SetupPort] Error opening serial port!
...
```

for several lines. This happens when communications with the motors aren't being established properly, and can be caused by a number of things.

#### Solution 1: Hello, IT, have you tried turning it off and on again?

Step one should always be to kill all active processes, power down the robot, unplug the USB's, wait a moment, and try again. Take care to plug USB 1 in first, then USB 2. The OS assigns numbers to the devices based on the order in which they are connected, and plugging them in the other way round can cause the above issue because the manager cant find motors with the right IDs on the devices its checking for them.

#### Solution 2: Baudrate issues

This can also happen because the Dynamixel's are configured on the wrong baud rate. You can connect to the motors using the Dynamixel wizard on a windows device to check if thats the case.

#### Solution 3: WSL issues

If using WSL, then you may see this error because the WSL instance doesn't have permission to access your serial ports. To rectify this first open a Powershell terminal and install usbipd:

```bash
winget install dorssel.usbipd-win
```

You may need to close the shell and open a new one after the install is completed. Then, check what devices your machine has access to:

```bash
usbipd list
```

This should show you something like this:

``` bash
Connected:
BUSID  VID:PID    DEVICE                                                        STATE
...
2-6    0403:6001  USB Serial Converter                                          Not shared
2-9    0403:6001  USB Serial Converter                                          Not shared
...
```

The devices labelled `USB Serial Converter` are the serial ports. You can give WSL access to them by entering:

```bash
PS C:\windows\system32> usbipd bind --busid <BUSID>
PS C:\windows\system32> usbipd attach --wsl --busid <BUSID>
```

where `<BUSID>` is the BUSID for the device given in the table (i.e., 2-6 and 2-7 in this case). This should give your WSL instance access to the devices.

### Problem 2: JOINT [blah_blah] does NOT respond

It is also possible when launching the manager that you may see:

```bash
...
[ERROR] [1710770880.069201067]: JOINT[lf_q3_joint] does NOT respond!!
[ERROR] [1710770880.147725925]: JOINT[lm_q1_joint] does NOT respond!!
[ERROR] [1710770880.226279075]: JOINT[lm_q2_joint] does NOT respond!!
[ERROR] [1710770880.304833681]: JOINT[lm_q3_joint] does NOT respond!!
[ERROR] [1710770880.383378695]: JOINT[lr_q1_joint] does NOT respond!!
[ERROR] [1710770880.461927172]: JOINT[lr_q2_joint] does NOT respond!!
...
```

This occurs if the motors are not active, or not communicating. This can happen if you mistakenly start the manager without plugging the robot in, or without switching on the power supply. Assuming that everything _is_ plugged in, then the culprit may be lose connections in the robot. Unplugging everything, jiggling the cables, and retrying the on/off switch on the robot can help with this. The LED on each motor should flash red on startup to indicate that they are powered on. If that doesn't happen, then power isn't reaching them.
