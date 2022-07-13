// Method: [zz_control].FGTranfers.rReal1   ( ) ->
//5/4/95
//091195
// _______


//•101398  MLB  add up subforms
$jobit:=JMI_makeJobIt(sCriterion5; i1)
If (rReal1<2000000)
	If (iMode#3)  //labels
		Case of 
			: (sCriterion3="WIP")  //verify the from location  
				LOAD RECORD:C52([Job_Forms_Items:44])
				If (([Job_Forms_Items:44]JobForm:1#sCriterion5) | ([Job_Forms_Items:44]ProductCode:3#sCriterion1))
					qryJMI($jobit)  //5/4/95
				End if 
				
				C_LONGINT:C283($sofar; $allowed; $jmi)  //•101398  MLB  add up subforms
				$sofar:=0
				$allowed:=0
				$jmi:=Records in selection:C76([Job_Forms_Items:44])
				Case of 
					: ($jmi=1)
						$sofar:=[Job_Forms_Items:44]Qty_Actual:11
						$allowed:=[Job_Forms_Items:44]Qty_Want:24
					: ($jmi>1)
						$sofar:=Sum:C1([Job_Forms_Items:44]Qty_Actual:11)
						$allowed:=Sum:C1([Job_Forms_Items:44]Qty_Want:24)
				End case 
				
				If (($sofar+rReal1)>$allowed)
					BEEP:C151
					ALERT:C41("This quantity will exceed the WANT for item "+String:C10(i1))
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
				qryFinishedGood(sCriterion2; sCriterion1)
				QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]ProductCode:1=sCriterion1; *)
				QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]Location:2="fg@")
				$qtyWMS:=(Sum:C1([Finished_Goods_Locations:35]QtyOH:9))-[Finished_Goods:26]Bill_and_Hold_Qty:108
				If (rReal1>$qtyWMS)  //verify the quantity
					BEEP:C151
					ALERT:C41("WARNING: Quantity on-hand in FG locations is less than what you are trying to B&H.")
					//rReal1:=$qtyWMS
					EDIT ITEM:C870(rReal1)
				End if 
				
			Else 
				//If (iMode=0)
				//FGL_CalcFXamount ($jobit)
				//End if 
				
				If ([Finished_Goods_Locations:35]Jobit:33#sJobit)
					QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Jobit:33=sJobit; *)
					QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]Location:2=sCriterion3)
				End if 
				
				If (rReal1>[Finished_Goods_Locations:35]QtyOH:9)  //verify the quantity
					BEEP:C151
					ALERT:C41("Quantity on-hand in that location is less than what you are trying to move.")
					GOTO OBJECT:C206(rReal1)
				End if 
				
		End case 
	End if   //mode
	
Else 
	BEEP:C151
	ALERT:C41("Quantity must be less than 2,000,000")
	rReal1:=0
	GOTO OBJECT:C206(rReal1)
End if 
