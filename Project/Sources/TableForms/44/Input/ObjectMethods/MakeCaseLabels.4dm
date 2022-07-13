// ----------------------------------------------------
// Method: [Job_Forms_Items].Input.MakeCaseLabels   ( ) ->
// By: Mel Bohince @ 04/07/16, 20:21:53
// Description
// mockup so labels can be printed for testing
// ----------------------------------------------------

If (False:C215)  //see also which uses [Job_Forms_Items_Labels] for the zebra printer
	$counter:=Zebra_CaseNumberManager("find"; [Job_Forms_Items:44]Jobit:4)
End if 

uConfirm("Make JPSI records for scan tests?"; "Yes"; "Cancel")
If (ok=1)
	
	
	READ WRITE:C146([JPSI_Job_Physical_Support_Items:111])
	ALL RECORDS:C47([JPSI_Job_Physical_Support_Items:111])
	util_DeleteSelection(->[JPSI_Job_Physical_Support_Items:111])
	
	For ($i; 1; 40)
		CREATE RECORD:C68([JPSI_Job_Physical_Support_Items:111])
		[JPSI_Job_Physical_Support_Items:111]ID:1:=Substring:C12(String:C10($i+TSTimeStamp); 4)
		SAVE RECORD:C53([JPSI_Job_Physical_Support_Items:111])
	End for 
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
		
		
		ALL RECORDS:C47([JPSI_Job_Physical_Support_Items:111])
		FIRST RECORD:C50([JPSI_Job_Physical_Support_Items:111])
		APPLY TO SELECTION:C70([JPSI_Job_Physical_Support_Items:111]; [JPSI_Job_Physical_Support_Items:111]ItemType:2:=WMS_CaseId(""; "set"; [Job_Forms_Items:44]Jobit:4; Selected record number:C246([JPSI_Job_Physical_Support_Items:111]); 1000))
		
		FIRST RECORD:C50([JPSI_Job_Physical_Support_Items:111])
		APPLY TO SELECTION:C70([JPSI_Job_Physical_Support_Items:111]; [JPSI_Job_Physical_Support_Items:111]Location:5:=[Job_Forms_Items:44]ProductCode:3)
		
		FIRST RECORD:C50([JPSI_Job_Physical_Support_Items:111])
		APPLY TO SELECTION:C70([JPSI_Job_Physical_Support_Items:111]; [JPSI_Job_Physical_Support_Items:111]Description:4:=WMS_CaseId([JPSI_Job_Physical_Support_Items:111]ItemType:2; "barcode"))
		
	Else 
		
		ALL RECORDS:C47([JPSI_Job_Physical_Support_Items:111])
		APPLY TO SELECTION:C70([JPSI_Job_Physical_Support_Items:111]; [JPSI_Job_Physical_Support_Items:111]ItemType:2:=WMS_CaseId(""; "set"; [Job_Forms_Items:44]Jobit:4; Selected record number:C246([JPSI_Job_Physical_Support_Items:111]); 1000))
		APPLY TO SELECTION:C70([JPSI_Job_Physical_Support_Items:111]; [JPSI_Job_Physical_Support_Items:111]Location:5:=[Job_Forms_Items:44]ProductCode:3)
		APPLY TO SELECTION:C70([JPSI_Job_Physical_Support_Items:111]; [JPSI_Job_Physical_Support_Items:111]Description:4:=WMS_CaseId([JPSI_Job_Physical_Support_Items:111]ItemType:2; "barcode"))
		
	End if   // END 4D Professional Services : January 2019 First record
	
	UNLOAD RECORD:C212([JPSI_Job_Physical_Support_Items:111])
	BEEP:C151
	ALERT:C41("40 [JPSI_Job_Physical_Support_Items] records created to make labels for "+[Job_Forms_Items:44]Jobit:4)
End if   //ok


