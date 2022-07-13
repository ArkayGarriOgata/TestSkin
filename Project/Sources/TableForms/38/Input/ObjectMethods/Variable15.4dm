If (Not:C34(User in group:C338(Current user:C182; "SalesReps")))
	app_OpenSelectedIncludeRecords(->[Estimates_DifferentialsForms:47]DiffFormId:3; 0; "FORM")
	
Else 
	uConfirm("Sorry, I'd show you, but then I would have to kill you."; "Easy Man"; "Cancel")
End if 