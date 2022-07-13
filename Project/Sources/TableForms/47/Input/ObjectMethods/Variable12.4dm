If ([Estimates_DifferentialsForms:47]FormNumber:2>0)
	sAddCPN2For
	r1:=Sum:C1([Estimates_FormCartons:48]FormWantQty:9)  //3/15/95 upr 66
	r2:=Sum:C1([Estimates_FormCartons:48]MakesQty:5)
	ORDER BY:C49([Estimates_FormCartons:48]; [Estimates_FormCartons:48]ItemNumber:3; >)
	Estimate_ReCalcNeeded
Else 
	uConfirm("Enter a form number first"; "OK"; "Help")
End if 