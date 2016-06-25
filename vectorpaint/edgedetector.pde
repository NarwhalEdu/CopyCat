class EdgeDetector {
    //    private char[] thetaMaxColor;
    public PImage findEdges(PImage img) {
        PImage buf = createImage(img.width, img.height, RGB);
        buf.loadPixels();
        for(int x=0; x < img.width; x++) {
            for(int y=0; y < img.height; y++) {
                color thispixel = img.pixels[x + y*img.width];
                if(red(thispixel) != 255
                   && blue(thispixel) != 255
                   && green(thispixel) != 255) {
                    int numNeighbors = countNeighbors(x, y, img);
                    if(numNeighbors < 9) {
                        buf.pixels[x + y*img.width] = color(0,0,0);
                    } else {
                        buf.pixels[x + y*img.width] = color(255,255,255);
                    }
                } else {
                    buf.pixels[x + y*img.width] = color(255,255,255);
                }
            }
        }
        buf.updatePixels();
        return buf;
    }

    int countNeighbors(int x, int y, PImage img) {
        int neighbors = 0;
        for(int i = -1; i <= 1; i++) {
            for(int j = -1; j <= 1; j++) {
                int newx = x+i;
                int newy = y+j;
                if (!(newx < 0 || newy < 0
                      || newx >= img.width || newy >= img.height)) {
                    color newpixel = img.pixels[newx + newy*img.width];
                    if(red(newpixel) != 255
                       && blue(newpixel) != 255
                       && green(newpixel) != 255) {
                        neighbors++;
                    }
                }
            }
        }
        return neighbors;
    }
    
    // PImage findEdges(PImage img) {
    //     this.thetaMaxColor = new char[img.width*img.height];
    //     PImage buf = createImage(img.width,img.height,RGB);
    //     PImage blurred = createImage(img.width,img.height,RGB);
    //     buf.loadPixels();
    //     blurred = img;
    //     blurred = blur(blurred);
    //     float[] thetaR = new float[blurred.width*blurred.height];
    //     float[] thetaG = new float[blurred.width*blurred.height];
    //     float[] thetaB = new float[blurred.width*blurred.height];
    //     PImage Gy = createImage(img.width,img.height,RGB);
    //     PImage Gx = createImage(img.width,img.height,RGB);
    //     float[][] sobelMatrix = { {-1, 0, 1},
    //                               {-2, 0, 2},
    //                               {-1, 0, 1} };
    //     float[][] sobelMatrixT = { {1, 2, 1},
    //                                {0, 0, 0},
    //                                {-1, -2, -1} };
    //     float[][] nsobelMatrix = { {1, 0, -1},
    //                                {2, 0, -2},
    //                                {1, 0, -1} };
    //     float[][] nsobelMatrixT = { {-1, -2, -1},
    //                                 {0, 0, 0},
    //                                 {1, 2, 1} };
    //     for(int x=(sobelMatrix.length-1)/2; x < img.width - (sobelMatrix.length+1)/2; x++) {
    //         for(int y=(sobelMatrix.length-1)/2; y < img.height - (sobelMatrix.length+1)/2; y++) {
    //             int loc = x+y*img.width;
    //             Gx.pixels[loc] = convolution(x,y,sobelMatrix,blurred);
    //             Gy.pixels[loc] = convolution(x,y,sobelMatrixT,blurred);
    //             Gx.pixels[loc] += convolution(x,y,nsobelMatrix,blurred);
    //             Gy.pixels[loc] += convolution(x,y,nsobelMatrixT,blurred);
    //             //                println(red(Gx.pixels[loc]) + "," + blue(Gx.pixels[loc]) + "," + green(Gx.pixels[loc]));
    //             buf.pixels[loc] =  color(abs(red(Gx.pixels[loc])) + abs(red(Gy.pixels[loc])),
    //                                     abs(green(Gx.pixels[loc])) + abs(green(Gy.pixels[loc])),
    //                                     abs(blue(Gx.pixels[loc])) + abs(blue(Gy.pixels[loc])));
    //             thetaR[loc] = round(atan2(red(Gy.pixels[loc]),red(Gx.pixels[loc])));
    //             thetaG[loc] = round(atan2(green(Gy.pixels[loc]), green(Gx.pixels[loc])));
    //             thetaB[loc] = round(atan2(blue(Gy.pixels[loc]), blue(Gx.pixels[loc])));
    //         }
    //     }
    //     buf = nonMax(buf,thetaR,thetaG,thetaB);
    //     for(int i=0; i < width; i++) {
    //         for(int j=0; j < height; j++) {
    //         //            println(floatY[i]);
    //         //sourceImg.pixels[i] = color(Y[i]);
    //             if(color(buf.pixels[i+j*width]) != color(0)) {
    //                 buf.pixels[i+j*width] = color(255);
    //                 //                    print(sY + " ");
    //             } else {
    //                 buf.pixels[i+j*width] = color(0);
    //                 //print("0000 ");
    //             }
    //         }
    //         //            println();
    //     }

    //     //        buf = threshold(buf, thetaR, thetaG, thetaB);
    //     buf.updatePixels();
    //     return buf;
    // }

    // PImage blur(PImage img) {
    //     float[][] GausM = new float[5][5];
    //     float stdev = 1.3;
    //     for(int i=0; i < GausM.length; i++) {
    //         for(int j=0; j < GausM.length; j++) {
    //             GausM[i][j] = (1/(2*PI*stdev*stdev))*exp(-1*(((i-2)*(i-2)+(j-2)*(j-2))/(2*stdev*stdev)));
    //         }
    //     }
    //     for(int x=0; x < img.width; x++) {
    //         for(int y=0; y < img.height; y++) {
    //             img.pixels[x + y*img.width] = convolution(x,y,GausM,img);
    //         }
    //     }
    //     return img;
    // }

    // PImage nonMax(PImage img, float[] thetaR, float[] thetaG, float[] thetaB) {
    //     PImage buf = createImage(img.width, img.height, RGB);
    //     for(int x=1; x < img.width-1; x++) {
    //         for(int y=1; y < img.height-1; y++) {
    //             int loc = x + y*img.width;
    //             // if(isMaximum(img, x, y, thetaR[loc])) {
    //             //     buf.pixels[loc] = color(brightness(img.pixels[loc]));
    //             //     this.thetaMaxColor[loc] = 'R';
    //             // } else if(isMaximum(img, x, y, thetaB[loc])) {
    //             //     buf.pixels[loc] = color(brightness(img.pixels[loc]));
    //             //     this.thetaMaxColor[loc] = 'B';
    //             // } else if(isMaximum(img, x, y, thetaG[loc])) {
    //             //     buf.pixels[loc] = color(brightness(img.pixels[loc]));
    //             //     this.thetaMaxColor[loc] = 'G';
    //             // }
    //             if(!isMaximum(img, x, y, thetaR[loc])
    //                && !isMaximum(img, x, y, thetaG[loc])
    //                && !isMaximum(img, x, y, thetaB[loc])) {
    //                 buf.pixels[loc] = color(0);
    //                 //                    this.thetaMaxColor[loc] = ' ';
    //             } else {
    //                 buf.pixels[loc] = color(brightness(img.pixels[loc]));
    //             }
    //         }
    //     }
    //     return buf;
    // }

    // PImage threshold(PImage img, float[] thetaR, float[] thetaG, float[] thetaB) {
    //     PImage buf = createImage(img.width,img.height,RGB);
    //     int Hthresh = 22;
    //     int Lthresh = 2;
    //     for(int x=1; x < img.width-1; x++) {
    //         for(int y=1; y < img.height-1; y++) {
    //             int loc = x+y*img.width;
    //             if(brightness(img.pixels[loc]) > Hthresh && buf.pixels[loc] != color(255)) {
    //                 buf.pixels[loc] = color(255);
    //                 int newloc = loc;
    //                 int newx = x;
    //                 int newy = y;
    //                 int[] possiblestep = new int[2];
    //                 while(brightness(img.pixels[newloc]) >= Lthresh
    //                       && newx != img.width && newx != 0
    //                       && newy != img.height && newy != 0) {
    //                     buf.pixels[newloc] = color(255);
    //                     switch(this.thetaMaxColor[newloc]) {
    //                     case 'R':
    //                         possiblestep = stepdirection(thetaR[newloc], newx, newy);
    //                         break;
    //                     case 'G':
    //                         possiblestep = stepdirection(thetaG[newloc], newx, newy);
    //                         break;
    //                     case 'B':
    //                         possiblestep = stepdirection(thetaB[newloc], newx, newy);
    //                         break;
    //                     case ' ':
    //                         newx = img.width;
    //                         break;
    //                     }
    //                     newx = constrain(possiblestep[0],0,width);
    //                     newy = constrain(possiblestep[1],0,height);
    //                     newloc = newx + newy*img.width;
    //                 }
    //             }
    //         }
    //     }
    //     return buf;
    // }

    // color convolution(int x, int y, float[][] matrix, PImage img) {
    //     float rtotal = 0.0;
    //     float gtotal = 0.0;
    //     float btotal = 0.0;
    //     int offset = matrix.length / 2;
    //     for (int i = 0; i < matrix.length; i++){
    //         for (int j= 0; j < matrix.length; j++){
    //             // What pixel are we testing
    //             int xloc = x+i-offset;
    //             int yloc = y+j-offset;
    //             int loc = xloc + img.width*yloc;
    //             // Make sure we haven't walked off our image, we could do better here
    //             loc = constrain(loc,0,img.pixels.length-1);
    //             // Calculate the convolution
    //             rtotal += (red(img.pixels[loc]) * matrix[i][j]);
    //             gtotal += (green(img.pixels[loc]) * matrix[i][j]);
    //             btotal += (blue(img.pixels[loc]) * matrix[i][j]);
    //         }
    //     }
    //     // Return the resulting color
    //     return color(rtotal, gtotal, btotal);
    // }

    // float round(float angle) {
    //     if(angle >= -PI/8 && angle < PI/8
    //        || (angle-PI) >= -PI/8 && angle >= 7*PI/8
    //        || (angle+PI) < PI/8 && angle < -7*PI/8) {
    //         return 0;
    //     } else if(angle < 3*PI/8 && angle >= PI/8
    //               || angle <= -5*PI/8 && angle > -7*PI/8) {
    //         return PI/4;
    //     } else if(angle < 5*PI/8 && angle >= 3*PI/8
    //               || angle <= -3*PI/8 && angle > -5*PI/8) {
    //         return PI/2;
    //     } else if(angle < 7*PI/8 && angle >= 5*PI/8
    //               || angle <= -PI/8 && angle > -3*PI/8) {
    //         return 3*PI/4;
    //     } else {
    //         return 0;
    //     }
    // }

    //     boolean isMaximum(PImage img, int x, int y, float angle) {
    //     int loc = x+y*width;
    //     if(angle == 0f) {
    //         int above = x+(y+1)*width;
    //         int below = x+(y-1)*width;
    //         if(img.pixels[loc] > img.pixels[above] && img.pixels[loc] > img.pixels[below]) {
    //             return true;
    //         }
    //     } else if(int(10*angle) == int(10*PI/4)) {
    //         int uleft = (x-1)+(y+1)*width;
    //         int lright = (x+1)+(y-1)*width;
    //         if(img.pixels[loc] > img.pixels[uleft] && img.pixels[loc] > img.pixels[lright]) {
    //             return true;
    //         }
    //     } else if(int(10*angle) == int(10*PI/2)) {
    //         int right = (x+1)+y*width;
    //         int left = (x-1)+y*width;
    //         if(img.pixels[loc] > img.pixels[right] && img.pixels[loc] > img.pixels[left]) {
    //             return true;
    //         }
    //     } else if(int(10*angle) == int(10*3*PI/4)) {
    //         int lleft = (x+1)+(y+1)*width;
    //         int uright = (x-1)+(y-1)*width;
    //         if(img.pixels[loc] > img.pixels[lleft] && img.pixels[loc] > img.pixels[uright]) {
    //             return true;
    //         }
    //     }
    //     return false;
    // }

    
    // // boolean isMaximum(PImage img, int x, int y, float angle) {
    // //     int loc = x+y*img.width;
    // //     if(angle == 0f) {
    // //         if(img.pixels[loc] > img.pixels[x + (y-1)*img.width]
    // //            && img.pixels[loc] > img.pixels[x + (y+1)*img.width]) {
    // //             return true;
    // //         }
    // //     } else if(int(10*angle) == int(10*PI/4)) {
    // //         if(img.pixels[loc] > img.pixels[(x-1) + (y+1)*img.width]
    // //            && img.pixels[loc] > img.pixels[(x+1) + (y-1)*img.width]) {
    // //             return true;
    // //         }
    // //     } else if(int(10*angle) == int(10*PI/2)) {
    // //         if(img.pixels[loc] > img.pixels[(x-1) + y*img.width]
    // //            && img.pixels[loc] > img.pixels[(x+1) + y*img.width]) {
    // //             return true;
    // //         }
    // //     } else  if(int(10*angle) == int(10*3*PI/2)){
    // //         if(img.pixels[loc] > img.pixels[(x+1) + (y+1)*img.width]
    // //            && img.pixels[loc] > img.pixels[(x-1) + (y-1)*img.width]) {
    // //             return true;
    // //         }
    // //     }
    // //     return false;
    // // }

    // int[] stepdirection(float angle, int x, int y) {
    //     int[] nextloc = new int[4];
    //     if(angle == 0) {
    //         nextloc[0] = x+1;
    //         nextloc[1] = y;
    //         return nextloc;
    //     } else if(angle == PI/4) {
    //         nextloc[0] = x+1;
    //         nextloc[1] = y+1;
    //         return nextloc;
    //     } else if(angle == PI/2) {
    //         nextloc[0] = x;
    //         nextloc[1] = y+1;
    //         return nextloc;
    //     } else {
    //         nextloc[0] = x+1;
    //         nextloc[1] = y-1;
    //         return nextloc;
    //     }
    // }
}

