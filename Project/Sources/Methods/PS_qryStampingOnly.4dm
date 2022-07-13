//%attributes = {}
// -------
// Method: PS_qryStampingOnly   ( ) ->
// By: Mel Bohince @ 10/05/16, 08:10:43
// Description
// based on PS_qryDieCuttingOnly
// ----------------------------------------------------
// Modified by: Mel Bohince (1/28/19) swithc to QWA

CostCtrInit  // Modified by: Mel Bohince (7/9/21) //set up group ipv's

C_TEXT:C284($1; $2)
C_LONGINT:C283($0; $press)  //$cnt_of_presses
//C_TEXT($press_ids)

// Modified by: Mel Bohince (3/28/16) make maintence easier
//$press_ids:=txt_Trim (<>STAMPERS)  //load all presses in an array for a build query below
//$cnt_of_presses:=Num(util_TextParser (16;$press_ids;Character code(" ");13))

Case of 
	: (Count parameters:C259=0)
		// ******* possible bug  - 4D PS - January  2019 ********
		
		QUERY WITH ARRAY:C644([ProductionSchedules:110]CostCenter:1; <>aSTAMPERS)  // Modified by: Mel Bohince (1/28/19) see uInit_CostCenterGroups
		//QUERY([ProductionSchedules];[ProductionSchedules]CostCenter=util_TextParser (1);*)
		//For ($press;2;$cnt_of_presses)
		//QUERY([ProductionSchedules]; | ;[ProductionSchedules]CostCenter=util_TextParser ($press);*)
		//End for 
		//QUERY([ProductionSchedules])
		
		// ******* possible bug  - 4D PS - January 2019 (end) *********
		
	: (Count parameters:C259=1)
		QUERY SELECTION WITH ARRAY:C1050([ProductionSchedules:110]CostCenter:1; <>aSTAMPERS)  // Modified by: Mel Bohince (1/28/19) see uInit_CostCenterGroups
		//QUERY SELECTION([ProductionSchedules];[ProductionSchedules]CostCenter=util_TextParser (1);*)
		//For ($press;2;$cnt_of_presses)
		//QUERY SELECTION([ProductionSchedules]; | ;[ProductionSchedules]CostCenter=util_TextParser ($press);*)
		//End for 
		//QUERY SELECTION([ProductionSchedules])
		
	: (Count parameters:C259=2)  //leave search open
		QUERY:C277([ProductionSchedules:110]; [ProductionSchedules:110]CostCenter:1=<>aSTAMPERS{1}; *)
		For ($press; 2; Size of array:C274(<>aSTAMPERS))
			QUERY:C277([ProductionSchedules:110];  | ; [ProductionSchedules:110]CostCenter:1=<>aSTAMPERS{$press}; *)
		End for 
		
End case 

$0:=Records in selection:C76([ProductionSchedules:110])  //
zwStatusMsg("SCHED"; "All die cutting filter has been applied")