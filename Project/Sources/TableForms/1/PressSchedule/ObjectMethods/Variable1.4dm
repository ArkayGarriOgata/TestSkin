//OM: sCriterion1() -> 
//@author mlb - 12/4/01  14:00
$settings:=PS_Settings("get"; sCriterion1)
QUERY:C277([Cost_Centers:27]; [Cost_Centers:27]ID:1=sCriterion1)
If (Records in selection:C76([Cost_Centers:27])>0)
	//QUERY([PressSchedule];[PressSchedule]Press=sCriterion1)
	//ORDER BY([PressSchedule];[PressSchedule]Priority;>;[PressSchedule]StartDate;>)
	
Else 
	BEEP:C151
	ALERT:C41(sCriterion1+" was not found.")
	sCriterion1:=""
	$settings:=PS_Settings("reset")
End if 
//