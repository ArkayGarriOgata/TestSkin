If (Form event code:C388=On Header:K2:17)
	QUERY:C277([Customers:16]; [Customers:16]ID:1=[Customers_Order_Lines:41]CustID:4)
	xCustName:=[Customers:16]Name:2
End if 

If (Form event code:C388=On Display Detail:K2:22)
	C_REAL:C285(xQtyAllow; xQtyGlued; xQtyToExam; xQtyFrExam; xQtyAvail; xQtyOnHand; xQtyShort)
	C_TEXT:C284(xJobits)
	
	
	
	QUERY:C277([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]CartonSpecKey:7=[Customers_Order_Lines:41]CartonSpecKey:19)
	If (Records in selection:C76([Estimates_Carton_Specs:19])#0)
		xQtyAllow:=[Customers_Order_Lines:41]Quantity:6*[Estimates_Carton_Specs:19]OverRun:47
	Else 
		xQtyAllow:=[Customers_Order_Lines:41]Quantity:6
	End if 
	
	QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]OrderItem:2=[Customers_Order_Lines:41]OrderLine:3)
	If (Records in selection:C76([Job_Forms_Items:44])#0)
		xQtyGlued:=Sum:C1([Job_Forms_Items:44]Qty_Actual:11)
	Else 
		xQtyGlued:=0
	End if 
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
		
		QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]ProductCode:1=[Customers_Order_Lines:41]ProductCode:5; *)
		QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]CustID:12=[Customers_Order_Lines:41]CustID:4)
		QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]OrderItem:16=[Customers_Order_Lines:41]OrderLine:3)
		QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]Location:9="examining")
		
	Else 
		
		QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]ProductCode:1=[Customers_Order_Lines:41]ProductCode:5; *)
		QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]CustID:12=[Customers_Order_Lines:41]CustID:4; *)
		QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]OrderItem:16=[Customers_Order_Lines:41]OrderLine:3; *)
		QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]Location:9="examining")
		
	End if   // END 4D Professional Services : January 2019 query selection
	
	//This might notwork-do we always now which [OrderLine] a transaction is associate
	If (Records in selection:C76([Finished_Goods_Transactions:33])#0)
		xQtyToExam:=Sum:C1([Finished_Goods_Transactions:33]Qty:6)
	Else 
		xQtyToExam:=0
	End if 
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
		
		QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]ProductCode:1=[Customers_Order_Lines:41]ProductCode:5; *)
		QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]CustID:12=[Customers_Order_Lines:41]CustID:4)
		QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]viaLocation:11="WIP")
		QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]Location:9="FG@")
		
		
	Else 
		
		QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]ProductCode:1=[Customers_Order_Lines:41]ProductCode:5; *)
		QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]CustID:12=[Customers_Order_Lines:41]CustID:4; *)
		QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]viaLocation:11="WIP"; *)
		QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]Location:9="FG@"; *)
		
		
	End if   // END 4D Professional Services : January 2019 query selection
	//This might notwork-do we always now which [OrderLine] a transaction is associate
	If (Records in selection:C76([Finished_Goods_Transactions:33])#0)
		xQtyTrans:=Sum:C1([Finished_Goods_Transactions:33]Qty:6)
	Else 
		xQtyTrans:=0
	End if 
	
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
		
		QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]ProductCode:1=[Customers_Order_Lines:41]ProductCode:5; *)
		QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]CustID:12=[Customers_Order_Lines:41]CustID:4)
		QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]OrderItem:16=[Customers_Order_Lines:41]OrderLine:3)
		QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]viaLocation:11="Examining")
		QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]Location:9#"Scrap")
		
		
	Else 
		
		QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]ProductCode:1=[Customers_Order_Lines:41]ProductCode:5; *)
		QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]CustID:12=[Customers_Order_Lines:41]CustID:4; *)
		QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]OrderItem:16=[Customers_Order_Lines:41]OrderLine:3; *)
		QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]viaLocation:11="Examining"; *)
		QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]Location:9#"Scrap")
		
		
	End if   // END 4D Professional Services : January 2019 query selection
	//This might notwork-do we always now which [OrderLine] a transaction is associate
	If (Records in selection:C76([Finished_Goods_Transactions:33])#0)
		xQtyfrExam:=Sum:C1([Finished_Goods_Transactions:33]Qty:6)
	Else 
		xQtyFrExam:=0
	End if 
	
	
	xQtyAvail:=xQtyGlued-xQtyToExam+xQtyFrExam
	
	QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]ProductCode:1=[Customers_Order_Lines:41]ProductCode:5; *)
	QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]CustID:16=[Customers_Order_Lines:41]CustID:4)
	If (Records in selection:C76([Finished_Goods_Locations:35])#0)
		xQtyOnHand:=Sum:C1([Finished_Goods_Locations:35]QtyOH:9)
	Else 
		xQtyOnHand:=0
	End if 
	
	xQtyShort:=xQtyAllow-[Customers_Order_Lines:41]Qty_Shipped:10-xQtyonHand
	
	$T:=Records in selection:C76([Job_Forms_Items:44])
	xJobits:=""  //String($T)
	//this code cause automatic relation from jobits to orderlines to screw up report•
	//until this is made into a manual relation, we can't do this 
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
		
		For ($X; 1; $T)
			xJobits:=xJobITs+[Job_Forms_Items:44]JobForm:1+"  "
			NEXT RECORD:C51([Job_Forms_Items:44])
		End for 
		
		
	Else 
		
		ARRAY TEXT:C222($_JobForm; 0)
		SELECTION TO ARRAY:C260([Job_Forms_Items:44]JobForm:1; $_JobForm)
		
		For ($X; 1; $T)
			xJobits:=xJobITs+$_JobForm{$X}+"  "
		End for 
		
	End if   // END 4D Professional Services : January 2019 query selection
	
	
	
End if 