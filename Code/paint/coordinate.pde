class Coordinate {
    private final static int l1 = 72;
    private final static int l2 = 102;

    private float x;
    private float y;
    private float theta1;
    private float theta2;
    private String serialLine;
    
    public Coordinate() {
        this.x = 0;
        this.y = 0;
        this.theta1 = 0;
        this.theta2 = 0;
        this.serialLine = "hello world!";
    }
    
    /* angles2String() takes the angles the servos need
       to go to and puts them in a string
       theta1,theta2'\n' assigned to .serialLine */
    void angles2String(float theta1, float theta2) {
        int angle1 = touSec(theta1); //change the angles to microseconds
        int angle2 = touSec(theta2);
        // these two lines just switch min and max uSecs if the servos are switched
        // angle1 = -angle1 + 2900;
        // angle2 = -angle2 + 2900;
        this.serialLine = angle1 + "," + angle2 + "\n";
    }

    /*Given a point to go to (Px,Py) getAngles()
      solves for the angles the servos need to go
      to and assigns them to .theta1 and .theta2
      It's just inverse kinematics. */
    void getAngles(float Px, float Py) {
        // first find theta2 where c2 = cos(theta2) and s2 = sin(theta2)
        float c2 = (pow(Px,2) + pow(Py,2) - pow(l1,2) - pow(l2,2))/(2*l1*l2); //is btwn -1 and 1
        float s2 = sqrt(1 - pow(c2,2));
        this.theta2 = degrees(atan2(s2,c2));  // solves for the angle in degrees and places in correct quadrant
        this.theta1 = degrees(atan2(-l2*s2*Px + (l1 +  l2*c2)*Py,
                                    (l1 + l2*c2)*Px + l2*s2*Py));
    }

    /* touSec() takes an angle in degrees (0-180) and
       converts it into the equivalent microsecond
       value for a servo */
    int touSec(float angle) {
        //angle = (-1)*angle + 180;
        float uSec = (angle/180)*1450 + 750;
        if(uSec - int(uSec) < 0.5) {
            return int(uSec);
        } else {
            return (int(uSec)+1);
        }
    }

    /* mapCoordinates() takes the x and y coordinates
       from the mouse and changes them to numbers
       suitable for the arduino to control the servos*/
    void mapCoordinates(float x, float y, int width, int height) {
        float aspectRatio = (float)(width)/((float)(height));
        if(aspectRatio > 1) {
            this.x = (x/width)*75-150;
            this.y = (-1*((y/height)*75)*(1/aspectRatio))+30;
        } else {
            this.x = (((x/width)*75))*(aspectRatio)-150;
            this.y = (-1*((y/height)*75)+30);
        }

    }
}
