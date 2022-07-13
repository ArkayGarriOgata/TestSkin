//%attributes = {"publishedWeb":true}
// uFGBillnHold
//upr 1208 9/8/94
//•061295  MLB  UPR 1640
//•080395  MLB  UPR 1490
//•3/27/97cs found bug where jobformitem not assigned during move upr 1840
// Modified by: Mel Bohince (10/8/19) add ship-to to the invoice

C_LONGINT:C283($needed; $i; $numBins)
C_BOOLEAN:C305($continue; $success)
C_DATE:C307($xactionDate)
$success:=True:C214
$xactionDate:=4D_Current_date
//search for valid raw material
QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderLine:3=sCriterion6)
RELATE ONE:C42([Customers_Order_Lines:41]OrderNumber:1)

If (Records in selection:C76([Customers_Order_Lines:41])>0)
	[Customers_Order_Lines:41]Qty_Shipped:10:=[Customers_Order_Lines:41]Qty_Shipped:10+rReal1
	[Customers_Order_Lines:41]Qty_Open:11:=[Customers_Order_Lines:41]Qty_Open:11-rReal1
	If ([Customers_Order_Lines:41]Qty_Open:11<=0)
		[Customers_Order_Lines:41]Status:9:="Closed"
	End if 
	SAVE RECORD:C53([Customers_Order_Lines:41])
	$billto:=[Customers_Order_Lines:41]defaultBillto:23
	$shipto:=[Customers_Order_Lines:41]defaultShipTo:17  // Modified by: Mel Bohince (10/8/19) 
	$custPO:=[Customers_Order_Lines:41]PONumber:21
	qryFinishedGood(sCriterion2; sCriterion1)  //•061295  MLB  UPR 1640 
	
	[Finished_Goods:26]Bill_and_Hold_Qty:108:=[Finished_Goods:26]Bill_and_Hold_Qty:108+rReal1
	SAVE RECORD:C53([Finished_Goods:26])
	$invoiceNum:=Invoice_GetNewNumber
	FGX_post_transaction(Current date:C33; 1; "B&H"+String:C10($invoiceNum))
	
	$Remark:=sCriterion9+" "+sCriterion7
	$err:=Invoice_NewBillandHold([Customers_Order_Lines:41]OrderLine:3; $invoiceNum; $Remark; rReal1)  //•060499  mlb  UPR 236 add comment to invoice
	
	UNLOAD RECORD:C212([Finished_Goods_Transactions:33])
	UNLOAD RECORD:C212([Finished_Goods:26])
	UNLOAD RECORD:C212([Customers_Order_Lines:41])
	
Else 
	BEEP:C151
	uConfirm("A valid customer order number is required.")
	$success:=False:C215
End if 

$0:=$success