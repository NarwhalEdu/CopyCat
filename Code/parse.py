# Call with plotFace.py. Must have lines.txt!!!
import csv
import sys

def parse_csv():
    f = open("lines.txt")
    try:
        # reader = csv.reader(f)
        # for row in reader:
            # print row
        # input: theta1, theta2
        # output: [[theta1, theta2], [theta1, theta2], ...]
    
        #thetavals = [(map(int,vals)) for vals in csv.reader(f, delimiter=",")]
        thetavals = []
        for row in csv.reader(f, delimiter=","):
            if row:
                thetavals.append(map(int,row))
    finally:
        f.close()
    return thetavals
