xText:=""

$picked:=0
For ($i; 1; Size of array:C274(aPicked))
	$picked:=$picked+aPicked{$i}
	aQtyOnHand{$i}:=aQtyOnHand{$i}-aPicked{$i}
End for 



READ WRITE:C146([Customers_Order_Lines:41])
QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderLine:3=aOL{PickListBox})
If (fLockNLoad(->[Customers_Order_Lines:41]))
	READ WRITE:C146([Customers_Orders:40])
	RELATE ONE:C42([Customers_Order_Lines:41]OrderNumber:1)
	sPONum2:=[Customers_Order_Lines:41]PONumber:21
	sCPN:=[Customers_Order_Lines:41]ProductCode:5
	
	sBreakText:=aPO{PickListBox}
	iRelNumber:=aRelNum{PickListBox}
	t3:="SHIPPED FROM RAMA"
	
	READ WRITE:C146([Customers_ReleaseSchedules:46])
	GOTO RECORD:C242([Customers_ReleaseSchedules:46]; aRecNum{PickListBox})
	If (fLockNLoad(->[Customers_ReleaseSchedules:46]))
		
		$continue:=True:C214
		REDUCE SELECTION:C351([Customers_Bills_of_Lading:49]; 0)  //so no latent values are found in invoice & orderline steps
		$XactDate:=4D_Current_date
		$invoiceNum:=Invoice_GetNewNumber
		
		START TRANSACTION:C239
		
		//*Find out which bins to relieve
		For ($i; 1; Size of array:C274(aBin))
			
			If (aPicked{$i}>0)
				If ($continue)  //*        Post a F|G transaction  
					GOTO RECORD:C242([Finished_Goods_Locations:35]; aRecNo{$i})  //load some stuff for the fgTrans    
					sCriterion1:=[Finished_Goods_Locations:35]ProductCode:1
					sCriterion2:=[Finished_Goods_Locations:35]CustID:16
					sCriterion3:=aBin{$i}
					sCriterion5:=[Finished_Goods_Locations:35]JobForm:19
					i1:=[Finished_Goods_Locations:35]JobFormItem:32
					rReal1:=aPicked{$i}
					sCriterion6:=[Customers_Order_Lines:41]OrderLine:3+"/PayU"+String:C10($invoiceNum)
					sCriterion4:="Customer"
					sCriterion7:=""
					sCriterion8:=""
					sCriterion9:="Pay-Use"
					sCriter10:=aPallet{$i}
					FGX_post_transaction($XactDate; 1; "Ship")
					$continue:=FGL_InventoryShipped(aRecNo{$i}; aPicked{$i})  //*      Relieve inventory 
					
				Else 
					$i:=$i+Size of array:C274(aBin)
				End if 
			End if   //qty taken
			
		End for 
		
		If ($continue)
			[Customers_ReleaseSchedules:46]Actual_Qty:8:=[Customers_ReleaseSchedules:46]Actual_Qty:8+$picked
			[Customers_ReleaseSchedules:46]OpenQty:16:=[Customers_ReleaseSchedules:46]OpenQty:16-$picked
			[Customers_ReleaseSchedules:46]Actual_Date:7:=$XactDate
			[Customers_ReleaseSchedules:46]ModDate:18:=$XactDate
			[Customers_ReleaseSchedules:46]ModWho:19:=<>zResp
			[Customers_ReleaseSchedules:46]InvoiceNumber:9:=$invoiceNum
			[Customers_ReleaseSchedules:46]B_O_L_number:17:=-200  // special flag so release trigger doesn't try to re invoice
			SAVE RECORD:C53([Customers_ReleaseSchedules:46])
			
			
			//*Send invoice
			$cpn:=sCriterion1  //•101095  MLB  
			$billto:=[Customers_Order_Lines:41]defaultBillto:23  //               stuff for invoice
			$shipto:=""  //             stuff for invoice
			$BOLnum:=0  //    stuff for invoice
			$FOB:=""  //                     stuff for invoice
			$custID:=[Customers_Order_Lines:41]CustID:4  //              stuff for invoice
			$currRel:=0
			
			
			
			$err:=Invoice_NewPayUse([Customers_Order_Lines:41]OrderLine:3; $invoiceNum; t3; $picked; sBreakText)  //•060499  mlb  UPR 236 add comment to invoice
			
			//*Book shipment  
			dAppDate:=$XactDate  //4D_Current_date  `4/5/95 use ship date for xactions and invoice
			
			//*Post to Log 
			xText:=xText+Char:C90(13)
			xText:=xText+"          PO Nº: "+sPONum2+Char:C90(13)
			xText:=xText+"     Invoice Nº: "+String:C10($invoiceNum)+Char:C90(13)
			xText:=xText+"           Date: "+String:C10($XactDate; <>SHORTDATE)+Char:C90(13)
			xText:=xText+"        Bill to: "+$billto+Char:C90(13)
			xText:=xText+"Customer Reference: "+sBreakText+Char:C90(13)
			xText:=xText+String:C10($picked; "###,###,##0")+" of CPN: "+sCriterion1+" @ "+String:C10([Customers_Order_Lines:41]Price_Per_M:8; "$##,##0.00")+" /M"+Char:C90(13)
			xText:=xText+t3+Char:C90(13)
			
			CREATE RECORD:C68([Customers_BilledPayUse:86])
			[Customers_BilledPayUse:86]Orderline:1:=[Customers_Order_Lines:41]OrderLine:3
			[Customers_BilledPayUse:86]PONumber:2:=sPONum2
			[Customers_BilledPayUse:86]CustReleaseNum:3:=sBreakText
			[Customers_BilledPayUse:86]Invoice:4:=$invoiceNum
			[Customers_BilledPayUse:86]InvoiceDate:5:=$XactDate
			[Customers_BilledPayUse:86]QuantityBilled:6:=$picked
			[Customers_BilledPayUse:86]ProductCode:7:=sCriterion1
			[Customers_BilledPayUse:86]InvoiceMemo:8:=t3
			SAVE RECORD:C53([Customers_BilledPayUse:86])
			
			VALIDATE TRANSACTION:C240
			
			aQtyAct{PickListBox}:=$picked
			aQtyShipable{PickListBox}:=aQtyShipable{PickListBox}-$picked
			aInvoice{PickListBox}:=$invoiceNum
			
		Else 
			ALERT:C41("inventory relief failed")
			CANCEL TRANSACTION:C241
		End if 
		
	Else   //rel
		ALERT:C41("release locked")
	End if   //rel locked
	
Else   //ord
	ALERT:C41("orderline locked")
End if   //ord locked
