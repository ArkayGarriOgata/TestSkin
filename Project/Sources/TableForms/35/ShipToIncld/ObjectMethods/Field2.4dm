If (([Job_Forms_Items:44]ProductCode:3#[Finished_Goods_Locations:35]ProductCode:1) | ([Job_Forms_Items:44]JobForm:1#[Finished_Goods_Locations:35]JobForm:19))
	//SEARCH([JobMakesItem];[JobMakesItem]ProductCode=[FG_Locations]ProductCode;*)
	//SEARCH([JobMakesItem]; & [JobMakesItem]JobForm=[FG_Locations]JobForm)
	qryJMI([Finished_Goods_Locations:35]JobForm:19; [Finished_Goods_Locations:35]JobFormItem:32)  //;[FG_Locations]ProductCode)`121495
	
End if 
//