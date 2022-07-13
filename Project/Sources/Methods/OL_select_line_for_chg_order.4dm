//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 12/03/10, 13:12:05
// ----------------------------------------------------
// Method: OL_select_line_for_chg_order
// ----------------------------------------------------

C_TEXT:C284($1)

QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderNumber:1=[Customers_Order_Change_Orders:34]OrderNo:5)
ORDER BY:C49([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderLine:3; >)
$Count:=Records in selection:C76([Customers_Order_Lines:41])

If ($Count>0)
	ARRAY LONGINT:C221(aL1; $Count)
	ARRAY LONGINT:C221(aL2; $Count)
	ARRAY LONGINT:C221(aL3; $Count)
	ARRAY TEXT:C222(aCPN; $Count)
	SELECTION TO ARRAY:C260([Customers_Order_Lines:41]; aL1; [Customers_Order_Lines:41]LineItem:2; aL2; [Customers_Order_Lines:41]ProductCode:5; aCPN; [Customers_Order_Lines:41]Quantity:6; aL3)
	sDlogTitle:="You may select an Order Line for your Change Order."
	uDialog("SelectOrderLine"; 290; 210)
	Case of 
		: (OK=1) & (iMode<=2)  //if this is not in review mode
			GOTO RECORD:C242([Customers_Order_Lines:41]; aL1{aL2})
			If (Count parameters:C259=1)
				CREATE RECORD:C68([Customers_Order_Changed_Items:176])
				[Customers_Order_Changed_Items:176]id_added_by_converter:41:=[Customers_Order_Change_Orders:34]OrderChg_Items:6
			End if 
			uLoadChgOrdItem
			SAVE RECORD:C53([Customers_Order_Changed_Items:176])
			
		: (iMode>2)
			ALERT:C41("You may not create a Change Order Line since you are currently reviewing"+" these records.")
	End case 
Else 
	ALERT:C41("No Order Lines Found.")
End if 
RELATE MANY:C262([Customers_Order_Change_Orders:34]OrderChg_Items:6)
ORDER BY:C49([Customers_Order_Changed_Items:176]; [Customers_Order_Changed_Items:176]ItemNo:1; >)
