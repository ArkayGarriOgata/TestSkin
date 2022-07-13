//%attributes = {"publishedWeb":true}
//PM: PS_qryCurrentBackLog() -> 
//@author mlb - 6/18/02  11:59

C_TEXT:C284($1)
C_REAL:C285($0)

If ($1#"All")
	
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
		QUERY:C277([ProductionSchedules:110]; [ProductionSchedules:110]CostCenter:1=$1)
		If (bShowCompleted=0)
			QUERY SELECTION:C341([ProductionSchedules:110]; [ProductionSchedules:110]Completed:23=0)
		End if 
	Else 
		If (bShowCompleted=0)
			QUERY:C277([ProductionSchedules:110]; [ProductionSchedules:110]Completed:23=0; *)
		End if 
		QUERY:C277([ProductionSchedules:110]; [ProductionSchedules:110]CostCenter:1=$1)
	End if   // END 4D Professional Services : January 2019 query selection
	
	
Else 
	PS_qryPrintingOnly
	If (bShowCompleted=0)
		QUERY SELECTION:C341([ProductionSchedules:110]; [ProductionSchedules:110]Completed:23=0)
	End if 
End if 

If (Records in selection:C76([ProductionSchedules:110])>0)
	$0:=Sum:C1([ProductionSchedules:110]DurationSeconds:9)/3600
	ORDER BY:C49([ProductionSchedules:110]; [ProductionSchedules:110]Priority:3; >; [ProductionSchedules:110]StartDate:4; >)
Else 
	$0:=0
End if 

zwStatusMsg("SCHED"; $1+" has been refreshed")