ARRAY LONGINT:C221(axlRecordNums; 0)

Pjt_setReferId(pjtId)

CtlCtrGetArrays(->abOrderLinesLB; ->axlRecNums; ->axlRecordNums)
CREATE SET FROM ARRAY:C641([Customers_Order_Lines:41]; axlRecordNums; "clickedIncludeRecord")
app_OpenSelectedIncludeRecords(->[Customers_Order_Lines:41]OrderLine:3; 3)