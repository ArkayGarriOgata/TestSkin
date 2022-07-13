//(s) Flex Field6
// • mel (6/27/05, 15:28:27) add seperating
If ([Estimates_Machines:20]Flex_field6:37)
	Case of 
		: (Position:C15([Estimates_Machines:20]CostCtrID:4; <>GLUERS)#0)  //gluing & imager
			If ([Estimates_Machines:20]CostCtrID:4#[Cost_Centers:27]ID:1)
				READ ONLY:C145([Cost_Centers:27])
				qryCostCenter([Estimates_Machines:20]CostCtrID:4; [Estimates_Machines:20]UseStdDated:43)  //3/15/95 upr 66    
				[Estimates_Machines:20]Effectivity:6:=[Cost_Centers:27]EffectivityDate:13
				[Estimates_Machines:20]LaborStd:7:=[Cost_Centers:27]MHRlaborSales:4
				[Estimates_Machines:20]OverheadStd:8:=[Cost_Centers:27]MHRburdenSales:5
				[Estimates_Machines:20]OOPStd:17:=[Estimates_Machines:20]LaborStd:7+[Estimates_Machines:20]OverheadStd:8  //•071296  MLB 
			End if 
			[Estimates_Machines:20]Run_Override:27:=[Cost_Centers:27]RS_Spl:52
			UNLOAD RECORD:C212([Cost_Centers:27])
			READ WRITE:C146([Cost_Centers:27])
			
		: (Position:C15([Estimates_Machines:20]CostCtrID:4; " 501 502 ")#0)  //hand labor separting, so work in sheets
			[Estimates_Machines:20]Flex_Field5:25:=True:C214
			[Estimates_Machines:20]Flex_Field3:20:=3
	End case 
	
Else 
	[Estimates_Machines:20]Flex_Field3:20:=0
End if 
//eos