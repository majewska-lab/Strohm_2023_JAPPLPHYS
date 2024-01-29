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

	// Translational correction on each z-stacks
	run("Linear Stack Alignment with SIFT", "initial_gaussian_blur=1.60 steps_per_scale_octave=3 minimum_image_size=64 maximum_image_size=1024 feature_descriptor_size=4 feature_descriptor_orientation_bins=8 closest/next_closest_ratio=0.92 maximal_alignment_error=25 inlier_ratio=0.05 expected_transformation=Translation interpolate");
	selectWindow("Aligned 16 of 16");
	file_name = replace(file,".tif","");
	run("Grays");
	run("Despeckle", "stack");
	print("Ran Despeckle");
	run("Z Project...", "projection=[Max Intensity]");
	run("Gaussian Blur...", "sigma=1 stack"); 
	print("Ran Guassian Blur");
	setMinAndMax(0, 1311); // Increase B/C
	run("Brightness/Contrast...");
	setMinAndMax(0, 89);
	run("Apply LUT");
	
	// Save Zmax projection 
	path = input + File.separator + file;
	stack_name = File.getName(path);
	zmax_name = "MAX_Aligned 16 of 16";
	selectWindow(zmax_name); // Make sure to select the Max projection window
	zmax_name = replace(zmax_name,suffix,".tif"); // rename max file name for saving
	zmax_file = replace(stack_name,".tif","_MAX.tif");
	saveAs("tiff", output + File.separator + zmax_file); // save MAX projection as .tif
	// Note: zmax_name is also the name of the max projection window. stack_name is that of the z-stack
	close("*");
	print("done");
	}

