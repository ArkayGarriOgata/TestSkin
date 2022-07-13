//(s) sCustId - FgCostingRpt2
//•1/31/97 cs - added stuff for saving to disk
If ([Customers:16]ID:1#[Finished_Goods:26]CustID:2)
	QUERY:C277([Customers:16]; [Customers:16]ID:1=[Finished_Goods:26]CustID:2)
End if 
If (fSave) & (In header:C112) & (Level:C101=1)  //user wants a disk file
	C_TEXT:C284($Tab; $Cr)
	$Tab:=Char:C90(9)
	$Cr:=Char:C90(13)
	SEND PACKET:C103(vDoc; $Cr+$Tab+[Customers:16]ID:1+$Tab+[Customers:16]Name:2+$Cr)
End if 