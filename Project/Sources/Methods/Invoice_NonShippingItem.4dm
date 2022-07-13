//%attributes = {"publishedWeb":true}
// -------
// Method: Invoice_NonShippingItem   ( "suppressMsgs & UI ") ->
// Description
//  create an invoice for something that is not shipped in the normal way
//  assumes that there is a selection of orderlines before the call
// ----------------------------------------------------
// formerly: sInvoiceNoFgs   ( ) ->
//$1 optional anything,  suppress searches
//$1 indicatss that the call is from  Rpt_BillofLadin
//5/1/95 special billing concideration, chip
//5/3/95 param 2 of uPostFgx is int
//•051595  MLB  UPR 1508
//•060995  MLB  UPR 1641
//•071295  MLB  UPR 222
//•071495  MLB  
//•080495  MLB  UPR 1490
//•111595 allow selection, bob
//•021997  MLB  UPR 1853  reset the qty's after invoice
//•031197  mBohince  Make sure prep gets billed when shipped
//•4/15/99  MLB  new invoice method
// Modified by: Mel Bohince (1/14/19) validate the billto provided
// Added by: Mel Bohince (6/24/19) test for po containing numeric value
C_LONGINT:C283($validAddressID)
READ ONLY:C145([Addresses:30])

C_TEXT:C284($1)
C_BOOLEAN:C305($userDialog)  //•031197  mBohince  

If (Count parameters:C259=0)
	$userDialog:=True:C214
Else 
	$userDialog:=False:C215
End if 

CREATE SET:C116([Customers_Order_Lines:41]; "Hold")

