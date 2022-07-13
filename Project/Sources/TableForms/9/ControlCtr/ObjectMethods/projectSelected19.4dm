ARRAY LONGINT:C221(axlRecordNums; 0)

Pjt_setReferId(pjtId)

CtlCtrGetArrays(->abFGLB; ->axlRecNums; ->axlRecordNums)
CREATE SET FROM ARRAY:C641([Finished_Goods:26]; axlRecordNums; "clickedIncludeRecord")
USE SET:C118("clickedIncludeRecord")
If (Records in selection:C76([Finished_Goods:26])#0)  // Added by: Mark Zinke (3/18/13)
	app_OpenSelectedIncludeRecords(->[Finished_Goods:26]ProductCode:1)
End if 