

/*
 * Macro template to process multiple images in a folder
 * 
 * Run Sholl analysis on cropped thresholded microglia images in Batch (all .tifs in a folder)
 */

#@ File (label = "Thresholded Microglia", style = "directory") input
#@ File (label = "Spreadsheets", style = "directory") output
#@ String (label = "File suffix", value = ".tif") suffix

// See also Process_Folder.py for a version of this code
// in the Python scripting language.


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
print("Processing: " + file);
open(input + File.separator + file);
	
	//roiManager("reset");
	//nROIs = Overlay.size;
	// print("Number ROIs: " + d2s(nROIs,0));
	//Overlay.activateSelection(nROIs-1);
	//roiManager("add");

	run("Set Scale...", "distance=3.5 known=1 unit=micron");
	setThreshold(1, 255);
	setOption("BlackBackground", true);
	run("Convert to Mask");
	run("Clear Results");
	//roiManager("select", 0);
	//roiManager("measure");
	setTool("point");
	waitForUser("Click center of cell body... then click OK");
	run("Legacy: Sholl Analysis (From Image)...", "starting=2 ending=200 radius_step=2 #_samples=1 integration=Mean enclosing=1 #_primary=2 infer fit linear polynomial=[Best fitting degree] most normalizer=Area save directory=["+output+"] do");
	
	close("*");
}




