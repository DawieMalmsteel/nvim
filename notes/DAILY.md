# Tutorial
- connect hdmi to monitor arch: https://www.youtube.com/watch?v=uw4LhcMCp4U
- install yazi: https://lindevs.com/install-yazi-on-ubuntu

# Jetson Nano Wifi Commands
- connect wifi jetbot jetson nano: sudo nmcli device wifi connect "SSID" password "PASSWORD"
- shut down jetson nano: sudo shutdown now
- reboot jetson nano: sudo reboot
- check wifi status jetson nano: nmcli device status
- check wifi networks jetson nano: nmcli device wifi list
- check ip address jetson nano: ifconfig
- check disk usage jetson nano: df -h
- check memory usage jetson nano: free -h
- check cpu usage jetson nano: top
- check gpu usage jetson nano: jtop
- check system info jetson nano: uname -a

# Jetson Nano Remote
- example link: http://<your_p_address>:8080
- get ip address jetson nano: ifconfig

# Jetbot link
- org: https://jetbot.org/

To connect to the correct port on your JetBot (Jetson Nano), follow these steps:

1. **Identify the Port**:
   - If you're connecting via USB, the Jetson Nano typically exposes a serial port. On your host machine (Linux), check available ports:
     ```bash
     ls /dev/ttyUSB*
     ```
     or
     ```bash
     ls /dev/ttyACM*
     ```

2. **Use `dmesg` to Verify**:
   - After plugging in the USB cable, run:
     ```bash
     dmesg | grep tty
     ```
     This will show which port was assigned (e.g., `/dev/ttyUSB0`).

3. **Connect via Serial Console**:
   - Use a terminal emulator like `minicom` or `screen` to connect:
     ```bash
     screen /dev/ttyUSB0 115200
     ```
     Replace `/dev/ttyUSB0` with the correct port.

4. **Check SSH Port (Default: 22)**:
   - If connecting over SSH, ensure the JetBot is on the same network. Use the IP address and default SSH port:
     ```bash
     ssh jetbot@<IP_ADDRESS>
     ```
     Replace `<IP_ADDRESS>` with the JetBot's IP.

5. **Verify Open Ports**:
   - Use `nmap` to scan the JetBot's IP for open ports:
     ```bash
     nmap <IP_ADDRESS>
     ```
     Look for ports like `22` (SSH) or others specific to your setup.
