//[releaseSchedule]Layout Proc.: ShipmentByBrand called by rRptShipByBrand
//5/4/95 add brand break
//•061395  MLB  UPR 176 rewrite cause compiled version accum. style failed
If (False:C215)
	Case of 
		: (Form event code:C388=On Display Detail:K2:22)
			iShipments:=iShipments+1
			iShipQty:=[Customers_ReleaseSchedules:46]Actual_Qty:8+iShipQty
			If (fSave)
				SEND PACKET:C103(vDoc; [Customers_ReleaseSchedules:46]ProductCode:11+Char:C90(9)+[Customers_ReleaseSchedules:46]Shipto:10+Char:C90(9)+String:C10(iShipments)+Char:C90(9))
				SEND PACKET:C103(vDoc; String:C10([Customers_ReleaseSchedules:46]Actual_Qty:8)+Char:C90(13))
			End if 
			
		: (Form event code:C388=On Printing Break:K2:19)
			Case of 
				: (Level:C101=4)  //cpn
					iShipTot:=iShipTot+iShipments
					iTotShipQty:=iTotShipQty+iShipQty
					
				: (Level:C101=3)  //cpn
					rb5:=rb5+iShipTot
					rb6:=rb6+iTotShipQty
					
				: (Level:C101=2)  //brand
					rb3:=rb3+rb5
					rb4:=rb4+rb6
					If (fSave)
						SEND PACKET:C103(vDoc; (Char:C90(9)*4)+"Brand Total"+Char:C90(9)+String:C10(rb5)+Char:C90(9))
						SEND PACKET:C103(vDoc; String:C10(rb6)+Char:C90(13))
					End if 
					
				: (Level:C101=1)  //customer
					// TRACE
					rb2:=rb2+rb4
					rb1:=rb1+rb3
					If (fSave)
						SEND PACKET:C103(vDoc; (Char:C90(9)*4)+"Customer Total"+(Char:C90(9)*2)+Char:C90(9)+String:C10(rb3)+Char:C90(9))
						SEND PACKET:C103(vDoc; String:C10(rb4)+Char:C90(13))
					End if 
					
				: (Level:C101=0)  //report        
					If (fSave)
						SEND PACKET:C103(vDoc; "Report Total"+(Char:C90(9)*6)+Char:C90(9)+String:C10(rb1)+Char:C90(9))
						SEND PACKET:C103(vDoc; String:C10(rb2)+Char:C90(13))
					End if 
			End case 
			
		: (Form event code:C388=On Header:K2:17)
			Case of 
				: (Level:C101=1)  //cust
					If ([Customers:16]ID:1#[Customers_ReleaseSchedules:46]CustID:12)
						QUERY:C277([Customers:16]; [Customers:16]ID:1=[Customers_ReleaseSchedules:46]CustID:12)
					End if 
					If (fSave)
						SEND PACKET:C103(vDoc; [Customers:16]ID:1+" "+[Customers:16]Name:2+Char:C90(13))
					End if 
					rb3:=0  //brand b2 total shipments
					rb4:=0  //brand b2 total qty        
					
				: (Level:C101=2)  //brand        
					rb5:=0  //cpn/shipto total shipments
					rb6:=0  //cpn/shipto total qty         
					
				: (Level:C101=3)  //cpn
					iShipTot:=0
					iTotShipQty:=0
					iShipments:=0
					iShipQty:=0
					
					//: (Level=4)  `shipto        
					// iShipments:=0 fails on page break
					// iShipQty:=0
					
			End case 
			
	End case 
	
Else   //the other way 
	
	Case of 
		: (Form event code:C388=On Display Detail:K2:22)
			// iShipments:=1  `+iShipments
			// iShipQty:=[ReleaseSchedule]Actual_Qty  `+iShipQty
			If (fSave)
				SEND PACKET:C103(vDoc; [Customers_ReleaseSchedules:46]ProductCode:11+Char:C90(9)+[Customers_ReleaseSchedules:46]Shipto:10+Char:C90(9)+String:C10([Customers_ReleaseSchedules:46]NumberOfCases:30)+Char:C90(9))
				SEND PACKET:C103(vDoc; String:C10([Customers_ReleaseSchedules:46]Actual_Qty:8)+Char:C90(13))
			End if 
			
		: (Form event code:C388=On Printing Break:K2:19)
			Case of 
				: (Level:C101=4)  //cpn
					Li1:=Subtotal:C97([Customers_ReleaseSchedules:46]NumberOfCases:30)
					Li2:=Subtotal:C97([Customers_ReleaseSchedules:46]Actual_Qty:8)
					
				: (Level:C101=3)  //cpn
					iShipTot:=Subtotal:C97([Customers_ReleaseSchedules:46]NumberOfCases:30)
					iTotShipQty:=Subtotal:C97([Customers_ReleaseSchedules:46]Actual_Qty:8)
					
				: (Level:C101=2)  //brand
					rb5:=Subtotal:C97([Customers_ReleaseSchedules:46]NumberOfCases:30)
					rb6:=Subtotal:C97([Customers_ReleaseSchedules:46]Actual_Qty:8)
					If (fSave)
						SEND PACKET:C103(vDoc; (Char:C90(9)*4)+"Brand Total"+Char:C90(9)+String:C10(rb5)+Char:C90(9))
						SEND PACKET:C103(vDoc; String:C10(rb6)+Char:C90(13))
					End if 
					
				: (Level:C101=1)  //customer
					// TRACE
					rb3:=Subtotal:C97([Customers_ReleaseSchedules:46]NumberOfCases:30)
					rb4:=Subtotal:C97([Customers_ReleaseSchedules:46]Actual_Qty:8)
					If (fSave)
						SEND PACKET:C103(vDoc; (Char:C90(9)*4)+"Customer Total"+(Char:C90(9)*2)+Char:C90(9)+String:C10(rb3)+Char:C90(9))
						SEND PACKET:C103(vDoc; String:C10(rb4)+Char:C90(13))
					End if 
					
				: (Level:C101=0)  //report 
					rb1:=Subtotal:C97([Customers_ReleaseSchedules:46]NumberOfCases:30)
					rb2:=Subtotal:C97([Customers_ReleaseSchedules:46]Actual_Qty:8)
					If (fSave)
						SEND PACKET:C103(vDoc; "Report Total"+(Char:C90(9)*6)+Char:C90(9)+String:C10(rb1)+Char:C90(9))
						SEND PACKET:C103(vDoc; String:C10(rb2)+Char:C90(13))
					End if 
			End case 
			
		: (Form event code:C388=On Header:K2:17)
			Case of 
				: (Level:C101=1)  //cust
					If ([Customers:16]ID:1#[Customers_ReleaseSchedules:46]CustID:12)
						QUERY:C277([Customers:16]; [Customers:16]ID:1=[Customers_ReleaseSchedules:46]CustID:12)
					End if 
					If (fSave)
						SEND PACKET:C103(vDoc; [Customers:16]ID:1+" "+[Customers:16]Name:2+Char:C90(13))
					End if 
			End case 
			
	End case 
End if 

//