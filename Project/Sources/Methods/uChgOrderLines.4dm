//%attributes = {"publishedWeb":true}
//uChgOrderLines  code simplification  11/8/94
//upr 1380 12/20/94
//upr 1411 1/25/95 fix infinit loop
//2/2/94 but sales rep into new orderlines.
//upr 1148 02/13/95 chip
//upr 1268 02/15/95 chip
//upr 1447 3/6/95
//•051595  MLB  UPR 1508
//•060295  MLB  UPR 184
//•072395  MLB  set status if closed
//• mlb - 8/21/02  11:03 add pjtnum on new orderlines
// Modified by: Mel Bohince (11/12/15) add logging to find v14.4 failure
// Modified by: Mel Bohince (11/13/15) first record isn't loading even with explicit call

C_TEXT:C284($Brand; $orderline)


If ([Customers_Order_Change_Orders:34]NewBrand:42#"")  //•060295  MLB  UPR 184
	$Brand:=[Customers_Order_Change_Orders:34]NewBrand:42
Else 
	$Brand:=[Customers_Order_Change_Orders:34]OldBrand:43
End if 
USE SET:C118("Lines")
LOAD RECORD:C52([Customers_Order_Changed_Items:176])  // Modified by: Mel Bohince (11/13/15) 
$orderline:=fMakeOLkey([Customers_Order_Change_Orders:34]OrderNo:5; [Customers_Order_Changed_Items:176]ItemNo:1)
utl_Logfile("debug.log"; "CCO# Query: "+$orderline)
// ******* Verified  - 4D PS - January  2019 ********

QUERY SELECTION:C341([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderLine:3=$orderline)

// ******* Verified  - 4D PS - January 2019 (end) *********

If (Records in selection:C76([Customers_Order_Lines:41])=0)
	CREATE RECORD:C68([Customers_Order_Lines:41])
	//see also uLinesLikeOrder
	[Customers_Order_Lines:41]OrderLine:3:=fMakeOLkey([Customers_Order_Change_Orders:34]OrderNo:5; [Customers_Order_Changed_Items:176]ItemNo:1)
	//[OrderLines]OrderLine:=String([OrderChgHistory]OrderNo;"00000.")
	//«+String([OrderChgHistory]OrderChg_Items'ItemNo;"00")
	[Customers_Order_Lines:41]OrderNumber:1:=[Customers_Order_Change_Orders:34]OrderNo:5
	[Customers_Order_Lines:41]LineItem:2:=[Customers_Order_Changed_Items:176]ItemNo:1
	[Customers_Order_Lines:41]CustID:4:=[Customers_Order_Change_Orders:34]CustID:2
	[Customers_Order_Lines:41]DateOpened:13:=4D_Current_date
	[Customers_Order_Lines:41]zCount:18:=1  //`•051595  MLB  UPR 1508
	If ([Customers_Order_Lines:41]OrderNumber:1#[Customers_Orders:40]OrderNumber:1)  //2/2/95
		READ ONLY:C145([Customers_Orders:40])
		QUERY:C277([Customers_Orders:40]; [Customers_Orders:40]OrderNumber:1=[Customers_Order_Lines:41]OrderNumber:1)
	End if 
	[Customers_Order_Lines:41]SalesRep:34:=[Customers_Orders:40]SalesRep:13  //2/2/95
	[Customers_Order_Lines:41]ProjectNumber:50:=[Customers_Orders:40]ProjectNumber:53  //• mlb - 8/21/02  11:03
	//[Customers_Order_Lines]CustomerName:=cust_getname([Customers_Order_Lines]CustID) now in trigger
	SAVE RECORD:C53([Customers_Order_Lines:41])
End if   //order line doen't exsist

If (fLockNLoad(->[Customers_Order_Lines:41]))
	[Customers_Order_Lines:41]Status:9:="Accepted"
	[Customers_Order_Lines:41]ProductCode:5:=[Customers_Order_Changed_Items:176]NewProductCode:10  //change name later
	[Customers_Order_Lines:41]Quantity:6:=[Customers_Order_Changed_Items:176]NewQty:4
	[Customers_Order_Lines:41]Qty_Open:11:=[Customers_Order_Lines:41]Quantity:6-[Customers_Order_Lines:41]Qty_Shipped:10
	utl_Logfile("debug.log"; "CCO#"+[Customers_Order_Lines:41]OrderLine:3+" "+String:C10([Customers_Order_Changed_Items:176]NewQty:4)+" @ "+String:C10([Customers_Order_Changed_Items:176]NewPrice:5)+" item# "+String:C10([Customers_Order_Changed_Items:176]ItemNo:1))
	
	[Customers_Order_Lines:41]Price_Per_M:8:=[Customers_Order_Changed_Items:176]NewPrice:5
	If (Length:C16([Customers_Order_Lines:41]edi_line_status:55)>0)
		FG_Contract_Price_Change([Customers_Order_Lines:41]ProductCode:5; [Customers_Order_Lines:41]Price_Per_M:8)
	End if 
	[Customers_Order_Lines:41]Cost_Per_M:7:=[Customers_Order_Changed_Items:176]NewCost:14
	[Customers_Order_Lines:41]CostLabor_Per_M:30:=[Customers_Order_Changed_Items:176]NewLaborCost:19
	[Customers_Order_Lines:41]CostOH_Per_M:31:=[Customers_Order_Changed_Items:176]NewOHCost:21
	[Customers_Order_Lines:41]CostMatl_Per_M:32:=[Customers_Order_Changed_Items:176]NewMatlCost:17
	[Customers_Order_Lines:41]CostScrap_Per_M:33:=[Customers_Order_Changed_Items:176]NewSECost:23
	[Customers_Order_Lines:41]CartonSpecKey:19:=[Customers_Order_Changed_Items:176]CartonSpecKey:6  //upr 1148 02/13/95 chip
	[Customers_Order_Lines:41]SpecialBilling:37:=[Customers_Order_Changed_Items:176]SpecialBilling:38  //upr 1268 02/15/95 chip
	[Customers_Order_Lines:41]ExcessQtySold:40:=[Customers_Order_Changed_Items:176]NewExcessQty:40  //upr 1447 3/6/95
	
	If ([Customers_Order_Lines:41]Qty_Open:11<=0)  //•072395  MLB 
		[Customers_Order_Lines:41]Status:9:="Closed"
	Else 
		[Customers_Order_Lines:41]Status:9:="Accepted"
	End if 
	
	If ([Customers_Order_Lines:41]PONumber:21#[Customers_Order_Changed_Items:176]NewPO:12)  //upr 1380 12/20/94
		READ WRITE:C146([Customers_ReleaseSchedules:46])
		RELATE MANY:C262([Customers_Order_Lines:41]OrderLine:3)
		While (Not:C34(End selection:C36([Customers_ReleaseSchedules:46])))
			If ([Customers_ReleaseSchedules:46]Actual_Qty:8>0)
				BEEP:C151
				ALERT:C41("Release number "+String:C10([Customers_ReleaseSchedules:46]ReleaseNumber:1)+" has already shipped, please contact accounting.")
				[Customers_ReleaseSchedules:46]ChangeLog:23:=[Customers_ReleaseSchedules:46]ChangeLog:23+Char:C90(13)+"PO changed from "+[Customers_ReleaseSchedules:46]CustomerRefer:3+" to "+[Customers_Order_Changed_Items:176]NewPO:12+" after being shipped."
			End if 
			[Customers_ReleaseSchedules:46]CustomerRefer:3:=[Customers_Order_Changed_Items:176]NewPO:12
			[Customers_ReleaseSchedules:46]CustomerLine:28:=$Brand  //•060295  MLB  UPR 184
			SAVE RECORD:C53([Customers_ReleaseSchedules:46])
			NEXT RECORD:C51([Customers_ReleaseSchedules:46])  //upr 1411 1/25/95
		End while 
	End if 
	//see also uLinesLikeOrder
	[Customers_Order_Lines:41]PONumber:21:=[Customers_Order_Changed_Items:176]NewPO:12
	[Customers_Order_Lines:41]OrderType:22:=[Customers_Order_Changed_Items:176]NewOrdType:15
	[Customers_Order_Lines:41]ModDate:15:=4D_Current_date
	[Customers_Order_Lines:41]ModWho:16:=<>zResp
	[Customers_Order_Lines:41]FOB:36:=[Customers_Order_Changed_Items:176]New_FOB:29
	[Customers_Order_Lines:41]defaultBillto:23:=[Customers_Order_Changed_Items:176]NewBillto:25
	[Customers_Order_Lines:41]defaultShipTo:17:=[Customers_Order_Changed_Items:176]NewShipto:27
	[Customers_Order_Lines:41]OverRun:25:=[Customers_Order_Changed_Items:176]NewOverRun:31
	[Customers_Order_Lines:41]UnderRun:26:=[Customers_Order_Changed_Items:176]NewUnderRun:33
	[Customers_Order_Lines:41]Classification:29:=[Customers_Order_Changed_Items:176]NewClassificati:35
	[Customers_Order_Lines:41]NeedDate:14:=[Customers_Order_Changed_Items:176]NeedDate:37  //upr 1228  
	[Customers_Order_Lines:41]CustomerLine:42:=$Brand  //•060295  MLB  UPR 184
	If ([Customers_Order_Changed_Items:176]NewProductCode:10="Special Freight")  //ensure that 'special freight do not get into bookings
		[Customers_Order_Lines:41]OrderType:22:=[Customers_Order_Changed_Items:176]NewProductCode:10  //upr 1268 02/16/ 95 chip
		[Customers_Order_Changed_Items:176]OrderType:8:=[Customers_Order_Changed_Items:176]NewProductCode:10
	End if 
	SAVE RECORD:C53([Customers_Order_Lines:41])
	
Else 
	uCancelTran
End if 
//