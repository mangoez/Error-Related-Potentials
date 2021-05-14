# Importing Libraries
import serial
import time


arduino = serial.Serial(port='/dev/tty.usbmodem14201', baudrate=115200, timeout=.1)

while True:
    x = input("Enter a number: ") # Taking input from user
    if (x == '1'):
        arduino.write(b'1')
    else:
        arduino.write(b'0')
