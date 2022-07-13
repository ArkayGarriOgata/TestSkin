//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 05/30/07, 15:33:50
// ----------------------------------------------------
// Method: FG_getHistoricDates("orders") -> text
// Description
// get the last order, transaction, and release
// ----------------------------------------------------

$0:=""

Case of 
	: ($1="orders")
		READ ONLY:C145([Customers_Order_Lines:41])
		QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]ProductCode:5=[Finished_Goods:26]ProductCode:1)
		If (Records in selection:C76([Customers_Order_Lines:41])>0)
			SELECTION TO ARRAY:C260([Customers_Order_Lines:41]DateOpened:13; $aDate)
			SORT ARRAY:C229($aDate; <)  //reverse chron
			$0:=String:C10($aDate{1})  //latest date
			
		Else 
			$0:="no-orders"
		End if 
		
	: ($1="releases")
		READ ONLY:C145([Customers_ReleaseSchedules:46])
		QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]ProductCode:11=[Finished_Goods:26]ProductCode:1)
		If (Records in selection:C76([Customers_ReleaseSchedules:46])>0)
			SELECTION TO ARRAY:C260([Customers_ReleaseSchedules:46]Sched_Date:5; $aDate)
			SORT ARRAY:C229($aDate; <)  //reverse chron
			$0:=String:C10($aDate{1})  //latest date
			
		Else 
			$0:="no-releases"
		End if 
		
	: ($1="ship")
		READ ONLY:C145([Finished_Goods_Transactions:33])
		QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]ProductCode:1=[Finished_Goods:26]ProductCode:1; *)
		QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]XactionType:2="Ship")
		If (Records in selection:C76([Finished_Goods_Transactions:33])>0)
			SELECTION TO ARRAY:C260([Finished_Goods_Transactions:33]XactionDate:3; $aDate)
			SORT ARRAY:C229($aDate; <)  //reverse chron
			$0:=String:C10($aDate{1})  //latest date
			
		Else 
			$0:="no-shipments"
		End if 
End case 