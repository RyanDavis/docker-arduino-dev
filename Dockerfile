FROM ubuntu:22.04

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    python3 \
    python3-pip \
    build-essential \
    ca-certificates \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Install Arduino CLI
RUN curl -fsSL https://raw.githubusercontent.com/arduino/arduino-cli/master/install.sh | sh
RUN mv bin/arduino-cli /usr/local/bin/
RUN chmod +x /usr/local/bin/arduino-cli

# Create workspace directory
WORKDIR /workspace

# Initialize Arduino CLI config
RUN arduino-cli config init

# Update package index
RUN arduino-cli core update-index

# Install ESP32 board support
RUN arduino-cli core install esp32:esp32

# Install common libraries for ESP32 development
RUN arduino-cli lib install "WiFi" "ArduinoJson" "PubSubClient" "Adafruit NeoPixel"

# Create directories for projects and libraries
RUN mkdir -p /workspace/projects /workspace/libraries

# Set up user permissions for device access
RUN groupadd -g 1000 arduino && \
    useradd -u 1000 -g arduino -m arduino && \
    usermod -a -G dialout arduino

# Copy configuration files
COPY arduino-cli.yaml /root/.arduino15/arduino-cli.yaml

# Create a startup script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/bash"]