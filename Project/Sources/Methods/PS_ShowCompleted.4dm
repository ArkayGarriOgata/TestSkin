//%attributes = {}
// -------
// Method: PS_ShowCompleted   ( ) ->
// By: Mel Bohince @ 04/21/17, 16:13:27
// Description
// give ui to hide or show completed sequences since Frank seldom clears them
// ----------------------------------------------------

$canMakeChanges:=User in group:C338(Current user:C182; "RoleOperations")
Case of 
	: ($1="hide")
		bShowCompleted:=0
		Case of 
			: (sCriterion1="All")
				QUERY:C277([ProductionSchedules:110];  & ; [ProductionSchedules:110]Completed:23=0)  // Modified by: Mel Bohince (4/21/17) 
				PS_qryPrintingOnly("selection")  // Modified by: Mel Bohince (4/21/17) 
				
				pressBackLog:=Sum:C1([ProductionSchedules:110]DurationSeconds:9)/3600
				ORDER BY:C49([ProductionSchedules:110]; [ProductionSchedules:110]StartDate:4; >; [ProductionSchedules:110]StartTime:5; >)
				UNLOAD RECORD:C212([ProductionSchedules:110])
				
			: (sCriterion1="D/C")
				QUERY:C277([ProductionSchedules:110];  & ; [ProductionSchedules:110]Completed:23=0)  // Modified by: Mel Bohince (4/21/17) 
				PS_qryDieCuttingOnly("selection")  // Modified by: Mel Bohince (4/21/17) 
				
				pressBackLog:=Sum:C1([ProductionSchedules:110]DurationSeconds:9)/3600
				ORDER BY:C49([ProductionSchedules:110]; [ProductionSchedules:110]StartDate:4; >; [ProductionSchedules:110]StartTime:5; >)
				UNLOAD RECORD:C212([ProductionSchedules:110])
				
			Else 
				If ($canMakeChanges)
					READ WRITE:C146([ProductionSchedules:110])  //controled at the layout level
				End if 
				
				$settings:=PS_Settings("get"; sCriterion1)
				If (Records in selection:C76([Cost_Centers:27])>0)
					pressBackLog:=PS_qryCurrentBackLog(sCriterion1)
					
				Else 
					BEEP:C151
					ALERT:C41(sCriterion1+" was not found.")
					sCriterion1:=""
					$settings:=PS_Settings("reset")
				End if 
		End case 
		
	: ($1="show")
		bShowCompleted:=1
		Case of 
			: (sCriterion1="All")
				PS_qryPrintingOnly  // Modified by: Mel Bohince (4/21/17) 
				pressBackLog:=Sum:C1([ProductionSchedules:110]DurationSeconds:9)/3600
				ORDER BY:C49([ProductionSchedules:110]; [ProductionSchedules:110]StartDate:4; >; [ProductionSchedules:110]StartTime:5; >)
				UNLOAD RECORD:C212([ProductionSchedules:110])
				
			: (sCriterion1="D/C")
				PS_qryDieCuttingOnly  // Modified by: Mel Bohince (4/21/17) 
				pressBackLog:=Sum:C1([ProductionSchedules:110]DurationSeconds:9)/3600
				ORDER BY:C49([ProductionSchedules:110]; [ProductionSchedules:110]StartDate:4; >; [ProductionSchedules:110]StartTime:5; >)
				UNLOAD RECORD:C212([ProductionSchedules:110])
				
			Else 
				If ($canMakeChanges)
					READ WRITE:C146([ProductionSchedules:110])  //controled at the layout level
				End if 
				
				$settings:=PS_Settings("get"; sCriterion1)
				If (Records in selection:C76([Cost_Centers:27])>0)
					pressBackLog:=PS_qryCurrentBackLog(sCriterion1)
					
				Else 
					BEEP:C151
					ALERT:C41(sCriterion1+" was not found.")
					sCriterion1:=""
					$settings:=PS_Settings("reset")
				End if 
		End case 
		
End case 

