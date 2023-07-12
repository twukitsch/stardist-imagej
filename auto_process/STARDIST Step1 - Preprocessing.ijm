/* STARDIST Step 1. 8-bit Conversion & Preprocessing
*/
// MACRO START MESSAGE
	print("***** STARDIST Step 1. 8-bit Conversion & Preprocessing STARTED *****");


// CLOSE ALL OPEN IMAGES
	while (nImages > 0) {
		selectImage(nImages);
	    close();
	}


// USER INTERFACE

	// CREATE OBJECTS
		inDir = ""; // input directory
		imgtype = newArray("tif", "jpg"); // a list of filetypes that worked so far with STARDIST
		outDir = ""; // output directory
		dwnsmple = ""; // downsample amount

	// CREATE USER DIALOGS
		Dialog.create("STARDIST Step 1. 8-bit Conversion & Preprocessing");
		Dialog.addMessage("----------File Path & Project Info----------");
		Dialog.addDirectory("Choose Raw Image Path:", inDir);
		Dialog.addChoice("Raw Image Type:", imgtype);
		Dialog.addDirectory("Choose the Output Path:", outDir);
		Dialog.addCheckbox("Batch Process Mode:", true);
		Dialog.addNumber("Downsample Percent:", dwnsmple, 0, 6, "%");
		Dialog.show();

	// GET USER INPUT VALUES
		inDir = Dialog.getString();
		imgtype = Dialog.getChoice();
		outDir = Dialog.getString();
		batchmode = Dialog.getCheckbox();
		dwnsmple = Dialog.getNumber();
		dwnsmple = dwnsmple/100;

	// SET BATCH MODE
		setBatchMode(batchmode); // true or false, true if you don't want to see the images, which is faster


// PREPROCESSING LOOP

	// LOOP SETUP
		list = getFileList(inDir); // initialize file list

	// START MESSAGE
		print("***** RUNNING STEP 1. PREPROCESSING *****");

	// START LOOP
		for (i = 0; i < list.length; i++) {
			showProgress(i+1, list.length);
		 	path = inDir + list[i]; // full path of each file
		 	if (endsWith(path, imgtype)) { // use only user-selected image type
			 	open(path);
			 	ImageID = File.name;
			 	print("Processing " + ImageID); // user feedback

				// PREPROCESSING
					run("8-bit");
					run("Scale...", "x=" + dwnsmple + " y=" + dwnsmple + " interpolation=Bilinear average create"); // downsampling the image for larger images
					run("Smooth");
					run("Subtract Background...", "rolling=100");
					run("Median...", "radius=1");
					run("Enhance Contrast...", "saturated=0.3");
					run("Sharpen");

				// SAVE
					selectWindow(ImageID);
				 	saveAs("TIFF", outDir + "PrePro-" + ImageID); // PrePro for "Preprocessed"
				 	close("*");
		 	}
		}


// MACRO END MESSAGE
	print("Images Pre-processed and available in " + outDir + ".");
	print("***** STARDIST Step 1. 8-bit Conversion & Preprocessing ENDED *****")
