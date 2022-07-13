// -------
// Method: [zz_control].PressSchedule.ThruPutView   ( ) ->
// By: Mel Bohince @ 08/24/16, 15:44:41
// Description
// show only the thruput marked sequences
// ----------------------------------------------------
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
	
	
	Case of 
		: (sCriterion1="All")
			PS_qryPrintingOnly
			
		: (sCriterion1="D/C")
			PS_qryDieCuttingOnly
			
		Else 
			QUERY:C277([ProductionSchedules:110]; [ProductionSchedules:110]CostCenter:1=sCriterion1)
	End case 
	
	QUERY SELECTION:C341([ProductionSchedules:110]; [ProductionSchedules:110]ThruPutValueOfJob:78>=0)
	
	
Else 
	
	C_LONGINT:C283($cnt_of_presses; $press)
	C_TEXT:C284($press_ids)
	
	Case of 
		: (sCriterion1="All")
			zwStatusMsg("SCHED"; "All press filter has been applied")
			$press_ids:=txt_Trim(<>PRESSES)
			$cnt_of_presses:=Num:C11(util_TextParser(16; $press_ids; Character code:C91(" "); 13))
			ARRAY TEXT:C222($_CostCenter; $cnt_of_presses)
			For ($press; 1; $cnt_of_presses)
				$_CostCenter{$press}:=util_TextParser($press)
			End for 
			
			QUERY WITH ARRAY:C644([ProductionSchedules:110]CostCenter:1; $_CostCenter)
			QUERY SELECTION:C341([ProductionSchedules:110]; [ProductionSchedules:110]ThruPutValueOfJob:78>=0)
			
		: (sCriterion1="D/C")
			zwStatusMsg("SCHED"; "All die cutting filter has been applied")
			$press_ids:=txt_Trim(<>BLANKERS)
			$cnt_of_presses:=Num:C11(util_TextParser(16; $press_ids; Character code:C91(" "); 13))
			ARRAY TEXT:C222($_CostCenter; $cnt_of_presses)
			For ($press; 1; $cnt_of_presses)
				$_CostCenter{$press}:=util_TextParser($press)
			End for 
			
			QUERY WITH ARRAY:C644([ProductionSchedules:110]CostCenter:1; $_CostCenter)
			QUERY SELECTION:C341([ProductionSchedules:110]; [ProductionSchedules:110]ThruPutValueOfJob:78>=0)
			
		Else 
			QUERY:C277([ProductionSchedules:110]; [ProductionSchedules:110]CostCenter:1=sCriterion1; *)
			QUERY:C277([ProductionSchedules:110]; [ProductionSchedules:110]ThruPutValueOfJob:78>=0)
			
	End case 
	
End if   // END 4D Professional Services : January 2019 query selection

ORDER BY:C49([ProductionSchedules:110]; [ProductionSchedules:110]ThruPutValueOfJob:78; <)