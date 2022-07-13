//(s) sCustId - FgCostingRpt1
//•1/31/97 cs - added stuff for saving to disk
If ([Customers:16]ID:1#[Finished_Goods:26]CustID:2)
	QUERY:C277([Customers:16]; [Customers:16]ID:1=[Finished_Goods:26]CustID:2)
End if 
If (fSave) & (In header:C112)  //user wants a disk file  
	SEND PACKET:C103(vDoc; Char:C90(13)+Char:C90(9)+[Customers:16]ID:1+Char:C90(9)+[Customers:16]Name:2+Char:C90(13))
End if 