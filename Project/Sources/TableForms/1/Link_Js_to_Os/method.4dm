//JML  9/15/93   [control];"Link_js_to_Os"

If (Form event code:C388=On Load:K2:1)
	ARRAY TEXT:C222(asTacID; 0)
	C_TEXT:C284(vLinkInst)
	C_BOOLEAN:C305(vLinkDirty)  //tells us when links need to be saved
	C_LONGINT:C283(vOldJobItem; vOldOrdItem)
	vOldJobItem:=0
	vOldOrdItem:=0
	ARRAY TEXT:C222(asJOrderID; 0)
	ARRAY TEXT:C222(asJProdCode; 0)
	ARRAY LONGINT:C221(asJQty; 0)
	ARRAY LONGINT:C221(aJobItem; 0)
	ARRAY TEXT:C222(asOOrderID; 0)
	ARRAY TEXT:C222(asOProdCode; 0)
	ARRAY LONGINT:C221(asOQty; 0)
	
	Case of 
			
		: (vViaWho="FromOrders")
			vLinkInst:=""
			//fill order line arrays
			RELATE MANY:C262([Customers_Orders:40]OrderNumber:1)
			SELECTION TO ARRAY:C260([Customers_Order_Lines:41]CartonSpecKey:19; $aCPkey; [Customers_Order_Lines:41]OrderLine:3; $aOL; [Customers_Order_Lines:41]ProductCode:5; $aCPN)
			vOldOrdItem:=1
			vOldJobItem:=0
			
		: (vViaWho="FromJobs")
			//fill job item arrays
			SELECTION TO ARRAY:C260([Job_Forms_Items:44]OrderItem:2; asJOrderID; [Job_Forms_Items:44]ProductCode:3; asJProdCode; [Job_Forms_Items:44]Qty_Yield:9; asJQty; [Job_Forms_Items:44]ItemNumber:7; aJobItem)
			vOldJobItem:=1
			asJProdCode:=vOldJobItem
			asJOrderID:=vOldJobItem
			asJQty:=vOldJobItem
			aJobItem:=vOldJobItem
			
			QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]ProductCode:5=asJProdCode{asJProdCode})
			SELECTION TO ARRAY:C260([Customers_Order_Lines:41]OrderLine:3; asOOrderID; [Customers_Order_Lines:41]ProductCode:5; asOProdCode; [Customers_Order_Lines:41]Qty_Open:11; asOQtyOpen)
			SORT ARRAY:C229(asOOrderID; asOProdCode; asOQtyOpen; >)
			
			vOldOrdItem:=0
			
			vLinkInst:="This dialog is used to peg Order Lines to the current Job items."+Char:C90(13)
			vLinkInst:=vLinkInst+"    1:  Select a Job Item -this will update the list of available Orderlines."+Char:C90(13)
			vLinkInst:=vLinkInst+"    2:  Select the desired Order line to peg to this Job item."+Char:C90(13)
			vLinkInst:=vLinkInst+"    3:  Repeat above steps for remaining Job items."+Char:C90(13)
			vLinkInst:=vLinkInst+"    4:  Press the <Post Links> button."+Char:C90(13)
			
	End case 
	
	
End if 