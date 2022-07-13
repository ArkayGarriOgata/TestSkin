//%attributes = {}
// --------------
// Method: trigger_CustomersReleaseSchedul()  --> 
// ----------------------------------------------------
// User name: Mel Bohince
// Created: 02/01/07, 13:16:41
// ----------------------------------------------------
// Modified by: Mel Bohince (11/9/16) only use po on invoices per DAM.
// Modified by: Mel Bohince (2/15/17) go back to original per DAM
// Modified by: Mel Bohince (6/7/17) add Que_Register for release in less than 6 days
// Added by: Mel Bohince (3/18/20) save #cases 
// Modified by: Mel Bohince (1/20/21) favor the releases' custRefer  or invoice PO and all customers the same
// Mel Bohince (3/23/21) use PK_getCaseCountByCalcOfQty for uniformity

C_LONGINT:C283($0)
//C_DATE($fence)//used by Shuttle to decide if it should be sent
//$fence:=Add to date(4D_Current_date;0;0;5)  // Modified by: Mel Bohince (6/8/17) 

$0:=0

Case of 
	: (Trigger event:C369=On Saving Existing Record Event:K3:2)
		
		If (Substring:C12([Customers_ReleaseSchedules:46]CustomerRefer:3; 1; 1)#"<")  //not a forecast
			If (Old:C35([Customers_ReleaseSchedules:46]Sched_Date:5)#[Customers_ReleaseSchedules:46]Sched_Date:5)
				[Customers_ReleaseSchedules:46]ChgDateVersion:15:=[Customers_ReleaseSchedules:46]ChgDateVersion:15+1
			End if 
			If (Old:C35([Customers_ReleaseSchedules:46]Sched_Qty:6)#[Customers_ReleaseSchedules:46]Sched_Qty:6)
				[Customers_ReleaseSchedules:46]ChgQtyVersion:14:=[Customers_ReleaseSchedules:46]ChgQtyVersion:14+1
			End if 
		End if   //rev'd
		
		If ([Customers_ReleaseSchedules:46]Shipto:10="00073")  // switzerland
			If (Position:C15("Spl Pallet"; [Customers_ReleaseSchedules:46]Expedite:35)=0)
				[Customers_ReleaseSchedules:46]Expedite:35:="Spl Pallet "+[Customers_ReleaseSchedules:46]Expedite:35
			End if 
		End if 
		
		// Added by: Mel Bohince (3/18/20) save #cases 
		[Customers_ReleaseSchedules:46]NumberOfCases:30:=-1
		$caseCount:=PK_getCaseCountByCPN([Customers_ReleaseSchedules:46]ProductCode:11)
		If ($caseCount>0)
			// Mel Bohince (3/23/21) use PK_getCaseCountByCalcOfQty for uniformity
			If ([Customers_ReleaseSchedules:46]Actual_Qty:8=0)
				[Customers_ReleaseSchedules:46]NumberOfCases:30:=PK_getCaseCountByCalcOfQty([Customers_ReleaseSchedules:46]Sched_Qty:6; $caseCount; "odd")  //Round([Customers_ReleaseSchedules]Sched_Qty/$caseCount;2)
			Else 
				[Customers_ReleaseSchedules:46]NumberOfCases:30:=PK_getCaseCountByCalcOfQty([Customers_ReleaseSchedules:46]Actual_Qty:8; $caseCount; "odd")  //Round([Customers_ReleaseSchedules]Actual_Qty/$caseCount;2)
			End if 
			
		Else 
			[Customers_ReleaseSchedules:46]NumberOfCases:30:=-2
		End if 
		
		
		//Handle release being shipped
		If (Old:C35([Customers_ReleaseSchedules:46]Actual_Date:7)#[Customers_ReleaseSchedules:46]Actual_Date:7) & ([Customers_ReleaseSchedules:46]Actual_Date:7#!00-00-00!)  //just shipped
			[Customers_ReleaseSchedules:46]B_O_L_pending:45:=0
			
			Case of 
				: ([Customers_ReleaseSchedules:46]B_O_L_number:17=-200)  //invoiced  payuse style from Rama
					//pass 
				: ([Customers_ReleaseSchedules:46]PayU:31=1)  //don't invoice a payuse pay-use shipment
					//pass 
				: ([Customers_ReleaseSchedules:46]InvoiceNumber:9>No current record:K29:2)  //bill and holds set this to -3 in REL_ReleaseShipped
					//Invoice_NewShipment([Customers_ReleaseSchedules]B_O_L_number;[Customers_ReleaseSchedules]InvoiceNumber;[Customers_ReleaseSchedules]Actual_Qty)
					//*Bring into memory all the related records required
					
					$exception:=REL_GetShipRecords([Customers_ReleaseSchedules:46]B_O_L_number:17)
					If (Length:C16($exception)=0)
						
						C_BOOLEAN:C305(RAMA_PROJECT; ARDEN_PROJECT)  //change the soldTo to a billTo and reduce by $15/M
						RAMA_PROJECT:=CUST_isRamaProject([Customers_Bills_of_Lading:49]BillTo:4; [Customers_Bills_of_Lading:49]ShipTo:3)
						
						If ([Customers_Bills_of_Lading:49]ShipTo:3="02177") | ([Customers_Bills_of_Lading:49]ShipTo:3="02678")
							ARDEN_PROJECT:=True:C214
						Else 
							ARDEN_PROJECT:=False:C215
						End if 
						
						//*Create the invoice
						Invoice_New([Customers_ReleaseSchedules:46]InvoiceNumber:9)
						[Customers_Invoices:88]BillOfLadingNumber:3:=[Customers_ReleaseSchedules:46]B_O_L_number:17
						[Customers_Invoices:88]OrderLine:4:=[Customers_ReleaseSchedules:46]OrderLine:4
						[Customers_Invoices:88]ReleaseNumber:5:=[Customers_ReleaseSchedules:46]ReleaseNumber:1
						[Customers_Invoices:88]CustomerID:6:=[Customers_ReleaseSchedules:46]CustID:12
						[Customers_Invoices:88]Invoice_Date:7:=[Customers_ReleaseSchedules:46]Actual_Date:7
						
						[Customers_Invoices:88]SalesPerson:8:=[Customers_Order_Lines:41]SalesRep:34
						[Customers_Invoices:88]ShipTo:9:=[Customers_Bills_of_Lading:49]ShipTo:3
						[Customers_Invoices:88]BillTo:10:=[Customers_Bills_of_Lading:49]BillTo:4  // may be chg'd below if RAMA_PROJECT
						
						If (ARDEN_PROJECT)
							[Customers_Invoices:88]BillTo:10:="00880"
						End if 
						
						If ([Customers_ReleaseSchedules:46]CustID:12="01810") & ([Customers_ReleaseSchedules:46]Billto:22="04902")
							[Customers_Invoices:88]BillTo:10:="04906"
						End if 
						
						// Modified by: Mel Bohince (11/9/16) only use po on invoices per DAM.
						// Modified by: Mel Bohince (2/15/17) go back to original per DAM
						// Modified by: Mel Bohince (12/12/18) treat PnG spl
						// Modified by: Mel Bohince (1/20/21) favor the releases' custRefer and all customers the same
						
						Case of 
							: (False:C215)  //([Customers_ReleaseSchedules]CustID="00199")  //favor the orderline// Modified by: Mel Bohince (1/20/21) favor the releases' custRefer and all customers the same
								[Customers_Invoices:88]CustomersPO:11:=[Customers_Order_Lines:41]PONumber:21
								//next line because we like to have suspenders and a belt
								If (util_isOnlyAlpha([Customers_Invoices:88]CustomersPO:11))  // Modified by: Mel Bohince (10/11/19) 
									[Customers_Invoices:88]CustomersPO:11:=[Customers_Invoices:88]CustomersPO:11+" "+[Customers_ReleaseSchedules:46]CustomerRefer:3
								End if 
								
							Else   //orig, favor the release
								[Customers_Invoices:88]CustomersPO:11:=[Customers_ReleaseSchedules:46]CustomerRefer:3
								// Modified by: Mel Bohince (1/20/21) favor the releases' custRefer and all customers the same, and nothing fancy
								If (False:C215)  // (Position([Customers_Order_Lines]PONumber;[Customers_Invoices]CustomersPO)=0)  //concatenate both if useful
									If (Not:C34(util_isOnlyAlpha([Customers_Order_Lines:41]PONumber:21)))  // Modified by: Mel Bohince (10/11/19) 
										[Customers_Invoices:88]CustomersPO:11:=[Customers_Order_Lines:41]PONumber:21+" "+[Customers_Invoices:88]CustomersPO:11
									End if 
								End if 
						End case 
						
						
						// Modified by: Mel Bohince (9/26/18)
						[Customers_Invoices:88]CustomersPO:11:=Replace string:C233([Customers_Invoices:88]CustomersPO:11; "TBD "; "")
						[Customers_Invoices:88]CustomersPO:11:=Replace string:C233([Customers_Invoices:88]CustomersPO:11; "see below "; "")
						[Customers_Invoices:88]CustomersPO:11:=Replace string:C233([Customers_Invoices:88]CustomersPO:11; "to follow "; "")
						[Customers_Invoices:88]CustomersPO:11:=Replace string:C233([Customers_Invoices:88]CustomersPO:11; "TBD"; "")
						[Customers_Invoices:88]CustomersPO:11:=Replace string:C233([Customers_Invoices:88]CustomersPO:11; "see below"; "")
						[Customers_Invoices:88]CustomersPO:11:=Replace string:C233([Customers_Invoices:88]CustomersPO:11; "to follow"; "")
						
						
						
						[Customers_Invoices:88]InvComment:12:=[Customers_ReleaseSchedules:46]RemarkLine1:25+" "+[Customers_ReleaseSchedules:46]RemarkLine2:26
						
						If (Length:C16([Customers_Bills_of_Lading:49]ChainOfCustody:30)>0)  //◊CHAIN_OF_CUSTODY ` used as a marker to find in database
							$hit:=RM_isCertified_FSC_orSFI("placeholder")
							[Customers_Invoices:88]InvComment:12:=[Customers_Invoices:88]InvComment:12+" "+[Customers_Bills_of_Lading:49]ChainOfCustody:30
						End if 
						
						[Customers_Invoices:88]InvType:13:="Debit"  //mark this record as a credit/return for Dynamics
						[Customers_Invoices:88]ProductCode:14:=[Customers_ReleaseSchedules:46]ProductCode:11
						[Customers_Invoices:88]Quantity:15:=[Customers_ReleaseSchedules:46]Actual_Qty:8
						If ([Customers_Invoices:88]Quantity:15>[Customers_ReleaseSchedules:46]Sched_Qty:6)
							If (Not:C34(INV_PaysOverShip([Customers_ReleaseSchedules:46]CustID:12; [Customers_ReleaseSchedules:46]Billto:22)))  //(Not([Customers]Pays_Overship))
								[Customers_Invoices:88]InvComment:12:="Over Ship Adjustment: "+String:C10([Customers_ReleaseSchedules:46]Actual_Qty:8-[Customers_ReleaseSchedules:46]Sched_Qty:6)+" Applied to Invoice Qty "+[Customers_Invoices:88]InvComment:12
								[Customers_Invoices:88]Quantity:15:=[Customers_ReleaseSchedules:46]Sched_Qty:6
							End if 
						End if 
						
						$units:=[Customers_Invoices:88]Quantity:15
						[Customers_Invoices:88]PricePerUnit:16:=[Customers_Order_Lines:41]Price_Per_M:8
						[Customers_Invoices:88]PricingUOM:17:=[Finished_Goods:26]Acctg_UOM:29
						[Customers_Invoices:88]Terms:18:=[Customers_Orders:40]Terms:23
						
						If (RAMA_PROJECT)  //mlb 08/27/07 change terms on buffer stock and swap billto address
							CUST_isRamaProject_Swaps
						End if 
						
						[Customers_Invoices:88]ExtendedPrice:19:=[Customers_Invoices:88]Quantity:15*[Customers_Invoices:88]PricePerUnit:16
						If ([Customers_Invoices:88]PricingUOM:17="M") | ([Customers_Invoices:88]PricingUOM:17="")  //treat as per thousand
							[Customers_Invoices:88]ExtendedPrice:19:=[Customers_Invoices:88]ExtendedPrice:19/1000
							$units:=$units/1000
						End if 
						[Customers_Invoices:88]ExtendedPrice:19:=Round:C94([Customers_Invoices:88]ExtendedPrice:19; 2)
						[Customers_Invoices:88]CustomerLine:20:=[Customers_ReleaseSchedules:46]CustomerLine:28
						//If ([Customers_Order_Lines]OrderNumber<commissionChange)
						//[Customers_Invoices]CommissionPlan:=commissionLastPln
						//End if 
						[Customers_Invoices:88]CommissionPayable:21:=fSalesCommission("Normal"; [Customers_Invoices:88]OrderLine:4; $units)
						
						[Customers_Invoices:88]GL_CODE:23:=Invoice_getGLcode
						[Customers_Invoices:88]CoGS_FiFo:38:=Invoice_getFiFoCost([Customers_Invoices:88]OrderLine:4; [Customers_Invoices:88]ReleaseNumber:5)
						
						
						SAVE RECORD:C53([Customers_Invoices:88])
						LOAD RECORD:C52([Customers_Invoices:88])
						If ([Customers_Invoices:88]InvoiceNumber:1#[Customers_ReleaseSchedules:46]InvoiceNumber:9)
							$0:=TriggerMessage_Set(-31000-Table:C252(->[Customers_Invoices:88]); "BOL# "+String:C10([Customers_ReleaseSchedules:46]B_O_L_number:17)+" couldn't save invoice")
						End if 
						REDUCE SELECTION:C351([Customers_Invoices:88]; 0)
					Else   //related records not loaded, bail
						utl_Logfile("shipping.log"; "BOL# "+String:C10([Customers_ReleaseSchedules:46]B_O_L_number:17)+"; couldn't load related records")
						$0:=TriggerMessage_Set(-30000-Table:C252(->[Customers_ReleaseSchedules:46]); "BOL# "+String:C10([Customers_ReleaseSchedules:46]B_O_L_number:17)+" couldn't load related records"+$exception)
					End if   //loading related
					
				: ([Customers_ReleaseSchedules:46]InvoiceNumber:9=New record:K29:1)  //bill&hold or payuse
					//pass
				Else 
					$0:=TriggerMessage_Set(-31000-Table:C252(->[Customers_Invoices:88]); "BOL# "+String:C10([Customers_ReleaseSchedules:46]B_O_L_number:17)+" didn't have invoice#")
			End case   //has invoice number
			
			C_BOOLEAN:C305($commit)
			$commit:=ORD_LineItemShipped([Customers_ReleaseSchedules:46]Actual_Qty:8; [Customers_ReleaseSchedules:46]Actual_Date:7; [Customers_ReleaseSchedules:46]OrderLine:4; [Customers_ReleaseSchedules:46]PayU:31)  //*        Post to the orderline  
			If (Not:C34($commit))
				utl_Logfile("shipping.log"; "BOL# "+String:C10([Customers_ReleaseSchedules:46]B_O_L_number:17)+"; "+"Orderline "+[Customers_ReleaseSchedules:46]OrderLine:4+" was not updated")
			End if   //ord line updated
			
		End if   //actual shipped date set
		
		//SHUTTLE
		//If ([Customers_ReleaseSchedules]CustomerRefer#"<@")  //not a forecast
		//If (Length([Customers_ReleaseSchedules]CustomerRefer)>0)  //has a po
		//If ([Customers_ReleaseSchedules]CustomerRefer#"NO_ORDERLINE")
		//If ([Customers_ReleaseSchedules]Actual_Date=!00/00/0000!)  //not already shipped
		//If ([Customers_ReleaseSchedules]Sched_Date<=$fence) & ([Customers_ReleaseSchedules]Sched_Date#!00/00/0000!)
		//If ([Customers_ReleaseSchedules]THC_State=0)  //has inventory
		//If ([Customers_ReleaseSchedules]Shipto#"N/A") & ([Customers_ReleaseSchedules]Shipto#"00000")  //has a shipto
		//$err:=Shuttle_Register ("release";"";[Customers_ReleaseSchedules]ReleaseNumber)
		//End if 
		//End if 
		//End if 
		//End if 
		//End if 
		//End if 
		//End if 
		
	: (Trigger event:C369=On Saving New Record Event:K3:1)
		[Customers_ReleaseSchedules:46]CreatedBy:46:=[Customers_ReleaseSchedules:46]ModWho:19
		//example
		//       $id_str:=fGetNextLongInt (->[WMS_InternalBOLs])
		//       [WMS_InternalBOLs]bol_number:="BOL"+String($id_str;"000000")  //+Barcode_UPC_ChkDigit ($id)
		//[WMS_InternalBOLs]bol_encoded:=BarCode_128auto ([WMS_InternalBOLs]bol_number)
		//       [WMS_InternalBOLs]when_inserted:=TS_ISO_String_TimeStamp 
		
		If ([Customers_ReleaseSchedules:46]Shipto:10="00073")  // switzerland
			If (Position:C15("Spl Pallet"; [Customers_ReleaseSchedules:46]Expedite:35)=0)
				[Customers_ReleaseSchedules:46]Expedite:35:="Spl Pallet "+[Customers_ReleaseSchedules:46]Expedite:35
			End if 
		End if 
		
		// Added by: Mel Bohince (3/18/20) save #cases 
		[Customers_ReleaseSchedules:46]NumberOfCases:30:=-1
		$caseCount:=PK_getCaseCountByCPN([Customers_ReleaseSchedules:46]ProductCode:11)
		If ($caseCount>0)
			// Mel Bohince (3/23/21) use PK_getCaseCountByCalcOfQty for uniformity
			If ([Customers_ReleaseSchedules:46]Actual_Qty:8=0)
				[Customers_ReleaseSchedules:46]NumberOfCases:30:=PK_getCaseCountByCalcOfQty([Customers_ReleaseSchedules:46]Sched_Qty:6; $caseCount; "odd")  //Round([Customers_ReleaseSchedules]Sched_Qty/$caseCount;2)
			Else 
				[Customers_ReleaseSchedules:46]NumberOfCases:30:=PK_getCaseCountByCalcOfQty([Customers_ReleaseSchedules:46]Actual_Qty:8; $caseCount; "odd")  //Round([Customers_ReleaseSchedules]Actual_Qty/$caseCount;2)
			End if 
			
		Else 
			[Customers_ReleaseSchedules:46]NumberOfCases:30:=-2
		End if 
		
		//SHUTTLE
		//If ([Customers_ReleaseSchedules]CustomerRefer#"<@")  //not a forecast
		//If (Length([Customers_ReleaseSchedules]CustomerRefer)>0)  //has a po
		//If ([Customers_ReleaseSchedules]CustomerRefer#"NO_ORDERLINE")
		//If ([Customers_ReleaseSchedules]Actual_Date=!00/00/0000!)  //not already shipped
		//If ([Customers_ReleaseSchedules]Sched_Date<=$fence) & ([Customers_ReleaseSchedules]Sched_Date#!00/00/0000!)
		//If ([Customers_ReleaseSchedules]THC_State=0)  //has inventory
		//If ([Customers_ReleaseSchedules]Shipto#"N/A") & ([Customers_ReleaseSchedules]Shipto#"00000")  //has a shipto
		//$err:=Shuttle_Register ("release";"";[Customers_ReleaseSchedules]ReleaseNumber)
		//End if 
		//End if 
		//End if 
		//End if 
		//End if 
		//End if 
		//End if 
End case 