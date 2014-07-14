import processing.serial.*; //This allows us to use serial objects
 
Serial port; // Create object from Serial class
Coordinate point = new Coordinate();
int width = 600;
int height = 600;

void setup() {
  size(width, height);
  noSmooth();
  fill(126);
  background(102);
  //  println(Serial.list()); //This shows the various serial port option0
  String portName = Serial.list()[0]; //The serial port should match the one the Arduino is hooked to
  port = new Serial(this, portName, 9600); //Establish the connection rate
}

void draw() {}

/* mousePressed() keeps track of mouse clicks
   and sends the coordinates over serial */
void mousePressed() {
  stroke(255);
  ellipse(mouseX,mouseY,5,5);
  if(inbounds(mouseX, mouseY)) {
      point.mapCoordinates(mouseX, mouseY, width, height); //get adjusted coordinates
      point.getAngles(point.x, point.y); //change coordinates to angles
      point.angles2String(point.theta1, point.theta2); //prepare angles for serail
      port.write(point.serialLine); //send the angles over serial
      print(point.serialLine);
  }
}

/* mouseDragged() keeps track of the mouse
   coordinates while being dragged and sends
   them over serial*/
void mouseDragged() {
  stroke(255);
  ellipse(mouseX,mouseY,5,5);
  if(inbounds(mouseX, mouseY)) {
      point.mapCoordinates(mouseX, mouseY, width, height); //get adjusted coordinates
      point.getAngles(point.x, point.y); //change coordinates to angles
      point.angles2String(point.theta1, point.theta2); //prepare them for serial
      port.write(point.serialLine); //send them over serial
      print(point.serialLine);
  }
}

void keyPressed() {
    if(key == 'r') {
        background(102);
    }
}

/* inbounds() checks to see if the mouse position
   is actually on the drawing window */
boolean inbounds(int x, int y) {
    if(x > 0 && y > 0 && x < width && y < height){
        return true;
    } else {
        return false;
    }
}
