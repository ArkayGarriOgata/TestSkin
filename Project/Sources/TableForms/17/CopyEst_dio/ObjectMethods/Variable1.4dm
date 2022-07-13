//OM: sCriterion1() -> 
//@author mlb - 4/18/01  09:49
QUERY:C277([Estimates:17]; [Estimates:17]EstimateNo:1=sCriterion1)
If (Records in selection:C76([Estimates:17])>0)
	xText:="Job Nº: "+String:C10([Estimates:17]JobNo:50)+" Order Nº: "+String:C10([Estimates:17]OrderNo:51)
Else 
	BEEP:C151
	ALERT:C41(sCriterion1+" was not found")
	xText:=sCriterion1+" was not found"
	sCriterion1:=""
	GOTO OBJECT:C206(sCriterion1)
End if 
