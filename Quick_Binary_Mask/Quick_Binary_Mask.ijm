// Aim of the macro : Create a binary mask from ROI selections and/or overlays 
// Description : Detect overlays or selection stored in ROI-Manager and generate a black & white binary mask accordingly
// when no selection are found - the macro will pause and ask for selections - clicking "OK" without adding new selections will generate a default 8bit binary mask


if (nImages == 0) {
	showMessage("Macro error", "There is no images open");
	exit
}

//// Manage Overlay if there is
RoiCount = roiManager("count");
if (Overlay.size != 0){
	run("To ROI Manager"); 
	RoiCount = roiManager("count");
}
else {
	if (RoiCount == 0) {
		waitForUser("Create ROIs","Create ROI(s) and Click OK to continue \n If no ROI added image will be converted in an 8bit binary mask");
		RoiCount = roiManager("count");
		if (RoiCount ==0){
			run("8-bit");
			run("Make Binary");
			run("Convert to Mask");
			exit
		}
	}
}	

id = getImageID();
run("8-bit");
n = roiManager('count');
for (i = 0; i < n; i++) {
   	roiManager('select', i);
   	run("Set...", "value=255");
   	changeValues(0, 255, 255);
}

roiManager("deselect");
roiManager("Combine");
run("Make Inverse");
changeValues(0, 255, 0);
run("Convert to Mask");
