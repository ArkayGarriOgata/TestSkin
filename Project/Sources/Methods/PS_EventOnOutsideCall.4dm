//%attributes = {"publishedWeb":true}
//PM: PS_EventOnOutsideCall() -> 
//@author mlb - 6/7/02  12:01

// Modified by: MelvinBohince (1/27/22) update fields that may have changed

Case of 
	: (False:C215)  // Modified by: MelvinBohince (1/27/22) update fields that may have changed// Modified by: MelvinBohince (1/28/22) revert
		CUT NAMED SELECTION:C334([ProductionSchedules:110]; "refresh")
		USE NAMED SELECTION:C332("refresh")
		
	: (sCriterion1="All")
		PS_qryPrintingOnly
		If (bShowCompleted=0)
			// ******* Verified  - 4D PS - January  2019 ********
			
			QUERY SELECTION:C341([ProductionSchedules:110]; [ProductionSchedules:110]Completed:23=0)
			
			
			// ******* Verified  - 4D PS - January 2019 (end) *********
		End if 
		
		pressBackLog:=Sum:C1([ProductionSchedules:110]DurationSeconds:9)/3600
		ORDER BY:C49([ProductionSchedules:110]; [ProductionSchedules:110]StartDate:4; >; [ProductionSchedules:110]StartTime:5; >)
		
	: (sCriterion1="D/C")
		PS_qryDieCuttingOnly
		If (bShowCompleted=0)
			// ******* Verified  - 4D PS - January  2019 ********
			
			QUERY SELECTION:C341([ProductionSchedules:110]; [ProductionSchedules:110]Completed:23=0)
			
			
			// ******* Verified  - 4D PS - January 2019 (end) *********
		End if 
		pressBackLog:=Sum:C1([ProductionSchedules:110]DurationSeconds:9)/3600
		ORDER BY:C49([ProductionSchedules:110]; [ProductionSchedules:110]StartDate:4; >; [ProductionSchedules:110]StartTime:5; >)
		
	Else 
		If (Length:C16(sCriterion1)<5)  //be a little more defensive
			pressBackLog:=PS_qryCurrentBackLog(sCriterion1)
		End if 
End case 

UNLOAD RECORD:C212([ProductionSchedules:110])

CREATE SET:C116([ProductionSchedules:110]; "startingSelection")

BEEP:C151  // Modified by: MelvinBohince (1/28/22) 
