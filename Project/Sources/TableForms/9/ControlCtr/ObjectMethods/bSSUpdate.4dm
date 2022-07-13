// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 04/02/13, 09:23:17
// ----------------------------------------------------
// Method: bSSUpdate
// ----------------------------------------------------

ARRAY LONGINT:C221(axlRecordNums; 0)

Pjt_setReferId(pjtId)

CtlCtrGetArrays(->abSandS; ->axlRecNums; ->axlRecordNums)
CREATE SET FROM ARRAY:C641([Finished_Goods_SizeAndStyles:132]; axlRecordNums; "clickedIncludeRecord")
app_OpenSelectedIncludeRecords(->[Finished_Goods_SizeAndStyles:132]FileOutlineNum:1)