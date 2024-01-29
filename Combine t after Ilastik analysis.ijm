// Macro to pre-process hyperstacks from 2-photon imaging (Olympus Fluoview computer)
//  (1) Convert image to hyperstack (fluoview output is in 'xyztc', different than default for imageJ
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
	close("*");
	print("Processing: " + file);
	open(input + File.separator + file);
	file_name = replace(file,"T1_Object Predictions_.tiff","");
	selectWindow(file);
	rename(1);
	setAutoThreshold("Default dark");
	setThreshold(1, 255, "raw");
	run("Convert to Mask");
	// Combine stacks and rename 
	for (i = 2; i < 10; i++) {
	open(input+ File.separator + file_name+"T"+i+"_Object Predictions_.tiff");
	rename(i);
	setAutoThreshold("Default dark"); //Scale binary post Ilastik only 
	setThreshold(1, 255, "raw");
	run("Convert to Mask");}
	for (i = 10; i < 12; i++) {
	open(input+ File.separator + file_name+i+"_Object Predictions_.tiff");
	rename(i);
	setAutoThreshold("Default dark");//Scale binary post Ilastik only 
	setThreshold(1, 255, "raw");
	run("Convert to Mask");}
	
	run("Concatenate...", "  image1=1 image2=2 image3=3 image4=4 image5=5 image6=6 image7=7 image8=8 image9=9 image10=10 image11=11 image12=12");
	//image13=13 image14=14 image15=15
	selectWindow("Untitled");
	//Run line 63-68 if getting soma ROI for motility analysis 
	/*for (a=0; a<50; a++){ run("Dilate", "stack");}
	roiManager("reset");
	run("Analyze Particles...", "size=250-Infinity circularity=0.3-1.00 show=Overlay stack");
	run("To ROI Manager");
	roiManager("Save", output + File.separator+ file_name+"Ilastik_soma.zip");
	roiManager("reset");*/
	saveAs('tiff',output + File.separator + file_name+"Ilastik");
	close("*");
}
