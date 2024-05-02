FROM ubuntu:22.04 AS base

# Install basic dependencies
RUN apt-get update && \
    apt-get install -y \
    xvfb \
    ca-certificates \
    fonts-liberation \
    libasound2 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libatspi2.0-0 \
    libc6 \
    libcairo2 \
    libcups2 \
    libcurl4 \
    libdbus-1-3 \
    libdrm2 \
    libexpat1 \
    libgbm1 \
    libglib2.0-0 \
    libgtk-4-1 \
    libnspr4 \
    libnss3 \
    libpango-1.0-0 \
    libu2f-udev \
    libvulkan1 \
    libx11-6 \
    libxcb1 \
    libxcomposite1 \
    libxdamage1 \
    libxext6 \
    libxfixes3 \
    libxkbcommon0 \
    libxrandr2 \
    wget \
    xdg-utils \
    openjdk-18-jre-headless \
    jq \
    curl \
    unzip \
    openssh-client \
    python3 \
    python3-pip \
    libayatana-appindicator3-dev && \
    pip install requests selenium && \
    curl --location --fail --output mlxdeb.deb "https://mlxdists.s3.eu-west-3.amazonaws.com/mlx/1.15.0/multiloginx-amd64.deb" && \
    dpkg -i mlxdeb.deb && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set display environment variable -> For Xvfb, very important. Needs to be done as root
ENV DISPLAY=:99

# Create user and set working directory -> After everything is installed, you need to create an user. Automation does not work as root. You need an user to automate your browser profiles.
WORKDIR /app
RUN useradd -m mlx-user && \
    chown -R mlx-user:mlx-user .

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh

# Set permissions for the entrypoint script
RUN chmod +x /entrypoint.sh

# Give necessary permissions to root -> This is for Xvfb
RUN mkdir /tmp/.X11-unix
RUN chown root:root /tmp/.X11-unix && \
    chmod 1777 /tmp/.X11-unix
# Switch to mlx-user
USER mlx-user

# Copy scripts
COPY ./env.py /app/mlx-app/
COPY ./main.py /app/mlx-app/
COPY ./mlx_functions.py /app/mlx-app/

# Define entrypoint
ENTRYPOINT ["/entrypoint.sh"]