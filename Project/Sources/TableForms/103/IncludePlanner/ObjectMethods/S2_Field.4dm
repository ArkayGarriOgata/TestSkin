//OM: QuantityOrdered() -> 
//@author mlb - 5/22/01  13:13

If ([Prep_CatalogItems:102]ItemNumber:1#[Prep_Charges:103]PrepItemNumber:4)
	READ ONLY:C145([Prep_CatalogItems:102])
	QUERY:C277([Prep_CatalogItems:102]; [Prep_CatalogItems:102]ItemNumber:1=[Prep_Charges:103]PrepItemNumber:4)
End if 

[Prep_Charges:103]PriceQuoted:6:=[Prep_Charges:103]QuantityQuoted:2*[Prep_CatalogItems:102]Price:4
uUpdateTrail(->[Finished_Goods_Specifications:98]ModDate:56; ->[Finished_Goods_Specifications:98]ModWho:55)
//