#!/bin/bash

# Function to display Arduino CLI information
show_info() {
    echo "=========================================="
    echo "Arduino CLI Development Environment"
    echo "=========================================="
    echo "Arduino CLI version: $(arduino-cli version)"
    echo ""
    echo "Available boards (ESP32):"
    arduino-cli board listall | grep -i esp32c3
    echo ""
    echo "Workspace structure:"
    echo "  /workspace/projects - Your Arduino sketches"
    echo "  /workspace/libraries - Custom libraries"
    echo ""
    echo "Common commands:"
    echo "  arduino-cli core list                    # List installed cores"
    echo "  arduino-cli lib list                     # List installed libraries"
    echo "  arduino-cli lib examples <library>       # List library examples"
    echo "  arduino-cli sketch new <name>            # Create new sketch"
    echo "  arduino-cli compile -b esp32:esp32:esp32c3 <sketch>"
    echo "  arduino-cli upload -b esp32:esp32:esp32c3 -p /dev/ttyUSB0 <sketch>"
    echo ""
    echo "ESP32-C3 specific FQBN: esp32:esp32:esp32c3"
    echo "=========================================="
}

# Update core index on startup
echo "Updating Arduino core index..."
arduino-cli core update-index

# Show information
show_info

# Execute the command passed to the container
exec "$@"