#include <Servo.h>
 
Servo servo1;
Servo servo2;
float theta1;
float theta2;
int pot1 = 0;
int pot2 = 1;
 
void setup() {
// Serial.begin(9600);
servo1.attach(2,750,2200);
servo2.attach(3,750,2200);
servo1.write(90);
servo2.write(90);
}
void loop() {
theta1 = analogRead(pot1);
theta2 = analogRead(pot2);
// Serial.print(theta1); Serial.print(","); Serial.println(theta2);
theta1 = -(theta1/1023)*220+200;
theta2 = -(theta2/1023)*220+200;
if(theta1 < 0) theta1 = 0;
if(theta2 < 0) theta2 = 0;
if(theta1 > 180) theta1 = 180;
if(theta2 > 180) theta2 = 180;
drive_joints();
}
 
/* drive_joints() simply moves servos 1 and 2 */
void drive_joints() {
servo1.write(theta1);
servo2.write(theta2);
delay(30);
}
