#!/usr/bin/python
import serial
from serial import Serial
from time import sleep

ser = serial.Serial("/dev/ttyUSB1", baudrate=9600)


#while True:
#    data = ser.read(5)
#    print(data)



import socket

mysocket = socket.socket()
host = socket.gethostbyname(socket.getfqdn())
port = 8765

if host == "127.0.1.1":
    import commands
    host = commands.getoutput("hostname -I")
print "host = " + host

#Prevent socket.error: [Errno 98] Address already in use
mysocket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)

mysocket.bind((host, port))

mysocket.listen(5)

c, addr = mysocket.accept()

while True:

  #  data = c.recv(1024)
 #   data = data.replace("\r\n", '') #remove new line character
    #data = ser.read(1)
	data = ""
	data2 = ""
	while(data != ">" ):
		data2 = data2  + data 
		data = ser.read(1)
	
	inputStr = "Received :" + addr[0]
	print inputStr    
	if(data2[1] == 'b'):	
		print data2
    		c.send( data2 + "\n")

	sleep(1) 

    #if data == "Quit": break

	c.send("Server stopped\n")
	print "Server stopped"
#c.close()




#while True:
#    data = ser.read(5)
#    print(data)
