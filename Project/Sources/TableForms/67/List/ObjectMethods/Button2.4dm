//(S) [ReleaseSchedule]'List'bPriority
//CUT NAMED SELECTION([JobMasterLog];"setAdate")
//USE SET("UserSet")
//ONE RECORD SELECT([JobMasterLog])
//sCriterion1:=[JobMasterLog]JobForm
sCriterion1:=util_getKeyFromListing(->[Job_Forms_Master_Schedule:67]JobForm:4)
If (Length:C16(sCriterion1)=8)
	JML_SetDate(sCriterion1)
Else 
	JML_SetDate
End if 
//USE NAMED SELECTION("setAdate")