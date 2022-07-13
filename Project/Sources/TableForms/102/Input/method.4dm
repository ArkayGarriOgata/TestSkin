//FM: Input() -> 
//@author mlb - 5/22/01  12:45

Case of 
	: (Form event code:C388=On Load:K2:1)
		If (Is new record:C668([Prep_CatalogItems:102]))
			[Prep_CatalogItems:102]ItemNumber:1:=app_set_id_as_string(Table:C252(->[Prep_CatalogItems:102]))  //fGetNextID (->[Prep_CatalogItems];5)
		End if 
End case 
//