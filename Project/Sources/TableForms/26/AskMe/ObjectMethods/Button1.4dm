If ([Finished_Goods_Transactions:33]ProductCode:1=sCPN)
	If (<>pid_CAR#0)
		zwStatusMsg("Calling CAR"; "Sending selected jobit.")
		<>jobit:=[Finished_Goods_Transactions:33]Jobit:31
		CUT NAMED SELECTION:C334([Customers_Order_Lines:41]; "holdOL")
		$slash:=Position:C15("/"; [Finished_Goods_Transactions:33]OrderItem:16)
		QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderLine:3=(Substring:C12([Finished_Goods_Transactions:33]OrderItem:16; 1; ($slash-1))))
		If (Records in selection:C76([Customers_Order_Lines:41])=1)
			<>PO:=[Customers_Order_Lines:41]PONumber:21
		Else 
			<>PO:=""
		End if 
		USE NAMED SELECTION:C332("holdOL")
		POST OUTSIDE CALL:C329(<>pid_CAR)
		//cancel
		HIDE PROCESS:C324(Current process:C322)
		
	Else 
		BEEP:C151
	End if 
	
Else 
	BEEP:C151
End if 