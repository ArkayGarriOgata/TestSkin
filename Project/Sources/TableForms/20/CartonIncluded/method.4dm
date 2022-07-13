$e:=Form event code:C388
Case of 
	: ($e=On Display Detail:K2:22)
		util_alternateBackground
		tName:=""
		tName:=(Num:C11(([Estimates_Machines:20]WasteAdj_Percen:40#0) | ([Estimates_Machines:20]MR_Override:26#0) | ([Estimates_Machines:20]Run_Override:27#0)))*"•"
		t2:=""
		t2:=(Num:C11([Estimates_Machines:20]FormChangeHere:9)*"ƒ")
		
	: ($e=On Clicked:K2:4)
		GET HIGHLIGHTED RECORDS:C902([Estimates_Machines:20]; "clickedCSpec")
		
	: ($e=On Double Clicked:K2:5)
		
End case 
