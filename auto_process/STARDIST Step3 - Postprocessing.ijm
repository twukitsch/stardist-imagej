/* StarDist segmentation & count 
*/
//MACRO START MESSAGE
print("***** MACRO STARTED *****");

//CLOSE ALL OPEN IMAGES
while (nImages>0) { 
	selectImage(nImages); 
    close(); 
}

//INPUT/OUTPUT DIALOG FOR USER
//CREATE OBJECTS
	dir1 = "";
	dir2 = "";
	proj = "";
	part_min = 500; //minimum particle area in px^2 to count as a cell
	part_max = "Infinity"; //maximum particle area in px^2 to count as a cell

//CREATE USER DIALOGS
	Dialog.create("STARDIST Step 3. Post Processing & Cell Count");
	Dialog.addDirectory("Choose Label Image Path:", dir1);
	Dialog.addDirectory("Choose the Output Path:", dir2);
	Dialog.addString("Project Abbreviation:", proj);
	Dialog.addCheckbox("Batch Process Mode", true);
	Dialog.addMessage("Only unncheck Batch Procecss Mode during troubleshooting.\n _When Batch Process Mode is unchecked, it will slow down processing \nspeed, but show every image generated during processing.");
	Dialog.addNumber("Minimum Cell Area to Count as a Cell:", part_min, 0, 10, "px^2");
	Dialog.addNumber("Maximum Cell Area to Count as a Cell:", part_max, 0, 10, "px^2");
	Dialog.show();

//GET USER INPUT VALUES
	dir1 = Dialog.getString();
	dir2 = Dialog.getString();
	proj = Dialog.getString();
	batchmode = Dialog.getCheckbox();
	part_min = Dialog.getNumber();
	part_max = Dialog.getNumber();

//SET BATCH MODE
setBatchMode(batchmode); //true or false, true if you don't want to see the images, which is faster

//START MESSAGE
print("***** RUNNING STEP 3. POSTPROCESSING & CELL COUNT *****");

//INITIALIZE FILE LIST
list = getFileList(dir1);

//START LOOP

for (i=0; i<list.length; i++) {
 showProgress(i+1, list.length); 
 path = dir1 + list[i]; //full path of each file
 if (endsWith(path, "tif")) {
 open(path);
 FileName = File.nameWithoutExtension;
 ImageID=File.name;
 print("Processing " +ImageID);


//CREATE COUNT FROM LABEL IMAGE
setThreshold(1, 65535, "raw"); //converts everything to black (background) or white (signal)
run("Convert to Mask");
run("Watershed"); //delineates overlapping cells
run("Analyze Particles...", "size=" +part_min+ "-" +part_max+ " show=[Count Masks] summarize"); // Change the size as needed depending on the image and cell size

 }
}

//SAVE RESULTS
	selectWindow("Summary");
	//save the summary table as a CSV file
	Table.save(dir2 + proj + " STARDIST Cell Count Results.csv");

//MACRO END MESSAGE
print("Images processed, counts available in" + dir2 + proj + " STARDIST Cell Count Results.csv");
print("***** MACRO END *****");