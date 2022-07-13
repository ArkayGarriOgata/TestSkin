//%attributes = {}

// Method: PSG_NotGlued ( )  -> 
// ----------------------------------------------------
// Author: Mel Bohince
// Created: 06/13/14, 11:53:50
// ----------------------------------------------------
// Description
// if no gluing or flatpacking specified, set gluer to "NOT" so it's not loaded into glue schedule by PSG_MasterArray("LOAD") & JMI_setGlueDuration
//
// ----------------------------------------------------
// Modified by: Mel Bohince (1/28/19) swithc to QWA

C_LONGINT:C283($form)  //$cnt_of_gluers

//$gluer_ids:=txt_Trim (<>GLUERS)  //load all gluers in an array for a build query below
//$cnt_of_gluers:=Num(util_TextParser (16;$gluer_ids;Character code(" ");13))


READ WRITE:C146([Job_Forms_Items:44])
QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]Completed:39=!00-00-00!)  //these will be the items that need the duration set
//QUERY([Job_Forms_Items]; & ;[Job_Forms_Items]Gluer#"9xx")

DISTINCT VALUES:C339([Job_Forms_Items:44]JobForm:1; $aJobForm)  //visit each form once
$numElements:=Size of array:C274($aJobForm)
$numItemsUpdate:=0
$backlogAdded:=0
uThermoInit($numElements; "Processing Array")
For ($form; 1; $numElements)
	$jobform:=$aJobForm{$form}
	QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=$jobform)
	If (Position:C15([Job_Forms:42]Status:6; " Released WIP ")>0)
		//find the glue sequences in this form's budget
		QUERY:C277([Job_Forms_Machines:43]; [Job_Forms_Machines:43]JobForm:1=$jobform)
		// ******* possible bug  - 4D PS - January  2019 ********
		
		QUERY SELECTION WITH ARRAY:C1050([Job_Forms_Machines:43]CostCenterID:4; <>aGLUERS)  // Modified by: Mel Bohince (1/28/19) see uInit_CostCenterGroups
		//QUERY SELECTION([Job_Forms_Machines];[Job_Forms_Machines]CostCenterID=util_TextParser (1);*)
		//For ($gluer;2;$cnt_of_gluers)
		//QUERY SELECTION([Job_Forms_Machines]; | ;[Job_Forms_Machines]CostCenterID=util_TextParser ($gluer);*)
		//End for 
		//QUERY SELECTION([Job_Forms_Machines])
		
		// ******* possible bug  - 4D PS - January 2019 (end) *********
		
		If (Records in selection:C76([Job_Forms_Machines:43])=0)
			QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]JobForm:1=$jobform)
			APPLY TO SELECTION:C70([Job_Forms_Items:44]; [Job_Forms_Items:44]Gluer:47:="9xx")
		End if 
	End if 
	
	uThermoUpdate($form)
End for 
uThermoClose
util_TextParser