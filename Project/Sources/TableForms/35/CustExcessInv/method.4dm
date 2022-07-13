//Layout Proc.: CustExcessInv()  080195  MLB
//•080195  MLB  UPR 213
Case of 
	: (In header:C112)
		If (Level:C101=1)
			If ([Customers:16]ID:1#[Finished_Goods_Locations:35]CustID:16)
				QUERY:C277([Customers:16]; [Customers:16]ID:1=[Finished_Goods_Locations:35]CustID:16)
			End if 
			USE SET:C118("OpenOrders")
			// ******* Verified  - 4D PS - January  2019 ********
			
			QUERY SELECTION:C341([Customers_Order_Lines:41]; [Customers_Order_Lines:41]CustID:4=[Finished_Goods_Locations:35]CustID:16)
			
			
			// ******* Verified  - 4D PS - January 2019 (end) *********
			CREATE SET:C116([Customers_Order_Lines:41]; "OneCustOrders")
			r21:=0
			r31:=0
		End if 
		
		
	: (In break:C113)
		Case of 
			: (Level:C101=2)
				If ([Finished_Goods:26]FG_KEY:47#([Finished_Goods_Locations:35]CustID:16+":"+[Finished_Goods_Locations:35]ProductCode:1))
					qryFinishedGood([Finished_Goods_Locations:35]CustID:16; [Finished_Goods_Locations:35]ProductCode:1)
				End if 
				r1:=Subtotal:C97([Finished_Goods_Locations:35]QtyOH:9)
				USE SET:C118("OneCustOrders")
				// ******* Verified  - 4D PS - January  2019 ********
				
				QUERY SELECTION:C341([Customers_Order_Lines:41]; [Customers_Order_Lines:41]ProductCode:5=[Finished_Goods_Locations:35]ProductCode:1)
				
				// ******* Verified  - 4D PS - January 2019 (end) *********
				
				C_LONGINT:C283($i; $ords; $open)
				$open:=0
				$ords:=Records in selection:C76([Customers_Order_Lines:41])
				If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
					
					For ($i; 1; $ords)
						$open:=$open+(([Customers_Order_Lines:41]Quantity:6*(1+([Customers_Order_Lines:41]OverRun:25/100)))-[Customers_Order_Lines:41]Qty_Shipped:10+[Customers_Order_Lines:41]Qty_Returned:35)
						NEXT RECORD:C51([Customers_Order_Lines:41])
					End for 
					
				Else 
					
					ARRAY LONGINT:C221($_Quantity; 0)
					ARRAY REAL:C219($_OverRun; 0)
					ARRAY LONGINT:C221($_Qty_Shipped; 0)
					ARRAY LONGINT:C221($_Qty_Returned; 0)
					
					SELECTION TO ARRAY:C260([Customers_Order_Lines:41]Quantity:6; $_Quantity; \
						[Customers_Order_Lines:41]OverRun:25; $_OverRun; \
						[Customers_Order_Lines:41]Qty_Shipped:10; $_Qty_Shipped; \
						[Customers_Order_Lines:41]Qty_Returned:35; $_Qty_Returned)
					
					For ($i; 1; $ords; 1)
						$open:=$open+(($_Quantity{$i}*(1+($_OverRun{$i}/100)))-$_Qty_Shipped{$i}+$_Qty_Returned{$i})
					End for 
					
				End if   // END 4D Professional Services : January 2019 query selection
				
				If (r1>$open)
					r2:=r1-$open
				Else 
					r2:=0
				End if 
				r21:=r21+r2
				r31:=r31+((r2/1000)*[Finished_Goods:26]LastPrice:27)
				If (fSave)
					SEND PACKET:C103(vDoc; [Finished_Goods_Locations:35]CustID:16+Char:C90(9)+[Customers:16]Name:2+Char:C90(9)+[Finished_Goods_Locations:35]ProductCode:1+Char:C90(9)+[Finished_Goods:26]CartonDesc:3+Char:C90(9))
					SEND PACKET:C103(vDoc; String:C10(r2)+Char:C90(9))
					SEND PACKET:C103(vDoc; String:C10([Finished_Goods:26]LastPrice:27)+Char:C90(9))
					SEND PACKET:C103(vDoc; Char:C90(13))
				End if 
				
		End case 
		
End case 
//