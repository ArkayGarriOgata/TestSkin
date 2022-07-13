//(S)"List All Items" bPriceChg: Price Change
//• 5/22/97 cs upr 1882 - warn user about the use of this button

C_LONGINT:C283($i)
C_BOOLEAN:C305($fCOLine)

$fCOLine:=False:C215

RELATE MANY:C262([Customers_Order_Change_Orders:34]OrderChg_Items:6)
If (Records in selection:C76([Customers_Order_Changed_Items:176])>0)
	uConfirm("'List All Items' should only be used to change every order line."+Char:C90(13)+"Delete existing lines?"; "Delete"; "I'll Use '+'")
	If (OK=1)
		//ALL SUBRECORDS([Customers_Order_Change_Orders]OrderChg_Items)
		
		util_DeleteSelection(->[Customers_Order_Changed_Items:176])
		//Delete Subrecords  
		//While (Records in subselection([Customers_Order_Change_Orders]OrderChg_Items)>0)
		//DELETE SUBRECORD([Customers_Order_Change_Orders]OrderChg_Items)
		//ALL SUBRECORDS([Customers_Order_Change_Orders]OrderChg_Items)
		//End while 
		//
		$fCOLine:=True:C214
		
	Else 
		BEEP:C151
		$fCOLine:=False:C215
	End if 
	
Else 
	$fCOLine:=True:C214
End if 

If ($fCOLine)
	QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderNumber:1=[Customers_Order_Change_Orders:34]OrderNo:5)
	ORDER BY:C49([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderLine:3; >)
	If (Records in selection:C76([Customers_Order_Lines:41])>0)
		For ($i; 1; Records in selection:C76([Customers_Order_Lines:41]))
			CREATE RECORD:C68([Customers_Order_Changed_Items:176])
			[Customers_Order_Changed_Items:176]id_added_by_converter:41:=[Customers_Order_Change_Orders:34]OrderChg_Items:6
			uLoadChgOrdItem
			SAVE RECORD:C53([Customers_Order_Changed_Items:176])
			NEXT RECORD:C51([Customers_Order_Lines:41])
		End for 
	End if 
End if 
RELATE MANY:C262([Customers_Order_Change_Orders:34]OrderChg_Items:6)
ORDER BY:C49([Customers_Order_Changed_Items:176]; [Customers_Order_Changed_Items:176]ItemNo:1; >)