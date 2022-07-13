If (([Job_Forms_Items:44]ProductCode:3#[Finished_Goods_Locations:35]ProductCode:1) | ([Job_Forms_Items:44]JobForm:1#[Finished_Goods_Locations:35]JobForm:19))
	//SEARCH([JobMakesItem];[JobMakesItem]ProductCode=[FG_Locations]ProductCode;*)
	//SEARCH([JobMakesItem]; & [JobMakesItem]JobForm=[FG_Locations]JobForm)
	qryJMI([Finished_Goods_Locations:35]JobForm:19; 0; [Finished_Goods_Locations:35]ProductCode:1)
	
	If (Records in selection:C76([Job_Forms_Items:44])>1)  //•080395  MLB  UPR 1490
		// ******* Verified  - 4D PS - January  2019 ********
		
		QUERY SELECTION:C341([Job_Forms_Items:44]; [Job_Forms_Items:44]ItemNumber:7=[Finished_Goods_Locations:35]JobFormItem:32)
		
		
		// ******* Verified  - 4D PS - January 2019 (end) *********
	End if 
	
End if 
//