//Split image into 12 separate time points
//MaKenna Cealie

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
			processFile(input, output, suffix, list[i]);
	}

// Runs analysis on each file in input folder with correct extension
function processFile(input, output, suffix, file) {
	
	// Do the processing here by adding your own code.
	close("*");
	print("Processing: " + file);
	path = input + File.separator + file;
	open(path); // open the file
	stack_name = File.getName(path);
	nosuff = File.getNameWithoutExtension(path);
	selectWindow(stack_name);

run("Stack Splitter", "number=12");


	//Goes through each of the 12 time points in a single image
	for(i = 1; i < 10; i++) {
//		t_frame = i+1; // this is the time frame
		print("Processing time: " + i);
		selectWindow("slice000"+i+"_"+ stack_name);
		saveAs("tiff", output + File.separator + stack_name+ "_T"+i);}
	for(i = 10; i < 13; i++) {
//		t_frame = i+1; // this is the time frame
		print("Processing time: " + i);
		selectWindow("slice00"+i+"_"+ stack_name);
		saveAs("tiff", output + File.separator + stack_name+ "_T"+i);}
	close("*");
	print("Image DONE");
	}
print("All Files DONE!");
}