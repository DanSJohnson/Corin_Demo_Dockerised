#!/usr/bin/env python

import rospy
from std_msgs.msg import Bool

if __name__ == "__main__":
    rospy.init_node("demo_gateway")

    pub = rospy.Publisher("/demo_start", Bool, queue_size=1, latch=True)

    rospy.sleep(2)

    input("Demo ready. Press ENTER to start...")

    print("ENTER RECEIVED")

    pub.publish(Bool(data=True))

    print("MESSAGE PUBLISHED")

    rospy.loginfo("Start signal sent")

    rospy.spin()