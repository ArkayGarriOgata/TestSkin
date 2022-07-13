// ----------------------------------------------------
// Method: [Customers_Projects].ControlCtr.projectSelected11
// ----------------------------------------------------

ARRAY LONGINT:C221(axlRecordNums; 0)

Pjt_setReferId(pjtId)

CtlCtrGetArrays(->abArtLB; ->axlRecNums; ->axlRecordNums)
CREATE SET FROM ARRAY:C641([Finished_Goods_Specifications:98]; axlRecordNums; "clickedIncludeRecord")
app_OpenSelectedIncludeRecords(->[Finished_Goods_Specifications:98]ControlNumber:2)