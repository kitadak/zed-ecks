#!/usr/bin/python

import sys
import os.path

OUTFILE="sound_out"

QUARTERBEAT=80
REST="R"

# W->Whole Note
# H->Half Note
# Q->Quarter Note
# E->Eighth Note
# S->Sixteenth Note
# T->Thirty-Secondth Note
#
# D->With Dot
# T->Triplet (TODO)
# Format: [TIME] [NOTE] [OCTAVE]
# Example: ED C# 1
TIMETABLE={
	"W"  : QUARTERBEAT*4,
	"H"  : QUARTERBEAT*2,
	"HD" : QUARTERBEAT*1.5,
	"Q"  : QUARTERBEAT,
	"QD" : QUARTERBEAT*1.5,
	"E"  : QUARTERBEAT*0.5,
	"ED" : QUARTERBEAT*0.75,
	"S"  : QUARTERBEAT*0.25,
	"SD" : QUARTERBEAT*0.375,
	"T"  : QUARTERBEAT*0.125,
	"TD" : QUARTERBEAT*0.1875
}

NOTETABLE={
	"C"	 : 234,
	"C#" : 222,
	"D"	 : 208,
	"D#" : 196,
	"E"  : 185,
	"F"  : 175,
	"F#" : 166,
	"G"  : 157,
	"G#" : 148,
	"A"  : 139,
	"A#" : 132,
	"B"  : 124
}

if len(sys.argv) != 2:
	print "Usage: ./sound_translation.py [input file]"
	exit(-1)

o = open(OUTFILE, 'w')
f = open(sys.argv[1], 'r')



for line in f:
	if line[0] == "#":
		continue

	if line[0] == "$":
		break

	tokens = line.split()
	if len(tokens) == 0:
		continue

	if tokens[0] == REST:
		time = int(TIMETABLE[tokens[1]])
		o.write("\tdefb " + "254," +
			str(time) + "," + str(time) + "\n")
	else:
		time = int(TIMETABLE[tokens[0]])
		note = int(NOTETABLE[tokens[1]])
		octave = 0

		# check if there is octave adjustment
		if len(tokens) == 3:
			octave = int(tokens[2]) * 2
			note = note / octave

		o.write("\tdefb " + str(time) + "," +
			str(note) + "," + str(note+1) + "\n")

