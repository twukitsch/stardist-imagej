/* STARDIST Step 0. Split Color Channels
*/
//MACRO START MESSAGE
	print("***** STARDIST Step 0. Split Color Channels STARTED *****");


// DIRECTORY SETUP

	// INPUT
		rawDir = getDirectory("Select the Raw Image Folder"); 	// ask user to select a folder in GUI
		fileList = getFileList(rawDir); // get the full list of all files and folders within
	// OUTPUT
		outDir = getDirectory("Select the Output Folder"); // bring up GUI for output
		File.makeDirectory(outDir); // make a folder for image output

	// CREATE DIRECTORIES FOR EACH CHANNEL
		split_dir = newArray(outDir + "RED/", outDir + "GREEN/", outDir + "BLUE/");
		File.makeDirectory(split_dir[0]);
		File.makeDirectory(split_dir[1]);
		File.makeDirectory(split_dir[2]);

// SET BATCH MODE
	setBatchMode(true);


// SPLITTING LOOP

	// START MESSAGE
		print("***** RUNNING STEP 0. SPLIT CHECK *****");

	// START LOOP
		for (i = 0; i < lengthOf(fileList); i++) {
			current_imagePath = rawDir + fileList[i]; // concatenate rawDir and [i] of fileList array to make current_imagePath

			if (!File.isDirectory(current_imagePath)){ // check that the current image is not a directory

				open(current_imagePath);
				getDimensions(width, height, channels, slices, frames); // get open image info

				if (channels > 1) { // check for more than one image channel
					run("Split Channels");

					// SAVE LOOP
					ch_nbr = nImages; // variable storing number of image channels
					for (j = 1 ; j <= ch_nbr ; j++){
						selectImage(j);
						currentImage_name = getTitle();
						saveAs("tiff", split_dir[j-1] + currentImage_name); // use split_dir directories to put channels in separate folders
						print("Saving " + currentImage_name);
					}

					// CLOSE ALL IMAGES
						run("Close All"); // always do this before starting next
				}
			}
		}


// RESET BATCH MODE
	setBatchMode(false);


// MACRO END MESSAGE
	print("Color channels split and available in the following directories:\nC1 - RED in: " +split_dir[0]+ "\nC2 - GREEN in: " +split_dir[1]+ "\nC3 - BLUE in: " +split_dir[2]);
	print("***** STARDIST Step 0. Split Color Channels ENDED *****")
