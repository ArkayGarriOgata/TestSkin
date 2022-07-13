//%attributes = {"publishedWeb":true}
//Procedure: fCustServAllow()  053195  MLB
//•053195  MLB  UPR 1619
//make sure only the proper type of change orders can be sent to customer service

C_BOOLEAN:C305($0)  //return true if this cco can be sent direct to cs

$0:=True:C214  // be optimistic

If (($0) & ([Customers_Order_Change_Orders:34]Cancel_:32))
	$0:=False:C215
End if 

If (($0) & ([Customers_Order_Change_Orders:34]HoldOtherReason:31))
	$0:=False:C215
End if 

If (($0) & ([Customers_Order_Change_Orders:34]SizeChg:7))
	$0:=False:C215
End if 

If (($0) & ([Customers_Order_Change_Orders:34]QtyChg:8))
	$0:=False:C215
End if 

If (($0) & ([Customers_Order_Change_Orders:34]ProcessChg:9))
	$0:=False:C215
End if 

If (($0) & ([Customers_Order_Change_Orders:34]SpecialServiceC:11))
	$0:=False:C215
End if 

If (($0) & ([Customers_Order_Change_Orders:34]GraphicChg:12))
	$0:=False:C215
End if 

If (($0) & ([Customers_Order_Change_Orders:34]AddOrDeleteItem:13))
	$0:=False:C215
End if 

If (($0) & ([Customers_Order_Change_Orders:34]PriceChg:21))
	$0:=False:C215
End if 

If (($0) & ([Customers_Order_Change_Orders:34]FOB_point:25))
	$0:=False:C215
End if 

If (($0) & ([Customers_Order_Change_Orders:34]CPNchg:10))
	$0:=False:C215
End if 

If (($0) & ([Customers_Order_Change_Orders:34]ContinueWith:33))
	$0:=False:C215
End if 

If (($0) & ([Customers_Order_Change_Orders:34]ContinueWithout:34))
	$0:=False:C215
End if 