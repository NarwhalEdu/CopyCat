/* vectorpaint.pde will take a black and white image and find its
   edges (press 'e').  Then it will vectorize and send the edges
   to an arduino (press 'v') in the form [uS,uS\n]. To reset the
   image is 'r' and to quit is 'q'. */

import java.awt.Frame;
import java.awt.BorderLayout;
import processing.serial.*; //This allows us to use serial objects
import controlP5.*;

Serial port; // Create object from Serial class
private ControlP5 cp5;
ControlFrame cf;
PImage g_img;
PImage vectimg;
EdgeDetector edge;
CannyRGB edges;
Coordinate point = new Coordinate();
String imageFilename =
    //"/home/cappie/Dropbox/Documents/startup/processing/dotpaint/BenIsraelite.JPG";
    //"triangular-face.jpg";
    "me.jpg";
    //"circle.png";
    //"square.png";
    //"/home/cappie/Dropbox/Documents/startup/processing/forrealsquare.png";
    //"/home/cappie/Pictures/Webcam/nancy.jpg";
    //"/home/cappie/Dropbox/Documents/startup/images/ada-bw.jpg";
int width;
int height;
int stdev = 1;
boolean pastblur = false;
ArrayList<int[]> vector = new ArrayList<int[]>();

public void setup() {
    // Set up default canvas size
    g_img = loadImage(imageFilename); // Load an image
    width = g_img.width;
    height = g_img.height;
    size(width, height);
    cp5 = new ControlP5(this);
    cf = addControlFrame("extra", 200,200);
    background(200,200,200);

    String portName = Serial.list()[0]; //The serial port should match the one the Arduino is hooked to
    //port = new Serial(this, portName, 9600); //Establish the connection rate
    image(g_img,0,0,width,height);
    edge = new EdgeDetector();
    edges = new CannyRGB(g_img);
}
 
public void draw() {}
 
void keyPressed() {
    if(key == 'r') {
        resetImage();
        edges = new CannyRGB(g_img);
        pastblur = false;
    } else if(key == 'v') {
        createVector();
        send();
    } else if(key == 'b') {
        edges.changeStdev(stdev);
        g_img = edges.blur();
        image(g_img, 0, 0, width, height);
    } else if(key == 'e') {
        // g_img = edges.sobelDetection();
        // g_img.save("lol.jpg");
        g_img = edge.findEdges(g_img);
        image(g_img, 0, 0, width, height);
        pastblur = true;
    } else if(key == 'n') {
        g_img = edges.nonMax();
        image(g_img, 0, 0, width, height);
    } else if(key == 't') {
        g_img = edges.thresholding();
        image(g_img, 0, 0, width, height);
    } else if(key == 'q') { //quits and saves
        createVector();
        String[] lines = new String[vector.size()];
        
        for(int i = 0; i < vector.size(); i++) {
            point.mapCoordinates(vector.get(i)[0], vector.get(i)[1],
                                 width, height); //get adjusted coordinates
            point.getAngles(point.x,point.y);
            point.angles2String(point.theta1, point.theta2);
            lines[i] = point.serialLine;
        }
        saveStrings("lines.txt", lines);
        g_img.save("lol.png");
        exit();
    }
}

/* resetImage() brings the image back to original state */
void resetImage() {
    background(200,200,200);
    g_img = loadImage(imageFilename);
    image(g_img, 0,0, width, height);
}

/* createVector() searches an image for filled pixels
   when it finds one it follows filled pixels next to it
   clearing them as it goes.  It adnnnds the pixel locations
   [x,y] to vector and inserts a [-1,0] when there is a
   break in the vector */
void createVector() {
    vectimg = g_img;
    image(vectimg, 0, 0, vectimg.width, vectimg.height);
    // for(int y=0; y < vectimg.height; y++) { //iterate through entire picture
    //     for(int x=0; x < vectimg.width; x++) {
    for(int y=0; y < vectimg.height-1; y++) {
        for(int x=0; x < vectimg.width-1; x++) {
   // for(int y=55; y < vectimg.height-56; y++) {
    //for(int x=55; x < vectimg.width-56; x++) {
            if(vectimg.pixels[x + y*vectimg.width] <= color(0,0,0)) {//check for filled pixels
                int vectorLength = 0; //keep track of the vector length
                int walkingx = x; //these will be used to follow paths
                int walkingy = y;
                while(true) {
                    step(walkingx, walkingy); //add the point to vector
                    int[] neighbors = getNeighbors(walkingx,walkingy); //get next neighbor
                    if(neighbors != null) { //if there's a neighbor add it
                        walkingx = neighbors[0];
                        walkingy = neighbors[1];
                        vectorLength++; //increase vectorlength
                    } else { //if there isn't a neighbor the vector is done
                        if(vectorLength == 0) { //if it's just a point remove it
                            vector.remove(vector.size()-1);
                            break;
                        } else if(vectorLength < 0.05*vectimg.width
                                  && vectorLength != 0) { //remove vectors that are too short
                            for(int i = 0; i <= vectorLength; i++) {
                                vector.remove(vector.size()-1);
                            }
                            vectorLength = 0;
                        } else { //if it's not too short then insert a break
                            int[] lol = {-1,0};
                            vector.add(lol);
                            vectorLength = 0;
                        }
                        break;
                    }
                }
            }
        }
    }
}

