If ([Estimates_Machines:20]CostCtrID:4="412") | ([Estimates_Machines:20]CostCtrID:4="416")
	If (([Estimates_Machines:20]Flex_Field2:19+[Estimates_Machines:20]Flex_Field4:21)=0)
		[Estimates_Machines:20]FormChangeHere:9:=False:C215
	Else 
		[Estimates_Machines:20]FormChangeHere:9:=True:C214
	End if 
End if 