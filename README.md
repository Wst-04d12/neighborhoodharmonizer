# neighborhoodharmonizer


Uses raspberry pi 3b+ as the IoT hardware to control the relay of a neighborhoodharmonizer(i am 100% SURE that this is just a 12V LED).  
The GPIO features uses a lua library called lua periphery[https://github.com/vsergeev/lua-periphery] check the doc for more info.  
This project is port from a auto control project that coded by myself years ago, so you will see some useless or nonsense codes because this one is a ported.  
I won't make the code of this project beautiful or do any high-level optimization, because this is for use not for some skill-showing purpose.  

TODO List:  
add a remote controlling function, to turn the LED on instantly at anytime you want.  
my idea is to use a file to determine whether or not the user want to turn on the device instantly, and for the users, execute some simple command via SSH to do this by creating a file with a unique name for the main program to detect, and delete it as turning off.  
maybe there is some better solution in hardware level, like add a and-door to the circuit and control the relay simultaneously.  
