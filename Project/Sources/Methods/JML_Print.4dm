//%attributes = {"publishedWeb":true}
//doAECprint

dDate:=4D_Current_date
tTime:=4d_Current_time

uYesNoCancel("Which style report would you like?"; "Screen Shot"; "Job Track"; "Rel Histogram")
Case of 
	: (bAccept=1)
		util_PAGE_SETUP(->[Job_Forms_Master_Schedule:67]; "ScreenShot")
		FORM SET OUTPUT:C54([Job_Forms_Master_Schedule:67]; "ScreenShot")
		PRINT SELECTION:C60([Job_Forms_Master_Schedule:67])
		
	: (bNo=1)
		t2:="JOB TRACKING MASTER LOG"
		t2b:=""
		t3:=""
		util_PAGE_SETUP(->[Job_Forms_Master_Schedule:67]; "JobTrack")
		FORM SET OUTPUT:C54([Job_Forms_Master_Schedule:67]; "JobTrack")
		PRINT SELECTION:C60([Job_Forms_Master_Schedule:67])
		
	Else 
		JML_ReleaseDistribution
		
End case 

FORM SET OUTPUT:C54([Job_Forms_Master_Schedule:67]; "List")