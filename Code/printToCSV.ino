// for use with processing interface!!!
// code derived from http://www.instructables.com/id/Robotic-Arm-with-Servo-Motors/?ALLSTEPS
// code derived from http://www.instructables.com/id/Intro-and-what-youll-need/?ALLSTEPS
// derived from http://arduino.cc/en/Tutorial/Graph
// code derived from http://www.circuitsathome.com/mcu/robotic-arm-inverse-kinematics-on-arduino
//l1 67.5 mm
//l2 65.8mm

#include <Servo.h>
Servo servo1;
Servo servo2;
Servo servo3;
int theta1;  // target angles as determined through IK
int theta2;
int theta1prev; //old targets for error correction
int theta2prev;
int buf;
unsigned long time; //time is really long!
int writingposition = 140;
int idleposition = 170;

void setup() {
  Serial.begin(9600);
  servo1.attach(2,750,2200);
  servo2.attach(3,750,2200);
  servo3.attach(4,500,2400);
  servo1.write(90);
  servo2.write(80);
  servo3.write(idleposition);
  pinMode(13,OUTPUT);
}
  
void loop() {
  if(Serial.available() > 0) { //check for data
    readAngles(); //get the angles
    if(theta1 > 180 || theta1 < 0) { these two if statements check if the data is reasonable.  When using drag in processing sometimes absurd numbers get sent
      theta1 = theta1prev;
    }
    if(theta2 > 180 || theta2 < 0) {
      theta2 = theta2prev;
    }
    drive_joints();
    if(!writing()){
      startWritingNow();
    }
    theta1prev = theta1;
    theta2prev = theta2;
    time = millis();
  } else if(millis() - time > 300 && writing) { //move the pen(servo3) up when done
    stopWritingNow();
  }
}

/* drive_joints() simply moves servos 1 and 2 */
void drive_joints() {
  servo1.writeMicroseconds(theta1);
  servo2.writeMicroseconds(theta2);
}

/* readAngles() reads the doubles from the serial port
   it is inteded to take in data of the form 2.2,3.4'\n'
   where there is only one decimal place and the values
   are sperated by a comma and a newline after the tuple*/   
void readAngles() {
  byte character = Serial.read(); //read the first byte on serial
  while(character != 10) {
    if(character != ','){ //newline(10) and comma are special
      buf = buf*10;
      buf += (int)(character - '0'); //these two lines turn the string into an integer
    } else if(character == ',') {
      theta1 = buf; //after a comma the buffer has the first angle
      Serial.print(theta1);
      buf = 0;
    } else {
      //      theta2 = buf; //after a newline the buffer has the second angle
      buf = 0;
    }
    while(Serial.available() == 0) {
      delayMicroseconds(100);
    }
    character = Serial.read();
  }
  theta2 = buf;
  Serial.print(",");
  Serial.println(theta2);
  buf = 0;
}

/* startWritingNow() moves servo3 into writing position
   there is a delay to wait for the other servos to get
   into position before it makes a mark */
void startWritingNow() {
  servo3.write(writingposition);
}

/* stopWritingNow() moves servo3 off the page */
void stopWritingNow() {
  servo3.write(idleposition);
}

boolean writing() {
  if(abs(servo3.read() - writingposition) < 1) {
    return true;
  } else {
    return false;
  }
}
