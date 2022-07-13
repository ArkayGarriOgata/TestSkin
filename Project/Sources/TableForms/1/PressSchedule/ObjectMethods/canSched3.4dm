//OM: bMove() -> 
//@author mlb - 12/5/01  12:01
C_TEXT:C284($press)

$numSelected:=Records in set:C195("clickedIncludeRecord")
If ($numSelected>0)
	USE SET:C118("clickedIncludeRecord")  //use POs user selected to process
	//target to move to:
	Case of 
		: (Position:C15(sCriterion1; <>PRESSES)>0)
			$press:=Request:C163("Move to which press?("+<>PRESSES+")"; "417"; "Move"; "Cancel")
		: (Position:C15(sCriterion1; <>SHEETERS)>0)
			$press:=Request:C163("Move to which sheeter?("+<>SHEETERS+")"; "428"; "Move"; "Cancel")
		: (Position:C15(sCriterion1; <>STAMPERS)>0)
			$press:=Request:C163("Move to which stamper?("+<>STAMPERS+")"; "452"; "Move"; "Cancel")
		: (Position:C15(sCriterion1; <>BLANKERS)>0)
			$press:=Request:C163("Move to which die cutter?("+<>BLANKERS+")"; "467"; "Move"; "Cancel")
		Else 
			$press:=Request:C163("Move to which schedule?"; ""; "Move"; "Cancel")
	End case 
	
	QUERY:C277([Cost_Centers:27]; [Cost_Centers:27]ID:1=$press)
	If (Records in selection:C76([Cost_Centers:27])>0)
		
		app_Log_Usage("log"; "PS Move"; sCriterion1+": "+String:C10($numSelected)+" moved to "+$press)
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
			
			FIRST RECORD:C50([ProductionSchedules:110])
			For ($seq; 1; $numSelected)
				[ProductionSchedules:110]Priority:3:=0
				[ProductionSchedules:110]CostCenter:1:=$press
				[ProductionSchedules:110]Name:2:=[Cost_Centers:27]Description:3
				//PS_moveToOtherPlant ($oldFacility;[Cost_Centers]CompanyID)
				SAVE RECORD:C53([ProductionSchedules:110])
				NEXT RECORD:C51([ProductionSchedules:110])
			End for 
		Else 
			
			APPLY TO SELECTION:C70([ProductionSchedules:110]; [ProductionSchedules:110]Priority:3:=0)
			APPLY TO SELECTION:C70([ProductionSchedules:110]; [ProductionSchedules:110]CostCenter:1:=$press)
			APPLY TO SELECTION:C70([ProductionSchedules:110]; [ProductionSchedules:110]Name:2:=[Cost_Centers:27]Description:3)
			
		End if   // END 4D Professional Services : January 2019 First record
		
		
	Else 
		uConfirm("C/C specified, "+$press+", was not found, no Moves."; "Ok"; "Dang")
	End if   //$press is valid
	
	pressBackLog:=PS_qryCurrentBackLog(sCriterion1)
	FORM GOTO PAGE:C247(1)
	
	$pid:=PS_pid_mgr("pid"; $press)
	SHOW PROCESS:C325($pid)
	BRING TO FRONT:C326($pid)
	POST OUTSIDE CALL:C329($pid)
	
Else 
	uConfirm("Select the sequences to Move first."; "Ok"; "Cancel")
End if   //some selections

