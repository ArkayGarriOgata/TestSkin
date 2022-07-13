//OM: bLoad() -> 
//@author mlb - 12/4/01  14:09
C_LONGINT:C283($x; $y; $state)
GET MOUSE:C468($x; $y; $state; *)
$winRef:=OpenSheetWindow(->[ProductionSchedules:110]; "BlockTime")  //;0;$x;$y-200)
DIALOG:C40([ProductionSchedules:110]; "BlockTime")
CLOSE WINDOW:C154  //($winRef)
If (ok=1)
	
	CREATE RECORD:C68([ProductionSchedules:110])
	[ProductionSchedules:110]JobSequence:8:="Blocked"
	[ProductionSchedules:110]CostCenter:1:=sCriterion1
	[ProductionSchedules:110]Name:2:=[Cost_Centers:27]Description:3
	
	[ProductionSchedules:110]Line:10:=sCriterion3
	[ProductionSchedules:110]Customer:11:=sCriterion2
	
	[ProductionSchedules:110]Priority:3:=Num:C11(sCriterion5)
	[ProductionSchedules:110]StartDate:4:=dDate
	[ProductionSchedules:110]StartTime:5:=tTime
	If (rb1=1)
		[ProductionSchedules:110]FixedStart:12:=True:C214
	Else 
		[ProductionSchedules:110]FixedStart:12:=False:C215
	End if 
	[ProductionSchedules:110]DurationSeconds:9:=Time:C179(sCriterion4)
	
	$start:=TSTimeStamp([ProductionSchedules:110]StartDate:4; [ProductionSchedules:110]StartTime:5)
	$duration:=[ProductionSchedules:110]DurationSeconds:9*1
	$end:=$start+$duration
	TS2DateTime($end; ->[ProductionSchedules:110]EndDate:6; ->[ProductionSchedules:110]EndTime:7)
	SAVE RECORD:C53([ProductionSchedules:110])
	zwStatusMsg("BLOCK"; sCriterion4+" have been blocked for "+sCriterion3+" as Priority 0, reset as needed.")
	
	
End if   //ok

pressBackLog:=PS_qryCurrentBackLog(sCriterion1)
