/* STARDIST Step 0. Split Color Channels 
*/
//MACRO START MESSAGE
print("***** STARDIST Step 0. Split Color Channels STARTED *****");

// ask user to select a folder in GUI
raw_dir = getDirectory("Select the Raw Image Folder");
// get the list of files (& folders) in it
fileList = getFileList(raw_dir);
// prepare a folder to output the images in GUI
output_dir = getDirectory("Select the Output Folder");
File.makeDirectory(output_dir);
// make directories for each color channel
split_dir = newArray(output_dir + "RED/", output_dir + "GREEN/", output_dir + "BLUE/");
File.makeDirectory(split_dir[0]);
File.makeDirectory(split_dir[1]);
File.makeDirectory(split_dir[2]);

//activate batch mode
setBatchMode(true);

// LOOP to process the list of files
for (i = 0; i < lengthOf(fileList); i++) {
	// define the "path"
	// Concatenate raw_dir and [i] of fileList array
	current_imagePath = raw_dir + fileList[i];
	// check that the currentFile is not a directory
	if (!File.isDirectory(current_imagePath)){
		// open the image and split
		open(current_imagePath);
		// get image info
		getDimensions(width, height, channels, slices, frames);
		// if it's a multi-channel image, we need to split channels into RGB
		if (channels > 1) {
			run("Split Channels");


		// now we save all the generated images as tif in the output_dir
		ch_nbr = nImages ;
			for (j = 1 ; j <= ch_nbr ; j++){
				selectImage(j);
				currentImage_name = getTitle();
				saveAs("tiff", split_dir[j-1] + currentImage_name);
				print("Saving " + currentImage_name);
			}
		// make sure to close every image before opening the next one
		run("Close All");
		}
	}
}
setBatchMode(false);

//MACRO END MESSAGE
print("Color channels split and available in the following directories:\nC1 - RED in: " +split_dir[0]+ "\nC2 - GREEN in: " +split_dir[1]+ "\nC3 - BLUE in: " +split_dir[2]);
print("***** STARDIST Step 0. Split Color Channels ENDED *****")
