import shutil
from shutil import copyfile
import os
from os import path
import numpy
from numpy import arange

# specify ranges for saddle position

xStart = -0.11
xEnd = -0.09
yStart = -0.06
yEnd = -0.04

# specify file you want to modify
defaultName = 'CMC_leg_8e_probed.osim'
src = path.realpath(defaultName)

print(src)
dirsrc = '/Users/chelseachen/Documents/OpenSim/4.1/Models/OS/spec-opensim/MTP_r2/'


# specify lines that need to be edited
editLine_x = 905 # for pelvis tx
editLine_y = 921 # for pelvis tx

tabs = '\t\t\t\t\t\t\t'

def generateOSIM():
	# print(xStart)
	# print(yEnd)
	for x in arange(xStart, xEnd, 0.01):
		for y in arange(yStart, yEnd, 0.01):
			newName = 'CMC_probed_x_' + str(x) + '_y_' + str(y) + '.osim'

			dirName = dirsrc + 'CMC/ResultsCMC/'+'Saddle_x_' + str(x) + '_y_' + str(y)
			os.mkdir(dirName)


			# grabs the lines of the osim file
			copyfile(src, newName)
			newOSIM = open(newName)
			lines = newOSIM.readlines()
			newOSIM.close()

			#edit lines here
			lines[editLine_x] = str(tabs) + '<default_value>' + str(x) + '</default_value>'
			lines[editLine_y] = str(tabs) + '<default_value>' + str(y) + '</default_value>'

			# write edited lines back to file
			newOSIM = open(newName, 'w')
			newOSIM.write("".join(lines))
			newOSIM.close()

if __name__ == '__main__':
	generateOSIM()