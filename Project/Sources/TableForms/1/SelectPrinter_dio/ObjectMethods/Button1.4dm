If (Length:C16(<>aPrinterNames{0})>0)
	READ ONLY:C145([zz_control:1])
	ALL RECORDS:C47([zz_control:1])
	
	SET CURRENT PRINTER:C787(<>aPrinterNames{0})
	//PRINT SETTINGS
	//Print form([CONTROL];"TestPrint")
	util_PAGE_SETUP(->[WMS_Label_Tracking:75]; "portrait")
	//OUTPUT FORM([LabelTracking];"portrait")
	Print form:C5([WMS_Label_Tracking:75]; "portrait")
	PAGE BREAK:C6
	
	
	FIRST RECORD:C50([WMS_Label_Tracking:75])
	util_PAGE_SETUP(->[WMS_Label_Tracking:75]; "landscape")
	//OUTPUT FORM([LabelTracking];"landscape")
	Print form:C5([WMS_Label_Tracking:75]; "landscape")
	PAGE BREAK:C6
	
	
Else 
	BEEP:C151
	ALERT:C41("Select a Printer's name from the combo box.")
End if 