//5/4/95
//091195
If (iMode#3)  //labels
	Case of 
		: (sCriterion3="WIP")  //verify the from location  
			LOAD RECORD:C52([Job_Forms_Items:44])
			If (([Job_Forms_Items:44]JobForm:1#sCriterion5) | ([Job_Forms_Items:44]ProductCode:3#sCriterion1))
				qryJMI(sCriterion5; i1)  //5/4/95
			End if 
			
			If (([Job_Forms_Items:44]Qty_Actual:11+rReal1)>[Job_Forms_Items:44]Qty_Yield:9)
				BEEP:C151
				ALERT:C41("Warning: This quantity will exceed the yield for item "+String:C10([Job_Forms_Items:44]ItemNumber:7)+" on that form.")
				//sCriterion5:="00000.00"
				//GOTO AREA(sCriterion5)
			End if 
			
		: (sCriterion3="Customer")  //a return
			If ([Customers_Order_Lines:41]OrderLine:3#sCriterion6)
				QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderLine:3=sCriterion6; *)
				QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]ProductCode:5=sCriterion1)
			End if 
			If (rReal1>([Customers_Order_Lines:41]Qty_Shipped:10-[Customers_Order_Lines:41]Qty_Returned:35))  //verify the quantity
				BEEP:C151
				ALERT:C41("Quantity shipped is less than what you are trying to return.")
				GOTO OBJECT:C206(rReal1)
			End if 
			
		: (iMode=5)  //bill and hold
			QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]ProductCode:1=sCriterion1; *)
			QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]Location:2="fg@")
			If (rReal1>(Sum:C1([Finished_Goods_Locations:35]QtyOH:9)))  //verify the quantity
				BEEP:C151
				ALERT:C41("Quantity on-hand in FG locations is less than what you are trying to move.")
				GOTO OBJECT:C206(rReal1)
			End if 
			
		Else 
			If (([Finished_Goods_Locations:35]JobForm:19#sCriterion5) | ([Finished_Goods_Locations:35]ProductCode:1#sCriterion1) | ([Finished_Goods_Locations:35]Location:2=sCriterion3))
				QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]JobForm:19=sCriterion5; *)
				QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]ProductCode:1=sCriterion1; *)
				QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]Location:2=sCriterion3; *)
				QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]JobFormItem:32=i1)  //091195
			End if 
			
			If (rReal1>[Finished_Goods_Locations:35]QtyOH:9)  //verify the quantity
				BEEP:C151
				ALERT:C41("Quantity on-hand in that location is less than what you are trying to move.")
				GOTO OBJECT:C206(rReal1)
			End if 
			
	End case 
End if   //mode