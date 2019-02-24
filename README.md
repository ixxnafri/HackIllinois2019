# HackIllinois2019

An IoT monitoring infrastructure was constructed for an enterprise IoT environment. Our system monitors the business conditions (air quality or noise) of the infrastructure via Wireless protocols. The data of MAC addresses is collected from WiFi protocols to estimate the amount of people in a specific location.

This project was divided into several tasks:

Task 1: Setting up the Sensing Device (Sensor)
  1. Physically configure Arduino - plug in external sensors. 
  2. Setting up ESP-8266 with Arduino Uno 
  3. MAC address scanner using ESP- 8266. 
  4. Program the Arduino with the Air Quality Sensor
  
Task 2. Set up Xbee Mesh Network

  XCTU is a free multi-platform application that enables developers to interact with the DigiMesh Xbee models through a           GUI. Unique features like the graphical network view, which graphically maps the XBee network with the signal strength of each connection, and the XBee API frame builder, which intuitively helps build and interpret API frames.
  
Task 3. Setting up the Web Server on Raspberry Pi

  In this step, data received from Xbees will be sent to IOS apps bys setting up a socket server on the Raspberry Pi. When data is received on the Coordinator Xbee, all the data will be sent serially to the Raspberry Pi. In order to read the data sent from the Xbee, the python Serial library is used. In order to determine the right serial port, type "dmesg | grep tty" in order to see where the device is connected. 

  Socket server used to communicate with IOS apps can be set up using the Python Socket library. Right now, for simplicity, static IP addresses and ports are used. Improvements for dynamic addresses should be implemented in the future.

Task 4. Pulled data from Socket Server into an iOS app.
  
  Created a UI to display the air quality of each room as well as the devices available in each room. 



