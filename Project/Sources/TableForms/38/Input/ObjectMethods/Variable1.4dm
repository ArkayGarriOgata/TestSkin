If (<>fisSalesRep) | (<>fisCoord)
	uConfirm("Sorry, I'd show you, but then I would have to kill you."; "I'm telling"; "Cancel")
	
Else 
	app_OpenSelectedIncludeRecords(->[Estimates_Carton_Specs:19]CartonSpecKey:7; 0; "CSPEC")
	
End if 