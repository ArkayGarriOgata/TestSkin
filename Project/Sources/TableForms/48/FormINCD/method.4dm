Case of 
	: (Form event code:C388=On Display Detail:K2:22)
		util_alternateBackground
		
	: (Form event code:C388=On Data Change:K2:15)
		Estimate_ReCalcNeeded
		
		If (([Estimates_FormCartons:48]NumberUp:4#0) & ([Estimates_FormCartons:48]NetSheets:7#0))
			[Estimates_FormCartons:48]MakesQty:5:=[Estimates_FormCartons:48]NumberUp:4*[Estimates_FormCartons:48]NetSheets:7
			r2:=Sum:C1([Estimates_FormCartons:48]MakesQty:5)
		End if 
		
	: (Form event code:C388=On Clicked:K2:4)
		GET HIGHLIGHTED RECORDS:C902([Estimates_FormCartons:48]; "clickedIncluded")
End case 
