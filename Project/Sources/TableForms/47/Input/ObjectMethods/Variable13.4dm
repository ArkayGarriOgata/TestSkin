//upr 165 1/5/94  (s)bDelCPN2For
If (Records in set:C195("clickedIncluded")>0)
	CUT NAMED SELECTION:C334([Estimates_FormCartons:48]; "hold")
	USE SET:C118("clickedIncluded")
	uConfirm("Delete item "+String:C10([Estimates_FormCartons:48]ItemNumber:3)+" from form "+[Estimates_FormCartons:48]DiffFormID:2+"?")
	If (ok=1)
		Estimate_ReCalcNeeded
		RELATE ONE:C42([Estimates_FormCartons:48]Carton:1)
		[Estimates_Differentials:38]TotalPieces:8:=[Estimates_Differentials:38]TotalPieces:8-[Estimates_Carton_Specs:19]Quantity_Want:27
		SAVE RECORD:C53([Estimates_Differentials:38])
		DELETE RECORD:C58([Estimates_Carton_Specs:19])
		DELETE RECORD:C58([Estimates_FormCartons:48])
		RELATE MANY:C262([Estimates_DifferentialsForms:47]DiffFormId:3)
		MESSAGES OFF:C175
		r1:=Sum:C1([Estimates_FormCartons:48]FormWantQty:9)  //3/15/95 upr 66
		r2:=Sum:C1([Estimates_FormCartons:48]MakesQty:5)
		ORDER BY:C49([Estimates_FormCartons:48]; [Estimates_FormCartons:48]ItemNumber:3; >)
		ORDER BY:C49([Estimates_Machines:20]; [Estimates_Machines:20]Sequence:5; >)
		ORDER BY:C49([Estimates_Materials:29]; [Estimates_Materials:29]Sequence:12; >)
		MESSAGES ON:C181
		
	End if 
	USE NAMED SELECTION:C332("hold")
	
Else 
	BEEP:C151
End if 
//