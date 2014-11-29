#!/bin/bash

# example files are in espressoDIR/PP/examples/example01

pw.x < pw.in > pw.out
pw.x < band.in > band.out
bands.x < bands.in > bands.out # this will produce the file for the filband option
                               # sometimes called band.dat
plotband.x < plotband.in > plotband.out # this in file needs the file for the filband option
										# from the previous step
ps2pdf band.ps
gnome-open band.pdf
