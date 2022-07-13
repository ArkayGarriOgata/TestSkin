Case of 
	: (Form event code:C388=On Load:K2:1)
		If (Record number:C243([Customers_Projects:9])#New record:K29:1)
			iMode:=2
			
		Else 
			iMode:=1
			REDUCE SELECTION:C351([Estimates:17]; 0)
			REDUCE SELECTION:C351([Job_Forms:42]; 0)
			[Customers_Projects:9]id:1:=app_set_id_as_string(Table:C252(->[Customers_Projects:9]))  //fGetNextID (->[Customers_Projects];5)
			[Customers_Projects:9]DateOpened:11:=4D_Current_date
			
		End if 
		
End case 