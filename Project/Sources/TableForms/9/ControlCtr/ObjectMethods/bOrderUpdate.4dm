// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 04/01/13, 16:48:05
// ----------------------------------------------------
// Object Method: [Customers_Projects]ControlCtr.bOrderUpdate
// ----------------------------------------------------

ARRAY LONGINT:C221(axlRecordNums; 0)

Pjt_setReferId(pjtId)

CtlCtrGetArrays(->abOrderLinesLB; ->axlRecNums; ->axlRecordNums)
CREATE SET FROM ARRAY:C641([Customers_Order_Lines:41]; axlRecordNums; "clickedIncludeRecord")
USE SET:C118("clickedIncludeRecord")
app_OpenSelectedIncludeRecords(->[Customers_Order_Lines:41]OrderLine:3)