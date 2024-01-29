// Dialog box made using Script Parameters: https://imagej.net/Script_Parameters
// These are 'global' parameters, so you can use them inside of functions 
// below without explicitly mentioning them as inputs

#@ File (label = "Input directory", style = "directory") input
#@ File (label = "Output directory", style = "directory") output
#@ File (label = "Cropped Microglia directory", style = "directory") dir_microglia
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
	print("Processing: " + file);
	path = input + File.separator + file;
	open(path); // open the file
	stack_name = File.getName(path);
	selectWindow(stack_name);
	
	//Use ROI manager to draw outline each microglia with polygons 
	roiManager("reset"); 
	setOption("Show All", true); 
	setTool("polygon"); 
	waitForUser("Outline microglia and add to ROI manager (press 't')"); 
	ROIset_name = replace(stack_name,".tif","_ROIset.zip");
	roiManager("Save", output+ File.separator+ ROIset_name);
	run("Select None");
	Overlay.remove // Removes the cell body overlays


// Re-load microglia ROIs and then crop them out
	roiManager("reset");
	roiManager("open", output + File.separator+ ROIset_name);
	num_mg = roiManager("count");
	num_mg_string = d2s(num_mg, 0);
	setBackgroundColor(0, 0, 0);

// To make background after clear outside black 
// so when you 'Clear Outside' the ROI below it needs to also be white 
microglia_file_name = replace(stack_name,".tif","_mgROI_");

for(i = 0; i < num_mg; i++) {
    t_frame = i+1;
    roiManager("reset");
    roiManager("open", output + File.separator+ ROIset_name);
    roiManager("select",i);
    run("Duplicate...", "title=cropped_microglia_temp");
    run("Clear Outside");
    run("Select None");
    selectWindow("cropped_microglia_temp");
    setMinAndMax(0, 1311); // Increase B/C
    //insert more preprocessing if needed
    
    // Save file
    num_ROI = d2s(i+1,0);
    new_file_name = microglia_file_name + num_ROI + "of" + num_mg_string + ".tif";
    saveAs("tiff",dir_microglia + File.separator + new_file_name);
    close(new_file_name);
    selectWindow(stack_name);
}
roiManager("reset");
close("*"); print("DONE!");
}


}
