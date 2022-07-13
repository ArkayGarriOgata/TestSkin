//(s) [orderchghistory]changeitems'newqty
//• 10/7/97 cs upr 225
Case of 
	: (Form event code:C388=On Data Change:K2:15)
		If (fOnlyOne)  //order has started to ship
			If ([Customers_Order_Lines:41]LineItem:2#[Customers_Order_Changed_Items:176]ItemNo:1)  //the correct order line is not in mem
				CREATE SET:C116([Customers_Order_Lines:41]; "hold")
				QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderNumber:1=[Customers_Order_Change_Orders:34]OrderNo:5; *)
				QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]LineItem:2=[Customers_Order_Changed_Items:176]ItemNo:1)
			End if 
			$Total:=[Customers_Order_Lines:41]Qty_Shipped:10-[Customers_Order_Lines:41]Qty_Returned:35
			
			If ($Total>Self:C308->)
				uConfirm("You may NOT reduce the Order "+" below the amount already shipped."+"  To reduce the Order below shipped amounts do a 'RevShip' or 'Return'"+Char:C90(13)+"Set Order Quantity to Shipped Quantity?"; "Ship Qty"; "No Change")
				
				If (OK=1)
					Self:C308->:=$Total
				Else 
					Self:C308->:=[Customers_Order_Changed_Items:176]OldQty:2
				End if 
			End if 
		Else 
			If (Self:C308->=0) & (Old:C35(Self:C308->)>0)  //• 10/7/97 cs upr 225
				uConfirm("Reducing this quantity to zero will result in the removal"+" of the original orderline"+Char:C90(13)+"Leave this quantity at Zero?"; "Zero"; "Revert")
				If (OK=0)
					Self:C308->:=Old:C35(Self:C308->)
				End if 
			End if 
		End if 
End case 



//