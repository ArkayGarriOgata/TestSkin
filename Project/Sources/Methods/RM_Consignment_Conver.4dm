//%attributes = {"publishedWeb":true}
//(P) uConvConsign

//Open window(2;45;317;200;8;nGetPrcsName ;"wCloseCancel")
$winRef:=OpenFormWindow(->[Raw_Materials:21]; "RMconsignment")
SET MENU BAR:C67(4)
READ WRITE:C146([Raw_Materials_Locations:25])
READ ONLY:C145([Purchase_Orders_Items:12])
READ ONLY:C145([Raw_Materials:21])
DIALOG:C40([Raw_Materials:21]; "RMconsignment")
If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : UNLOAD RECORD
	
	UNLOAD RECORD:C212([Purchase_Orders_Items:12])
	UNLOAD RECORD:C212([Raw_Materials:21])
	
	
Else 
	
	// you have read only mode
	
	
	
End if   // END 4D Professional Services : January 2019 
UNLOAD RECORD:C212([Raw_Materials_Locations:25])
CLOSE WINDOW:C154($winRef)
uWinListCleanup