
If ([Finished_Goods_Specifications:98]OrderNumber:59=0)
	FG_PrepServiceSetFGrecord([Finished_Goods_Specifications:98]ControlNumber:2)
	Pjt_setReferId([Finished_Goods_Specifications:98]ProjectNumber:4)
	[Finished_Goods_Specifications:98]OrderNumber:59:=FG_PrepSetupBill([Finished_Goods_Specifications:98]ControlNumber:2)
	//SAVE RECORD([FG_Specification])
	If ([Finished_Goods_Specifications:98]OrderNumber:59#0)
		//tickle the record so 
		[Finished_Goods_Specifications:98]CommentsFromQA:53:=[Finished_Goods_Specifications:98]CommentsFromQA:53+" "
		ACCEPT:C269
		//REDUCE SELECTION([FG_Specification];0)
	End if 
	
Else 
	READ ONLY:C145([Customers_Orders:40])
	If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
		
		QUERY:C277([Customers_Orders:40]; [Customers_Orders:40]OrderNumber:1=[Finished_Goods_Specifications:98]OrderNumber:59)
		$sFile:=sFile  //cover a side effect of Viewsetter
		<>PassThrough:=True:C214
		CREATE SET:C116([Customers_Orders:40]; "◊PassThroughSet")
		REDUCE SELECTION:C351([Customers_Orders:40]; 0)
		
	Else 
		
		SET QUERY DESTINATION:C396(Into set:K19:2; "◊PassThroughSet")
		QUERY:C277([Customers_Orders:40]; [Customers_Orders:40]OrderNumber:1=[Finished_Goods_Specifications:98]OrderNumber:59)
		SET QUERY DESTINATION:C396(Into current selection:K19:1)
		$sFile:=sFile  //cover a side effect of Viewsetter
		<>PassThrough:=True:C214
		
		
	End if   // END 4D Professional Services : January 2019 
	
	ViewSetter(2; ->[Customers_Orders:40])
	sFile:=$sFile  //Table name(->[Request])  `reset this for normal exit
End if 

FORM GOTO PAGE:C247(1)