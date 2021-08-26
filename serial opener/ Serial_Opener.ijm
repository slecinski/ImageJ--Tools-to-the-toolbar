/* Aim of the macro : Avoid loading manually each image to analyse (e.g take intensities measurments for all images in my datafile)
 * Description : Load images from a selected directory, on demand =  clicking the "OK" button from the inactive message window will load the next image in the directory 
 * - With option to keep or not the result table between each image loaded - same for keeping or not the previous image open when loading the next.
 * - Work for tif and czi image format
 */
 
 
#@ File(label="Select directory", style="directory") Source_Directory
#@ Boolean(label="<html>Before loading the next image:  Keep result table ?</html>") ResultTable
#@ Boolean(label="Clean imageJ (close image(s) open)?") ImClean



Loadsavepath = Source_Directory + File.separator ;
listFileInDir = getFileList(Loadsavepath);
print("Name of files opened:");

//start the batch 
for (b=0; b<lengthOf(listFileInDir); b++) {
	showProgress(b/lengthOf(listFileInDir));
	filename = listFileInDir[b];	
	if (endsWith(filename, "czi") || endsWith(filename, "tif")) {   // Line to detect the czi or tif files (replace with prefered format if needed)
		openImpath = Loadsavepath+filename;
		print(filename);
		run("Bio-Formats Importer", "open=["+openImpath+"] autoscale color_mode=Default view=Hyperstack stack_order=XYCZT ");
		ImInitial = getTitle();
		selectWindow(ImInitial);
/////////
		waitForUser("Do your things", "load next image");
/////////
		if (ResultTable == true) {
			if (ImClean == true){  // keep resultable and clean imagej
				close("*");
			}
			else {  // keep resultable and keep images
				//Do nothing
			}	
		}
		else {
			if (ImClean == true){  // clean result table and clean imageJ
				run("Clear Results");
				close("*");
			}
			else {  // clean result table and keep images
				run("Clear Results");
			}
		}
	}
}
showMessage("That was the last images");