MESSAGES OFF:C175
QUERY SELECTION:C341([Customers_Order_Lines:41]; [Customers_Order_Lines:41]SpecialBilling:37=True:C214; *)  //special billing
QUERY SELECTION:C341([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]InvoiceNum:38=0; *)  //not yet invoiced
QUERY SELECTION:C341([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]defaultBillto:23#""; *)  //someplace to send it
QUERY SELECTION:C341([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]defaultBillto:23#"?????"; *)  //someplace to send it
QUERY SELECTION:C341([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]Status:9="Accepted"; *)  //booked
QUERY SELECTION:C341([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]PONumber:21#"")  //•071495  MLB  require po
$State:=Read only state:C362([Customers_Order_Lines:41])

If (Records in selection:C76([Customers_Order_Lines:41])>0)  //something to bill
	
	If (Records in selection:C76([Customers_Order_Lines:41])>1)  //•111595 allow user to make selection, idk y
		If ($userDialog)  //•031197  mBohince 
			ARRAY TEXT:C222(aOL; 0)
			ARRAY LONGINT:C221(aBinRecNum; 0)  //bin record number
			SELECTION TO ARRAY:C260([Customers_Order_Lines:41]; aBinRecNum; [Customers_Order_Lines:41]OrderLine:3; aOL)
			SORT ARRAY:C229(aOL; aBinRecNum; >)
			ARRAY TEXT:C222(aBullet; Size of array:C274(aOL))
			If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
				
				CREATE EMPTY SET:C140([Customers_Order_Lines:41]; "Picks")
				NewWindow(200; 290; 6; 0; "Pick List")
				t10:="Click on the orderlines that you wish to invoice:"
				DIALOG:C40([zz_control:1]; "SimplePick")
				If (ok=1)
					For ($i; 1; Size of array:C274(aOL))
						If (aBullet{$i}="•")
							GOTO RECORD:C242([Customers_Order_Lines:41]; aBinRecNum{$i})
							ADD TO SET:C119([Customers_Order_Lines:41]; "Picks")
						End if 
					End for 
				End if 
				CLOSE WINDOW:C154
				USE SET:C118("Picks")
				CLEAR SET:C117("Picks")
				
			Else 
				
				ARRAY LONGINT:C221($_Picks; 0)
				
				NewWindow(200; 290; 6; 0; "Pick List")
				t10:="Click on the orderlines that you wish to invoice:"
				DIALOG:C40([zz_control:1]; "SimplePick")
				If (ok=1)
					For ($i; 1; Size of array:C274(aOL))
						If (aBullet{$i}="•")
							
							APPEND TO ARRAY:C911($_Picks; aBinRecNum{$i})
							
						End if 
					End for 
				End if 
				CLOSE WINDOW:C154
				CREATE SELECTION FROM ARRAY:C640([Customers_Order_Lines:41]; $_Picks)
				
				
			End if   // END 4D Professional Services : January 2019 
			
		End if   //user interface
	End if 
	
	FIRST RECORD:C50([Customers_Order_Lines:41])
	
	If ($userDialog)
		uThermoInit(Records in selection:C76([Customers_Order_Lines:41]); "Invoicing Orderlines…")
	End if 
	
	For ($i; 1; Records in selection:C76([Customers_Order_Lines:41]))  //that have been prequalified to be invoiced
		// Modified by: Mel Bohince (11/20/18) test for spl billing unit of measure
		//$numFG:=qryFinishedGood ([Customers_Order_Lines]CustID;[Customers_Order_Lines]ProductCode)
		//If ($numFG>0)
		//If ([Finished_Goods]Acctg_UOM="M")
		//If ($userDialog)
		//uConfirm ([Customers_Order_Lines]OrderLine+" has the per thousand as UOM so will overstate bookings if is a spl billing";"Ok";"Help")
		//Else 
		//utl_Logfile ("BatchRunner.Log";[Customers_Order_Lines]OrderLine+" has the per thousand as UOM so will overstate bookings if is a spl billing")
		//End if 
		//End if 
		//End if 
		C_BOOLEAN:C305($improbable_PO)  // Added by: Mel Bohince (6/24/19) 
		$improbable_PO:=util_isOnlyAlpha([Customers_Order_Lines:41]PONumber:21)
		If (Not:C34($improbable_PO))
			$validAddressID:=0
			SET QUERY DESTINATION:C396(Into variable:K19:4; $validAddressID)
			QUERY:C277([Addresses:30]; [Addresses:30]ID:1=[Customers_Order_Lines:41]defaultBillto:23)
			SET QUERY DESTINATION:C396(Into current selection:K19:1)
			If ($validAddressID>0)
				
				$invoiceNum:=Invoice_GetNewNumber
				
				If ($invoicenum>0)
					$Remark:="Special Billing Charge for: "+[Customers_Order_Lines:41]ProductCode:5+"  "+[Customers_Order_Lines:41]InvoiceComment:43
					
					UNLOAD RECORD:C212([Customers_Order_Lines:41])
					READ WRITE:C146([Customers_Order_Lines:41])  //set to read only in api procedure
					LOAD RECORD:C52([Customers_Order_Lines:41])
					[Customers_Order_Lines:41]InvoiceNum:38:=$InvoiceNum
					[Customers_Order_Lines:41]Status:9:="Closed"
					[Customers_Order_Lines:41]DateCompleted:12:=4D_Current_date
					[Customers_Order_Lines:41]Qty_Shipped:10:=[Customers_Order_Lines:41]Quantity:6  //•021997  MLB  UPR 1853
					[Customers_Order_Lines:41]Qty_Open:11:=0  //•021997  MLB  UPR 1853
					SAVE RECORD:C53([Customers_Order_Lines:41])
					
					Case of 
						: (Substring:C12([Customers_Orders:40]EstimateNo:3; 1; 1)="C")  //via a FG_Spec Control Number
							SET QUERY LIMIT:C395(1)
							READ WRITE:C146([Finished_Goods_Specifications:98])
							QUERY:C277([Finished_Goods_Specifications:98]; [Finished_Goods_Specifications:98]ControlNumber:2=[Customers_Orders:40]EstimateNo:3)
							If (Records in selection:C76([Finished_Goods_Specifications:98])=1)
								If (fLockNLoad(->[Finished_Goods_Specifications:98]))
									[Finished_Goods_Specifications:98]InvoiceNumber:60:=$InvoiceNum
									SAVE RECORD:C53([Finished_Goods_Specifications:98])
								End if 
								
								READ ONLY:C145([Prep_CatalogItems:102])
								QUERY:C277([Prep_CatalogItems:102]; [Prep_CatalogItems:102]Description:2=[Customers_Order_Lines:41]ProductCode:5)
								If (Records in selection:C76([Prep_CatalogItems:102])>0)
									READ WRITE:C146([Prep_Charges:103])
									QUERY:C277([Prep_Charges:103]; [Prep_Charges:103]ControlNumber:1=[Customers_Orders:40]EstimateNo:3; *)
									QUERY:C277([Prep_Charges:103];  & ; [Prep_Charges:103]PrepItemNumber:4=[Prep_CatalogItems:102]ItemNumber:1)
									If (Records in selection:C76([Prep_Charges:103])=1)
										If (fLockNLoad(->[Prep_Charges:103]))
											[Prep_Charges:103]InvoiceNumber:7:=$InvoiceNum
											SAVE RECORD:C53([Prep_Charges:103])
										End if 
									End if 
								End if 
								
							End if 
							REDUCE SELECTION:C351([Finished_Goods_Specifications:98]; 0)
							REDUCE SELECTION:C351([Prep_CatalogItems:102]; 0)
							REDUCE SELECTION:C351([Prep_Charges:103]; 0)
							SET QUERY LIMIT:C395(0)
							
						Else 
							READ WRITE:C146([Finished_Goods_Specifications:98])
							QUERY:C277([Finished_Goods_Specifications:98]; [Finished_Goods_Specifications:98]OrderNumber:59=[Customers_Orders:40]OrderNumber:1; *)
							QUERY:C277([Finished_Goods_Specifications:98];  & ; [Finished_Goods_Specifications:98]InvoiceNumber:60=0)
							If (Records in selection:C76([Finished_Goods_Specifications:98])>0)
								While (Not:C34(End selection:C36([Finished_Goods_Specifications:98])))
									If (fLockNLoad(->[Finished_Goods_Specifications:98]))
										[Finished_Goods_Specifications:98]InvoiceNumber:60:=$InvoiceNum
										SAVE RECORD:C53([Finished_Goods_Specifications:98])
									End if 
									
									READ WRITE:C146([Prep_Charges:103])
									QUERY:C277([Prep_Charges:103]; [Prep_Charges:103]ControlNumber:1=[Finished_Goods_Specifications:98]ControlNumber:2; *)
									QUERY:C277([Prep_Charges:103];  & ; [Prep_Charges:103]InvoiceNumber:7=0)
									If (Records in selection:C76([Prep_Charges:103])>1)
										APPLY TO SELECTION:C70([Prep_Charges:103]; [Prep_Charges:103]InvoiceNumber:7:=$InvoiceNum)
									End if 
									
									NEXT RECORD:C51([Finished_Goods_Specifications:98])
								End while 
							End if 
							REDUCE SELECTION:C351([Finished_Goods_Specifications:98]; 0)
							REDUCE SELECTION:C351([Prep_CatalogItems:102]; 0)
							REDUCE SELECTION:C351([Prep_Charges:103]; 0)
							
					End case 
					
					//---- setup to post FGtrans for COGS report 5/1/95
					//see also FG_PrepServiceAutoContractInv
					
					sCriterion1:=[Customers_Order_Lines:41]ProductCode:5
					sCriterion2:=[Customers_Order_Lines:41]CustID:4  //•072695  MLB  UPR 1680`""  `•071495  MLB 
					sCriterion3:="Spl Billing"  //•051595  MLB  UPR 1508
					sCriterion4:="Customer"
					sCriterion5:=String:C10([Customers_Orders:40]JobNo:44; "00000")+".sb"  //•051595  MLB  UPR 1508 add 00000 formate
					i1:=0  //•080495  MLB  UPR 1490
					sCriterion6:=[Customers_Order_Lines:41]OrderLine:3
					sCriterion7:=""
					sCriterion8:=""
					sCriterion9:="AutoXbilled"
					rReal1:=[Customers_Order_Lines:41]Quantity:6
					fFlag1:=False:C215
					FGX_post_transaction(4D_Current_date; 1; "Ship")  //post a transaction for special billing, 5/3/95 param 2 is int
					
					$err:=Invoice_NewSpecial([Customers_Order_Lines:41]OrderLine:3; $invoiceNum; $Remark)
					
				End if 
				
				If ($userDialog)
					uThermoUpdate($i)
				End if 
				
			Else   //invalid billto used
				If ($userDialog)
					uConfirm("Invalid Billto on orderline "+[Customers_Order_Lines:41]OrderLine:3+", invoice not created for it."; "Ok"; "Help")
				Else 
					utl_Logfile("BatchRunner.Log"; "Invoice_NonShippingItem "+[Customers_Order_Lines:41]OrderLine:3+" Billto problem")
				End if 
			End if 
			
		Else   //invalid po
			If ($userDialog)
				uConfirm("Invalid PO '"+[Customers_Order_Lines:41]PONumber:21+"' on orderline "+[Customers_Order_Lines:41]OrderLine:3+", invoice not created for it."; "Ok"; "Help")
			Else 
				utl_Logfile("BatchRunner.Log"; "Invoice_NonShippingItem "+[Customers_Order_Lines:41]OrderLine:3+" PO problem")
			End if 
		End if 
		
		NEXT RECORD:C51([Customers_Order_Lines:41])
		
	End for 
	
	If ($userDialog)
		uThermoClose
	End if 
	
Else   //no candidates
	If ($userDialog)
		ALERT:C41("All S/B Orderlines Have Previously been invoiced"+" or are missing information "+"(Accepted, PO, Billto, Spl Bill).")
	End if 
	
End if 

If ($State)
	READ ONLY:C145([Customers_Order_Lines:41])
	uClearSelection(->[Customers_Order_Lines:41])
End if 
USE SET:C118("Hold")
CLEAR SET:C117("Hold")
MESSAGES ON:C181
UNLOAD RECORD:C212([Finished_Goods:26])