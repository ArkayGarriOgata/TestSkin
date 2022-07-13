//%attributes = {"publishedWeb":true}
//PM:  ORD_NewOrder  [Customers]
//formerly  
//doOpenOrder2()   --JML   9/14/93
//!!!!!!!!!!!!!  see also gChgOApproval
//                              mod mlb 1/7/94
//This procedure is accessed by the <enter Order> button found in the 
//Customer ORder palette.  It creates a new Order based on the 
//Estimate number given.  This procedure is a re-write of the old 
//openorder procedure.
//upr 95 10/11/94
//upr 1287
//1/26/95 add to job master log 
//upr 1415 02/10/95 chip
//upr 1437 2/20/95  combine qty of same item# c-specs
//2/23/95 jim said to remove
//upr 1447 3/6/95
//3/13/95 jb request     
//4/5/95 upr 1458  keep orderline item # contiguous
//•051295 upr 1508 allow special billings w/o estimate
//•051995  MLB  UPR 177 resequence the order estimate
//•060195  MLB  UPR 184 allow CONTRACT orders
//•071495  MLB  no cost for plates dupes & dies; remove other spl billing options
//•082295  MLB  propgate job numbers
//• 4/10/98 cs Nan Checking
//•100499  mlb  revert back to including cost of  plates dupes and dies
// at some point this was stopped, and now calculating bookings from
//orderlines overstates the PV. Ralph and Jim Bona found this problem
// Modified by: Mel Bohince (6/10/14) Darlene hates reserved jobs, cause many never get used

C_LONGINT:C283(vord; $numRecs; vi; $job; $i; $orderitem; $selected_dif; $err)
C_TEXT:C284($case; $billTo; vCust)
C_REAL:C285(vestP; vestC; vordP; vordC; r1)
C_TEXT:C284($custName; $pjtName)
C_BOOLEAN:C305($propgateJob)  //•082295  MLB  
C_TEXT:C284($lastItem)

MESSAGES OFF:C175

READ ONLY:C145([Customers_Projects:9])
REDUCE SELECTION:C351([Customers:16]; 0)
REDUCE SELECTION:C351([Customers_Projects:9]; 0)

$propgateJob:=False:C215  // used to flag that new job number should be sent to estimate series.
$err:=0
vcust:=""
$custName:=""
$pjtName:=""

