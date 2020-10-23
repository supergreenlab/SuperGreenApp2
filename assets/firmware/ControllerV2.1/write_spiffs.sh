#!/bin/bash
DIR=`dirname "$0"`
DIR=`( cd "$DIR" && pwd )`
python $DIR/esptool.py --chip esp32 --port ${SERIAL_PORT} --baud 921600 write_flash -z 0x3f0000 spiffs.bin
