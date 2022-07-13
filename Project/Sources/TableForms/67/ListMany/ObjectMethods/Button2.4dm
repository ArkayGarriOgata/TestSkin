//(S) [ReleaseSchedule]'List'bPriority
CUT NAMED SELECTION:C334([Job_Forms_Master_Schedule:67]; "setAdate")
USE SET:C118("UserSet")
ONE RECORD SELECT:C189([Job_Forms_Master_Schedule:67])
sCriterion1:=[Job_Forms_Master_Schedule:67]JobForm:4
If (Length:C16(sCriterion1)=8)
	JML_SetDate(sCriterion1)
Else 
	JML_SetDate
End if 
USE NAMED SELECTION:C332("setAdate")