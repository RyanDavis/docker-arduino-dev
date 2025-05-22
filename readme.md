# Arduino ESP32-C3 Development Environment

A Docker-based development environment for Arduino with ESP32-C3 support using Arduino CLI.

## Features

- Arduino CLI pre-installed and configured
- ESP32 board support with ESP32-C3 specific configuration
- Common libraries pre-installed (WiFi, ArduinoJson, PubSubClient, Adafruit NeoPixel)
- Serial device access for programming and monitoring
- Persistent storage for projects and libraries
- Convenient Makefile for common operations

## Quick Start

1. **Build and start the environment:**
   ```bash
   make build
   make up
   ```

2. **Open an interactive shell:**
   ```bash
   make shell
   ```

3. **Create a new sketch:**
   ```bash
   make new-sketch
   # Enter sketch name when prompted
   ```

4. **Compile a sketch:**
   ```bash
   make compile SKETCH=./projects/your_sketch
   ```

5. **Upload to ESP32-C3:**
   ```bash
   make upload SKETCH=./projects/your_sketch PORT=/dev/ttyUSB0
   ```

## Directory Structure

```
.
├── docker-compose.yml      # Docker Compose configuration
├── Dockerfile             # Container image definition
├── arduino-cli.yaml       # Arduino CLI configuration
├── entrypoint.sh          # Container startup script
├── Makefile              # Convenient build commands
├── projects/             # Your Arduino sketches (mounted volume)
└── libraries/            # Custom libraries (mounted volume)
```

## Available Commands

### Docker Management
- `make build` - Build the Docker environment
- `make up` - Start the environment in background
- `make down` - Stop the environment
- `make shell` - Open interactive shell
- `make clean` - Clean up Docker resources

### Arduino Development
- `make compile SKETCH=path` - Compile a sketch
- `make upload SKETCH=path PORT=device` - Upload sketch to board
- `make monitor PORT=device` - Open serial monitor
- `make new-sketch` - Create new sketch interactively
- `make list-boards` - List connected boards
- `make install-lib` - Install library interactively
- `make list-examples` - List examples for a specific library
- `make copy-example` - Copy library example to projects folder
- `make list-core-examples` - List core Arduino examples
- `make copy-core-example` - Copy core Arduino example to projects folder

### Configuration Variables
- `BOARD` - Target board (default: `esp32:esp32:esp32c3`)
- `PORT` - Serial port (default: `/dev/ttyUSB0`)
- `SKETCH` - Path to sketch directory

## ESP32-C3 Specific Information

**Board FQBN:** `esp32:esp32:esp32c3`

**Common Upload Ports:**
- Linux: `/dev/ttyUSB0`, `/dev/ttyACM0`
- macOS: `/dev/cu.usbserial-*`, `/dev/cu.usbmodem*`
- Windows: `COM3`, `COM4`, etc.

## Working with Arduino Examples (Core + Library)

The environment provides access to both core Arduino examples and library-specific examples.

### Core Arduino Examples (Built-in ESP32 examples)

```bash
# List all core Arduino examples available for ESP32
make list-examples

# Copy a core example to your projects folder
make copy-example
# Examples: WiFi/WiFiScan, WebServer/HelloServer, BLE/BLE_server, etc.
```

### Library Examples (Third-party libraries like SBUS)

```bash
# List examples for a specific library
make list-lib-examples
# Enter library name when prompted (e.g., "SBUS")

# Copy a library example to your projects folder
make copy-lib-example
# Enter library name and example name when prompted
```

### Using Arduino CLI Commands (in container shell)

```bash
# List all installed libraries (including core)
arduino-cli lib list

# List examples for a specific library
arduino-cli lib examples SBUS

# Browse core examples manually
ls -la /root/.arduino15/packages/esp32/hardware/esp32/*/libraries/
```

### Common Core Examples for ESP32-C3

The ESP32 core includes many built-in examples:

