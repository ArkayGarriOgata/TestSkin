//OM: bLoad() -> 
//@author mlb - 12/4/01  14:09
$winRef:=Open form window:C675([ProductionSchedules:110]; "BlockTime"; 0)
DIALOG:C40([ProductionSchedules:110]; "BlockTime")
CLOSE WINDOW:C154
If (ok=1)
	
	CREATE RECORD:C68([ProductionSchedules:110])
	[ProductionSchedules:110]JobSequence:8:="Blocked"
	[ProductionSchedules:110]CostCenter:1:=sCriterion1
	[ProductionSchedules:110]Name:2:=[Cost_Centers:27]Description:3
	
	[ProductionSchedules:110]Line:10:=sCriterion3
	[ProductionSchedules:110]Customer:11:=sCriterion2
	
	[ProductionSchedules:110]Priority:3:=0
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
	
	QUERY:C277([ProductionSchedules:110]; [ProductionSchedules:110]CostCenter:1=sCriterion1)
	If (Records in selection:C76([ProductionSchedules:110])>0)
		pressBackLog:=Sum:C1([ProductionSchedules:110]DurationSeconds:9)/3600
		ORDER BY:C49([ProductionSchedules:110]; [ProductionSchedules:110]Priority:3; >; [ProductionSchedules:110]StartDate:4; >)
	Else 
		pressBackLog:=0
	End if 
End if   //ok
