//(s)[Estimate].Input_bDelPS
//how do you tell if a record is selected?
If (Records in set:C195("clickedPSpec")=1)
	USE SET:C118("clickedPSpec")
	uConfirm("Are you sure you want to delete process spec "+[Estimates_PSpecs:57]ProcessSpec:2+" from this Estimate?")
	If (OK=1)
		DELETE RECORD:C58([Estimates_PSpecs:57])
	End if 
	QUERY:C277([Estimates_PSpecs:57]; [Estimates_PSpecs:57]EstimateNo:1=[Estimates:17]EstimateNo:1)
	ORDER BY:C49([Estimates_PSpecs:57]; [Estimates_PSpecs:57]ProcessSpec:2; >)
	
Else 
	BEEP:C151
End if 
//