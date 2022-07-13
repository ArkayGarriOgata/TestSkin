//(LP)[FG_Transactions].CostOfSales
//mod 9/13/94 upr 120
//mod 9/14/94 test and negate returns.
//upr 1309 11/7/94 dont use current orderline price
//11/18/94 test if unit of measure is in thousands
//2/10/95 make correction for price change xaction records
//3/14/95 add invoice number to price chgs
//5/1/95 special billing conciderations, chip
//•051595  MLB  UPR 1508
//•11/15/95 pay use invoice numbers
//•11/16/95 jim asked for special billing to always be /ea instead of /M
//•021696  mBohince
//•030496  MLB  format the GP varible in send packet to "###,##0.00"
//•061998  MLB  add Rebate to PV calc
//•062498  MLB  remove rebate from total pv
//•080498  MLB  use actual cost after closeout
Case of 
	: (Form event code:C388=On Header:K2:17)
		MESSAGES OFF:C175
	: (Form event code:C388=On Printing Detail:K2:18)  //each ORDER record  
		
		real1:=0
		real2:=0
		real3:=0
		real4:=0
		real5:=0
		real6:=0
		real7:=0
		rqty:=0
		QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderLine:3=Substring:C12([Finished_Goods_Transactions:33]OrderItem:16; 1; 8))
		QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]ReleaseNumber:1=Num:C11(Substring:C12([Finished_Goods_Transactions:33]OrderItem:16; 10)))
		
		Case of 
			: ([Finished_Goods_Transactions:33]XactionType:2="Ship")
				rqty:=[Finished_Goods_Transactions:33]Qty:6
				
			: ([Finished_Goods_Transactions:33]XactionType:2="B&H@")  //• 2/9/98 cs fix for the recent inclusion of B&H
				rqty:=[Finished_Goods_Transactions:33]Qty:6
			Else   //treat as a return
				rqty:=-[Finished_Goods_Transactions:33]Qty:6
		End case 
		
		READ ONLY:C145([Finished_Goods:26])
		C_LONGINT:C283($denom)
		qryFinishedGood("#CPN"; [Finished_Goods_Transactions:33]ProductCode:1)
		
		If ([Finished_Goods:26]Acctg_UOM:29="M")
			$denom:=1000
		Else 
			$denom:=1
		End if 
		
		Case of 
			: ([Finished_Goods_Transactions:33]JobForm:5="PriceChg")  //2/10/95 (set by uInvoAdjustment)
				uClearSelection(->[Job_Forms_Items:44])
				$denom:=1
				t10:=[Finished_Goods_Transactions:33]ActionTaken:27  //3/14/95
				
			: ([Customers_Order_Lines:41]SpecialBilling:37)  //5/1/95
				t10:=String:C10([Customers_Order_Lines:41]InvoiceNum:38)  //5/1/95
				uClearSelection(->[Job_Forms_Items:44])
				$denom:=1  //•11/16/95 jim asked for it
				
			: ([Finished_Goods_Transactions:33]Reason:26="Pay-Use")  //•11/15/95
				t10:=Substring:C12([Finished_Goods_Transactions:33]OrderItem:16; 14)  //11/15/95
				qryJMI([Finished_Goods_Transactions:33]JobForm:5; [Finished_Goods_Transactions:33]JobFormItem:30)
				
			: ([Finished_Goods_Transactions:33]Reason:26="Auto-billed")  //•11/15/95
				t10:=Substring:C12([Finished_Goods_Transactions:33]OrderItem:16; 5)  //11/15/95
				uClearSelection(->[Job_Forms_Items:44])
				
			: ([Finished_Goods_Transactions:33]Reason:26="Overshipment")  //•021696  mBohince  shd be -qty, -extPrc, 0 costs
				t10:=String:C10([Customers_ReleaseSchedules:46]InvoiceNumber:9)
				uClearSelection(->[Job_Forms_Items:44])
				
			: ([Finished_Goods_Transactions:33]XactionType:2="B&H@")  //• 2/9/98 cs fix for the recent inclusion of B&H
				t10:=[Finished_Goods_Transactions:33]XactionType:2
				qryJMI([Finished_Goods_Transactions:33]JobForm:5; [Finished_Goods_Transactions:33]JobFormItem:30)  //•051595  MLB  UPR 1508  
				
			Else 
				t10:=String:C10([Customers_ReleaseSchedules:46]InvoiceNumber:9)  //3/14/95
				qryJMI([Finished_Goods_Transactions:33]JobForm:5; [Finished_Goods_Transactions:33]JobFormItem:30)  //•051595  MLB  UPR 1508        
		End case 
		
		real1:=real1+Round:C94(((rqty/$denom)*[Finished_Goods_Transactions:33]PricePerM:19); 2)  //accumulate total allowable    `upr 1309
		Case of 
			: ([Finished_Goods_Transactions:33]Reason:26="Overshipment")  //•021696  mBohince
				rqty:=-[Finished_Goods_Transactions:33]Qty:6
			: ([Finished_Goods_Transactions:33]XactionType:2="B&H@")  //• 2/9/98 cs fix for the recent inclusion of B&H
				rqty:=[Finished_Goods_Transactions:33]Qty:6
		End case 
		//While (Not(End selection([JobMakesItem])))
		If (Records in selection:C76([Job_Forms_Items:44])#0)  //2/10/95
			If ([Job_Forms_Items:44]FormClosed:5) & (<>UseActCost)  //•080498  MLB  
				real2:=real2+Round:C94(([Job_Forms_Items:44]Cost_Mat:12*(rqty/$denom)); 0)
				real3:=real3+Round:C94(([Job_Forms_Items:44]Cost_LAB:13*(rqty/$denom)); 0)
				real4:=real4+Round:C94(([Job_Forms_Items:44]Cost_Burd:14*(rqty/$denom)); 0)
				real7:=real7+Round:C94(([Job_Forms_Items:44]Cost_SE:16*(rqty/$denom)); 0)
			Else 
				real2:=real2+Round:C94(([Job_Forms_Items:44]PldCostMatl:17*(rqty/$denom)); 0)
				real3:=real3+Round:C94(([Job_Forms_Items:44]PldCostLab:18*(rqty/$denom)); 0)
				real4:=real4+Round:C94(([Job_Forms_Items:44]PldCostOvhd:19*(rqty/$denom)); 0)
				real7:=real7+Round:C94(([Job_Forms_Items:44]PldCostS_E:20*(rqty/$denom)); 0)
			End if 
			real5:=real2+real3+real4
			//real6:=((real1-real5)/real1)*100  `•061998  MLB  
			$rebate:=fGetCustRebate([Finished_Goods_Transactions:33]CustID:12)  //•061998  MLB 
			real6:=fProfitVariable("PV"; real5; real1; 0; $rebate)*100  //•061998  MLB 
			
		Else 
			If ([Customers_Order_Lines:41]SpecialBilling:37)  //•051595  MLB  UPR 1508
				real2:=real2+0
				real3:=real3+0
				real4:=real4+Round:C94(([Customers_Order_Lines:41]Cost_Per_M:7*(rqty/$denom)); 0)
				real7:=real7+0
				real5:=real2+real3+real4
				//real6:=((real1-real5)/real1)*100  `•061998  MLB  
				$rebate:=fGetCustRebate([Finished_Goods_Transactions:33]CustID:12)  //•061998  MLB 
				real6:=fProfitVariable("PV"; real5; real1; 0; $rebate)*100  //•061998  MLB 
				
			End if 
		End if 
		If (fSave)
			SEND PACKET:C103(vDoc; [Finished_Goods_Transactions:33]JobForm:5+Char:C90(9)+String:C10([Job_Forms_Items:44]ItemNumber:7)+Char:C90(9)+[Finished_Goods_Transactions:33]CustID:12+Char:C90(9)+[Customers_Order_Lines:41]CustomerName:24)
			SEND PACKET:C103(vDoc; [Customers_Order_Lines:41]SalesRep:34+Char:C90(9)+t10+Char:C90(9)+[Finished_Goods_Transactions:33]FG_Classification:22+Char:C90(9))
			SEND PACKET:C103(vDoc; Char:C90(9)+String:C10(rqty)+Char:C90(9)+String:C10(real1)+Char:C90(9)+String:C10(real2)+Char:C90(9)+String:C10(real3))
			SEND PACKET:C103(vDoc; Char:C90(9)+String:C10(real4)+Char:C90(9)+String:C10(real5)+Char:C90(9)+String:C10(real6; "###,##0.00")+Char:C90(9)+String:C10(real7)+Char:C90(13))
		End if 
		
	: (Form event code:C388=On Printing Break:K2:19)
		Case of 
			: (Level:C101=1)
				real8a:=Subtotal:C97(rqty)
				real1a:=Subtotal:C97(real1)
				real2a:=Subtotal:C97(real2)
				real3a:=Subtotal:C97(real3)
				real4a:=Subtotal:C97(real4)
				real5a:=Subtotal:C97(real5)
				//real6a:=((real1a-real5a)/real1a)*100`•061998  MLB 
				$rebate:=fGetCustRebate([Finished_Goods_Transactions:33]CustID:12)  //•061998  MLB 
				real6a:=fProfitVariable("PV"; real5a; real1a; 0; $rebate)*100  //•061998  MLB 
				real7a:=Subtotal:C97(real7)
				If (fSave)
					SEND PACKET:C103(vDoc; (6*Char:C90(9))+"Job Totals"+Char:C90(9)+String:C10(real8a)+Char:C90(9)+String:C10(real1a)+Char:C90(9)+String:C10(real2a)+Char:C90(9)+String:C10(real3a))
					SEND PACKET:C103(vDoc; Char:C90(9)+String:C10(real4a)+Char:C90(9)+String:C10(real5a)+Char:C90(9)+String:C10(real6a; "###,##0.00")+Char:C90(9)+String:C10(real7a)+Char:C90(13))
				End if 
				
			: (Level:C101=0)
				real8t:=Subtotal:C97(rqty)
				real1t:=Subtotal:C97(real1)
				real2t:=Subtotal:C97(real2)
				real3t:=Subtotal:C97(real3)
				real4t:=Subtotal:C97(real4)
				real5t:=Subtotal:C97(real5)
				// real6t:=((real1t-real5t)/real1t)*100`•061998  MLB  
				//•062498  MLB  use a zero rebate for total
				//$rebate:=fGetCustRebate ([FG_Transactions]CustID)  `•061998  MLB 
				//TRACE
				real6t:=fProfitVariable("PV"; real5t; real1t; 0; 0)*100  //•061998  MLB 
				real7t:=Subtotal:C97(real7)
				If (fSave)
					SEND PACKET:C103(vDoc; (6*Char:C90(9))+"Grand Totals"+Char:C90(9)+String:C10(real8t)+Char:C90(9)+String:C10(real1t)+Char:C90(9)+String:C10(real2t)+Char:C90(9)+String:C10(real3t))
					SEND PACKET:C103(vDoc; Char:C90(9)+String:C10(real4t)+Char:C90(9)+String:C10(real5t)+Char:C90(9)+String:C10(real6t; "###,##0.00")+Char:C90(9)+String:C10(real7t)+Char:C90(13))
				End if 
				MESSAGES ON:C181
		End case 
End case 
//