//%attributes = {"publishedWeb":true}
//PM: JML_PressScheduleComplete() -> 
//@author mlb - 4/17/02  11:48
// Modified by: Mel Bohince (3/4/14) let marking complete set date on JML,to assist gluer scheduling
app_Log_Usage("log"; "PS Completed"; [ProductionSchedules:110]JobSequence:8)

If (app_LoadIncludedSelection("init"; ->[ProductionSchedules:110]JobSequence:8)>0)
	If (sCriterion1=[ProductionSchedules:110]CostCenter:1)
		$onlyMark:=True:C214
		If (User in group:C338(Current user:C182; "RoleOperations"))
			uConfirm("Only Mark "+[ProductionSchedules:110]JobSequence:8+" as Complete or Remove?"; "Only Mark"; "Remove")
			If (ok=0)
				$onlyMark:=False:C215
				If ([ProductionSchedules:110]JobSequence:8#"Blocked")
					uConfirm("Remove "+[ProductionSchedules:110]JobSequence:8+" from the schedule?"; "Remove"; "Cancel")
					If (ok=1)
						If ([ProductionSchedules:110]Completed:23=0)  //• mlb - 6/18/02  10:44 two stage complete
							[ProductionSchedules:110]Completed:23:=TSTimeStamp
							SAVE RECORD:C53([ProductionSchedules:110])  //its going to be deleted, but need this for JML updates
							PF_SendEndTask([ProductionSchedules:110]JobSequence:8; sCriterion1; 0)
						End if 
						
						Case of 
							: (Position:C15(sCriterion1; <>PRESSES)>0)
								PS_CompleteJML
								
							: (Position:C15(sCriterion1; <>SHEETERS)>0)
								PS_CompleteJML(->[Job_Forms_Master_Schedule:67]DateStockSheeted:47)
								
							: (Position:C15(sCriterion1; <>STAMPERS)>0)
								
							: (Position:C15(sCriterion1; <>BLANKERS)>0)
								PS_CompleteJML(->[Job_Forms_Master_Schedule:67]GlueReady:28)
						End case 
						
						PS_CompleteBudget
						
						DELETE RECORD:C58([ProductionSchedules:110])
						
					Else   //offer to remove completed
						uConfirm("Remove completed date from "+[ProductionSchedules:110]JobSequence:8+"?"; "Yes"; "Nope")
						If (ok=1)
							[ProductionSchedules:110]Completed:23:=0
							SAVE RECORD:C53([ProductionSchedules:110])
						End if 
					End if 
					
				Else   //blocked time
					uConfirm("Remove the blocked time called "+[ProductionSchedules:110]Customer:11+" "+[ProductionSchedules:110]Line:10+"?"; "Remove"; "Keep")
					If (ok=1)
						DELETE RECORD:C58([ProductionSchedules:110])
					End if 
				End if   //blocked
			Else 
				$onlyMark:=True:C214
			End if 
		End if   //role operations
		////////////////
		
		If ($onlyMark)  //pressman
			If ([ProductionSchedules:110]JobSequence:8#"Blocked")
				If ([ProductionSchedules:110]Completed:23=0)  //• mlb - 6/18/02  10:44 two stage complete
					uConfirm("Mark "+[ProductionSchedules:110]JobSequence:8+" as Completed?"; "Complete"; "Cancel")
					If (ok=1)
						PS_updateRecord(->[ProductionSchedules:110]Completed:23; TSTimeStamp)
						PF_SendEndTask([ProductionSchedules:110]JobSequence:8; sCriterion1; 0)
						Case of   // Modified by: Mel Bohince (3/4/14) let marking complete set date on JML
							: (Position:C15(sCriterion1; <>PRESSES)>0)
								PS_CompleteJML
								
							: (Position:C15(sCriterion1; <>SHEETERS)>0)
								PS_CompleteJML(->[Job_Forms_Master_Schedule:67]DateStockSheeted:47)
								
							: (Position:C15(sCriterion1; <>STAMPERS)>0)
								
							: (Position:C15(sCriterion1; <>BLANKERS)>0)
								PS_CompleteJML(->[Job_Forms_Master_Schedule:67]GlueReady:28)
						End case 
						
						//PS_MakeReadyTimerNextStart 
					End if 
					
				Else 
					uConfirm("Remove completed date from "+[ProductionSchedules:110]JobSequence:8+"?"; "Yes"; "Nope")
					If (ok=1)
						PS_updateRecord(->[ProductionSchedules:110]Completed:23; 0)
					End if 
				End if 
				
			Else   //blocked
				BEEP:C151
				zwStatusMsg("ERROR"; "Not authorized to remove blocked time")
			End if   //not blocked  
		End if 
		
		pressBackLog:=PS_qryCurrentBackLog(sCriterion1)
		
		PS_setPageBasedOnAccess
	End if 
	
	app_LoadIncludedSelection("clear"; ->[ProductionSchedules:110]JobSequence:8)
End if 