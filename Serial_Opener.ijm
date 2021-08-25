/*
 * Script to just load images one after and other and work on them in beetween
 * can choose to keep the result table in between
 * 
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
	if (endsWith(filename, "czi") || endsWith(filename, "tif")) {   // change extension here , line code to detect the czi or tif extension
		openImpath = Loadsavepath+filename;
		print(filename);
		run("Bio-Formats Importer", "open=["+openImpath+"] autoscale color_mode=Default view=Hyperstack stack_order=XYCZT ");
		ImInitial = getTitle();
		selectWindow(ImInitial);
/////////
		waitForUser("Do your things", "OK to close all & load next image");
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