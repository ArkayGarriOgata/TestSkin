//%attributes = {}
// Method: FG_PrepServiceAutoContractInv() -> 
//see also FG_PrepServiceAutoInvoice calling Invoice_NonShippingItem
// ----------------------------------------------------
// by: mel: 10/12/04, 16:58:58
// ----------------------------------------------------
// Description:
// send an invoice for prep when original item is first shipped.
// see also FG_inventoryShipped
// ----------------------------------------------------

C_LONGINT:C283($i; $numFG)

READ WRITE:C146([Finished_Goods:26])
READ WRITE:C146([Finished_Goods_Transactions:33])
READ WRITE:C146([Customers_Invoices:88])
READ ONLY:C145([Finished_Goods_Classifications:45])
READ ONLY:C145([Customers_Brand_Lines:39])
READ ONLY:C145([Customers_Bills_of_Lading:49])
READ ONLY:C145([Customers_Order_Lines:41])
READ ONLY:C145([Customers_Orders:40])
READ ONLY:C145([Customers_ReleaseSchedules:46])

QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]DateFirstShipped:95#!00-00-00!; *)
QUERY:C277([Finished_Goods:26];  & ; [Finished_Goods:26]PrepInvoiceNumber:96=0)
$numFG:=Records in selection:C76([Finished_Goods:26])

