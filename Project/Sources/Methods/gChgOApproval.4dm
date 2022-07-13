//%attributes = {"publishedWeb":true}
//(P) gChgOApproval: Change Order Approval see also ORD_ChangeOrder and ORD_ChangeORder_add_item
//8/22/94
//9/2/94
//9/13/94 - 9/16/94 BAK Many Mods 
//upr 1228  11/7/94
//upr 1309 11/7/94 price change controls
//Credit Checks - BAK 11/8/94
//upr 1221 11/21/94
//record locking problems (phone) 11/30/94
//fax 12/22/94
//12/29/94 fix compile error on line 107
//upr 1411 1/25/95 also trap for missing product classification
//upr 1438 2/28/95
//3/1/95 upr 1242
//upr 1447 3/6/96
//4/27/95 chip upr 1252
//5/3/95 chip upr 1489
//•051595  MLB  UPR 1508
//•060295  MLB  UPR 184 add cust brand to orderlines and releases
//•071295  MLB  UPR 221
//•071495  MLB  change kill to superceded
//•081595  MLB  
//•111495  MLB  UPR 1779
//•051696  MLB  remove "Reject" command cause this in nolonger a button script
//•6/24/97 cs - Ralph got a runtime error
//• 7/10/97 cs - Ralph created and accepted a CCo - status on Order did not change
//  reason is fOthersOpen routine - added parameter to this routine
//• 7/24/97 cs upr 1815 - need to keep Customer order need date correct with regar
//   to CCO items - dDate1 set in befor of CCO to Customer Order Need date, may be
//  change by script in Needdate on CCO line item
//• 3/6/98 cs make sure that closed date is set
//• 4/3/98 cs when accepting a price change on a 'preperatory item' which has NOT
//  been invoiced previously pass through all costs and mark prep order as invoice
//• 4/14/98 cs Nan checking
//•051999  mlb denominator and price chg on splbilling problem
//• mlb - 8/21/02  11:00 add pjt number of added lines
// Modified by: Mel Bohince (11/11/15) status workflow simplified, looking for bug
C_LONGINT:C283($i; $j; $k)
C_TEXT:C284($oldCCOStat)
C_BOOLEAN:C305($pendingCCO; $noClass)
C_REAL:C285($rOrderDiff)

MESSAGES OFF:C175

