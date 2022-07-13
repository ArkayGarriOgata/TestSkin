
If (asBin>0)
	sBinNo:=asBin{asBin}
	sCompany:=aCompany{asBin}
	sPONo:=asPONo{asBin}
	rActCost:=arActCost{asBin}
	If (asQty{asBin}>0)
		rQty:=0
	Else 
		BEEP:C151
		rQty:=0
	End if 
End if 

SetObjectProperties(""; ->rQty; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/13/13)
GOTO OBJECT:C206(rQty)
OBJECT SET ENABLED:C1123(bAdd; True:C214)