#Authored by G0ldenGunSec (Dave Cossa)
import fileinput
import os
import sys

if len(sys.argv) < 2:
    print("error, please include the path to the folder where the httrack clone is located as an arg -- ex. python httrackCleaner.py /var/www/html/siteFolder")
    exit()
print("starting cleaning...")
rootdir = sys.argv[1]


for root, directories, filenames in os.walk(rootdir):
        currDir = root
        for filename in filenames:
                tempVar = os.path.join(currDir, filename)
                try:

                        with open(tempVar, "r") as f:
                            lines = f.readlines()
                        with open(tempVar, "w") as f:
                            for line in lines:
                                if not 'Mirrored' in line:
                                        if 'HTTrack' in line:
                                                f.write('<meta http-equiv="content-type" content="text/html;charset=utf-8" />')
                                        else:
                                                f.write(line)
                        f.close


                except:
                        print("error cannot parse file: " + os.path.join(currDir, filename))
print("cleaning finished, all tags should be removed!")
