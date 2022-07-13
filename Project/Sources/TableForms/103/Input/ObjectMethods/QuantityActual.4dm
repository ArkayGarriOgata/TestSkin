//OM: QuantityActual() -> 
//@author mlb - 5/22/01  13:10

If ([Prep_CatalogItems:102]ItemNumber:1#[Prep_Charges:103]PrepItemNumber:4)
	READ ONLY:C145([Prep_CatalogItems:102])
	QUERY:C277([Prep_CatalogItems:102]; [Prep_CatalogItems:102]ItemNumber:1=[Prep_Charges:103]PrepItemNumber:4)
End if 

[Prep_Charges:103]PriceQuoted:6:=[Prep_Charges:103]QuantityQuoted:2*[Prep_CatalogItems:102]Price:4
[Prep_Charges:103]PriceActual:5:=[Prep_Charges:103]QuantityActual:3*[Prep_CatalogItems:102]Price:4
[Prep_Charges:103]PriceRevised:11:=[Prep_Charges:103]QuantityRevised:10*[Prep_CatalogItems:102]Price:4