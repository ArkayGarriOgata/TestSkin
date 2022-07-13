//%attributes = {}

// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 08/18/11, 14:53:43
// ----------------------------------------------------
// Method: FG_SetGluerDemand
// Description
// set the next release and qty for use by gluer schedule in PS_Gluers_Load_Arrays
//
// Parameters
// ----------------------------------------------------

If (Not:C34(<>modification4D_10_05_19))  // BEGIN 4D Professional Services : Query With array
	
	READ ONLY:C145([Job_Forms_Items:44])
	QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]Completed:39=!00-00-00!)
	
	ARRAY TEXT:C222($aCPN; 0)
	DISTINCT VALUES:C339([Job_Forms_Items:44]ProductCode:3; $aCPN)
	READ WRITE:C146([Finished_Goods:26])
	QUERY WITH ARRAY:C644([Finished_Goods:26]ProductCode:1; $aCPN)
	
Else 
	
	READ WRITE:C146([Finished_Goods:26])
	QUERY:C277([Finished_Goods:26]; [Job_Forms_Items:44]Completed:39=!00-00-00!)
	
End if   // END 4D Professional Services : January 2019 

C_LONGINT:C283($i; $numRecs)

$numRecs:=Records in selection:C76([Finished_Goods:26])
uThermoInit($numRecs; "Updating GluerDemand in FG Records")
For ($i; 1; $numRecs)
	//param 2 set to zero to get next release, use 1 if you want next "uncovered" release
	[Finished_Goods:26]Gluer_NextRelease:112:=JMI_getNextReleaseDate([Finished_Goods:26]ProductCode:1; 0)
	[Finished_Goods:26]Gluer_ReleaseQty:113:=JMI_getNextReleaseQty([Finished_Goods:26]ProductCode:1; 0)
	SAVE RECORD:C53([Finished_Goods:26])
	NEXT RECORD:C51([Finished_Goods:26])
	uThermoUpdate($i)
End for 
uThermoClose
//
