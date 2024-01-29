//preprocessing script to take stacks from 1.5x images used for soma analysis
// Dialog box made using Script Parameters: https://imagej.net/Script_Parameters
// These are 'global' parameters, so you can use them inside of functions 
// below without explicitly mentioning them as inputs
//created by Alexandra Strohm toxicology training program University of Rochester

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
	selectWindow("Aligned 81 of 81");//this is based on how thick your zstack is, change if it is a different thickness
	file_name = replace(file,".tif","");
	//converts aligned stack to grayscale, despeckles, and z-projects the stack
	run("Grays");
	run("Despeckle", "stack");
	print("Ran Despeckle");
	run("Z Project...", "projection=[Max Intensity]");
	
	// Save Zmax projection 
	path = input + File.separator + file;
	stack_name = File.getName(path);
	zmax_name = "MAX_Aligned 81 of 81";
	selectWindow(zmax_name); // Make sure to select the Max projection window
	zmax_name = replace(zmax_name,suffix,".tif"); // rename max file name for saving
	zmax_file = replace(stack_name,".tif","_MAX.tif");
	saveAs("tiff", output + File.separator + zmax_file); // save MAX projection as .tif
	// Note: zmax_name is also the name of the max projection window. stack_name is that of the z-stack
	close("*");
	print("done");
	}

