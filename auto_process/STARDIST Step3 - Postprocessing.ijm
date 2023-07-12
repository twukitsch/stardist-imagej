/* StarDist segmentation & count
*/
// MACRO START MESSAGE
	print("***** STARDIST Step 3. Postprocessing STARTED *****");


// CLOSE ALL OPEN IMAGES
	while (nImages > 0) {
		selectImage(nImages);
	    close();
	}


// USER INTERFACE

	// CREATE OBJECTS
		inDir = ""; // input directory
		outDir = ""; // output directory
		proj = ""; // project abbreviation
		partMin = 500; // minimum particle area in px^2 to count as a cell
		partMax = "Infinity"; // maximum particle area in px^2 to count as a cell

	// CREATE USER DIALOGS
		Dialog.create("STARDIST Step 3. Post Processing & Cell Count");
		Dialog.addDirectory("Choose Label Image Path:", inDir);
		Dialog.addDirectory("Choose the Output Path:", outDir);
		Dialog.addString("Project Abbreviation:", proj);
		Dialog.addCheckbox("Batch Process Mode", true);
		Dialog.addMessage("Only unncheck Batch Procecss Mode during troubleshooting.\n _When Batch Process Mode is unchecked, it will slow down processing \nspeed, but show every image generated during processing.");
		Dialog.addNumber("Minimum Cell Area to Count as a Cell:", partMin, 0, 10, "px^2");
		Dialog.addNumber("Maximum Cell Area to Count as a Cell:", partMax, 0, 10, "px^2");
		Dialog.show();

	// GET USER INPUT VALUES
		inDir = Dialog.getString();
		outDir = Dialog.getString();
		proj = Dialog.getString();
		batchmode = Dialog.getCheckbox();
		partMin = Dialog.getNumber();
		partMax = Dialog.getNumber();

	// SET BATCH MODE
	setBatchMode(batchmode); //true or false, true if you don't want to see the images, which is faster


// POSTPROCESSING & CELL COUNT LOOP

	// LOOP SETUP
		list = getFileList(inDir);  // initialize file list

	// START MESSAGE
		print("***** RUNNING STEP 3. POSTPROCESSING & CELL COUNT *****");

		// START LOOP
			for (i=0; i<list.length; i++) {
				showProgress(i+1, list.length);
			 	path = inDir + list[i]; // full path of each file
			 	if (endsWith(path, "tif")) { // uses only .tif files
				 	open(path);
				 	ImageID = File.name;
				 	print("Processing & Counting " + ImageID); // user feedback

					// CREATE COUNT FROM LABEL IMAGE
						setThreshold(1, 65535, "raw"); // converts everything to black (background) or white (signal)
						run("Convert to Mask");
						run("Watershed"); // delineates overlapping cells
						run("Analyze Particles...", "size=" + partMin + "-" + partMax + " show=[Count Masks] summarize"); // change the size as needed depending on the image and cell size
			 	}
			}


// SAVE RESULTS TABLE
	selectWindow("Summary");
	Table.save(outDir + proj + " STARDIST Cell Count Results.csv"); // save the summary table as a CSV file


// MACRO END MESSAGE
	print("Images processed, counts available in" + outDir + proj + " STARDIST Cell Count Results.csv");
	print("***** STARDIST Step 3. Postprocessing ENDED *****");
