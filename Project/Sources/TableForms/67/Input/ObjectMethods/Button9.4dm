//If (fSetMAD)
//BUTTON TEXT(bApplyMAD;"MAD Set is OFF")
//fSetMAD:=False
//Else 
//fSetMAD:=True
//BUTTON TEXT(bApplyMAD;"MAD Set is ON")

C_DATE:C307(newHRD)
newHRD:=Date:C102(Request:C163("What HaveReadyDate do you want to use on items?"; String:C10([Job_Forms_Master_Schedule:67]MAD:21; System date short:K1:1)))
If (ok=1)
	If (newHRD>=[Job_Forms_Master_Schedule:67]MAD:21)
		fSetMAD:=True:C214
		uConfirm("Now double-click on the items to set their HRD to "+String:C10(newHRD; System date short:K1:1); "OK"; "Help")
	Else 
		uConfirm("Can't set items' HRD before the Jobs. HRD Setting cancelled."; "OK"; "Help")
		fSetMAD:=False:C215
		newHRD:=[Job_Forms_Master_Schedule:67]MAD:21
	End if 
	
Else 
	uConfirm("HRD Setting cancelled."; "OK"; "Help")
	fSetMAD:=False:C215
End if 