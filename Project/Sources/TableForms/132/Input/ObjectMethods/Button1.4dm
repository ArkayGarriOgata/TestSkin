If ([Finished_Goods_SizeAndStyles:132]DateSubmitted:5#!00-00-00!)
	//[FG_Specification]DateSubmitted:=4D_Current_date
	//bSubmit:=1
	SAVE RECORD:C53([Finished_Goods_SizeAndStyles:132])
	FORM SET OUTPUT:C54([Finished_Goods_SizeAndStyles:132]; "ConstructionWorkOrder")
	
	
	PRINT RECORD:C71([Finished_Goods_SizeAndStyles:132])
	FORM SET OUTPUT:C54([Finished_Goods_SizeAndStyles:132]; "list")
	
Else 
	BEEP:C151
	uConfirm("Can't print without setting Submit."; "OK"; "Help")
End if 