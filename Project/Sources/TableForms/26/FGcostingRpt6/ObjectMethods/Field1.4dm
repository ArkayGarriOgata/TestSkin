//(s) sCustId - FgCostingRpt6
If ([Customers:16]ID:1#[Finished_Goods:26]CustID:2)
	//QUERY([CUSTOMER];[CUSTOMER]ID=[Finished_Goods]CustID)
	qryCustomer(->[Customers:16]ID:1; [Finished_Goods:26]CustID:2)
End if 

If (fSave) & (In header:C112)  //user wants a disk file  
	SEND PACKET:C103(vDoc; Char:C90(Carriage return:K15:38)+Char:C90(Tab:K15:37)+[Customers:16]ID:1+Char:C90(Tab:K15:37)+[Customers:16]Name:2+Char:C90(Carriage return:K15:38))
End if 