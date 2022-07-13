// ----------------------------------------------------
// Object Method: [Customers_Projects].ControlCtr.bFGSUpdate
// ----------------------------------------------------
ARRAY LONGINT:C221(axlRecordNums; 0)

Pjt_setReferId(pjtId)

CtlCtrGetArrays(->abSuptItemBottomLB; ->axlRecNumsB; ->axlRecordNums)
CREATE SET FROM ARRAY:C641([JTB_Job_Transfer_Bags:112]; axlRecordNums; "clickedIncludeRecord")
USE SET:C118("clickedIncludeRecord")
app_OpenSelectedIncludeRecords(->[JTB_Job_Transfer_Bags:112]ID:1)