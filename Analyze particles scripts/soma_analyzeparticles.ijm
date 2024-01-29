

/*
 * Macro template to process multiple images in a folder
 * 
 * Run cell soma pixels analysis on cropped thresholded soma images in Batch (all .tifs in a folder)
 */

#@ File (label = "Thresholded Microglia", style = "directory") input
#@ File (label = "Spreadsheets", style = "directory") output
#@ String (label = "File suffix", value = ".tif") suffix

processFolder(input);

// function to scan folders/subfolders/files to find files with correct suffix
function processFolder(input) {
	list = getFileList(input);
	list = Array.sort(list);
	for (i = 0; i < list.length; i++) {
		if(File.isDirectory(input + File.separator + list[i]))
			processFolder(input + File.separator + list[i]);
		if(endsWith(list[i], suffix))
			processFile(input, output, list[i]);
	}
}

function processFile(input, output, file) {
	// Do the processing here by adding your own code.
	// print("Processing: " + file);
	open(input + File.separator + file);

	run("Set Measurements...", "area mean center shape feret's redirect=None decimal=3");
	run("Select None");
	run("Grays");
	setAutoThreshold("Default dark");
	run("Threshold...");
	setThreshold(1, 255);
	setOption("BlackBackground", true);
	run("Convert to Mask");
	run("Clear Results");
	run("Set Scale...", "distance=1.5 known=1 unit=micron");
	run("Analyze Particles...", "size=50-Infinity pixel display");
  	updateResults();
	selectWindow("Results");
	saveAs("results", output+"/"+file+"_Results.csv");
	run("Clear Results");
	close("*");
}
print("done")




