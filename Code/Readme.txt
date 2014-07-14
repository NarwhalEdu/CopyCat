CopyCat:
Arduino
Basic "copycat" arm functionality, using two potentiometers as inputs to control two servomotors.

basicsIK: 
Arduino
Basic inverse kinematics code, including examples of how to program a circle and a line.

paint:
Processing
A graphical user interface for drawing and sending commands over serial to a plugged-in Arduino running serialdraw.

serialdraw:
Arduino
Code to accept x,y commands from Processing and turn them into theta values so that the robot arm may draw them.

Inverse Kinematics explanation:
See trig.png, as well as
http://www.instructables.com/id/Robotic-Arm-with-Servo-Motors/step5/Plug-it-in-and-Write-some-code/
as well as
http://www.eng.utah.edu/~cs5310/chapters.html (uh oh! July 2014: Files now locked by password and not accessible)
Also.
"if this elbowup/down stuff is coming out of nowhere -- basically there are two combinations of theta 1 and theta 2 that will work for any given x,y coordinate and you just pick whether you want the elbow up or down solution)"
The code in basicIK.ino should be understandable after reading these resources.

For mapping the working envelope of the arm, please see the python file workingenv.py --> see workingenvelope.png for what the output should look like (generated using ipython).




