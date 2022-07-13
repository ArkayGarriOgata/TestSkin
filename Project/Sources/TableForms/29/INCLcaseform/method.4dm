$e:=Form event code:C388
Case of 
	: ($e=On Display Detail:K2:22)
		util_alternateBackground
		
	: ($e=On Clicked:K2:4)
		GET HIGHLIGHTED RECORDS:C902([Estimates_Materials:29]; "clickedMaterial")
		
	: ($e=On Double Clicked:K2:5)
		
		
	: ($e=On Data Change:K2:15)
		Estimate_ReCalcNeeded
End case 
