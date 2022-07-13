//Searchpicker sample code
C_BOOLEAN:C305(useFindWidget)
Case of 
		
	: (Form event code:C388=On Load:K2:1)
		// Init the var itself
		// this can be done anywhere else in your code
		C_TEXT:C284(vSearch)
		vSearch:=""
		// the let's customise the SearchPicker (if needed)
		C_TEXT:C284($ObjectName)
		$ObjectName:=OBJECT Get name:C1087(Object current:K67:2)
		SearchPicker SET HELP TEXT($ObjectName; "Name Rep CS Plnr")
		
	: (Form event code:C388=On Data Change:K2:15)
		
		Case of 
			: (Not:C34(useFindWidget))
				useFindWidget:=True:C214  //toggle, coming from legacy [zz_control];"Select_dio"
				
			: (Length:C16(vSearch)>0)
				$criterian:="@"+vSearch+"@"
				QUERY:C277([Customers:16]; [Customers:16]Name:2=$criterian; *)
				QUERY:C277([Customers:16];  | ; [Customers:16]SalesmanID:3=$criterian; *)
				QUERY:C277([Customers:16];  | ; [Customers:16]ShortName:57=$criterian; *)
				QUERY:C277([Customers:16];  | ; [Customers:16]PlannerID:5=$criterian; *)
				QUERY:C277([Customers:16];  | ; [Customers:16]CustomerService:46=$criterian)
				
			Else 
				ALL RECORDS:C47([Customers:16])
		End case 
		
		ORDER BY:C49([Customers:16]; [Customers:16]Name:2; >)
		
End case 
