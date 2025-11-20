FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        openssh-server \
        ca-certificates \
        sudo \
        nano \
        vim \
        zsh \
        curl \
        git && \
    rm -rf /var/lib/apt/lists/*

# Create SSH directory
RUN mkdir -p /var/run/sshd

# Create a non-root user
ARG USERNAME=dev
ARG USER_UID=1000
ARG USER_GID=1000

RUN groupadd --gid $USER_GID $USERNAME && \
    useradd --uid $USER_UID --gid $USER_GID -m $USERNAME && \
    echo "$USERNAME:$USERNAME" | chpasswd && \
    usermod -aG sudo $USERNAME && \
    chsh -s /usr/bin/zsh $USERNAME && \
    # Use 'zsh' as default shell
    echo 'export ZSH="/home/'$USERNAME'/.oh-my-zsh"' >> /home/$USERNAME/.zshrc && \
    echo 'export PATH="$HOME/bin:$HOME/.local/bin:$PATH"' >> /home/$USERNAME/.zshrc && \
    chown $USER_UID:$USER_GID /home/$USERNAME/.zshrc

# SSH configuration
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/#Port 22/Port 22/' /etc/ssh/sshd_config && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config

# Set working directory
WORKDIR /workspace

# Expose SSH port
EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
