#@ DatasetIOService io
#@ CommandService command

""" This example runs stardist on all tif files in a folder

***This is a minor modification from the original maweigert/stardist_script.py gist by Martin Weigert, link below:
https://gist.github.com/maweigert/8dd6ef139e1cd37b2307b35fb50dee4a***

Full list of Parameters:

res = command.run(StarDist2D, False,
			 "input", imp, "modelChoice", "DSB 2018 (from StarDist 2D paper)",
			 "modelFile","/path/to/TF_SavedModel.zip",
			 "normalizeInput",True, "percentileBottom",35, "percentileTop",99.8,
			 "probThresh",0.725, "nmsThresh", 0.35, "outputType","Label Image",
			 "nTiles",1, "excludeBoundary",2, "verbose",1, "showCsbdeepProgress",1, "showProbAndDist",0).get();
EDIT THE VALUES BELOW NOT THE VALUES ABOVE TO INPUT YOUR SETTINGS FROM INITIAL TESTING

"""

from de.csbdresden.stardist import StarDist2D
from glob import glob
import os

# run stardist on all tiff files in <indir> and save the label image to <outdir>
indir   = os.path.expanduser("F:/TW1/Images/Zeiss Brightfield/TestOUT/")
outdir  = os.path.expanduser("F:/TW1/Images/Zeiss Brightfield/TestOUT2/")

for f in sorted(glob(os.path.join(indir,"*.tif"))):
	print "processing ", f

	imp = io.open(f)

	res = command.run(StarDist2D, False,
			"input", imp,
			"modelChoice", "DSB 2018 (from StarDist 2D paper)",
			"normalizeInput",True, "percentileBottom",35, "percentileTop",99.8,
			"probThresh",0.725, "nmsThresh", 0.35, "outputType","Label Image",
			"nTiles",1, "excludeBoundary",2, "verbose",1, "showCsbdeepProgress",1, "showProbAndDist",0
			).get()
	label = res.getOutput("label")

  	filename = os.path.basename(f)
	basename = os.path.splitext(filename)[0]
	io.save(label, os.path.join(outdir,"label-" + basename + ".tif"))
