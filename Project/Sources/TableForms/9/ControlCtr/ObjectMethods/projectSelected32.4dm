ARRAY LONGINT:C221(axlRecordNums; 0)

Pjt_setReferId(pjtId)

CtlCtrGetArrays(->abJobLinesLB; ->axlRecNums; ->axlRecordNums)
CREATE SET FROM ARRAY:C641([Job_Forms:42]; axlRecordNums; "clickedIncludeRecord")
USE SET:C118("clickedIncludeRecord")
app_OpenSelectedIncludeRecords(->[Job_Forms:42]JobFormID:5)
