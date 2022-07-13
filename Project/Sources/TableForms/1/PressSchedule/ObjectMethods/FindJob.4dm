//util_FindAndHighlight (->[ProductionSchedules]JobSequence)
// Modified by: Mel Bohince (10/26/15) 
$mode:=OBJECT Get title:C1068(*; "FindJob")

If ($mode="Find Job...")
	GET HIGHLIGHTED RECORDS:C902([ProductionSchedules:110]; "focus")
	CUT NAMED SELECTION:C334([ProductionSchedules:110]; "before")
	USE SET:C118("focus")
	
	$currentSequence:=Substring:C12([ProductionSchedules:110]JobSequence:8; 1; 8)
	$jobform:=Request:C163("Find which jobform?"; $currentSequence; "Find"; "Cancel")
	If (ok=1)
		If (Length:C16($jobform)>4)
			QUERY:C277([ProductionSchedules:110]; [ProductionSchedules:110]JobSequence:8=($jobform+"@"))
			ORDER BY:C49([ProductionSchedules:110]; [ProductionSchedules:110]JobSequence:8; >)
			
			OBJECT SET TITLE:C194(*; "FindJob"; sCriterion1)
			
		Else 
			uConfirm("Enter at least the job number."; "Ok"; "Try again")
			USE NAMED SELECTION:C332("before")
		End if 
		
	Else 
		USE NAMED SELECTION:C332("before")
	End if 
	
Else   //restore
	USE NAMED SELECTION:C332("before")
	OBJECT SET TITLE:C194(*; "FindJob"; "Find Job...")
End if 