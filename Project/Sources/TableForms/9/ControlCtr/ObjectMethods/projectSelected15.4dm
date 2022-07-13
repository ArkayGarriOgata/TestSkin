// ----------------------------------------------------
// User name (OS): MB
// ----------------------------------------------------
// Method: [Customers_Projects].ControlCtr.projectSelected15
// ----------------------------------------------------

Pjt_setReferId(pjtId)
CREATE EMPTY SET:C140([Estimates:17]; "clickedIncludeRecord")  // Modified by: Mel Bohince (8/30/18) fix rt error

QUERY:C277([Estimates:17]; [Estimates:17]EstimateNo:1=atEstimateNum{abEstimateLB})  // Added by: Mark Zinke (3/18/13)
If (Records in selection:C76([Estimates:17])=1)  // Added by: Mark Zinke (3/18/13)
	ADD TO SET:C119([Estimates:17]; "clickedIncludeRecord")  // Added by: Mark Zinke (3/18/13)
End if 
$tablePtr:=->[Estimates:17]
If (Records in set:C195("clickedIncludeRecord")>0)
	
	UNLOAD RECORD:C212($tablePtr->)
	CUT NAMED SELECTION:C334($tablePtr->; "hold")
	USE SET:C118("clickedIncludeRecord")
	
	<>EstNo:=[Estimates:17]EstimateNo:1
	ViewSetter(5; $tablePtr)
	FORM GOTO PAGE:C247(ppHome)
	SELECT LIST ITEMS BY POSITION:C381(tc_PjtControlCtr; 1)
	
	USE NAMED SELECTION:C332("hold")
	
Else 
	
	uConfirm("Please select a "+Table name:C256($tablePtr)+" record(s) to update."; "OK"; "Help")
	
End if 