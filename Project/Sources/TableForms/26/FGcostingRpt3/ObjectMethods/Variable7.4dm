//(s) sCustId - FgCostingRpt3
//•1/31/97 cs - added stuff for saving to disk
If (sCustId#[Finished_Goods:26]CustID:2)
	$CustIndex:=Find in array:C230(aCustId; [Finished_Goods:26]CustID:2)
	sCustId:=aCustId{$CustIndex}
	sCustName:=aCustName{$CustIndex}
End if 

If (fSave) & (In header:C112) & (Level:C101=1)
	C_TEXT:C284($Tab; $Cr)
	C_LONGINT:C283($CustIndex)
	$Tab:=Char:C90(9)
	$Cr:=Char:C90(13)
	SEND PACKET:C103(vDoc; $Cr+$Tab+sCustId+$Tab+sCustName+$Cr)
End if 