//%attributes = {}
// Method: PS_qryDieCuttingOnly () -> 
// ----------------------------------------------------
// by: mel: 10/07/03, 17:02:15
// ----------------------------------------------------
// Modified by: Mel Bohince (12/5/13)  add 470 remove 476
// Modified by: Mel Bohince (1/28/19) swithc to QWA
CostCtrInit  // Modified by: Mel Bohince (7/9/21) //set up group ipv's

C_TEXT:C284($1; $2)
C_LONGINT:C283($0; $press)  //$cnt_of_presses
//C_TEXT($press_ids)

// Modified by: Mel Bohince (3/28/16) make maintence easier
//$press_ids:=txt_Trim (<>BLANKERS)  //load all presses in an array for a build query below
//$cnt_of_presses:=Num(util_TextParser (16;$press_ids;Character code(" ");13))

Case of 
	: (Count parameters:C259=0)
		QUERY WITH ARRAY:C644([ProductionSchedules:110]CostCenter:1; <>aBLANKERS)
		//QUERY([ProductionSchedules];[ProductionSchedules]CostCenter=util_TextParser (1);*)
		//For ($press;2;$cnt_of_presses)
		//QUERY([ProductionSchedules]; | ;[ProductionSchedules]CostCenter=util_TextParser ($press);*)
		//End for 
		//QUERY([ProductionSchedules])
		
	: (Count parameters:C259=1)  // in selection
		QUERY SELECTION WITH ARRAY:C1050([ProductionSchedules:110]CostCenter:1; <>aBLANKERS)
		
		//QUERY SELECTION([ProductionSchedules];[ProductionSchedules]CostCenter=util_TextParser (1);*)
		//For ($press;2;$cnt_of_presses)
		//QUERY SELECTION([ProductionSchedules]; | ;[ProductionSchedules]CostCenter=util_TextParser ($press);*)
		//End for 
		//QUERY SELECTION([ProductionSchedules])
		
	: (Count parameters:C259=2)  //leave search open
		QUERY:C277([ProductionSchedules:110]; [ProductionSchedules:110]CostCenter:1=<>aBLANKERS{1}; *)
		For ($press; 2; Size of array:C274(<>aBLANKERS))
			QUERY:C277([ProductionSchedules:110];  | ; [ProductionSchedules:110]CostCenter:1=<>aBLANKERS{$press}; *)
		End for 
		
End case 

$0:=Records in selection:C76([ProductionSchedules:110])  //
zwStatusMsg("SCHED"; "All die cutting filter has been applied")