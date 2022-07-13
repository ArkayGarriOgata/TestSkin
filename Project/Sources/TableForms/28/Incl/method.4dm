// ----------------------------------------------------
// Method: [Process_Specs_Machines].Incl   ( ) ->


$e:=Form event code:C388
Case of 
	: ($e=On Display Detail:K2:22)
		util_alternateBackground
		t2:=""
		t2:=(Num:C11([Process_Specs_Machines:28]formChangeHere:9)*"ƒ")
		
		If ((Position:C15([Process_Specs_Machines:28]CostCenterID:4; <>EMBOSSERS)>0) | (Position:C15([Process_Specs_Machines:28]CostCenterID:4; <>STAMPERS)>0))
			$shouldUse:=CostCtr_Description_Tweak(->[Process_Specs_Machines:28]CostCtrName:5; "save")
		End if 
		
	: ($e=On Clicked:K2:4)
		GET HIGHLIGHTED RECORDS:C902([Estimates_Materials:29]; "clickedMachine")
		
	: ($e=On Double Clicked:K2:5)
		
End case 
