//(lp) PiFgAdj.d (detail)
dDate1:=aDate{Index}  //x action date
sCpn:=aCpn{Index}  //product code
sJobForm:=aJobs{Index}  //job number
rQtyOh:=aQuantity{Index}  //On hand inventory
sBin:=aLocation{Index}  //location of inventory
rReal1:=aActCost{Index}  //cost of goods extended
sItemNumber:=AOL{Index}  //x action type
scc:=aRep{Index}  //mod who

//keep subtotals
rReal4:=rReal4+aQuantity{Index}  // Location sum, quantity
rReal5:=rReal5+aActCost{Index}  // Location sum, cost of goods extended

If (vDoc#?00:00:00?)
	C_TEXT:C284($xText)
	$xText:=sItemNumber+Char:C90(9)+String:C10(dDate1)+Char:C90(9)+sCpn+Char:C90(9)+sJobForm+Char:C90(9)+String:C10(rQtyOh)+Char:C90(9)+sBin+Char:C90(9)+String:C10(rReal1; "$###,###,##0.00")+Char:C90(9)+scc+Char:C90(13)
	SEND PACKET:C103(vDoc; $xText)
End if 