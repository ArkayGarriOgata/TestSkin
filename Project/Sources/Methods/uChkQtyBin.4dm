//%attributes = {"publishedWeb":true}
//uChkQtyBin: Check Quantity Available
//• 1/28/98 cs NAN checking

C_LONGINT:C283($i; $j)

If (arraynum>0)
	For ($i; 1; arraynum)
		// If (sJFNumber=aRMJFNum{$i})
		$j:=Find in array:C230(asBinPO; aRMBinPO{$i})
		If ($j>0)
			aRMPOQty{$i}:=uNANCheck(aRMPOQty{$i})  //• 1/28/98 cs NAN checking
			asQty{$j}:=uNANCheck(asQty{$j})  //• 1/28/98 cs NAN checking
			asQty{$j}:=asQty{$j}-aRMPOQty{$i}
		End if 
	End for 
End if 