/* STARDIST Step 1. 8-bit Conversion & Preprocessing
*/
//MACRO START MESSAGE
print("***** MACRO STARTED *****");

//CREATE OBJECTS
	dir1 = ""; //input directory
	imgtype = newArray("tif", "jpg"); //add more to this and test as needed, it is just a list of filetypes that worked with this macro
	dir2 = ""; //output directory
	dwnsmple = ""; //downsample amount
	
//CREATE USER DIALOGS
	Dialog.create("STARDIST Step 1. 8-bit Conversion & Preprocessing");
	Dialog.addMessage("----------File Path & Project Info----------");
	Dialog.addDirectory("Choose Raw Image Path:", dir1);
	Dialog.addChoice("Raw Image Type:", imgtype);
	Dialog.addDirectory("Choose the Output Path:", dir2);
	Dialog.addCheckbox("Batch Process Mode:", true);
	Dialog.addNumber("Downsample Percent:", dwnsmple, 0, 6, "%");
	Dialog.show();
	
//GET USER INPUT VALUES
	dir1 = Dialog.getString();
	imgtype = Dialog.getChoice();
	dir2 = Dialog.getString();
	batchmode = Dialog.getCheckbox();
	dwnsmple = Dialog.getNumber();
	dwnsmple = dwnsmple/100;

//SET BATCH MODE
setBatchMode(batchmode); //true or false, true if you don't want to see the images, which is faster

//START MESSAGE
print("***** RUNNING STEP 1. PREPROCESSING *****");

//INITIALIZE FILE LIST
	list = getFileList(dir1);

//START LOOP
for (i=0; i<list.length; i++) {
 showProgress(i+1, list.length); 
 path = dir1 + list[i]; //full path of each file
 if (endsWith(path, imgtype)) {
 open(path);
 FileName = File.nameWithoutExtension;
 ImageID=File.name;
 print("Processing " +ImageID);

//PREPROCESSING
	run("8-bit");
	run("Scale...", "x=" +dwnsmple+ " y=" +dwnsmple+ " interpolation=Bilinear average create"); //downsapling the image for larger images
	run("Smooth");
	run("Subtract Background...", "rolling=100");
	run("Median...", "radius=1");
	run("Enhance Contrast...", "saturated=0.3");
	run("Sharpen");

//SAVE (??)
	selectWindow(ImageID);
 	saveAs("TIFF", dir2+"PrePro-"+ImageID); //PrePro for "Preprocessed"
 	close("*");
 }
}

//MACRO END MESSAGE
print("Images Pre-processed and available in " +dir2+ ".");
print("***** MACRO END *****")