If (Old:C35([Customers_Order_Change_Orders:34]ChgOrderStatus:20)#[Customers_Order_Change_Orders:34]ChgOrderStatus:20)  //only available to a CCO_Approval member
	Open window:C153(100; 60; 330; 400; -722; "Change Order Approval: "+[Customers_Order_Change_Orders:34]ChangeOrderNumb:1)
	//*Load the Order'
	$orderNumber:=[Customers_Order_Change_Orders:34]OrderNo:5
	If ([Customers_Orders:40]OrderNumber:1#[Customers_Order_Change_Orders:34]OrderNo:5)
		READ WRITE:C146([Customers_Orders:40])
		QUERY:C277([Customers_Orders:40]; [Customers_Orders:40]OrderNumber:1=[Customers_Order_Change_Orders:34]OrderNo:5)
	End if 
	[Customers_Orders:40]NeedDate:51:=dDate1  //• 7/24/97 cs assign dDate1 - if changed by CCO needdate - cool, else no harm
	C_TEXT:C284($pjtNum)  //• mlb - 8/21/02  11:01
	$pjtNum:=[Customers_Orders:40]ProjectNumber:53
	SAVE RECORD:C53([Customers_Orders:40])  //• 7/24/97 cs  insure that the date gets updated
	
	//*Load the orderlines and create set called Lines  
	READ WRITE:C146([Customers_Order_Lines:41])  //•060295  MLB  UPR 184
	QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderNumber:1=[Customers_Order_Change_Orders:34]OrderNo:5)
	CREATE SET:C116([Customers_Order_Lines:41]; "Lines")
	$oldCCOStat:=Old:C35([Customers_Order_Change_Orders:34]ChgOrderStatus:20)
	
	//SAVE RECORD([OrderChgHistory])
	//*Chk for other pending CCOs
	
	$pendingCCO:=fOthersOpen([Customers_Order_Change_Orders:34]OrderNo:5; "New@"; [Customers_Order_Change_Orders:34]ChangeOrderNumb:1)
	
	//*Determine the status change and dispatch action
	Case of 
			//: (Position("Open";[Customers_Order_Change_Orders]ChgOrderStatus)=1)  //upr 1438 2/28/95
			//  //do nothing at this time
			
			//: (Position("Pricing";[Customers_Order_Change_Orders]ChgOrderStatus)=1)
			//do nothing at this time      
			
			//: (Position("Customer Service";[Customers_Order_Change_Orders]ChgOrderStatus)#0)  //3/1/95 upr 1242 remove holds
			//If (Not($pendingCCO))
			//uResetStatii 
			//End if 
			
		: (Position:C15("Cancel"; [Customers_Order_Change_Orders:34]ChgOrderStatus:20)#0)
			If (Not:C34($pendingCCO))
				uResetStatii
			End if 
			
			//: (Position("Reject";[Customers_Order_Change_Orders]ChgOrderStatus)=1)
			//BEEP
			//ALERT("Forward all paperwork to the Sales Rep. Order & Job are still on Hold.")
			
			//: (Position("Advise";[Customers_Order_Change_Orders]ChgOrderStatus)=1)
			//BEEP
			//ALERT("Forward all paperwork to the Sales Rep. Order & Job are still on Hold.")
			
		: (Position:C15("Proceed"; [Customers_Order_Change_Orders:34]ChgOrderStatus:20)=1)  // & (Position("Proceed";$oldCCOStat)=0)
			//*.   Proceeding with change
			//11/8/94 BAK - Perform a Customer Credit Check here.
			//*.      Load Customer
			If ([Customers:16]ID:1#[Customers_Orders:40]CustID:2)
				READ ONLY:C145([Customers:16])  //set to read only due to record locking later in this procedure 11/29/94
				QUERY:C277([Customers:16]; [Customers:16]ID:1=[Customers_Orders:40]CustID:2)
			End if 
			//*.         Credit check
			
			$sFailStat:="Credit Hold"
			RELATE MANY:C262([Customers_Order_Change_Orders:34]OrderChg_Items:6)
			ORDER BY:C49([Customers_Order_Changed_Items:176]; [Customers_Order_Changed_Items:176]ItemNo:1; >)
			//ALL SUBRECORDS([Customers_Order_Change_Orders]OrderChg_Items)
			//FIRST SUBRECORD([Customers_Order_Change_Orders]OrderChg_Items)
			$noClass:=False:C215
			//*.      Loop thru the cco items subfile and chk for ommissions
			If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) Next record
				
				For ($j; 1; Records in selection:C76([Customers_Order_Changed_Items:176]))  // chk for class and revenue delta
					//*.         Chk for order category R,C, O...
					If ([Customers_Order_Changed_Items:176]NewOrdType:15#"")  //if there is an ordertype
						//*.         Chk for order class 22,20 ...
						If ([Customers_Order_Changed_Items:176]NewClassificati:35#"")  //1/25/95
							$Denom:=nlGetFGDenom([Customers_Order_Change_Orders:34]CustID:2; [Customers_Order_Changed_Items:176]NewProductCode:10)  //•051999  mlb  dont use orderline value
							$rOrderDiff:=$rOrderDiff+([Customers_Order_Changed_Items:176]NewQty:4*[Customers_Order_Changed_Items:176]NewPrice:5/$denom)-([Customers_Order_Changed_Items:176]OldQty:2*[Customers_Order_Changed_Items:176]OldPrice:3/$denom)
							NEXT RECORD:C51([Customers_Order_Changed_Items:176])
						Else 
							BEEP:C151
							ALERT:C41("Product Classification is missing on CPN "+[Customers_Order_Changed_Items:176]NewProductCode:10)
							$noClass:=True:C214
							[Customers_Order_Change_Orders:34]ChgOrderStatus:20:="Pricing"
							$j:=$j+Records in selection:C76([Customers_Order_Changed_Items:176])
						End if 
					Else 
						BEEP:C151
						ALERT:C41("The Type is missing on CPN "+[Customers_Order_Changed_Items:176]NewProductCode:10)
						$noClass:=True:C214
						[Customers_Order_Change_Orders:34]ChgOrderStatus:20:="Pricing"
						$j:=$j+Records in selection:C76([Customers_Order_Changed_Items:176])
					End if 
				End for 
				
			Else 
				
				ARRAY TEXT:C222($_NewOrdType; 0)
				ARRAY TEXT:C222($_NewClassificati; 0)
				ARRAY TEXT:C222($_NewProductCode; 0)
				ARRAY REAL:C219($_NewQty; 0)
				ARRAY REAL:C219($_NewPrice; 0)
				ARRAY REAL:C219($_OldQty; 0)
				ARRAY REAL:C219($_OldPrice; 0)
				
				
				SELECTION TO ARRAY:C260([Customers_Order_Changed_Items:176]NewOrdType:15; $_NewOrdType; \
					[Customers_Order_Changed_Items:176]NewClassificati:35; $_NewClassificati; \
					[Customers_Order_Changed_Items:176]NewProductCode:10; $_NewProductCode; \
					[Customers_Order_Changed_Items:176]NewQty:4; $_NewQty; \
					[Customers_Order_Changed_Items:176]NewPrice:5; $_NewPrice; \
					[Customers_Order_Changed_Items:176]OldQty:2; $_OldQty; \
					[Customers_Order_Changed_Items:176]OldPrice:3; $_OldPrice)
				
				For ($j; 1; Size of array:C274($_OldPrice); 1)  // chk for class and revenue delta
					
					If ($_NewOrdType{$j}#"")  //if there is an ordertype
						
						If ($_NewClassificati{$j}#"")  //1/25/95
							
							$Denom:=nlGetFGDenom([Customers_Order_Change_Orders:34]CustID:2; $_NewProductCode{$j})  //•051999  mlb  dont use orderline value
							$rOrderDiff:=$rOrderDiff+($_NewQty{$j}*$_NewPrice{$j}/$denom)-($_OldQty{$j}*$_OldPrice{$j}/$denom)
							
						Else 
							
							BEEP:C151
							ALERT:C41("Product Classification is missing on CPN "+$_NewProductCode{$j})
							$noClass:=True:C214
							[Customers_Order_Change_Orders:34]ChgOrderStatus:20:="Pricing"
							$j:=$j+Size of array:C274($_NewQty)
							
						End if 
					Else 
						
						BEEP:C151
						ALERT:C41("The Type is missing on CPN "+$_NewProductCode{$j})
						$noClass:=True:C214
						[Customers_Order_Change_Orders:34]ChgOrderStatus:20:="Pricing"
						$j:=$j+Size of array:C274($_NewQty)
						
					End if 
				End for 
				
			End if   // END 4D Professional Services : January 2019 
			
			If (Not:C34($noClass))  //1/25/95
				//*.      Credit check the order difference and post it to customer
				If (True:C214)  //Credit Check
					//READ WRITE([Customers])
					//  //If (fLockNLoad (->[Customers]))// Modified by: Mel Bohince (9/8/16) Switch to optimistic so it doesn't impact the user for this none priority update
					//[Customers]Open_Orders:=[Customers]Open_Orders+$rOrderDiff
					//SAVE RECORD([Customers])
					//`End if 
					//UNLOAD RECORD([Customers])
					READ ONLY:C145([Customers:16])
					//        
					//*.      Set up booking date
					//BAK 8/26/94 - give Bob control of Accepted date for Bookings
					dAppDate:=Date:C102(Request:C163("CCO Approval Date and Booking Date is "; String:C10(4D_Current_date)))  //used by gAddBookings via gPriceChg
					$k:=0
					While (dAppDate=!00-00-00!)
						$k:=$k+1
						If ($k=4)
							ALERT:C41("CO will be accepted with current date."+Char:C90(13)+"Contact Administrator for assistance.")
							dAppDate:=4D_Current_date
						Else 
							dAppDate:=Date:C102(Request:C163("CO Approval Date and Booking Date is "; String:C10(4D_Current_date)))
						End if 
					End while 
					fCnclTrn:=False:C215
					//*Start Transaction
					START TRANSACTION:C239
					
					[Customers_Orders:40]ApprovedBy:14:=<>zResp
					SAVE RECORD:C53([Customers_Orders:40])
					[Customers_Order_Change_Orders:34]DateApproved:4:=dAppDate
					[Customers_Order_Change_Orders:34]ApprovedBy:16:=<>zResp
					SAVE RECORD:C53([Customers_Order_Change_Orders:34])
					//*.      Reset order status
					If (Not:C34($pendingCCO))
						uResetStatii
					End if 
					//*.      Brand Change
					If (([Customers_Order_Change_Orders:34]NewBrand:42#[Customers_Order_Change_Orders:34]OldBrand:43) & ([Customers_Order_Change_Orders:34]NewBrand:42#""))  //upr 1221 11/21/94, 1/26/95 chk for ""
						[Customers_Orders:40]CustomerLine:22:=[Customers_Order_Change_Orders:34]NewBrand:42
						ARRAY TEXT:C222(aBrand; 1)
						aBrand{1}:=[Customers_Orders:40]CustomerLine:22  //•111495  MLB  UPR 1779
						READ WRITE:C146([Estimates:17])
						QUERY:C277([Estimates:17]; [Estimates:17]EstimateNo:1=[Customers_Orders:40]EstimateNo:3)
						[Estimates:17]Brand:3:=[Customers_Orders:40]CustomerLine:22
						[Estimates:17]ModDate:37:=4D_Current_date
						[Estimates:17]ModWho:38:=<>zResp
						SAVE RECORD:C53([Estimates:17])
						UNLOAD RECORD:C212([Estimates:17])
						If ([Customers_Order_Change_Orders:34]NewEstimate:38#"")
							QUERY:C277([Estimates:17]; [Estimates:17]EstimateNo:1=[Customers_Order_Change_Orders:34]NewEstimate:38)
							[Estimates:17]Brand:3:=[Customers_Orders:40]CustomerLine:22
							[Estimates:17]ModDate:37:=4D_Current_date
							[Estimates:17]ModWho:38:=<>zResp
							SAVE RECORD:C53([Estimates:17])
							UNLOAD RECORD:C212([Estimates:17])
						End if 
						
						READ WRITE:C146([Jobs:15])
						QUERY:C277([Jobs:15]; [Jobs:15]JobNo:1=[Customers_Orders:40]JobNo:44)
						[Jobs:15]Line:3:=[Customers_Orders:40]CustomerLine:22
						[Jobs:15]ModDate:8:=4D_Current_date
						[Jobs:15]ModWho:9:=<>zResp
						SAVE RECORD:C53([Jobs:15])
						UNLOAD RECORD:C212([Jobs:15])
						
						READ WRITE:C146([Finished_Goods:26])
						READ WRITE:C146([Customers_ReleaseSchedules:46])  //•060295  MLB  UPR 184
						If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
							
							USE SET:C118("Lines")
							FIRST RECORD:C50([Customers_Order_Lines:41])
							
							
						Else 
							
							USE SET:C118("Lines")
							// see line 61
							
							
						End if   // END 4D Professional Services : January 2019 First record
						// 4D Professional Services : after Order by , query or any query type you don't need First record  
						While (Not:C34(End selection:C36([Customers_Order_Lines:41])))
							//•060295  MLB  UPR 184              
							[Customers_Order_Lines:41]CustomerLine:42:=[Customers_Orders:40]CustomerLine:22
							SAVE RECORD:C53([Customers_Order_Lines:41])
							QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OrderLine:4=[Customers_Order_Lines:41]OrderLine:3)
							APPLY TO SELECTION:C70([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]CustomerLine:28:=[Customers_Orders:40]CustomerLine:22)
							//end 184
							$Denom:=nlGetFGDenom  //4/27/95
							If ([Finished_Goods:26]Status:14#"Final")
								[Finished_Goods:26]Line_Brand:15:=[Customers_Orders:40]CustomerLine:22
								[Finished_Goods:26]ModDate:24:=4D_Current_date
								[Finished_Goods:26]ModWho:25:=<>zResp
								SAVE RECORD:C53([Finished_Goods:26])
								//API_FGTrans ("MOD")
							End if 
							gPriceChg2($Denom)  //adapted from gPriceChg used below`4/27/95
							UNLOAD RECORD:C212([Finished_Goods:26])
							NEXT RECORD:C51([Customers_Order_Lines:41])
						End while 
					End if 
					//*.      Rev Estimate
					If ([Customers_Order_Change_Orders:34]NewEstimate:38#"")
						$OldCaseSen:=[Customers_Orders:40]CaseScenario:4
						$OldEstNum:=[Customers_Orders:40]EstimateNo:3
						[Customers_Orders:40]EstimateNo:3:=[Customers_Order_Change_Orders:34]NewEstimate:38
						[Customers_Orders:40]CaseScenario:4:=[Customers_Order_Change_Orders:34]NewCaseScenario:40
						<>EstStatus:="Accepted Order"
						<>EstNo:=[Customers_Order_Change_Orders:34]NewEstimate:38
						$id:=New process:C317("uChgEstStatus"; <>lMinMemPart; "Estimate Status Change")
						//•071295  MLB  UPR 221
						If ([Customers_Order_Change_Orders:34]NewEstimate:38#[Customers_Order_Change_Orders:34]OrigEstimate:39)
							READ ONLY:C145([Jobs:15])
							QUERY:C277([Jobs:15]; [Jobs:15]EstimateNo:6=[Customers_Order_Change_Orders:34]OrigEstimate:39)
							If (Records in selection:C76([Jobs:15])=0)
								Repeat   //make sure prior call to uChgEstStatus
									DELAY PROCESS:C323(Current process:C322; 240)
								Until (<>EstNo="")
								<>EstStatus:="Superceded"  //•071495  MLB jim said don't set to kill
								<>EstNo:=[Customers_Order_Change_Orders:34]OrigEstimate:39
								$id:=New process:C317("uChgEstStatus"; <>lMinMemPart; "Estimate Status Change")
								If (False:C215)
									uChgEstStatus
								End if 
							End if 
						End if 
						//end 221
						//*.         Booking weight
						//gAdjBookingWgt ($OldEstNum;$OldCaseSen;"RevEst,GChgOApprvl")  
						//«`added parameter 3 4/27/95 chip upr 1252
					End if 
					
					[Customers_Orders:40]ModWho:8:=<>zResp
					[Customers_Orders:40]ModDate:9:=4D_Current_date
					SAVE RECORD:C53([Customers_Orders:40])
					//*.         Loop thru cco change items and process the changes
					RELATE MANY:C262([Customers_Order_Change_Orders:34]OrderChg_Items:6)
					If (Records in selection:C76([Customers_Order_Changed_Items:176])>0)
						If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
							
							ORDER BY:C49([Customers_Order_Changed_Items:176]; [Customers_Order_Changed_Items:176]ItemNo:1; >)
							FIRST RECORD:C50([Customers_Order_Changed_Items:176])  // Modified by: Mel Bohince (11/12/15) 
							
							
						Else 
							
							ORDER BY:C49([Customers_Order_Changed_Items:176]; [Customers_Order_Changed_Items:176]ItemNo:1; >)
							
							
						End if   // END 4D Professional Services : January 2019 First record
						// 4D Professional Services : after Order by , query or any query type you don't need First record  
						MESSAGE:C88(Char:C90(13)+"Accepting Customer Change Order...")
						//USE SET("Lines")
						
						For ($i; 1; (Records in selection:C76([Customers_Order_Changed_Items:176])))
							MESSAGE:C88(Char:C90(13)+String:C10($i)+") Orderline "+String:C10([Customers_Order_Changed_Items:176]ItemNo:1; "00")+"...")
							//*.            Over-write the orderlines
							uChgOrderLines  //upr 1447 3/6/96
							//*.            Load the FG
							READ WRITE:C146([Finished_Goods:26])  //set up f/g record
							//TRACE
							If ([Customers_Order_Changed_Items:176]OldProductCode:9#"")
								$Denom:=nlGetFGDenom([Customers_Order_Change_Orders:34]CustID:2; [Customers_Order_Changed_Items:176]OldProductCode:9)  //•051595  MLB  UPR 1508
							Else 
								$Denom:=nlGetFGDenom([Customers_Order_Change_Orders:34]CustID:2; [Customers_Order_Changed_Items:176]NewProductCode:10)  //•051999  mlb 
							End if 
							//*.            Update the Bookings           
							MESSAGE:C88(Char:C90(13)+"     Bookings...")
							gPriceChg($Denom)  //upr 1447 3/6/96, `4/27/95
							//*.            Process rename   
							If ([Customers_Order_Changed_Items:176]OldProductCode:9#[Customers_Order_Changed_Items:176]NewProductCode:10)
								MESSAGE:C88(Char:C90(13)+"     Rename C-Spec & F/G...")
								sRenameProdCod2
							End if   //changed cpn
							//*.            Process re-classification 
							If ([Customers_Order_Changed_Items:176]NewClassificati:35#[Customers_Order_Changed_Items:176]OldClassificati:34)
								MESSAGE:C88(Char:C90(13)+"     Product classification...")
								uChgProdClassif
							End if   //new classification              
							//*.            Process price change 
							If ([Customers_Order_Changed_Items:176]NewPrice:5#[Customers_Order_Changed_Items:176]OldPrice:3)
								If ([Customers_Order_Changed_Items:176]OldPrice:3#0)  //•051999  mlb  newly added i
									MESSAGE:C88(Char:C90(13)+"     Invoice Adjustment...")
									uInvoAdjustment($Denom)  //upr 1309,`•081595  MLB  add param
									If ([Customers_Order_Lines:41]Price_Per_M:8#0)
										[Finished_Goods:26]LastPrice:27:=uNANCheck([Customers_Order_Lines:41]Price_Per_M:8)  //5/3/95
									End if 
									SAVE RECORD:C53([Finished_Goods:26])
								End if 
							End if   //new price             
							
							NEXT RECORD:C51([Customers_Order_Changed_Items:176])
						End for 
						//*.         Release locks
						UNLOAD RECORD:C212([Customers_Order_Lines:41])
						UNLOAD RECORD:C212([Finished_Goods:26])
						UNLOAD RECORD:C212([Estimates_Carton_Specs:19])
						UNLOAD RECORD:C212([Customers:16])
						CLEAR SET:C117("Lines")
						//BAK 9/14/94 - Release Fix
						//*.         Inspect the releases (post-mortum)
						MESSAGE:C88(Char:C90(13)+"Changing release info...")
						uChgReleaseInfo
						//End of Fix    
						//*.         Delete zero qty orderlines
						MESSAGE:C88(Char:C90(13)+"Deleting zero quantity items...")
						uChgZeroQty
						
						CLOSE WINDOW:C154  // this may be extra
						
					End if   //no items
					//*Validate Transaction
					If (fCnclTrn=True:C214)
						CANCEL TRANSACTION:C241
						BEEP:C151
						ALERT:C41("This transaction has been cancelled!")
					Else 
						VALIDATE TRANSACTION:C240
						utl_Logfile("debug.log"; "Change order on "+String:C10($orderNumber)+"; Transaction Validated")
						
					End if 
					
				Else   //credit check
					[Customers_Order_Change_Orders:34]ChgOrderStatus:20:=$oldCCOStat
					SAVE RECORD:C53([Customers_Order_Change_Orders:34])
					[Customers_Orders:40]Status:10:=$sFailStat
					
					If ([Customers_Orders:40]Status:10="Closed")  //• 3/6/98 cs make sure that closed date is set
						[Customers_Orders:40]DateClosed:49:=4D_Current_date
					End if 
					[Customers_Orders:40]ModWho:8:=<>zResp
					[Customers_Orders:40]ModDate:9:=4D_Current_date
					SAVE RECORD:C53([Customers_Orders:40])
				End if   //credit check
				
			Else 
				//REJECT`•051696  MLB 
				BEEP:C151
				ALERT:C41("Change Order has been statused to Pricing.")
			End if   //$noClass         
			
		Else   //case
			BEEP:C151
			ALERT:C41("Send a Usage Problem Report to Mel or Chip, mention: (P) gChgOApproval."+Char:C90(13)+[Customers_Order_Change_Orders:34]ChgOrderStatus:20)
			
	End case 
	CLOSE WINDOW:C154
End if   //status modified  
SAVE RECORD:C53([Customers_Order_Change_Orders:34])
RELATE MANY:C262([Customers_Orders:40]OrderNumber:1)
ORDER BY:C49([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderLine:3; >)

MESSAGES ON:C181