pjtId:=Pjt_getReferId
If (Length:C16(pjtId)#0)
	QUERY:C277([Customers_Projects:9]; [Customers_Projects:9]id:1=pjtId)
	If (Records in selection:C76([Customers_Projects:9])=1)
		uSetUp(1; 1)  //uEnterOrder()
		gClearFlags
		//*Init files
		READ WRITE:C146(filePtr->)  //[CustomerOrder]
		READ WRITE:C146([Customers_Order_Lines:41])
		READ WRITE:C146([Customers_ReleaseSchedules:46])
		READ WRITE:C146([Estimates:17])  // for status changes
		READ WRITE:C146([Customers:16])
		READ WRITE:C146([Estimates_Carton_Specs:19])
		READ WRITE:C146([Estimates_FormCartons:48])
		
		vcust:=[Customers_Projects:9]Customerid:3
		QUERY:C277([Customers:16]; [Customers:16]ID:1=vcust)
		$custName:=[Customers_Projects:9]CustomerName:4
		$pjtName:=[Customers_Projects:9]Name:2
		
		//*Determine which estimate should be used or if just special billing
		windowTitle:="New Order for "+$custName+" in Project: "+$pjtName
		$winRef:=OpenFormWindow(->[zz_control:1]; "OpenOrder"; ->windowTitle; windowTitle)
		DIALOG:C40([zz_control:1]; "OpenOrder")
		ERASE WINDOW:C160
		
		If (OK=1)
			//*.   Load vars with users info
			If (bSplBill=1)  //•051295 upr 1508 spl billing only, customer was just selected
				$billTo:="?????"
				$shipto:="n/a"
				sPONum:="0-0000.00"
				$case:="00"
				$numRecs:=0
				
			Else   //normal enterorder    
				$billTo:="?????"
				$shipto:="?????"
				$selected_dif:=Find in array:C230(aSelected; "X")
				$case:=asCaseID{$selected_dif}
				QUERY:C277([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]Estimate_No:2=sPONum; *)
				QUERY:C277([Estimates_Carton_Specs:19];  & ; [Estimates_Carton_Specs:19]diffNum:11=$case)
				CREATE SET:C116([Estimates_Carton_Specs:19]; "DifferentialCartons")  //used by next two procedures
				$numRecs:=Records in selection:C76([Estimates_Carton_Specs:19])
				Ord_ResequenceCartonsIfGaps(sPONum; $case; "DifferentialCartons")
				$err:=Ord_CheckItemsForConsistency(sPONum; $case; "DifferentialCartons")
			End if 
			
			If ($err=0)
				//*Create a new Customer Order header    
				MESSAGE:C88(Char:C90(13)+" Opening order...")
				CREATE RECORD:C68([Customers_Orders:40])
				//vord:=app_AutoIncrement (->[Customers_Orders])
				C_TEXT:C284($server)
				$server:="?"
				app_getNextID(Table:C252(->[Customers_Orders:40]); ->$server; ->vord)
				[Customers_Orders:40]OrderNumber:1:=vord
				[Customers_Orders:40]Status:10:="New"
				[Customers_Orders:40]CustID:2:=vcust
				[Customers_Orders:40]CustomerName:39:=$custName
				[Customers_Orders:40]EstimateNo:3:=sPONum
				[Customers_Orders:40]CaseScenario:4:=$case
				[Customers_Orders:40]defaultBillTo:5:=$billTo
				[Customers_Orders:40]defaultShipto:40:=$shipTo
				[Customers_Orders:40]DateOpened:6:=4D_Current_date
				[Customers_Orders:40]EnteredBy:7:=<>zResp
				[Customers_Orders:40]ModWho:8:=<>zResp
				[Customers_Orders:40]ModDate:9:=4D_Current_date
				[Customers_Orders:40]ProjectNumber:53:=pjtId  //•5/04/00  mlb  
				
				Cust_GetTerms(vcust; ->[Customers_Orders:40]Terms:23; ->[Customers_Orders:40]FOB:25; ->[Customers_Orders:40]ShipVia:24)
				
				[Customers_Orders:40]PlannedBy:30:=[Customers:16]PlannerID:5
				[Customers_Orders:40]SalesRep:13:=[Customers:16]SalesmanID:3
				[Customers_Orders:40]SalesCoord:46:=[Customers:16]SalesCoord:45
				[Customers_Orders:40]CustomerService:47:=[Customers:16]CustomerService:46
				
				If (bSplBill=0)  //•051295 upr 1508 spl billing only, customer was just selected
					
					If (Length:C16([Customers_Orders:40]ProjectNumber:53)=0)
						pjtId:=[Estimates:17]ProjectNumber:63
						[Customers_Orders:40]ProjectNumber:53:=pjtId
					End if 
					
					If ([Estimates:17]Status:30="CONTRACT")  //•060195  MLB  UPR 184
						[Customers_Orders:40]Status:10:="CONTRACT"
						[Customers_Orders:40]IsContract:52:=True:C214  //•050396  MLB  UPR 184
						If ([Estimates:17]POnumber:18#"")
							[Customers_Orders:40]PONumber:11:=[Estimates:17]POnumber:18
						Else 
							[Customers_Orders:40]PONumber:11:="CONTRACT"
						End if 
						
					Else 
						[Customers_Orders:40]PONumber:11:=[Estimates:17]POnumber:18  // jim said to remove
					End if 
					
					[Customers_Orders:40]ContractExpires:12:=[Estimates:17]z_LastRelease:28
					[Customers_Orders:40]CustomerLine:22:=[Estimates:17]Brand:3
					[Customers_Orders:40]Contact_Agent:36:=[Estimates:17]z_Contact_Agent:43
					[Customers_Orders:40]EmailTo:38:=[Estimates:17]z_Contact_Analyst:45
					
					
					If (False:C215)  // Modified by: Mel Bohince (6/10/14) Darlene hates these cause many never get used
						If ([Estimates:17]JobNo:50=0)  //*Create a Job header if necessary
							If ([Estimates:17]Status:30#"CONTRACT")  //•060195  MLB  UPR 184        
								MESSAGE:C88(Char:C90(13)+" Planning Job...")
								READ WRITE:C146([Jobs:15])
								CREATE RECORD:C68([Jobs:15])
								$job:=Job_setJobNumber
								[Jobs:15]JobNo:1:=$job
								[Jobs:15]CustID:2:=vcust
								[Jobs:15]CustomerName:5:=$custName
								[Jobs:15]Line:3:=[Estimates:17]Brand:3
								[Jobs:15]Status:4:="Opened"
								[Jobs:15]EstimateNo:6:=sPONum
								[Jobs:15]CaseScenario:7:=$case
								$diff:=sPONum+$case
								QUERY:C277([Estimates_Differentials:38]; [Estimates_Differentials:38]Id:1=$diff)
								[Jobs:15]ProcessSpec:14:=[Estimates_Differentials:38]ProcessSpec:5
								[Jobs:15]Pld_CostTtlLabo:12:=uNANCheck([Estimates_Differentials:38]CostTtlLabor:11)
								[Jobs:15]Pld_CostTtlOH:13:=uNANCheck([Estimates_Differentials:38]CostTtlOH:12)
								[Jobs:15]Pld_CostTtlMatl:11:=uNANCheck([Estimates_Differentials:38]CostTtlMatl:13)
								
								[Jobs:15]ModDate:8:=4D_Current_date
								[Jobs:15]ModWho:9:=<>zResp
								[Jobs:15]zCount:10:=1
								[Jobs:15]OrderNo:15:=vord
								[Jobs:15]ProjectNumber:18:=pjtId
								SAVE RECORD:C53([Jobs:15])
								MESSAGE:C88(Char:C90(13)+" Job number "+String:C10($job)+" has been opened for use against this order.")
								UNLOAD RECORD:C212([Jobs:15])
								[Estimates:17]JobNo:50:=$job
								$propgateJob:=True:C214  //•082295  MLB  
							End if   //contract
						Else   //there is a job
							MESSAGE:C88(Char:C90(13)+" Job number "+String:C10([Estimates:17]JobNo:50)+" was opened for use against this estimate.")
						End if   //no job
						[Customers_Orders:40]JobNo:44:=[Estimates:17]JobNo:50
						//*   Create a Job Tracker if necessary          
						JML_newViaOrder([Estimates:17]Status:30)
					End if 
					
					[Estimates:17]OrderNo:51:=vord
					If ([Estimates:17]Status:30="CONTRACT")  //•060195  MLB  UPR 184
						[Estimates:17]Status:30:="CONTRACTED"
					Else 
						[Estimates:17]Status:30:="Ordered"
					End if 
					
					SAVE RECORD:C53([Estimates:17])
					
				End if   //splbill    
				
				//*.          SAVE THE ORDER
				SAVE RECORD:C53([Customers_Orders:40])  //4/5/95 upr 1458
				
				//*CREATE orderline items
				MESSAGE:C88(Char:C90(13)+" Creating order items...")
				If ($numRecs=0)
					If (bSplBill=0)  //•051295 upr 1508 spl billing only
						uConfirm("No carton specification were found, better check the results"; "OK"; "Help")
					End if 
					
				Else 
					//gEstimateLDWkSh ("Wksht")
					USE SET:C118("DifferentialCartons")
					If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
						
						ORDER BY:C49([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]Item:1; >)
						FIRST RECORD:C50([Estimates_Carton_Specs:19])
						
						
					Else 
						
						ORDER BY:C49([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]Item:1; >)
						
					End if   // END 4D Professional Services : January 2019 First record
					// 4D Professional Services : after Order by , query or any query type you don't need First record  
				End if   //no cartons   
				vestP:=0  //tally orders value and cost
				vestC:=0
				vordP:=0
				vordC:=0
				
				$lastItem:=""  //2/20/95  
				$orderitem:=1  //4/5/95 upr 1458
				For ($spec; 1; $numRecs)
					MESSAGE:C88("."+String:C10($orderitem))
					$orderitem:=ORD_AddItemRegular($lastItem=[Estimates_Carton_Specs:19]Item:1; $orderitem)  //upr 1447 3/6/95
					$lastItem:=[Estimates_Carton_Specs:19]Item:1
					NEXT RECORD:C51([Estimates_Carton_Specs:19])
				End for 
				
				If ($orderitem>=89)  //4/5/95 upr 1458
					uConfirm("Item numbering problem in New Order"; "OK"; "Help")
				End if 
				//••  SEE ALSO 'ORD_ChangeOrder'  ••
				vi:=89  //set this so that the NEXT (dies etc) starts at 90  upr 1415 02/10/95 chip
				If (bSplBill=0)  //•051295 upr 1508 spl billing only
					If (rInclPrep=1)
						vi:=vi+1
						MESSAGE:C88("."+String:C10(vi)+" Preparatory")
						ORD_AddItemSplBilling("Preparatory"; [Estimates:17]z_Cost_TotalPrep:9; 0; "25")
					End if 
					If (rInclDups=1)
						vi:=vi+1
						MESSAGE:C88("."+String:C10(vi)+" Dupes")
						ORD_AddItemSplBilling("Dupes"; [Estimates_Differentials:38]Cost_Dups:19; [Estimates_Differentials:38]Prc_Dups:24; "27")  //•100499  mlb  revert back to including cost of  plates dupes and dies
						//dOrderAddItem2 ("Dupes";0;[Differential]Prc_Dups;"27")
					End if 
					If (rInclPlates=1)
						vi:=vi+1
						MESSAGE:C88("."+String:C10(vi)+" Plates")
						ORD_AddItemSplBilling("Plates"; [Estimates_Differentials:38]Cost_Plates:20; [Estimates_Differentials:38]Prc_Plates:23; "27")  //•100499  mlb  revert back to including cost of  plates dupes and dies
						//dOrderAddItem2 ("Plates";0;[Differential]Prc_Plates;"27")
					End if 
					If (rInclDies=1)
						vi:=vi+1
						MESSAGE:C88("."+String:C10(vi)+" Dies")
						ORD_AddItemSplBilling("Dies"; [Estimates_Differentials:38]Cost_Dies:21; [Estimates_Differentials:38]Prc_Dies:22; "27")  //•100499  mlb  revert back to including cost of  plates dupes and dies
						//dOrderAddItem2 ("Dies";0;[Differential]Prc_Dies;"27")
					End if 
					If (rInclPnD=1)
						vi:=vi+1
						MESSAGE:C88("."+String:C10(vi)+" Plates and Dies")
						ORD_AddItemSplBilling("Plates and Dies"; ([Estimates_Differentials:38]Cost_Dies:21+[Estimates_Differentials:38]Cost_Plates:20); ([Estimates_Differentials:38]Prc_Dies:22+[Estimates_Differentials:38]Prc_Plates:23); "27")  //•100499  mlb  revert back to including cost of  plates dupes and dies
						//dOrderAddItem2 ("Plates and Dies";0;([Differential]Prc_Dies+
						//«[Differential]Prc_Plates);"27")
					End if 
				End if   //splbill  
				
				If (rInclFrate=1)
					vi:=vi+1
					MESSAGE:C88("."+String:C10(vi)+" Freight")
					ORD_AddItemSplBilling("SpecialFreight"; 0; 0; "9")
				End if 
				If (rInclCull=1)
					vi:=vi+1
					MESSAGE:C88("."+String:C10(vi)+" Culling")
					ORD_AddItemSplBilling("Culling"; 0; 0; "90")
				End if 
				
				If (rInclOther=1)
					uDialog("SpecialBilling"; 300; 170)
					If (False:C215)
						FORM SET INPUT:C55([zz_control:1]; "SpecialBilling")
					End if 
					
					If (OK=1)
						vi:=vi+1
						MESSAGE:C88("."+String:C10(vi)+" "+sDesc)
						ORD_AddItemSplBilling(sDesc; Num:C11(sPoLocation); 0; "27"; Num:C11(sChargeCode))  //these fields reused from another dialog
					End if 
				End if 
				//*Post booking info
				[Customers_Orders:40]EstSalesValue:18:=vestP
				[Customers_Orders:40]OrderSalesTotal:19:=vestP
				[Customers_Orders:40]BudgetCostTotal:20:=vestC
				[Customers_Orders:40]PV:21:=uNANCheck((vestP-vestC)/vestP)
				//*.          SAVE THE ORDER
				SAVE RECORD:C53([Customers_Orders:40])
				//*Update the customer and do the API trans
				[Customers:16]Active:15:=True:C214  //update the customer
				[Customers:16]ModAddress:35:=4D_Current_date
				[Customers:16]ModFlag:37:=True:C214
				[Customers:16]Open_Orders:34:=[Customers:16]Open_Orders:34+vestP
				sCID:=$billTo
				lCID:=Num:C11($billTo)
				
				SAVE RECORD:C53([Customers:16])
				REDUCE SELECTION:C351([Customers:16]; 0)
				//*Modify the new Customer Order
				fLoop:=False:C215
				iMode:=2
				ARRAY TEXT:C222(aBilltos; 0)
				ARRAY TEXT:C222(aShiptos; 0)
				
				pattern_PassThru(->[Customers_Orders:40])
				REDUCE SELECTION:C351([Customers_Orders:40]; 0)
				REDUCE SELECTION:C351([Customers_Order_Lines:41]; 0)
				ViewSetter(2; ->[Customers_Orders:40])
				
			End if 
		End if 
		//*Cleanup
		CLOSE WINDOW:C154
		MESSAGES ON:C181
		
		If ($propgateJob)  //•082295  MLB    
			<>EstNo:=sPONum
			C_LONGINT:C283(<>JobNo; $id)
			<>JobNo:=$job
			$id:=New process:C317("EST_ChgJobRefer"; <>lMinMemPart; "Estimate Job Change")
			If (False:C215)
				EST_ChgJobRefer
			End if 
		End if 
		
	Else 
		uConfirm("Project couldn't be found."; "OK"; "Help")
	End if 
	
Else 
	uConfirm("No Project number."; "OK"; "Help")
End if 

uSetUp(0; 0)
REDUCE SELECTION:C351([Customers:16]; 0)
REDUCE SELECTION:C351([Estimates:17]; 0)  //leave this here!