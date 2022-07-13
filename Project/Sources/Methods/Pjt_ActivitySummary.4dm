//%attributes = {"publishedWeb":true}
//PM: Pjt_ActivitySummary($pjt) -> 
//@author mlb - 8/9/01  14:52

C_TEXT:C284($t; $cr)

$pjtId:=$1
$t:=Char:C90(9)
$cr:=Char:C90(13)
xText:=""
dDateBegin:=4D_Current_date-30  //30
dDateEnd:=4D_Current_date

NewWindow(240; 115; 6; 0; "Select Activity Period")
DIALOG:C40([zz_control:1]; "DateRange2")
CLOSE WINDOW:C154

If (OK=1)
	If (bSearch=1)
		BEEP:C151
		ALERT:C41("Find button is not operational on this report. Last 30 days will be used.")
		dDateBegin:=4D_Current_date-30  //30
		dDateEnd:=4D_Current_date
	End if 
	
	utl_LogIt("init")
	utl_LogIt("PROJECT: "+$pjtId+" - "+pjtName+" for "+pjtCustName; 0)
	utl_LogIt("ACTIVITY SUMMARY FOR PERIOD "+String:C10(dDateBegin; System date short:K1:1)+" TO "+String:C10(dDateEnd; System date short:K1:1)+$cr; 0)
	
	utl_LogIt("Sales:"; 0)
	zwStatusMsg("PJT SUMMARY"; "Loading orders")
	QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]ProjectNumber:50=$pjtId; *)
	QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]DateOpened:13>=dDateBegin; *)
	QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]DateOpened:13<=dDateEnd; *)
	QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]Status:9#"Cancel@"; *)
	QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]Status:9#"Kill"; *)
	QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]Status:9#"New"; *)
	QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]Status:9#"Contract"; *)
	QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]Status:9#"Open@"; *)
	QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]Status:9#"Rejected")
	xText:=""
	
	SELECTION TO ARRAY:C260([Customers_Order_Lines:41]CustID:4; $aCustid; [Customers_Order_Lines:41]Quantity:6; $aQty; [Customers_Order_Lines:41]Price_Per_M:8; $aPrice; [Customers_Order_Lines:41]DateOpened:13; $aDate; [Customers_Order_Lines:41]Cost_Per_M:7; $aCost; [Customers_Order_Lines:41]SpecialBilling:37; $aSplBilling)
	SORT ARRAY:C229($aCustid; $aQty; $aPrice; $aDate; $aCost; $aSplBilling; >)  //
	$numCust:=Size of array:C274($aCustid)
	
	$bookedDollars:=0
	$bookedUnits:=0
	$bookedPrep:=0
	For ($i; 1; $numCust)
		If (Not:C34($aSplBilling{$i}))
			$rev:=$aQty{$i}/1000*$aPrice{$i}
			$bookedUnits:=$bookedUnits+$aQty{$i}
			$bookedDollars:=$bookedDollars+$rev
		Else 
			$rev:=$aQty{$i}*$aPrice{$i}
			$bookedPrep:=$bookedPrep+($aQty{$i}*$aPrice{$i})
		End if 
	End for 
	
	utl_LogIt("   "+String:C10($numCust)+" Orderlines Booked"; 0)
	utl_LogIt("   "+String:C10($bookedUnits; "##,###,##0")+" units were booked at a sales value of "+String:C10(Round:C94($bookedDollars; 0); "##,###,##0"); 0)
	utl_LogIt("   "+String:C10(Round:C94($bookedPrep; 0); "##,###,##0")+" Prep Dollars Booked"; 0)
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
		
		QUERY:C277([Estimates:17]; [Estimates:17]ProjectNumber:63=$pjtId)
		CREATE SET:C116([Estimates:17]; "pjtEstimates")
		QUERY SELECTION:C341([Estimates:17]; [Estimates:17]Status:30="Quote@")
		
		
	Else 
		
		QUERY:C277([Estimates:17]; [Estimates:17]ProjectNumber:63=$pjtId; *)
		QUERY:C277([Estimates:17]; [Estimates:17]Status:30="Quote@")
		
		
	End if   // END 4D Professional Services : January 2019 query selection
	$bookedUnits:=Records in selection:C76([Estimates:17])
	utl_LogIt("   "+String:C10(Round:C94($bookedUnits; 0); "##,###,##0")+"  Outstanding Quotes"; 0)
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
		
		USE SET:C118("pjtEstimates")
		QUERY SELECTION:C341([Estimates:17]; [Estimates:17]Status:30="Price@")
		
		
	Else 
		
		QUERY:C277([Estimates:17]; [Estimates:17]ProjectNumber:63=$pjtId; *)
		QUERY:C277([Estimates:17]; [Estimates:17]Status:30="Price@")
		
		
	End if   // END 4D Professional Services : January 2019 query selection
	$bookedUnits:=Records in selection:C76([Estimates:17])
	utl_LogIt("   "+String:C10(Round:C94($bookedUnits; 0); "##,###,##0")+"  RFQ's are waiting to be Quoted"; 0)
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
		
		USE SET:C118("pjtEstimates")
		QUERY SELECTION:C341([Estimates:17]; [Estimates:17]Status:30="RFQ")
		
		
	Else 
		
		QUERY:C277([Estimates:17]; [Estimates:17]ProjectNumber:63=$pjtId; *)
		QUERY:C277([Estimates:17]; [Estimates:17]Status:30="RFQ")
		
		
	End if   // END 4D Professional Services : January 2019 query selection
	$bookedUnits:=Records in selection:C76([Estimates:17])
	utl_LogIt("   "+String:C10(Round:C94($bookedUnits; 0); "##,###,##0")+"  RFQ's are waiting to be Estimated"; 0)
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
		
		USE SET:C118("pjtEstimates")
		QUERY SELECTION:C341([Estimates:17]; [Estimates:17]Status:30="New")
		
		
	Else 
		
		QUERY:C277([Estimates:17]; [Estimates:17]ProjectNumber:63=$pjtId; *)
		QUERY:C277([Estimates:17]; [Estimates:17]Status:30="New")
		
		
	End if   // END 4D Professional Services : January 2019 query selection
	$bookedUnits:=Records in selection:C76([Estimates:17])
	utl_LogIt("   "+String:C10(Round:C94($bookedUnits; 0); "##,###,##0")+"  New Estimates pending"+$cr; 0)
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
		
		CLEAR SET:C117("pjtEstimates")
		
		
	Else 
		
		
	End if   // END 4D Professional Services : January 2019 query selection
	
	utl_LogIt("Production:"; 0)
	zwStatusMsg("PJT SUMMARY"; "Loading production")
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
		
		QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]ProjectNumber:6=$pjtId)
		CREATE SET:C116([Job_Forms_Items:44]; "pjtJobits")
		util_outerJoin(->[Finished_Goods_Transactions:33]Jobit:31; ->[Job_Forms_Items:44]Jobit:4)
		QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionDate:3>=dDateBegin; *)
		QUERY SELECTION:C341([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]XactionDate:3<=dDateEnd; *)
		QUERY SELECTION:C341([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]XactionType:2="Receipt")
		
		
	Else 
		
		
		zwStatusMsg("Relating"; " Searching "+Table name:C256(->[Finished_Goods_Transactions:33])+" file. Please Wait...")
		
		QUERY BY FORMULA:C48([Finished_Goods_Transactions:33]; ([Finished_Goods_Transactions:33]XactionDate:3>=dDateBegin) & ([Finished_Goods_Transactions:33]XactionDate:3<=dDateEnd) & ([Finished_Goods_Transactions:33]XactionType:2="Receipt") & ([Job_Forms_Items:44]Jobit:4=[Finished_Goods_Transactions:33]Jobit:31) & ([Job_Forms_Items:44]ProjectNumber:6=$pjtId))
		
		zwStatusMsg(""; "")
		
	End if   // END 4D Professional Services : January 2019 query selection
	If (Records in selection:C76([Finished_Goods_Transactions:33])>0)
		$rev:=Sum:C1([Finished_Goods_Transactions:33]ExtendedPrice:20)
		$bookedUnits:=Sum:C1([Finished_Goods_Transactions:33]Qty:6)
	Else 
		$rev:=0
		$bookedUnits:=0
	End if 
	utl_LogIt("   "+String:C10($bookedUnits; "##,###,##0")+" units were glued at a sales value of  "+String:C10(Round:C94($rev; 0); "##,###,##0")+""; 0)
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
		
		USE SET:C118("pjtJobits")
		util_outerJoin(->[Finished_Goods_Locations:35]Jobit:33; ->[Job_Forms_Items:44]Jobit:4)
		
		
	Else 
		
		zwStatusMsg("Relating"; " Searching "+Table name:C256(->[Finished_Goods_Transactions:33])+" file. Please Wait...")
		
		QUERY BY FORMULA:C48([Finished_Goods_Transactions:33]; ([Job_Forms_Items:44]Jobit:4=[Finished_Goods_Transactions:33]Jobit:31) & ([Job_Forms_Items:44]ProjectNumber:6=$pjtId))
		
		zwStatusMsg(""; "")
		
		
	End if   // END 4D Professional Services : January 2019 query selection
	If (Records in selection:C76([Finished_Goods_Locations:35])>0)
		$bookedUnits:=Sum:C1([Finished_Goods_Locations:35]QtyOH:9)
	Else 
		$bookedUnits:=0
	End if 
	utl_LogIt("   "+String:C10($bookedUnits; "##,###,##0")+" units remain in inventory  "; 0)
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
		
		USE SET:C118("pjtJobits")
		QUERY SELECTION:C341([Job_Forms_Items:44];  & ; [Job_Forms_Items:44]Qty_Actual:11=0)
		
		
	Else 
		
		QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]ProjectNumber:6=$pjtId; *)
		QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]Qty_Actual:11=0)
		
		
	End if   // END 4D Professional Services : January 2019 query selection
	If (Records in selection:C76([Job_Forms_Items:44])>0)
		$bookedUnits:=Sum:C1([Job_Forms_Items:44]Qty_Want:24)
	Else 
		$bookedUnits:=0
	End if 
	utl_LogIt("   "+String:C10($bookedUnits; "##,###,##0")+" units are poised for production"; 0)
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
		
		CLEAR SET:C117("pjtJobits")
		
	Else 
		
		
		
	End if   // END 4D Professional Services : January 2019 query selection
	
	QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]ProjectNumber:40=$pjtId; *)
	QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Sched_Date:5>dDateEnd; *)
	QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Actual_Date:7=!00-00-00!)
	If (Records in selection:C76([Customers_ReleaseSchedules:46])>0)
		$bookedUnits:=Sum:C1([Customers_ReleaseSchedules:46]Sched_Qty:6)
	Else 
		$bookedUnits:=0
	End if 
	utl_LogIt("   There are "+String:C10($bookedUnits; "##,###,##0")+" units called off in future releases"+$cr; 0)
	
	utl_LogIt("Shipments:"; 0)
	zwStatusMsg("PJT SUMMARY"; "Loading releases")
	QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]ProjectNumber:40=$pjtId; *)
	QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Actual_Date:7>=dDateBegin; *)
	QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Actual_Date:7<=dDateEnd)
	
	SELECTION TO ARRAY:C260([Customers_ReleaseSchedules:46]OrderLine:4; $aOrderline; [Customers_ReleaseSchedules:46]Actual_Date:7; $aActDate; [Customers_ReleaseSchedules:46]Actual_Qty:8; $aActQty; [Customers_ReleaseSchedules:46]Sched_Date:5; $aSchDate; [Customers_ReleaseSchedules:46]Sched_Qty:6; $aSchQty)
	$rev:=0
	$ontime:=0
	$short:=0
	$numCust:=Size of array:C274($aOrderline)
	If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4
		
		For ($i; 1; $numCust)
			QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderLine:3=$aOrderline{$i})
			$rev:=$rev+($aActQty{$i}/1000*[Customers_Order_Lines:41]Price_Per_M:8)
			If ($aActDate{$i}<=$aSchDate{$i})
				$ontime:=$ontime+1
			End if 
			If ($aActQty{$i}<$aSchQty{$i})
				$short:=$short+1
			End if 
		End for 
		
	Else 
		
		ARRAY REAL:C219($_Price_Per_M; 0)
		ARRAY TEXT:C222($_aOrderline1; 0)
		
		QUERY WITH ARRAY:C644([Customers_Order_Lines:41]OrderLine:3; $aOrderline)
		SELECTION TO ARRAY:C260([Customers_Order_Lines:41]Price_Per_M:8; $_Price_Per_M; \
			[Customers_Order_Lines:41]OrderLine:3; $_aOrderline1)
		
		
		For ($i; 1; $numCust)
			$position:=Find in array:C230($_aOrderline1; $aOrderline{$i})
			
			$rev:=$rev+($aActQty{$i}/1000*$_Price_Per_M{$position})
			If ($aActDate{$i}<=$aSchDate{$i})
				$ontime:=$ontime+1
			End if 
			If ($aActQty{$i}<$aSchQty{$i})
				$short:=$short+1
			End if 
		End for 
		
	End if   // END 4D Professional Services : January 2019 query selection
	
	utl_LogIt("   "+String:C10($numCust; "##,###,##0")+" Releases Shipped"; 0)
	utl_LogIt("   "+String:C10($ontime; "##,###,##0")+" shipments were early or on time"; 0)
	utl_LogIt("   "+String:C10($numCust-$short; "##,###,##0")+" were full shipments"; 0)
	utl_LogIt("   "+String:C10(Round:C94($rev; 0); "##,###,##0")+" Dollars Billed"+$cr; 0)
	utl_LogIt("Collections"; 0)
	utl_LogIt("   "+"not available"+$cr; 0)
	utl_LogIt("Preparatory Work: "; 0)
	xText:=""
	zwStatusMsg("PJT SUMMARY"; "Loading FG specs")
	QUERY:C277([Finished_Goods_Specifications:98]; [Finished_Goods_Specifications:98]ProjectNumber:4=$pjtId; *)
	QUERY:C277([Finished_Goods_Specifications:98];  & ; [Finished_Goods_Specifications:98]DatePrepDone:6>=dDateBegin; *)
	QUERY:C277([Finished_Goods_Specifications:98];  & ; [Finished_Goods_Specifications:98]DatePrepDone:6<=dDateEnd)
	$numFGS:=Records in selection:C76([Finished_Goods_Specifications:98])
	$qtyQuote:=0
	$qtyAct:=0
	$priceQuote:=0
	$priceActual:=0
	$variance:=0
	$invoiced:=0
	$ordered:=0
	If ($numFGS>0)
		ORDER BY:C49([Finished_Goods_Specifications:98]; [Finished_Goods_Specifications:98]FG_Key:1; >; [Finished_Goods_Specifications:98]ControlNumber:2; >)
		xText:=xText+"   "+"Product Key"+$t+"Control Number"+$t+"DaysToComplete"+$t+"ServiceRequested"+$t+"ServiceItem"+$t+"QtyQuoted"+$t+"PriceQuoted"+$t+"QtyActual"+$t+"PriceActual"+$t+"Variance"+$cr
		If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) Next record
			
			For ($i; 1; $numFGS)
				//*get the customer name
				//$custid:=Substring([FG_Specification]FG_Key;1;5)
				//SET QUERY LIMIT(1)
				//QUERY([CUSTOMER];[CUSTOMER]ID=$custid)
				//SET QUERY LIMIT(0)
				If ([Finished_Goods_Specifications:98]OrderNumber:59#0)
					$ordered:=$ordered+1
				End if 
				//*get corrisponding prep charges
				RELATE MANY:C262([Finished_Goods_Specifications:98]ControlNumber:2)
				$numPrepChg:=Records in selection:C76([Prep_Charges:103])
				
				If ([Finished_Goods_Specifications:98]DatePrepDone:6#!00-00-00!) & ([Finished_Goods_Specifications:98]DateSubmitted:5#!00-00-00!)
					$days:=[Finished_Goods_Specifications:98]DatePrepDone:6-[Finished_Goods_Specifications:98]DateSubmitted:5
				Else 
					$days:=-1
				End if 
				
				If ($numPrepChg>0)
					If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
						
						ORDER BY:C49([Prep_Charges:103]; [Prep_Charges:103]ControlNumber:1)
						FIRST RECORD:C50([Prep_Charges:103])
						
						
					Else 
						
						ORDER BY:C49([Prep_Charges:103]; [Prep_Charges:103]ControlNumber:1)
						
					End if   // END 4D Professional Services : January 2019 First record
					// 4D Professional Services : after Order by , query or any query type you don't need First record  
					If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
						
						For ($j; 1; $numPrepChg)
							If ([Prep_Charges:103]InvoiceNumber:7#0)
								$invoiced:=$invoiced+1
							End if 
							QUERY:C277([Prep_CatalogItems:102]; [Prep_CatalogItems:102]ItemNumber:1=[Prep_Charges:103]PrepItemNumber:4)
							xText:=xText+"   "+[Finished_Goods_Specifications:98]ProductCode:3+$t+[Finished_Goods_Specifications:98]ControlNumber:2+$t+String:C10($days)+$t+[Finished_Goods_Specifications:98]ServiceRequested:54+$t+[Prep_CatalogItems:102]Description:2+$t+String:C10([Prep_Charges:103]QuantityQuoted:2)+$t+String:C10([Prep_Charges:103]PriceQuoted:6)+$t+String:C10([Prep_Charges:103]QuantityActual:3)+$t+String:C10([Prep_Charges:103]PriceActual:5)+$t+String:C10([Prep_Charges:103]PriceQuoted:6-[Prep_Charges:103]PriceActual:5)+$cr
							$qtyQuote:=$qtyQuote+[Prep_Charges:103]QuantityQuoted:2
							$qtyAct:=$qtyAct+[Prep_Charges:103]QuantityActual:3
							$priceQuote:=$priceQuote+[Prep_Charges:103]PriceQuoted:6
							$priceActual:=$priceActual+[Prep_Charges:103]PriceActual:5
							$variance:=$variance+([Prep_Charges:103]PriceQuoted:6-[Prep_Charges:103]PriceActual:5)
							NEXT RECORD:C51([Prep_Charges:103])
						End for 
						
					Else 
						
						ARRAY REAL:C219($_PriceQuoted; 0)
						ARRAY REAL:C219($_PriceActual; 0)
						ARRAY REAL:C219($_QuantityActual; 0)
						ARRAY REAL:C219($_QuantityQuoted; 0)
						ARRAY LONGINT:C221($_InvoiceNumber; 0)
						ARRAY TEXT:C222($_PrepItemNumber; 0)
						ARRAY TEXT:C222($_ItemNumber; 0)
						ARRAY TEXT:C222($_Description; 0)
						
						GET FIELD RELATION:C920([Prep_Charges:103]PrepItemNumber:4; $lienAller; $lienRetour)
						SET FIELD RELATION:C919([Prep_Charges:103]PrepItemNumber:4; Automatic:K51:4; Do not modify:K51:1)
						
						SELECTION TO ARRAY:C260([Prep_Charges:103]PriceQuoted:6; $_PriceQuoted; [Prep_Charges:103]PriceActual:5; $_PriceActual; [Prep_Charges:103]QuantityActual:3; $_QuantityActual; [Prep_Charges:103]QuantityQuoted:2; $_QuantityQuoted; [Prep_Charges:103]InvoiceNumber:7; $_InvoiceNumber; [Prep_Charges:103]PrepItemNumber:4; $_PrepItemNumber; [Prep_CatalogItems:102]ItemNumber:1; $_ItemNumber; [Prep_CatalogItems:102]Description:2; $_Description)
						
						SET FIELD RELATION:C919([Prep_Charges:103]PrepItemNumber:4; $lienAller; $lienRetour)
						
						
						For ($j; 1; $numPrepChg; 1)
							If ($_InvoiceNumber{$j}#0)
								$invoiced:=$invoiced+1
							End if 
							xText:=xText+"   "+[Finished_Goods_Specifications:98]ProductCode:3+$t+[Finished_Goods_Specifications:98]ControlNumber:2+$t+String:C10($days)+$t+[Finished_Goods_Specifications:98]ServiceRequested:54+$t+$_Description{$j}+$t+String:C10($_QuantityQuoted{$j})+$t+String:C10($_PriceQuoted{$j})+$t+String:C10($_QuantityActual{$j})+$t+String:C10($_PriceActual{$j})+$t+String:C10($_PriceActual{$j}-$_PriceActual{$j})+$cr
							$qtyQuote:=$qtyQuote+$_QuantityQuoted{$j}
							$qtyAct:=$qtyAct+$_QuantityActual{$j}
							$priceQuote:=$priceQuote+$_PriceQuoted{$j}
							$priceActual:=$priceActual+$_PriceActual{$j}
							$variance:=$variance+($_PriceQuoted{$j}-$_PriceActual{$j})
							
						End for 
						
					End if   // END 4D Professional Services : January 2019 query selection
					
					
				Else   //no prep charges
					xText:=xText+"   "+[Finished_Goods_Specifications:98]ProductCode:3+$t+[Finished_Goods_Specifications:98]ControlNumber:2+$t+String:C10($days)+$t+[Finished_Goods_Specifications:98]ServiceRequested:54+$t+"No Prep Charges found"+$cr
				End if   //prep charges   
				
				NEXT RECORD:C51([Finished_Goods_Specifications:98])
			End for 
			
		Else 
			
			ARRAY LONGINT:C221($_OrderNumber; 0)
			ARRAY TEXT:C222($_ControlNumber; 0)
			ARRAY DATE:C224($_DatePrepDone; 0)
			ARRAY DATE:C224($_DateSubmitted; 0)
			ARRAY TEXT:C222($_ProductCode; 0)
			ARRAY TEXT:C222($_ServiceRequested; 0)
			
			
			SELECTION TO ARRAY:C260([Finished_Goods_Specifications:98]OrderNumber:59; $_OrderNumber; \
				[Finished_Goods_Specifications:98]ControlNumber:2; $_ControlNumber; \
				[Finished_Goods_Specifications:98]DatePrepDone:6; $_DatePrepDone; \
				[Finished_Goods_Specifications:98]DateSubmitted:5; $_DateSubmitted; \
				[Finished_Goods_Specifications:98]ProductCode:3; $_ProductCode; \
				[Finished_Goods_Specifications:98]ServiceRequested:54; $_ServiceRequested)
			
			
			For ($i; 1; $numFGS; 1)
				
				If ($_OrderNumber{$i}#0)
					$ordered:=$ordered+1
				End if 
				//*get corrisponding prep charges
				QUERY:C277([Prep_Charges:103]; [Prep_Charges:103]ControlNumber:1=$_ControlNumber{$i})
				
				$numPrepChg:=Records in selection:C76([Prep_Charges:103])
				
				If ($_DatePrepDone{$i}#!00-00-00!) & ($_DateSubmitted{$i}#!00-00-00!)
					$days:=$_DatePrepDone{$i}-$_DateSubmitted{$i}
				Else 
					$days:=-1
				End if 
				
				If ($numPrepChg>0)
					
					ORDER BY:C49([Prep_Charges:103]; [Prep_Charges:103]ControlNumber:1)
					
					
					ARRAY REAL:C219($_PriceQuoted; 0)
					ARRAY REAL:C219($_PriceActual; 0)
					ARRAY REAL:C219($_QuantityActual; 0)
					ARRAY REAL:C219($_QuantityQuoted; 0)
					ARRAY LONGINT:C221($_InvoiceNumber; 0)
					ARRAY TEXT:C222($_PrepItemNumber; 0)
					ARRAY TEXT:C222($_ItemNumber; 0)
					ARRAY TEXT:C222($_Description; 0)
					
					GET FIELD RELATION:C920([Prep_Charges:103]PrepItemNumber:4; $lienAller; $lienRetour)
					SET FIELD RELATION:C919([Prep_Charges:103]PrepItemNumber:4; Automatic:K51:4; Do not modify:K51:1)
					
					SELECTION TO ARRAY:C260([Prep_Charges:103]PriceQuoted:6; $_PriceQuoted; [Prep_Charges:103]PriceActual:5; $_PriceActual; [Prep_Charges:103]QuantityActual:3; $_QuantityActual; [Prep_Charges:103]QuantityQuoted:2; $_QuantityQuoted; [Prep_Charges:103]InvoiceNumber:7; $_InvoiceNumber; [Prep_Charges:103]PrepItemNumber:4; $_PrepItemNumber; [Prep_CatalogItems:102]ItemNumber:1; $_ItemNumber; [Prep_CatalogItems:102]Description:2; $_Description)
					
					SET FIELD RELATION:C919([Prep_Charges:103]PrepItemNumber:4; $lienAller; $lienRetour)
					
					
					For ($j; 1; $numPrepChg; 1)
						If ($_InvoiceNumber{$j}#0)
							$invoiced:=$invoiced+1
						End if 
						xText:=xText+"   "+$_ProductCode{$i}+$t+$_ControlNumber{$i}+$t+String:C10($days)+$t+$_ServiceRequested{$i}+$t+$_Description{$j}+$t+String:C10($_QuantityQuoted{$j})+$t+String:C10($_PriceQuoted{$j})+$t+String:C10($_QuantityActual{$j})+$t+String:C10($_PriceActual{$j})+$t+String:C10($_PriceActual{$j}-$_PriceActual{$j})+$cr
						$qtyQuote:=$qtyQuote+$_QuantityQuoted{$j}
						$qtyAct:=$qtyAct+$_QuantityActual{$j}
						$priceQuote:=$priceQuote+$_PriceQuoted{$j}
						$priceActual:=$priceActual+$_PriceActual{$j}
						$variance:=$variance+($_PriceQuoted{$j}-$_PriceActual{$j})
						
					End for 
					
					
				Else   //no prep charges
					xText:=xText+"   "+$_ProductCode{$i}+$t+$_ControlNumber{$i}+$t+String:C10($days)+$t+$_ServiceRequested{$i}+$t+"No Prep Charges found"+$cr
				End if   //prep charges   
				
			End for 
			
		End if   // END 4D Professional Services : January 2019 
		
		xText:=xText+"   "+""+$t+""+$t+""+$t+"TOTALS"+$t+$t+String:C10($qtyQuote)+$t+String:C10($priceQuote)+$t+String:C10($qtyAct)+$t+String:C10($priceActual)+$t+String:C10($variance)+$cr
	End if 
	
	utl_LogIt("   There were "+String:C10($numFGS; "##,###,##0")+" prep work orders, "+String:C10($ordered; "##,###,##0")+" have been booked, "+String:C10($invoiced; "##,###,##0")+" have been invoiced"; 0)
	utl_LogIt("   Quoted "+String:C10($priceQuote; "##,###,##0")+" dollars of prep, expended "+String:C10($priceActual; "##,###,##0")+" dollars of actual work"+$cr; 0)
	utl_LogIt("   Details:"; 0)
	utl_LogIt(xText+$cr; 0)
	xText:=""
	
	zwStatusMsg("PJT SUMMARY"; "Done")
	utl_LogIt("show")
	
	utl_LogIt("init")
	zwStatusMsg(""; "")
End if 