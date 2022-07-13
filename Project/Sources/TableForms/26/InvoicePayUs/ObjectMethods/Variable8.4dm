//Script: bAccept()  092895  MLB
//•101295  MLB  deduct from orderlines
//• 8/20/97 cs remove booking Jim B request
//•4/15/99  MLB  upr236
//•060499  mlb  UPR 236 add comment to invoice
//072903 mlb update a release if possible
C_LONGINT:C283($i; $total; $invoice_number)
C_DATE:C307($XactDate)
$i:=qryFinishedGood("#CPN"; sCPN)
If ($i>0)  //found a fg record
	If (iTotal>0)
		$total:=0
		For ($i; 1; Size of array:C274(asBin))
			$total:=$total+aRel{$i}
		End for 
		If ($total=iTotal)
			
			$continue:=True:C214
			REDUCE SELECTION:C351([Customers_Bills_of_Lading:49]; 0)  //so no latent values are found in invoice & orderline steps
			$XactDate:=4D_Current_date
			$invoiceNum:=Invoice_GetNewNumber
			START TRANSACTION:C239
			//*Find out which bins to relieve
			For ($i; 1; Size of array:C274(asBin))
				If (aRel{$i}>0)
					If ($continue)  //*        Post a F|G transaction  
						GOTO RECORD:C242([Finished_Goods_Locations:35]; aBinRecNum{$i})  //load some stuff for the fgTrans    
						sCriterion1:=[Finished_Goods_Locations:35]ProductCode:1
						sCriterion2:=[Finished_Goods_Locations:35]CustID:16
						sCriterion3:=asBin{$i}
						sCriterion5:=[Finished_Goods_Locations:35]JobForm:19
						i1:=[Finished_Goods_Locations:35]JobFormItem:32
						rReal1:=aRel{$i}
						sCriterion6:=[Customers_Order_Lines:41]OrderLine:3+"/PayU"+String:C10($invoiceNum)
						sCriterion4:="Customer"
						sCriterion7:=""
						sCriterion8:=""
						sCriterion9:="Pay-Use"
						sCriter10:=""
						FGX_post_transaction($XactDate; 1; "Ship")
						$continue:=FGL_InventoryShipped(aBinRecNum{$i}; aRel{$i})  //*      Relieve inventory 
					Else 
						$i:=$i+Size of array:C274(asBin)
					End if 
				End if   //qty taken
				
			End for 
			
			If ($continue)
				//*     Validate   
				VALIDATE TRANSACTION:C240
				
				//*Update orderline
				ARRAY LONGINT:C221(aQty2; 0)
				$commit:=ORD_LineItemShipped(iTotal; $XactDate; [Customers_Order_Lines:41]OrderLine:3)
				If (iRelNumber#0)  //072903 mlb update a release if possible
					[Customers_ReleaseSchedules:46]InvoiceNumber:9:=$invoiceNum
					SAVE RECORD:C53([Customers_ReleaseSchedules:46])
					//$invoice_number:=REL_ReleaseShipped (iTotal;$XactDate;iRelNumber)
					
					$commit:=($invoice_number#No current record:K29:2)
				End if 
				//*Send invoice
				$cpn:=sCriterion1  //•101095  MLB  
				$billto:=[Customers_Order_Lines:41]defaultBillto:23  //               stuff for invoice
				$shipto:=""  //             stuff for invoice
				$BOLnum:=0  //    stuff for invoice
				$FOB:=""  //                     stuff for invoice
				$custID:=[Customers_Order_Lines:41]CustID:4  //              stuff for invoice
				$currRel:=0
				$custPO:=sPONum2
				$custRel:=sBreakText  //•101095  MLB customer refer
				$SubRel:=iTotal
				$Remark:=t3
				
				$err:=Invoice_NewPayUse([Customers_Order_Lines:41]OrderLine:3; $invoiceNum; t3; iTotal; sBreakText)  //•060499  mlb  UPR 236 add comment to invoice
				
				//*Book shipment  
				dAppDate:=$XactDate  //4D_Current_date  `4/5/95 use ship date for xactions and invoice
				
				//*Post to Log 
				xText:=xText+Char:C90(13)
				xText:=xText+"          PO Nº: "+sPONum2+Char:C90(13)
				xText:=xText+"     Invoice Nº: "+String:C10($invoiceNum)+Char:C90(13)
				xText:=xText+"           Date: "+String:C10($XactDate; <>SHORTDATE)+Char:C90(13)
				xText:=xText+"        Bill to: "+$billto+Char:C90(13)
				xText:=xText+"Customer Reference: "+sBreakText+Char:C90(13)
				xText:=xText+String:C10($SubRel; "###,###,##0")+" of CPN: "+$cpn+" @ "+String:C10([Customers_Order_Lines:41]Price_Per_M:8; "$##,##0.00")+" /M"+Char:C90(13)
				xText:=xText+t3+Char:C90(13)
				
				CREATE RECORD:C68([Customers_BilledPayUse:86])
				[Customers_BilledPayUse:86]Orderline:1:=[Customers_Order_Lines:41]OrderLine:3
				[Customers_BilledPayUse:86]PONumber:2:=$custPO
				[Customers_BilledPayUse:86]CustReleaseNum:3:=$custRel
				[Customers_BilledPayUse:86]Invoice:4:=$invoiceNum
				[Customers_BilledPayUse:86]InvoiceDate:5:=$XactDate
				[Customers_BilledPayUse:86]QuantityBilled:6:=iTotal
				[Customers_BilledPayUse:86]ProductCode:7:=$cpn
				[Customers_BilledPayUse:86]InvoiceMemo:8:=$Remark
				SAVE RECORD:C53([Customers_BilledPayUse:86])
				
			Else 
				CANCEL TRANSACTION:C241
				xText:=xText+Char:C90(13)+Char:C90(13)
				xText:=xText+"          PO Nº: "+sPONum2+Char:C90(13)
				xText:=xText+"     Invoice Nº: "+String:C10($invoiceNum)+" ** VOID **"+Char:C90(13)
				xText:=xText+"Transaction Canceled"+Char:C90(13)
			End if 
			
		Else 
			BEEP:C151
			ALERT:C41("The total does not equal the sum of the bin reductions.")
		End if 
	Else 
		BEEP:C151
		ALERT:C41("Invoice quantity must be greater than zero.")
	End if 
Else 
	BEEP:C151
	ALERT:C41(sCPN+" product code not found")
End if 

ARRAY TEXT:C222(asBin; 0)
ARRAY TEXT:C222(aJobit; 0)
ARRAY LONGINT:C221(aQty; 0)
ARRAY LONGINT:C221(aRel; 0)
ARRAY LONGINT:C221(aBinRecNum; 0)
UNLOAD RECORD:C212([Customers_Order_Lines:41])
UNLOAD RECORD:C212([Finished_Goods_Locations:35])
UNLOAD RECORD:C212([Customers_Orders:40])
UNLOAD RECORD:C212([Customers:16])
UNLOAD RECORD:C212([Finished_Goods:26])
UNLOAD RECORD:C212([Customers_ReleaseSchedules:46])

sPOnum2:=""
sCriterion1:=""
iQty:=0
iTotal:=0
sCPN:=""
sBreakText:=""  //•101095  MLB 
GOTO OBJECT:C206(sPOnum2)
//