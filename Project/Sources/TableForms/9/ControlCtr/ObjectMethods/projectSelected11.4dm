ARRAY LONGINT:C221(axlRecordNums; 0)

Pjt_setReferId(pjtId)

CtlCtrGetArrays(->abSuptItemTopLB; ->axlRecNums; ->axlRecordNums)
CREATE SET FROM ARRAY:C641([JPSI_Job_Physical_Support_Items:111]; axlRecordNums; "clickedIncludeRecord")
USE SET:C118("clickedIncludeRecord")
app_OpenSelectedIncludeRecords(->[JPSI_Job_Physical_Support_Items:111]ID:1)