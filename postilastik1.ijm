//This script is to convert object prediction tifs into binary images for downstream analysis

#@ File (label = "Input directory", style = "directory") input
#@ File (label = "Output directory", style = "directory") output
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
	open(input + File.separator + file);

	// Convert image to binary
	setThreshold(1, 255);
	setOption("BlackBackground", true);
	run("Convert to Mask");
	
	//Save binary images
	file_name = replace(file,".tif","");
	saveAs('tiff',output + File.separator + file_name + "_binary.tif");
	
	close("*");
}
