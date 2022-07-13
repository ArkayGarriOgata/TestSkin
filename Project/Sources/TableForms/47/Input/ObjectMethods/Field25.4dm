//[caseform]numbersheets script   -JML   8/20/93
//mod mlb 1/26/94
//3/15/95 upr 66
//updates the [formcartons]makesqty field when user changes this value
uConfirm("Apply "+String:C10([Estimates_DifferentialsForms:47]NumberSheets:4)+" to all items?"; "Change"; "No touch")
If (ok=1)
	QUERY:C277([Estimates_FormCartons:48]; [Estimates_FormCartons:48]DiffFormID:2=[Estimates_DifferentialsForms:47]DiffFormId:3)  //ensure that related records are loaded
	APPLY TO SELECTION:C70([Estimates_FormCartons:48]; [Estimates_FormCartons:48]MakesQty:5:=[Estimates_FormCartons:48]NumberUp:4*[Estimates_DifferentialsForms:47]NumberSheets:4)
	APPLY TO SELECTION:C70([Estimates_FormCartons:48]; [Estimates_FormCartons:48]NetSheets:7:=[Estimates_DifferentialsForms:47]NumberSheets:4)
	ORDER BY:C49([Estimates_FormCartons:48]; [Estimates_FormCartons:48]SubFormNumber:10; >; [Estimates_FormCartons:48]ItemNumber:3; >)
	r1:=Sum:C1([Estimates_FormCartons:48]FormWantQty:9)  //3/15/95 upr 66
	r2:=Sum:C1([Estimates_FormCartons:48]MakesQty:5)
	//REDRAW([Estimates_FormCartons])
End if 
[Estimates_Differentials:38]TotalPieceYld:10:=0
[Estimates_Differentials:38]TotalPieces:8:=0
//