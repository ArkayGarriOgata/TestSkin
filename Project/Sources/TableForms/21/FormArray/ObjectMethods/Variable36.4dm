C_LONGINT:C283($Pos)  //(S) rQty: Check for valid Quantity Received.
If (sBinNo#"") & (sPONo#"") & (rQty>0) & (sPONumber#"")
	$Pos:=Find in array:C230(asBinPO; txt_Pad(sBinNo; " "; 1; 11)+sPONo)
	If ($Pos>0)
		If (rQty>asQty{$Pos})
			BEEP:C151
			ALERT:C41("Warning: Quantity to Issue exceeds Quantity Available!")
			GOTO OBJECT:C206(rQty)
		End if 
	End if 
	OBJECT SET ENABLED:C1123(bAdd; True:C214)
End if 
//EOS