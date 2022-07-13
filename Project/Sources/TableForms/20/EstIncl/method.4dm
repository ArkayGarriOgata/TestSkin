Case of 
	: (Form event code:C388=On Display Detail:K2:22)
		tName:=""
		tName:=(Num:C11(([Estimates_Machines:20]WasteAdj_Percen:40#0) | ([Estimates_Machines:20]MR_Override:26#0) | ([Estimates_Machines:20]Run_Override:27#0)))*"•"
		t2:=""
		t2:=(Num:C11([Estimates_Machines:20]FormChangeHere:9)*"ƒ")
		
		If ((Position:C15([Estimates_Machines:20]CostCtrID:4; <>EMBOSSERS)>0) | (Position:C15([Estimates_Machines:20]CostCtrID:4; <>STAMPERS)>0))
			$shouldUse:=CostCtr_Description_Tweak(->[Estimates_Machines:20]CostCtrName:2; "save")
		End if 
		
End case 