# Must use with parse.py and lines.txt!!!
from math import *
import numpy as np
import matplotlib.pyplot as plt
import parse

l1 = 107
l2 = 110
elbowup = False

def get_angles(Px, Py):
  # first find theta2 where c2 = cos(theta2) and s2 = sin(theta2)
  c2 = (pow(Px,2) + pow(Py,2) - pow(l1,2) - pow(l2,2))/(2*l1*l2) # is btwn -1 and 1
  #Serial.print("c2 "); Serial.print(c2);

  if elbowup == False :
    s2 = sqrt(1 - pow(c2,2))  # sqrt can be + or -, and each corresponds to a different orientation

  elif elbowup == True:
    s2 = -sqrt(1 - pow(c2,2))

  theta2 = degrees(atan2(s2,c2))  # solves for the angle in degrees and places in correct quadrant
#theta2 = map(theta2, 0,180,180,0); // the servo is flipped. 0 deg is on the left physically
#now find theta1 where c1 = cos(theta1) and s1 = sin(theta1)
  theta1 = degrees(atan2(-l2*s2*Px + (l1 + l2*c2)*Py, (l1 + l2*c2)*Px + l2*s2*Py))
  theta1 = theta1
  return theta1 , theta2


def angles2xy(t1, t2):
    t1 = radians(t1)
    t2 = radians(t2)
    x = cos(t1) * l1 + cos(t1 + t2) * l2
    y = sin(t1) * l1 + sin(t1 + t2) * l2
    return (x, y)

def plotworkingenvelope():
    gridt1, gridt2 = tuple(np.indices([180, 180]))
    gridt1 = gridt1.flatten()
    gridt2 = gridt2.flatten()
    pts = zip(gridt1, gridt2)
    xy = [angles2xy(*pt) for pt in pts]
    plt.scatter([x[0] for x in xy], [x[1] for x in xy], marker="." )

def circle(xcenter, ycenter):
    radius = 10;
    xvals, yvals = [], []
    #xvals, yvals = [-91.59],[5.40]
    for i in np.arange(0,2*pi,0.1):
        xval = xcenter + (sin(i) * radius)
        yval = ycenter + (cos(i) * radius)
        xvals.append(xval)
        yvals.append(yval)
        print "x: " + str(xval) + ", y: " + str(yval)
    return xvals, yvals

#takes x,y values, plots them
# also x,y -> angles -> xy & plots 
def plotIKcircle(temp): 
    xvals, yvals = temp
    plt.plot(xvals, yvals, 'rd') #blue squares
    thetavals = [get_angles(tempx, tempy) for tempx, tempy in zip(xvals, yvals)]
    for i in range(len(thetavals)):
            print thetavals[i]
    IKvals = [angles2xy(theta1, theta2) for theta1, theta2 in thetavals] 
    tempx2, tempy2 = zip(*IKvals)
    plt.axis('equal')
    plt.plot(tempx2, tempy2, 'b.')
    #print "x: " + str(tempx2) + ", y: " + str(tempy2)

def plot_theta_vals(thetavals):
    IKvals = [angles2xy(theta1, theta2) for theta1, theta2 in thetavals] 
    tempx2, tempy2 = zip(*IKvals)
    plt.axis('equal')
    plt.plot(tempx2, tempy2, 'ro')

thetavals = parse.parse_csv()
plot_theta_vals(thetavals)

plotworkingenvelope()
#plotIKcircle(circle(-100,0))
plt.show()
