//%attributes = {"publishedWeb":true}
//PM: PS_qryPrintingOnly() -> 
//@author mlb - 5/24/02  10:32
// If you add code here, add it to PS_qryPrintingOnly, uInitInterPrsVar,uInit_CostCenterGroups, MainEventCase, CostCenterEquivalent, and Object Method: [zz_control].MainEvent.Schedule1.
// Modified by: Mel Bohince (5/8/14) make maintence easier
// Modified by: Mel Bohince (1/28/19) swithc to QWA
// Modified by: Mel Bohince (7/9/21) //set up group ipv's

C_TEXT:C284($1; $2)
C_LONGINT:C283($0; $press)  //$cnt_of_presses
//C_TEXT($press_ids)

// Modified by: Mel Bohince (5/8/14) make maintence easier
//$press_ids:=txt_Trim (<>PRESSES)  //load all presses in an array for a build query below
//$cnt_of_presses:=Num(util_TextParser (16;$press_ids;Character code(" ");13))
CostCtrInit  // Modified by: Mel Bohince (7/9/21) //set up group ipv's

Case of 
	: (Count parameters:C259=0)
		QUERY WITH ARRAY:C644([ProductionSchedules:110]CostCenter:1; <>aPRESSES)
		//QUERY([ProductionSchedules];[ProductionSchedules]CostCenter=util_TextParser (1);*)
		//For ($press;2;$cnt_of_presses)
		//QUERY([ProductionSchedules]; | ;[ProductionSchedules]CostCenter=util_TextParser ($press);*)
		//End for 
		//QUERY([ProductionSchedules])
		
	: (Count parameters:C259=1)  //in selection
		QUERY SELECTION WITH ARRAY:C1050([ProductionSchedules:110]CostCenter:1; <>aPRESSES)
		//QUERY SELECTION([ProductionSchedules];[ProductionSchedules]CostCenter=util_TextParser (1);*)
		//For ($press;2;$cnt_of_presses)
		//QUERY SELECTION([ProductionSchedules]; | ;[ProductionSchedules]CostCenter=util_TextParser ($press);*)
		//End for 
		//QUERY SELECTION([ProductionSchedules])
		
	: (Count parameters:C259=2)  //leave search open
		QUERY:C277([ProductionSchedules:110]; [ProductionSchedules:110]CostCenter:1=<>aPRESSES{1}; *)
		For ($press; 2; Size of array:C274(<>aPRESSES))
			QUERY:C277([ProductionSchedules:110];  | ; [ProductionSchedules:110]CostCenter:1=<>aPRESSES{$press}; *)
		End for 
		
End case 

zwStatusMsg("SCHED"; "All press filter has been applied")
$0:=Records in selection:C76([ProductionSchedules:110])