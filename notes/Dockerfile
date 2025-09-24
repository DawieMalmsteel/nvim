# Use an Arch Linux base image
FROM archlinux:latest

# Update and install OpenSSH
RUN pacman -Syu --noconfirm && pacman -S --noconfirm openssh

# Create a directory for SSH
RUN mkdir /var/run/sshd

# Generate SSH host keys
RUN ssh-keygen -A

# Allow root login and empty passwords
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
RUN sed -i 's/#PermitEmptyPasswords no/PermitEmptyPasswords yes/' /etc/ssh/sshd_config

# Set no password for root
RUN passwd -d root

# Expose port 22 for SSH
EXPOSE 22

# Start the SSH service
CMD ["/usr/bin/sshd", "-D"]

