// ----------------------------------------------------
// Method: [zz_control].PressSchedule.canSchedClear   ( ) ->
// By: Mel Bohince @ 01/20/16, 18:33:44
// Description
// remove completed items from this schedule
// ----------------------------------------------------

//CUT NAMED SELECTION([ProductionSchedules];"hold")
If (Records in set:C195("clickedIncludeRecord")>0)
	app_Log_Usage("log"; "PS Remove"; "")
	USE SET:C118("clickedIncludeRecord")  //use POs user selected to process
	
	QUERY SELECTION:C341([ProductionSchedules:110]; [ProductionSchedules:110]CostCenter:1=sCriterion1; *)  //
	QUERY SELECTION:C341([ProductionSchedules:110];  & ; [ProductionSchedules:110]Completed:23>0)
	
	If (Records in selection:C76([ProductionSchedules:110])>0)
		uConfirm("Remove "+String:C10(Records in selection:C76([ProductionSchedules:110]))+" completed sequences?"; "Delete"; "Cancel")
		If (ok=1)
			util_DeleteSelection(->[ProductionSchedules:110])
		End if 
		
	Else 
		uConfirm("Selected sequences were not completed."; "Ok"; "Cancel")
	End if 
	
Else 
	uConfirm("Select the completed sequences to delete first."; "Ok"; "Cancel")
End if 

pressBackLog:=PS_qryCurrentBackLog(sCriterion1)