uThermoInit($numFG; "Setting First Shipped")
For ($i; 1; $numFG)
	//assume its not requiring an invoice
	[Finished_Goods:26]PrepInvoiceNumber:96:=-2  //use -3 for priming, -2 =not required, else invo#
	//if it is, get the Line to see if its been set up with a price
	QUERY:C277([Customers_Brand_Lines:39]; [Customers_Brand_Lines:39]CustID:1=[Finished_Goods:26]CustID:2; *)
	QUERY:C277([Customers_Brand_Lines:39];  & ; [Customers_Brand_Lines:39]LineNameOrBrand:2=[Finished_Goods:26]Line_Brand:15)
	If ([Customers_Brand_Lines:39]PrepAutoBill:5>0)
		//get the order to see if it is contract
		QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]ProductCode:11=[Finished_Goods:26]ProductCode:1; *)
		QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Actual_Date:7=[Finished_Goods:26]DateFirstShipped:95)
		If (Records in selection:C76([Customers_ReleaseSchedules:46])>0)
			RELATE ONE:C42([Customers_ReleaseSchedules:46]OrderLine:4)
			RELATE ONE:C42([Customers_Order_Lines:41]OrderNumber:1)
			If ([Customers_Orders:40]IsContract:52)  // | (True)  `if it is, create an invoice
				[Finished_Goods:26]PrepInvoiceNumber:96:=Invoice_GetNewNumber
				If ([Finished_Goods:26]PrepInvoiceNumber:96>0)
					//---- setup to post FGtrans for COGS report 5/1/95
					//see also sInvoiceNoFgs
					$id:=FGX_NewFG_Transaction("SHIP"; 4D_Current_date; <>zResp)
					[Finished_Goods_Transactions:33]ProductCode:1:="Prep:"+[Finished_Goods:26]ProductCode:1
					[Finished_Goods_Transactions:33]CustID:12:=[Finished_Goods:26]CustID:2  //
					[Finished_Goods_Transactions:33]JobNo:4:="00000"
					[Finished_Goods_Transactions:33]JobForm:5:="00000.sb"
					[Finished_Goods_Transactions:33]JobFormItem:30:=0  //•080495  MLB  UPR 1490
					[Finished_Goods_Transactions:33]OrderNo:15:=String:C10([Customers_Order_Lines:41]OrderNumber:1)
					[Finished_Goods_Transactions:33]OrderItem:16:="INV:"+String:C10([Finished_Goods:26]PrepInvoiceNumber:96)
					[Finished_Goods_Transactions:33]Qty:6:=1
					[Finished_Goods_Transactions:33]Location:9:="Customer"
					[Finished_Goods_Transactions:33]viaLocation:11:="Spl Billing"
					[Finished_Goods_Transactions:33]Reason:26:="Auto-billed"
					[Finished_Goods_Transactions:33]FG_Classification:22:="25"
					[Finished_Goods_Transactions:33]PricePerM:19:=[Customers_Brand_Lines:39]PrepAutoBill:5
					[Finished_Goods_Transactions:33]ExtendedPrice:20:=[Customers_Brand_Lines:39]PrepAutoBill:5*[Finished_Goods_Transactions:33]Qty:6
					SAVE RECORD:C53([Finished_Goods_Transactions:33])
					
					Invoice_New([Finished_Goods:26]PrepInvoiceNumber:96)
					[Customers_Invoices:88]BillOfLadingNumber:3:=0
					[Customers_Invoices:88]OrderLine:4:=[Finished_Goods_Transactions:33]OrderNo:15+".sb"
					[Customers_Invoices:88]ReleaseNumber:5:=0  //[Bills_of_Lading]Manifest'Arkay_Release
					[Customers_Invoices:88]CustomerID:6:=[Finished_Goods_Transactions:33]CustID:12
					[Customers_Invoices:88]SalesPerson:8:=[Customers_Order_Lines:41]SalesRep:34
					[Customers_Invoices:88]ShipTo:9:=""  //[OrderLines]defaultShipTo
					[Customers_Invoices:88]BillTo:10:=[Customers_Order_Lines:41]defaultBillto:23
					[Customers_Invoices:88]CustomersPO:11:=[Customers_Order_Lines:41]PONumber:21
					[Customers_Invoices:88]InvComment:12:="Imaging Work, films. Screen, color prints, dies."
					[Customers_Invoices:88]InvType:13:="Debit"  //mark this record as a credit/return for Dynamics
					[Customers_Invoices:88]ProductCode:14:=[Finished_Goods_Transactions:33]ProductCode:1
					[Customers_Invoices:88]Quantity:15:=[Finished_Goods_Transactions:33]Qty:6
					[Customers_Invoices:88]PricePerUnit:16:=[Finished_Goods_Transactions:33]PricePerM:19
					[Customers_Invoices:88]PricingUOM:17:="EA"
					[Customers_Invoices:88]Terms:18:=Cust_GetTermsT([Customers_Orders:40]CustID:2; [Customers_Orders:40]defaultBillTo:5)
					[Customers_Invoices:88]ExtendedPrice:19:=[Finished_Goods_Transactions:33]ExtendedPrice:20
					
					[Customers_Invoices:88]CustomerLine:20:=[Customers_Order_Lines:41]CustomerLine:42
					//If ([Customers_Order_Lines]OrderNumber<commissionChange)
					//[Customers_Invoices]CommissionPlan:=commissionLastPln
					//End if 
					
					[Customers_Invoices:88]CommissionPayable:21:=fSalesCommission("SplBilling"; [Customers_Invoices:88]OrderLine:4; [Customers_Invoices:88]Quantity:15; [Customers_Invoices:88]ExtendedPrice:19)
					
					QUERY:C277([Finished_Goods_Classifications:45]; [Finished_Goods_Classifications:45]Class:1=[Finished_Goods_Transactions:33]FG_Classification:22)
					REDUCE SELECTION:C351([Customers_Bills_of_Lading:49]; 0)
					[Customers_Invoices:88]GL_CODE:23:=Invoice_getGLcode
					
					SAVE RECORD:C53([Customers_Invoices:88])
					UNLOAD RECORD:C212([Customers_Invoices:88])
					UNLOAD RECORD:C212([Finished_Goods_Transactions:33])
				End if 
			End if 
			
		End if 
		
	End if 
	
	SAVE RECORD:C53([Finished_Goods:26])
	NEXT RECORD:C51([Finished_Goods:26])
	uThermoUpdate($i)
End for 

uThermoClose

REDUCE SELECTION:C351([Finished_Goods:26]; 0)
REDUCE SELECTION:C351([Finished_Goods_Transactions:33]; 0)
REDUCE SELECTION:C351([Customers_Invoices:88]; 0)
REDUCE SELECTION:C351([Finished_Goods_Classifications:45]; 0)
REDUCE SELECTION:C351([Customers_Bills_of_Lading:49]; 0)
REDUCE SELECTION:C351([Customers_Order_Lines:41]; 0)
REDUCE SELECTION:C351([Customers_Orders:40]; 0)
REDUCE SELECTION:C351([Customers_ReleaseSchedules:46]; 0)
REDUCE SELECTION:C351([Customers_Brand_Lines:39]; 0)