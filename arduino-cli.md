# Notes

the esp32c3 uses USBCDC, and Serial debug may not work by default.  Check board details with:

```bash
arduino-cli board details -b esp32:esp32:esp32c3
```

From here you see that CDCOnBoot defaults to disabled.  To enable compile with the board option set to cdc

```bash
arduino-cli compile -b esp32:esp32:esp32c3:CDCOnBoot=cdc .
arduino-cli upload -b esp32:esp32:esp32c3:CDCOnBoot=cdc -p /dev/ttyACM0 .
arduino-cli monitor -b esp32:esp32:esp32c3 -p /dev/ttyACM0
```
