# add url to /root/.arduino_15/arduino-cli.yaml

# update configs
arduino-cli core update-configs

# install board
arduino-cli core search | grep nrf
arduino-cli core install adafruit:nrf52 
