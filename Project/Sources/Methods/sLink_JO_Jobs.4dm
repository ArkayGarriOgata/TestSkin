//%attributes = {"publishedWeb":true}
//sLink_JO_Jobs()        ---JML-9/15/93
//array procedure script in Job arrays of the 
//layout [control];"Link_Js_to_Os"
$Continue:=False:C215  // tells us to move on to next selected item.


If (vViaWho="FromOrders")  //that means this is known array
	//for now, this is not going to bew allowed
	If (vOldJobItem#asJProdCode)  //line has changed    
		If (vLinkDirty)
			CONFIRM:C162("Links have been defined but not saved."+"  Do you wish to discard these links?")
			If (OK#1)
				$Continue:=False:C215
				asJProdCode:=vOldJobItem
			Else   //user wants to ignore all those changes
				$Continue:=True:C214
				vLinkDirty:=False:C215
			End if 
		Else   //no links were specified
			$Continue:=True:C214
		End if 
	Else   //line has not changed 
		$Continue:=False:C215
	End if 
	If (vLinkDirty & $Continue)  //update data  records
		vLinkDirty:=False:C215
	End if 
	
Else   //Since we changed Jobmake item, find new relevant ordrlines
	If (vOldJobItem=asJProdCode)
		//then do nothing
	Else 
		If (asJProdCode=0)
			BEEP:C151
			asJProdCode:=vOldJobItem
		Else 
			QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]ProductCode:5=asJProdCode{asJProdCode}; *)
			QUERY:C277([Customers_Order_Lines:41];  & [Customers_Order_Lines:41]Qty_Open:11>0)
			SELECTION TO ARRAY:C260([Customers_Order_Lines:41]OrderLine:3; asOOrderID; [Customers_Order_Lines:41]ProductCode:5; asOProdCode; [Customers_Order_Lines:41]Qty_Open:11; asOQtyOpen)
			SORT ARRAY:C229(asOOrderID; asOProdCode; asOQtyOpen; >)
			vOldOrdItem:=0
		End if 
	End if 
	
	
End if 
vOldJobItem:=asJProdCode
asJOrderID:=vOldJobItem
asJQty:=vOldJobItem
aJobItem:=vOldJobItem
