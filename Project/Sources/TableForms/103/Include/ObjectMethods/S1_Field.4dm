//OM: PrepItemNumber() -> 
//@author mlb - 6/18/01  15:58

If ([Prep_CatalogItems:102]ItemNumber:1#[Prep_Charges:103]PrepItemNumber:4)
	READ ONLY:C145([Prep_CatalogItems:102])
	QUERY:C277([Prep_CatalogItems:102]; [Prep_CatalogItems:102]ItemNumber:1=[Prep_Charges:103]PrepItemNumber:4)
End if 

If ([Prep_Charges:103]ControlNumber:1="")
	[Prep_Charges:103]ControlNumber:1:=[Finished_Goods_Specifications:98]ControlNumber:2
End if 
//