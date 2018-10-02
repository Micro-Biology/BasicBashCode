#!/usr/bin/python

#FastqDrawHistogram
#Draws histogram of all fastq files in the current directory.

#Usage:

#cd Location_Of_Fastq_Files
#python2 ~/Python_Scripts/Histogram.py

#Prerequisites:

#Python 2.7
#Pandas
#Biopython
#Pygal

#Install using:

#sudo apt-get install python-pandas python-biopython python-dev python-pygal

import glob
import re
import os
from Bio import SeqIO
import pygal
from collections import Counter

# Draw a histogram given a file of sequences
def drawHistogram(sequenceFile):
	filename, extension = os.path.splitext(sequenceFile)
	extension = re.sub('\.','',extension) #replace the full stop in the ext.
	outfile = str(sequenceFile) + ".histogram.svg"
	sequences = [len(rec) for rec in SeqIO.parse(sequenceFile,extension)]
	counts = Counter(sequences)
	plot = pygal.XY(show_x_guides=True,show_legend=False,title="Sequence Length Histogram: "+sequenceFile, x_title="Sequence length (nt)", y_title="Number of sequences")
	plot.add('Sequence Lengths',counts.items(),show_dots=False)
	plot.render_to_file(outfile)
	print "Histogram " + outfile + " finished"
	return True


sequenceFiles = glob.glob("*.fastq")
for sequenceFile in sequenceFiles:
	graph = drawHistogram(sequenceFile)