/* send() iterates through the vector and sends each element
   over serial to the arduino.  A negative number in the zeroth
   column of vector will cause the arm to pick up its pen */
void send() {
    for(int i=0; i < vector.size(); i++) {
        int x = vector.get(i)[0];
        int y = vector.get(i)[1];
        //        print(x+","+y+",");
        if(vector.get(i)[0] < 0) { //check for negative element
            try {
                Thread.sleep(1000); //wait for the pen to pick up
            } catch (InterruptedException e) {
                print(e);
            }
        } else {
            point.mapCoordinates(x, y, width, height); //get adjusted coordinates
            point.getAngles(point.x, point.y); //change coordinates to angles
            point.angles2String(point.theta1, point.theta2); //prepare angles for serial
            //int[] lol = {int(point.theta1), int(point.theta2)};
            port.write(point.serialLine); //send the angles over serial
            print(point.serialLine);
            try {
                Thread.sleep(5);
            } catch (InterruptedException e) {
                print(e);
            }
        }
    }
}

/* step() adds the point x,y to vector and clears it so that
   it doesn't gennt double counted */
void step(int x, int y) {
    vectimg.pixels[x + y*vectimg.width] = color(255,255,255); //color pixel white
    int[] pix = {x,y};
    vector.add(pix); //add it to vector
}

/* getNeighbors() takes a point x,y and returns the location
   of one of its neighbors that is filled as a list [newx,newy].
   If there aren't any filled neighbors it returns null.*/
int[] getNeighbors(int x, int y) {
    int radius = 1;
    //    while(radius <= 3) {
        for(int i = -1; i <= 1; i++) {  //iterate through all neighbors (includes self)
            for(int j = -1; j <= 1; j++) {
                if(abs(i) == radius || abs(j) == radius) {
                    int newx = x+i;
                    int newy = y+j;
                    if (!(newx < 0 || newy < 0 //check if neighbor is filled and inbounds
                          || newx >= vectimg.width || newy >= vectimg.height)) {
                        if(vectimg.pixels[newx + newy*vectimg.width] <= color(0,0,0)) {
                            int[] pix = {newx,newy};
                            return pix;
                        }
                    }
                }
            }
            //            radius++;
            //        }
    }
    return null;
}

void changeBlur(float blurriness) {
    if(pastblur) {
        edges.changeStdev(blurriness);
    } else {
        edges.changeStdev(blurriness);
        g_img = edges.blur();
        image(g_img, 0, 0, width, height);
    }
}


void changeHighThreshold(float Hthresh){
    edges.changeHthresh(Hthresh);
    g_img = edges.thresholding();
    image(g_img, 0, 0, width, height);
}

void changeLowThreshold(float Lthresh){
    edges.changeLthresh(Lthresh);
    g_img = edges.thresholding();
    image(g_img, 0, 0, width, height);
}

ControlFrame addControlFrame(String theName, int theWidth, int theHeight) {
    Frame f = new Frame(theName);
    ControlFrame p = new ControlFrame(this, theWidth, theHeight);
    f.add(p);
    p.init();
    f.setTitle(theName);
    f.setSize(p.w, p.h);
    f.setLocation(100, 100);
    f.setResizable(false);
    f.setVisible(true);
    return p;
}

public class ControlFrame extends PApplet {
    int w, h;
    int abc = 100;

    public void setup() {
        size(w, h);
        frameRate(25);
        cp5 = new ControlP5(this);
        cp5.addSlider("blur").setRange(0.1, 7).setPosition(10,10);
        cp5.addSlider("H_threshold").setRange(1, 255).setPosition(10,30).setValue(90);
        cp5.addSlider("L_threshold").setRange(1, 255).setPosition(10,50).setValue(30);
    }

    public void draw() {
        background(abc);
    }
  
    public ControlFrame(Object theParent, int theWidth, int theHeight) {
        parent = theParent;
        w = theWidth;
        h = theHeight;
    }
    
    public ControlP5 control() {
        return cp5;
    }

    public void blur(float lol) {
        if(edges != null) {
            changeBlur(lol);
        }
    }

    public void H_threshold(float lol) {
        if(edges != null) {
            changeHighThreshold(lol);
        }
    }

    public void L_threshold(float lol) {
        if(edges != null) {
            changeLowThreshold(lol);
        }
    }

    ControlP5 cp5;
    Object parent;  
}
