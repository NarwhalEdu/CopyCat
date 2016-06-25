class CannyRGB{

    private PImage sourceImg;
    private PImage blurImg;
    private PImage edgeImg;
    private PImage nonMaxImg;
    private float[][] finalImg;
    private float[][] oldFinalImg;
    private float[][] theta;
    private float stdev = 0.1;
    private int Hthresh = 90;
    private int Lthresh = 30;

    
    public CannyRGB(PImage img) {
        sourceImg = img;
        width = sourceImg.width;
        height = sourceImg.height;
        blurImg = createImage(width, height, RGB);
        edgeImg = createImage(width, height, RGB);
        nonMaxImg = createImage(width, height, RGB);
        finalImg = new float[width*height][3];
        theta = new float[width*height][3];
        for(int i=0; i < width*height; i++) {
            finalImg[i][0] = sourceImg.pixels[i] >> 16 & 0xFF; // red(sourceImg.pixels[i]);
            finalImg[i][1] = sourceImg.pixels[i] >> 8 & 0xFF; // green(sourceImg.pixels[i]);
            finalImg[i][2] = sourceImg.pixels[i] & 0xFF; // blue(sourceImg.pixels[i]);
        }
        oldFinalImg = deepCopyFltMatrix(finalImg);
    }

    PImage blur() {
        float[][] buf = deepCopyFltMatrix(oldFinalImg);
        float[][] GausM = new float[5][5];
        for(int i=0; i < GausM.length; i++) {
            for(int j=0; j < GausM.length; j++) {
                GausM[i][j] =
                    (1/(2*PI*stdev*stdev))*exp(-1*(((i-2)*(i-2)+(j-2)*(j-2))/(2*stdev*stdev)));
            }
        }
        for(int x=0; x < width; x++) {
            for(int y=0; y < height; y++) {
                finalImg[x + y*width] = convolution(x,y,GausM,buf);
            }
        }
        final2current(blurImg);
        blurImg.updatePixels();
        return blurImg;
    }

    PImage sobelDetection() {
        float[][] buf = deepCopyFltMatrix(finalImg);
        float[][] gy = new float[width*height][3];
        float[][] gx = new float[width*height][3];
        float[][] sobelMatrix = { {-1, 0, 1},
                                  {-2, 0, 2},
                                  {-1, 0, 1} };
        float[][] sobelMatrixT = { {1, 2, 1},
                                   {0, 0, 0},
                                   {-1, -2, -1} };
        for(int x=(sobelMatrix.length-1)/2; x < width-(sobelMatrix.length+1)/2; x++) {
            for(int y=(sobelMatrix.length-1)/2; y < height-(sobelMatrix.length+1)/2; y++) {
                int loc = x+y*width;
                gx[loc] = convolution(x,y,sobelMatrix,buf);
                gy[loc] = convolution(x,y,sobelMatrixT,buf);
                finalImg[loc][0] = abs(gx[loc][0]) + abs(gy[loc][0]);
                finalImg[loc][1] = abs(gx[loc][1]) + abs(gy[loc][1]);
                finalImg[loc][2] = abs(gx[loc][2]) + abs(gy[loc][2]);
                theta[loc][0] = round(atan2(gy[loc][0],gx[loc][0]));
                theta[loc][1] = round(atan2(gy[loc][1],gx[loc][1]));
                theta[loc][2] = round(atan2(gy[loc][2],gx[loc][2]));
            }
        }
        final2current(edgeImg);
        edgeImg.updatePixels();
        return edgeImg;
    }

    PImage nonMax() {
        float[][] buf = deepCopyFltMatrix(finalImg);
        for(int x=1; x < width-1; x++) {
            for(int y=1; y < height-1; y++) {
                int loc = x + y*width;
                if(!isMaximum(buf, x, y, theta[loc][0])
                   && !isMaximum(buf, x, y, theta[loc][1])
                   && !isMaximum(buf, x, y, theta[loc][2])) {
                    finalImg[loc][0] = 0;
                    finalImg[loc][1] = 0;
                    finalImg[loc][2] = 0;
                }
            }
        }
        oldFinalImg = deepCopyFltMatrix(finalImg);
        final2current(nonMaxImg);
        nonMaxImg.updatePixels();
        return nonMaxImg;
    }

    PImage thresholding() {
        finalImg = deepCopyFltMatrix(oldFinalImg);
        float[][] buf = deepCopyFltMatrix(oldFinalImg);
        for(int x=1; x < width-1; x++) {
            for(int y=1; y < height-1; y++) {
                int loc = x+y*width;
                if(buf[loc][0] > Hthresh
                   || buf[loc][1] > Hthresh
                   || buf[loc][2] > Hthresh) {
                    float[] white = new float[] { 255,255,255 };
                    float[] black = new float[] { 0,0,0 };
                    finalImg[loc] = white;
                    int newloc = loc;
                    int newx = x;
                    int newy = y;
                    int[] nextstep = new int[2];
                    while((buf[newloc][0] >= Lthresh
                          || buf[newloc][1] >= Lthresh
                          || buf[newloc][2] >= Lthresh) 
                          && newx != width && newx != 0
                          && newy != height && newy != 0) {
                        finalImg[newloc] = white;
                        if(buf[newloc][0] != 0) {
                            nextstep = stepdirection(theta[newloc][0], newx, newy);
                            //print(theta[newloc][0]);
                        } else if(buf[newloc][1] != 0) {
                            nextstep = stepdirection(theta[newloc][1], newx, newy);
                            //print(theta[newloc][0]);
                        } else if(buf[newloc][2] != 0) {
                            nextstep = stepdirection(theta[newloc][2], newx, newy);
                            //print(theta[newloc][0]);
                        } else {
                            break;
                        }
                        buf[newloc] = black;
                        newx = nextstep[0];
                        newy = nextstep[1];
                        newloc = newx + newy*width;
                        //println(" " + buf[newloc][0] + " " + buf[newloc][1] + " " + buf[newloc][2]);
                    }
                    //println("stopped");
                    buf[loc] = black;
                }
            }
        }
        final2current(sourceImg);
        for(int i=0; i < width*height; i++) {
            if(sourceImg.pixels[i] == color(255)) sourceImg.pixels[i] = color(0);
            else sourceImg.pixels[i] = color(255);
        }
        sourceImg.updatePixels();
        return sourceImg;
    }        
        
    float[] convolution(int x, int y, float[][] matrix, float[][] othermatrix) {
        float rtotal = 0.0;
        float gtotal = 0.0;
        float btotal = 0.0;
        int offset = matrix.length / 2;
        for (int i = 0; i < matrix.length; i++){
            for (int j= 0; j < matrix.length; j++){
                // What pixel are we testing
                int xloc = x+i-offset;
                int yloc = y+j-offset;
                int loc = xloc + width*yloc;
                // Make sure we haven't walked off our image, we could do better here
                loc = constrain(loc,0,width*height-1);
                // Calculate the convolution
                rtotal += (othermatrix[loc][0] * matrix[i][j]);
                gtotal += (othermatrix[loc][1] * matrix[i][j]);
                btotal += (othermatrix[loc][2] * matrix[i][j]);
            }
        }
        float[] total = new float[] {rtotal, gtotal, btotal};
        // Return the resulting color
        return total;
    }

    float round(float angle) {
        if(angle >= -PI/8 && angle < PI/8) {
            return 0;
        } else if((angle-PI) >= -PI/8 && angle >= 7*PI/8
           || (angle+PI) < PI/8 && angle < -7*PI/8) {
            return PI;
        } else if(angle < 3*PI/8 && angle >= PI/8) {
            return PI/4;
        } else if(angle <= -5*PI/8 && angle > -7*PI/8) {
            return 5*PI/4;
        } else if(angle < 5*PI/8 && angle >= 3*PI/8) {
            return PI/2;
        } else if(angle <= -3*PI/8 && angle > -5*PI/8) {
            return 3*PI/2;
        } else if(angle < 7*PI/8 && angle >= 5*PI/8) {
            return 3*PI/4;
        } else if(angle <= -PI/8 && angle > -3*PI/8) {
            return 7*PI/4;
        } else {
            return 0;
        }
    }

    boolean isMaximum(float[][] buf, int x, int y, float angle) {
        int loc = x+y*width;
        int anglei = int(10*angle);
        for(int i=0; i < buf[1].length; i++) {
            if(int(angle) == 0 || anglei == int(10*PI)) {
                int above = x+(y+1)*width;
                int below = x+(y-1)*width;
                if(buf[loc][i] > buf[above][i] && buf[loc][i] > buf[below][i]) {
                    finalImg[loc][mod((i-1),buf[1].length)] = 0;
                    finalImg[loc][mod((i+1),buf[1].length)] = 0;
                    return true;
                }
            } else if(anglei == int(10*PI/4) || anglei == int(10*5*PI/4)) {
                int lleft = (x-1)+(y+1)*width;
                int uright = (x+1)+(y-1)*width;
                if(buf[loc][i] > buf[lleft][i] && buf[loc][i] > buf[uright][i]) {
                    finalImg[loc][mod((i-1),buf[1].length)] = 0;
                    finalImg[loc][mod((i+1),buf[1].length)] = 0;
                    return true;
                }
            } else if(anglei == int(10*PI/2) || anglei == int(10*3*PI/2)) {
                int right = (x+1)+y*width;
                int left = (x-1)+y*width;
                if(buf[loc][i] > buf[right][i] && buf[loc][i] > buf[left][i]) {
                    finalImg[loc][mod((i-1),buf[1].length)] = 0;
                    finalImg[loc][mod((i+1),buf[1].length)] = 0;
                    return true;
                }
            } else if(anglei == int(10*3*PI/4) || anglei == int(10*7*PI/4)) {
                int uleft = (x-1)+(y-1)*width;
                int lright = (x+1)+(y+1)*width;
                if(buf[loc][i] > buf[uleft][i] && buf[loc][i] > buf[lright][i]) {
                    finalImg[loc][mod((i-1),buf[1].length)] = 0;
                    finalImg[loc][mod((i+1),buf[1].length)] = 0;
                    return true;
                }
            }
        }
        return false;
    }

    // float maxValue(float[] list) {
    //     float max = 0;
    //     for(int i=0; i < list.length; i++) {
    //         if(list[i] > max) max = list[i];
    //     }
    //     //println(max);
    //     return max;
    // }

    // float[] map8bit(float[] list, float max) {
    //     float[] newlist = new float[list.length];
    //     for(int i=0; i < list.length; i++) {
    //         newlist[i] = (float)(list[i]/max)*255;
    //     }
    //     return newlist;
    // }

    float[][] deepCopyFltMatrix(float[][] input) {
        if (input == null)
            return null;
        float[][] result = new float[input.length][];
        for (int r = 0; r < input.length; r++) {
            result[r] = input[r].clone();
        }
        return result;
    }

    int mod(int divisor, int dividend) {
        int result = divisor%dividend;
        if(result < 0) {
            result += dividend;
        }
        return result;
    }

    int[] stepdirection(float angle, int x, int y) {
        int[] nextloc = new int[2];
        int anglei = int(10*angle);
        if(int(angle) == 0) {
            nextloc[0] = x+1;
            nextloc[1] = y;
            return nextloc;
        } else if(anglei == int(10*PI/4)) {
            nextloc[0] = x-1;
            nextloc[1] = y+1;
            return nextloc;
        } else if(anglei == int(10*PI/2)) {
            nextloc[0] = x;
            nextloc[1] = y+1;
            return nextloc;
        } else if(anglei == int(10*3*PI/4)){
            nextloc[0] = x-1;
            nextloc[1] = y-1;
            return nextloc;
        } else if(anglei == int(10*PI)) {
            nextloc[0] = x-1;
            nextloc[1] = y;
            return nextloc;
        } else if(anglei == int(10*5*PI/4)) {
            nextloc[0] = x+1;
            nextloc[1] = y-1;
            return nextloc;
        } else if(anglei == int(10*3*PI/2)) {
            nextloc[0] = x;
            nextloc[1] = y-1;
            return nextloc;
        } else {
            nextloc[0] = x+1;
            nextloc[1] = y+1;
            return nextloc;
        }
    }

    PImage final2current(PImage img) {
        for(int i=0; i < width; i++) {
            for(int j=0; j < height; j++) {
                img.pixels[i+j*width] = color(finalImg[i+j*width][0],
                                              finalImg[i+j*width][1],
                                              finalImg[i+j*width][2]);
            }
        }
        return img;
    }

    void changeStdev(float newStdev) {
        stdev = newStdev;
    }

    void changeHthresh(float newHthresh) {
        Hthresh = (int)newHthresh;
    }

    void changeLthresh(float newLthresh) {
        Lthresh = (int)newLthresh;
    }
}
