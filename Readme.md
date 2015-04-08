NarwhalEdu CopyCat Robot (Source Files)
=========

CopyCat is a small robot arm that draws.

![robot drawing nyancat](https://s3.amazonaws.com/ksr/assets/001/290/382/8419a63d23ee3d8706eb55e41b694969_large.jpg?1383771483) 
(prototype shown)

It consists of an atmega328 microcontroller running the Arduino bootloader, three servos, a lasercut acrylic/birch box, and a 3d-printed pen holder that holds markers up to a sharpie of "fine" thickness using a set screw. 

Copycat was the physical kit paired with NarwhalEdu's first class, "Robots, Drawing, and Engineering: An Online Course," and was mailed to our kickstarter backers in February 2014. See https://www.kickstarter.com/projects/narwhaledu/robots-drawing-and-engineering-an-online-course for more information on the kickstarter.

Update (April 2015): It is accompanied by our EdX class, now released to the public for free:  https://edge.edx.org/courses/NarwhalEdu/E101/2014_Spring/info 
You will need to sign up for an Edge Edx account (any one will do).
![edx screenshot](https://d262ilb51hltx0.cloudfront.net/max/800/1*kHT2rEMbzDIn6k12WZdCYw.png)

![kickstarter gif](https://s3.amazonaws.com/ksr/assets/001/290/378/2e23e35620fe6f3c54d762b610541e68_large.gif?1383771474)

Version
----

1.0

Repository Structure
-----------

### Hardware
#### Requirements
Screwdriver, soldering iron and solder, heatshrink and hot air gun if you wish

#### Lasercut Pieces

The solidworks files are the oldest -- the folder structure may be a bit messed up as of 13 March 2014, so the assembly file may not work out of the box, but all the files are there. However, the hole sizes and other cosmetic changes may have occurred between the solidworks files and the final inkscape lasercut files.

The Lasercut-ponoko files are EXAMPLES only of how you might order the pieces from ponoko. !!We have not ordered these files from ponoko or shapeways ourselves.!!

The most accurate files, although still not fully accurate, are the inkscape .svg (exported to .pdf as well) files in Lasercut-Yubo. However, the thickness of the legs on the C and D pieces are still thinner than the final version, which has a closer-fit with piece E.

To order lasercut pieces individually, we suggest (but cannot guarantee) using inkscape to move the Yubo drawings into ponoko templates, and then filing holes that are too small or hot-gluing holes that are too big. The main reason for the uncertainty is variation in lasercutter kerf widths depending on the lasercutter, which affects the pressfits we have in our design (on the potentiometer, the servo horns, and close-fit on C/D/E pieces).

#### 3d Printed Penholder

The pen holder is 3d printed and can be ordered from shapeways. We recommend the hollow version if you are printing on shapeways, as it will save some costs.

#### Potentiometer

Additionally, one thing not shown is that we stripped and soldered the potentiometers to fit onto the I/O shield appropriately.

### Code

We'll release more code after the class ends at the end of March 2014. For now, there's some basic code up in which the servo robot arm will follow the potentiometer arm in a "copycat" configuration.

### Instructions

In the "instructions" folder you can find the bill of materials for the individual kits, complete with cost; the packing slip; and the assembly instructions. If you are building from scratch you will need not only a screwdriver but also a soldering iron and solder in order to assemble the potentiometers, which we did for the students.

Important Links
--------------
- https://www.kickstarter.com/projects/narwhaledu/robots-drawing-and-engineering-an-online-course
- http://narwhaledu.com/copycat
- http://github.com/narwhaledu/copycat

Installation
--------------
Warning: The full filesize for this repo is over 60 megabytes.

```sh
git clone [git-repo-url] copycat
cd copycat
```


License
----

Public Domain: http://creativecommons.org/publicdomain/zero/1.0/

To the extent possible under law, NarwhalEdu has waived all copyright and related or neighboring rights to CopyCat v1.0. This work is published from: United States. 

If you happen to see us in person, feel free to buy us some cheetos or tangerines.

Contact
----
opensource@narwhaledu.com
