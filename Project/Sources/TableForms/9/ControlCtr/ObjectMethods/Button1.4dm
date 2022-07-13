Pjt_setReferId(pjtId)
READ WRITE:C146([Estimates:17])
QUERY:C277([Estimates:17])
If (ok=1)
	If (Pjt_AddToProjectLimitor(->[Estimates:17]))
		uConfirm("Change "+String:C10(Records in selection:C76([Estimates:17]))+" records to project number "+pjtId)
		If (ok=1)
			APPLY TO SELECTION:C70([Estimates:17]; Estimate_AssignToProject(pjtId))
		End if 
		
		QUERY:C277([Estimates:17]; [Estimates:17]ProjectNumber:63=pjtId)
		ORDER BY:C49([Estimates:17]; [Estimates:17]EstimateNo:1; >)
	End if 
End if 