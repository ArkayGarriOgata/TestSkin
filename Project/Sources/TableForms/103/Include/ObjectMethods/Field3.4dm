//OM: QuantityRevised() -> 
//@author mlb - 8/22/02  13:34

If ([Prep_CatalogItems:102]ItemNumber:1#[Prep_Charges:103]PrepItemNumber:4)
	READ ONLY:C145([Prep_CatalogItems:102])
	QUERY:C277([Prep_CatalogItems:102]; [Prep_CatalogItems:102]ItemNumber:1=[Prep_Charges:103]PrepItemNumber:4)
End if 

[Prep_Charges:103]PriceRevised:11:=[Prep_Charges:103]QuantityRevised:10*[Prep_CatalogItems:102]Price:4
fRevisedQuote:=True:C214
uUpdateTrail(->[Finished_Goods_Specifications:98]ModDate:56; ->[Finished_Goods_Specifications:98]ModWho:55)
//