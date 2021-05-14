import socket
import pygame

UDP_IP = "127.0.0.1"
UDP_PORT = 1234
MESSAGE = b"1"

print("UDP target IP: %s" % UDP_IP)
print("UDP target port: %s" % UDP_PORT)
print("message: %s" % MESSAGE)

sock = socket.socket(socket.AF_INET, # Internet
                     socket.SOCK_DGRAM) # UDP

while True:
    # for i in range(100):
    sock.sendto(MESSAGE, (UDP_IP, UDP_PORT))
    pygame.time.delay(100) # Wait for a bit
