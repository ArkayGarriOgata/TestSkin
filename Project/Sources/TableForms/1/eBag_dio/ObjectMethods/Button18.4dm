If (Records in set:C195("clickedIncluded")>0)
	CUT NAMED SELECTION:C334([Job_Forms_Items:44]; "hold")
	
	READ WRITE:C146([Job_Forms_Items:44])
	USE SET:C118("clickedIncluded")
	If (fLockNLoad(->[Job_Forms_Items:44]))
		If (Not:C34([Job_Forms_Items:44]CasesMade:55))
			uConfirm("Have the corrugated cases been made for item "+[Job_Forms_Items:44]Jobit:4; "Yes"; "No")
			If (ok=1)
				[Job_Forms_Items:44]CasesMade:55:=True:C214
				SAVE RECORD:C53([Job_Forms_Items:44])
			End if 
		Else 
			uConfirm("Uncheck that corrugated cases been made for item "+[Job_Forms_Items:44]Jobit:4; "Not made"; "Cancel")
			If (ok=1)
				[Job_Forms_Items:44]CasesMade:55:=False:C215
				SAVE RECORD:C53([Job_Forms_Items:44])
			End if 
		End if 
		
	End if 
	
	USE NAMED SELECTION:C332("hold")
	UNLOAD RECORD:C212([Job_Forms_Items:44])
	
Else 
	uConfirm("Select a carton first."; "OK"; "Help")
End if 