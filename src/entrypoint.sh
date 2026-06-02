#!/bin/bash
set -e

source /opt/ros/melodic/setup.bash
source /catkin_ws/devel/setup.bash

echo "Starting CORIN system..."

# --- start system ---
roslaunch corin_demo corin_demo.launch &
LAUNCH_PID=$!

cleanup() {
    echo ""
    echo "CTRL+C received → shutting down demo..."

    # 1. kill main system
    if kill -0 $LAUNCH_PID 2>/dev/null; then
        echo "Stopping roslaunch..."
        kill -INT $LAUNCH_PID
        wait $LAUNCH_PID 2>/dev/null || true
    fi

    # 2. restart manager for reset pose
    echo "Resetting robot via manager restart..."

    roslaunch corin_manager corin_manager.launch &
    MANAGER_PID=$!

    sleep 8   # allow robot to return to stance

    echo "Stopping reset manager..."
    kill -INT $MANAGER_PID
    wait $MANAGER_PID 2>/dev/null || true

    echo "Shutdown complete."
    exit 0
}

trap cleanup SIGINT SIGTERM

echo "System ready."
echo "Trigger demo via: rosservice call /start_demo \"{}\""

wait $LAUNCH_PID