- **WiFi Examples**: `WiFi/WiFiScan`, `WiFi/WiFiClient`, `WiFi/WiFiAccessPoint`
- **WebServer Examples**: `WebServer/HelloServer`, `WebServer/AdvancedWebServer`
- **BLE Examples**: `BLE/BLE_server`, `BLE/BLE_client`, `BLE/BLE_beacon`
- **Basic Examples**: `Basics/Blink`, `Basics/DigitalReadSerial`
- **Analog Examples**: `AnalogRead`, `AnalogWrite`
- **Communication**: `SPI`, `I2C/i2c_scanner`

### Manual File System Exploration

```bash
# Enter the container shell
make shell

# Find all example directories
find /root/.arduino15/packages/esp32/hardware/esp32/*/libraries -name "examples" -type d

# List specific core library examples
ls -la /root/.arduino15/packages/esp32/hardware/esp32/*/libraries/WiFi/examples/
ls -la /root/.arduino15/packages/esp32/hardware/esp32/*/libraries/WebServer/examples/
ls -la /root/.arduino15/packages/esp32/hardware/esp32/*/libraries/BLE/examples/

# View an example file
cat /root/.arduino15/packages/esp32/hardware/esp32/*/libraries/WiFi/examples/WiFiScan/WiFiScan.ino
```

### Quick Copy and Use Workflow

```bash
# Copy a WiFi scanning example (core example)
make copy-example
# Enter: WiFi/WiFiScan

# Copy a library example (e.g., SBUS)
make copy-lib-example
# Enter library: SBUS, example: basic_example

# Compile and upload
make compile SKETCH=./projects/WiFiScan
make upload SKETCH=./projects/WiFiScan PORT=/dev/ttyUSB0
make monitor PORT=/dev/ttyUSB0
```

### Library Example Locations

Libraries can be installed in different locations:
- **Core libraries**: `/root/.arduino15/packages/esp32/hardware/esp32/*/libraries/`
- **User libraries**: `/root/.arduino15/libraries/`
- **Sketch libraries**: `/workspace/libraries/`



## Manual Arduino CLI Commands

Once inside the container shell, you can use Arduino CLI directly:

```bash
# List available boards
arduino-cli board listall | grep esp32c3

# Create new sketch
arduino-cli sketch new projects/my_project

# Compile for ESP32-C3
arduino-cli compile -b esp32:esp32:esp32c3 projects/my_project

# Upload to ESP32-C3
arduino-cli upload -b esp32:esp32:esp32c3 -p /dev/ttyUSB0 projects/my_project

# Monitor serial output
arduino-cli monitor -p /dev/ttyUSB0

# Install libraries
arduino-cli lib install "WiFiManager"
arduino-cli lib search "sensor"
```

## Troubleshooting

### Device Access Issues
If you can't access your ESP32-C3 board:

1. **Check device permissions:**
   ```bash
   ls -la /dev/ttyUSB* /dev/ttyACM*
   sudo chmod 666 /dev/ttyUSB0  # Adjust device as needed
   ```

2. **Add user to dialout group:**
   ```bash
   sudo usermod -a -G dialout $USER
   ```

3. **Restart the container:**
   ```bash
   make down
   make up
   ```

### Common Upload Issues
- Ensure the board is in download mode (hold BOOT button while pressing RESET)
- Check that the correct port is specified
- Verify the USB cable supports data transfer (not just power)

### Library Issues
- Update the core index: `arduino-cli core update-index`
- Search for exact library names: `arduino-cli lib search "exact name"`

## Example Sketch

Here's a simple blink example for ESP32-C3:

```cpp
// projects/blink/blink.ino
#define LED_PIN 8  // ESP32-C3 built-in LED

void setup() {
  pinMode(LED_PIN, OUTPUT);
  Serial.begin(115200);
  Serial.println("ESP32-C3 Blink Example");
}

void loop() {
  digitalWrite(LED_PIN, HIGH);
  Serial.println("LED ON");
  delay(1000);
  
  digitalWrite(LED_PIN, LOW);
  Serial.println("LED OFF");
  delay(1000);
}
```

Compile and upload:
```bash
make compile SKETCH=./projects/blink
make upload SKETCH=./projects/blink
```