#https://github.com/pranjalv123/servoarm

from math import *
l1 = 67.5
l2 = 65.8
elbowup = True
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
  theta1 = degrees(atan2(-l2*s2*Px + (l1 +  l2*c2)*Py, (l1 + l2*c2)*Px + l2*s2*Py))
  theta1 = theta1
  return theta1 , theta2


def angles2xy(t1, t2):
    t1 = radians(t1)
    t2 = radians(t2)
    x = cos(t1) * l1 + cos(t1 + t2)  * l2
    y = sin(t1) * l1 + sin(t1 + t2)  * l2
    return (x, y)

def plotworkingenvelope():
    gridt1, gridt2 = tuple(indices([180, 180]))
    gridt1 = flatten(gridt1)
    gridt2 = flatten(gridt2)
    pts = zip(gridt1, gridt2)
    xy = [angles2xy(*pt) for pt in pts]
    scatter([x[0] for x in xy], [x[1] for x in xy] )
