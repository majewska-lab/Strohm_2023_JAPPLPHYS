
#@ File (label = "Input directory", style = "directory") input
#@ File (label = "Output directory", style = "directory") output
#@ String (label = "File suffix", value = "T1_Object Predictions_binary.tif") suffix


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

// Combine stacks and rename 
	for (i = 1; i < 13; i++) {
	file_name = replace(file,"T1","T"+i);
	open(input+ File.separator + file_name);
	rename(i);}
	run("Concatenate...", "  image1=1 image2=2 image3=3 image4=4 image5=5 image6=6 image7=7 image8=8 image9=9 image10=10 image11=11 image12=12");
	selectWindow("Untitled");
	
	//savefile
	selectWindow("Untitled");
	saveAs('tiff',output + File.separator + file_name + "_combined.tif");
	
	close("*");
}
