# Ubuntu - Imagen base
FROM ubuntu:24.04

# Instalación de SSH, sudo y Python 3
RUN apt-get update && \
    apt-get install -y openssh-server sudo python3 && \
    rm -rf /var/lib/apt/lists/*

# Creación del usuario ansible con su contraseña
RUN useradd -m -s /bin/bash ansible && \
    echo "ansible:ansible" | chpasswd

# Para que ansible utilice sudo sin contraseña
RUN echo "ansible ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/ansible && \
    chmod 0440 /etc/sudoers.d/ansible

# Configuración del servidor SSH
RUN mkdir -p /run/sshd && \
    ssh-keygen -A && \
    echo "PasswordAuthentication yes" > /etc/ssh/sshd_config.d/ansible-lab.conf

# Puerto - SSH
EXPOSE 22

# Para mantener el servidor SSH funcionando
CMD ["/usr/sbin/sshd", "-D", "-e"]