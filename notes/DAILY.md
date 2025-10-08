### 1. Start `roscore`
Ensure the ROS master node is running. Open a terminal and run:
```bash
roscore
```
Keep this terminal open, as `roscore` must be running for other ROS nodes to communicate.

---

### 2. Check Environment Variables
Ensure the `ROS_MASTER_URI` and `ROS_HOSTNAME` environment variables are set correctly.

Run the following commands in the terminal where you're launching RViz:
```bash
export ROS_MASTER_URI=http://localhost:11311
export ROS_HOSTNAME=localhost
```

To make these settings permanent, add them to your `~/.bashrc`:
```bash
echo "export ROS_MASTER_URI=http://localhost:11311" >> ~/.bashrc
echo "export ROS_HOSTNAME=localhost" >> ~/.bashrc
source ~/.bashrc
```

---

### 3. Verify ROS Master
Check if the ROS master is running by using:
```bash
rosnode list
```
If it shows no errors, the ROS master is running, and RViz should work.

---

### 4. If Running on a Network
If your JetBot is part of a network and you're running nodes on different machines, ensure the `ROS_MASTER_URI` points to the correct machine's IP address where `roscore` is running. For example:
```bash
export ROS_MASTER_URI=http://<master-ip>:11311
export ROS_HOSTNAME=<your-ip>
```
Replace `<master-ip>` and `<your-ip>` with the appropriate IP addresses.



roslaunch jetbot_pro lidar.launch && roslaunch jetbot_pro csi_camera.launch && python3  ros_lidar_follower.py
