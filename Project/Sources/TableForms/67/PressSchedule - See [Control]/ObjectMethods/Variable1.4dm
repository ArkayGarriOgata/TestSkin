//OM: sCriterion1() -> 
//@author mlb - 12/4/01  14:00
$settings:=PS_Settings("get"; sCriterion1)
QUERY:C277([Cost_Centers:27]; [Cost_Centers:27]ID:1=sCriterion1)
If (Records in selection:C76([Cost_Centers:27])>0)
	QUERY:C277([ProductionSchedules:110]; [ProductionSchedules:110]CostCenter:1=sCriterion1)
	ORDER BY:C49([ProductionSchedules:110]; [ProductionSchedules:110]Priority:3; >; [ProductionSchedules:110]StartDate:4; >)
	
Else 
	BEEP:C151
	ALERT:C41(sCriterion1+" was not found.")
	sCriterion1:=""
	$settings:=PS_Settings("reset")
End if 
//