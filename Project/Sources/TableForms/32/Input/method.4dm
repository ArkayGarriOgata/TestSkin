//(LP) [SALESMAN];"Input"
Case of 
	: (Form event code:C388=On Load:K2:1)
		beforeSale
		
	: (Form event code:C388=On Close Box:K2:21)
		CANCEL:C270
		bDone:=1
		
	: (Form event code:C388=On Data Change:K2:15)
		If (Is new record:C668([Salesmen:32]))
			QUERY:C277([Users:5]; [Users:5]LastName:2=[Salesmen:32]LastName:2; *)
			QUERY:C277([Users:5];  & ; [Users:5]FirstName:3=[Salesmen:32]FirstName:3; *)
			QUERY:C277([Users:5];  & ; [Users:5]MI:4=[Salesmen:32]MI:4)
			If (Records in selection:C76([Users:5])=1)
				[Salesmen:32]ID:1:=[Users:5]Initials:1
				OBJECT SET ENABLED:C1123(bValidate; True:C214)
			End if 
			
		Else 
			OBJECT SET ENABLED:C1123(bValidate; True:C214)
		End if 
		
	: (Form event code:C388=On Validate:K2:3)
		[Salesmen:32]ModDate:16:=4D_Current_date
		[Salesmen:32]ModWho:17:=<>zResp
		
		
		
	: (Form event code:C388=On Unload:K2:2)
		REDUCE SELECTION:C351([Customers_Bookings:93]; 0)
		REDUCE SELECTION:C351([Users:5]; 0)
End case 
//
