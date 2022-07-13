//%attributes = {"publishedWeb":true}
//uChkQtyAvllss: Check Quantity Available
//• 1/28/98 cs NAN checking
//•090998  MLB  fix range chk err

C_LONGINT:C283($i; $j)

If (arraynum>0)
	For ($i; 1; arraynum)
		If (sJFNumber=aRMJFNum{$i})
			$j:=Find in array:C230(aBudgetItem; aRMBudItem{$i})
			If ($j>-1)
				aQtyAvl{$j}:=uNANCheck(aQtyAvl{$j})  //• 1/28/98 cs NAN checking
				aQtyAvl{$j}:=aQtyAvl{$j}+aRMPOQty{$i}
			End if 
		End if 
	End for 
End if 