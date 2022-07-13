ARRAY LONGINT:C221(axlRecordNums; 0)

Pjt_setReferId(pjtId)

CtlCtrGetArrays(->abEstimateLB; ->axlRecNums; ->axlRecordNums)
CREATE SET FROM ARRAY:C641([Estimates:17]; axlRecordNums; "clickedIncludeRecord")
USE SET:C118("clickedIncludeRecord")
If (Records in selection:C76([Estimates:17])#0)  // Added by: Mark Zinke (3/18/13)
	app_OpenSelectedIncludeRecords(->[Estimates:17]EstimateNo:1)
End if 