// Macro to pre-process hyperstacks from 2-photon imaging (Olympus Fluoview computer)
//  (1) Convert image to hyperstack (fluoview output is in 'xyz', different than default for imageJ
//	(2) Options to despeckle and smooth (Guassian blur):
//			-run at this stage to not interfere with the autocropping when making maxZ projections
//	(3) Run 3D correct plugin on images
//	(4) Save to output folder, with '_3Dcorrect' appended to file name
//	Uses the batch processing macro template from FIJI/ImageJ website
//		-Brendan Whitelaw, Majewska lab, University of Rochester Neuroscience


// Dialog box made using Script Parameters: https://imagej.net/Script_Parameters
// These are 'global' parameters, so you can use them inside of functions 
// below without explicitly mentioning them as inputs

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


	run("Brightness/Contrast...");
	waitForUser("Adjust brightness/contrast... then click OK");
	run("Apply LUT");
	
	// Save Zmax projection 
	//Save binary images
	file_name = replace(file,".tif","");
	saveAs('tiff',output + File.separator + file_name + "_binary.tif");
	
	close("*");
}

	}

