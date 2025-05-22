# Arduino ESP32-C3 Development Makefile

# Default values
BOARD ?= esp32:esp32:esp32c3
PORT ?= /dev/ttyUSB0
SKETCH ?= ./projects/blink

# Docker compose commands
.PHONY: build up down shell clean compile upload monitor

build:
	@echo "Building Arduino development environment..."
	docker compose build

up:
	@echo "Starting Arduino development environment..."
	docker compose up -d

down:
	@echo "Stopping Arduino development environment..."
	docker compose down

shell:
	@echo "Opening shell in Arduino development environment..."
	docker compose exec arduino-cli /bin/bash

clean:
	@echo "Cleaning up Docker resources..."
	docker compose down -v
	docker system prune -f

# Arduino specific commands
compile:
	@echo "Compiling sketch: $(SKETCH)"
	docker compose exec -T arduino-cli arduino-cli compile -b $(BOARD) $(SKETCH)

upload:
	@echo "Uploading sketch: $(SKETCH) to $(PORT)"
	docker compose exec -T arduino-cli arduino-cli upload -b $(BOARD) -p $(PORT) $(SKETCH)

monitor:
	@echo "Opening serial monitor on $(PORT)"
	docker compose exec arduino-cli arduino-cli monitor -p $(PORT)

# Create a new sketch
new-sketch:
	@read -p "Enter sketch name: " name; \
	docker compose exec arduino-cli arduino-cli sketch new projects/$$name

# List connected boards
list-boards:
	@echo "Listing connected boards..."
	docker compose exec arduino-cli arduino-cli board list

# Install library
install-lib:
	@read -p "Enter library name: " lib; \
	docker compose exec arduino-cli arduino-cli lib install "$$lib"

# Search libraries
search-lib:
	@read -p "Enter search term: " term; \
	docker compose exec arduino-cli arduino-cli lib search "$$term"

# List core Arduino examples (default examples command)
list-examples:
	@echo "Listing core Arduino examples..."
	@docker compose exec arduino-cli /bin/bash -c "find /root/.arduino15/packages/esp32/hardware/esp32/*/libraries -name '*.ino' -path '*/examples/*' | sed 's|.*/libraries/\([^/]*\)/examples/\([^/]*\)/.*|\1/\2|' | sort -u | head -20"

# List library-specific examples
list-lib-examples:
	@read -p "Enter library name: " lib; \
	docker compose exec arduino-cli find /root/.arduino15/libraries/$$lib/examples -name "*.ino" 2>/dev/null || \
	docker compose exec arduino-cli find /root/.arduino15/packages/*/hardware/*/libraries/$$lib/examples -name "*.ino" 2>/dev/null || \
	echo "No examples found for $$lib"

# Copy core Arduino example to projects
copy-example:
	@echo "Available core examples:"
	@docker compose exec arduino-cli /bin/bash -c "find /root/.arduino15/packages/esp32/hardware/esp32/*/libraries -name '*.ino' -path '*/examples/*' | sed 's|.*/libraries/\([^/]*\)/examples/\([^/]*\)/.*|\1/\2|' | sort -u | head -20"
	@read -p "Enter library/example (e.g., WiFi/WiFiScan): " path; \
	lib=$$(echo "$$path" | cut -d'/' -f1); \
	example=$$(echo "$$path" | cut -d'/' -f2); \
	docker compose exec arduino-cli /bin/bash -c "find /root/.arduino15/packages/esp32/hardware/esp32/*/libraries/$$lib/examples/$$example -name '*.ino' -type f | head -1 | xargs dirname | xargs -I {} cp -r {} /workspace/projects/$$example"

# Copy library example to projects
copy-lib-example:
	@read -p "Enter library name: " lib; \
	read -p "Enter example name: " example; \
	docker compose exec arduino-cli /bin/bash -c "find /root/.arduino15/libraries/$$lib/examples/$$example -type d | head -1 | xargs -I {} cp -r {} /workspace/projects/$$example" || \
	docker compose exec arduino-cli /bin/bash -c "find /root/.arduino15/packages/*/hardware/*/libraries/$$lib/examples/$$example -type d | head -1 | xargs -I {} cp -r {} /workspace/projects/$$example"

help:
	@echo "Available commands:"
	@echo "  build             - Build the Docker environment"
	@echo "  up                - Start the environment"
	@echo "  down              - Stop the environment"
	@echo "  shell             - Open interactive shell"
	@echo "  clean             - Clean up Docker resources"
	@echo "  compile           - Compile sketch (SKETCH=path)"
	@echo "  upload            - Upload sketch (SKETCH=path PORT=device)"
	@echo "  monitor           - Open serial monitor (PORT=device)"
	@echo "  new-sketch        - Create new sketch"
	@echo "  list-boards       - List connected boards"
	@echo "  install-lib       - Install library"
	@echo "  search-lib        - Search for libraries"
	@echo "  list-examples     - List core Arduino examples"
	@echo "  list-lib-examples - List examples for a specific library"
	@echo "  copy-example      - Copy core Arduino example to projects"
	@echo "  copy-lib-example  - Copy library example to projects"
	@echo ""
	@echo "Variables:"
	@echo "  BOARD=$(BOARD)"
	@echo "  PORT=$(PORT)"
	@echo "  SKETCH=$(SKETCH)"