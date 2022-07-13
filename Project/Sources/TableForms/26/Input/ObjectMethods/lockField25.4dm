If ([Finished_Goods:26]ProcessSpec:33#"")
	QUERY:C277([Process_Specs:18]; [Process_Specs:18]ID:1=[Finished_Goods:26]ProcessSpec:33; *)
	QUERY:C277([Process_Specs:18];  & ; [Process_Specs:18]Cust_ID:4=[Finished_Goods:26]CustID:2)
	Case of 
		: (Records in selection:C76([Process_Specs:18])=0)
			BEEP:C151
			ALERT:C41([Finished_Goods:26]ProcessSpec:33+" has not been defined for this customer.")
			[Finished_Goods:26]ProcessSpec:33:=""
			
		: (Records in selection:C76([Process_Specs:18])>1)
			Open window:C153(20; 50; 240; 270; 1; "")
			DIALOG:C40([Process_Specs:18]; "PickOne")
			CLOSE WINDOW:C154
			If (ok=1)
				[Finished_Goods:26]ProcessSpec:33:=asText{asText}
			Else 
				[Finished_Goods:26]ProcessSpec:33:=""
			End if 
			QUERY:C277([Process_Specs:18]; [Process_Specs:18]ID:1=[Finished_Goods:26]ProcessSpec:33; *)
			QUERY:C277([Process_Specs:18];  & ; [Process_Specs:18]Cust_ID:4=[Finished_Goods:26]CustID:2)
			
		Else 
			[Finished_Goods:26]ProcessSpec:33:=[Process_Specs:18]ID:1
	End case 
End if 
//