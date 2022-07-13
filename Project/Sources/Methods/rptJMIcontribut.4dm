//%attributes = {"publishedWeb":true}
//rptJMIcontribut(filename)
//dump out pertinent contribution details
//create your rm selection before calling this proc
//mlb 100598 htk wants date in words like April, May..., and sales rep
//•120398  MLB  add actual

C_TIME:C306($docRef)

If (Count parameters:C259=0)
	$docRef:=Create document:C266("")
	C_TEXT:C284(sEffective)
	sEffective:="00/00/00"
	// sEffective:=Request("Enter effectivity date:";sEffective)
	uYesNoCancel("Search based on which table?"; "Job Form"; "Job Items"; "Cancel")
	Case of 
		: (bAccept=1)
			QUERY:C277([Job_Forms:42])
			If (OK=1)
				
				If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
					uRelateSelect(->[Job_Forms_Items:44]JobForm:1; ->[Job_Forms:42]JobFormID:5)
					
				Else 
					
					zwStatusMsg("Relating"; " Searching "+Table name:C256(->[Job_Forms_Items:44])+" file. Please Wait...")
					RELATE MANY SELECTION:C340([Job_Forms_Items:44]JobForm:1)
					zwStatusMsg(""; "")
					
				End if   // END 4D Professional Services : January 2019 query selection
				
			End if 
			
		: (bNo=1)
			QUERY:C277([Job_Forms_Items:44])
		Else 
			ok:=0
	End case 
	
Else 
	$docRef:=Create document:C266($1)
End if 

If (OK=1)
	C_TEXT:C284($t; $cr)
	$t:=Char:C90(9)
	$cr:=Char:C90(13)
	C_TEXT:C284(xText)
	xText:=""
	C_LONGINT:C283($i; $ordQty)
	
	uSendPacket($docRef; "Job Item Valuation "+$cr+"Using MHR effective: "+sEffective+$cr+"Sales value from either pegged orderline or contract price"+$cr+$cr)
	
	uSendPacket($docRef; "Job Item"+$t+"ProductCode"+$t+"Qty_Want"+$t+"Qty_Actual"+$t+"PldCostMatl"+$t+"PldCostLab"+$t+"PldCostOvhd"+$t+"PldCostTotal"+$t+"Glued"+$t)
	uSendPacket($docRef; "EstNetSheets"+$t+"Caliper"+$t+"Width"+$t+"Length"+$t)
	uSendPacket($docRef; "Orderline"+$t+"Customer"+$t+"Line"+$t+"Price/M"+$t+"BookedCost"+$t+"Order_Qty"+$t+"SaleValue"+$t+"Contribution"+$t+"Job_PV"+$t+"Booked_PV"+$t+"Act_Contrib"+$t+"Act_PV"+$t+"Date_Glued"+$t+"SalesRep"+$cr)
	
	uThermoInit(Records in selection:C76([Job_Forms_Items:44]); "Saving Job Items to disk")
	$i:=0
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
		
		FIRST RECORD:C50([Job_Forms_Items:44])
		
		
	Else 
		
		// see line 34 | 26
		
		
	End if   // END 4D Professional Services : January 2019 First record
	// 4D Professional Services : after Order by , query or any query type you don't need First record  
	If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) Next record
		
		While (Not:C34(End selection:C36([Job_Forms_Items:44])))
			If (Length:C16(xText)>20000)
				SEND PACKET:C103($docRef; xText)
				xText:=""
			End if 
			
			$i:=$i+1
			
			uSendPacket($docRef; [Job_Forms_Items:44]JobForm:1+"."+String:C10([Job_Forms_Items:44]ItemNumber:7; "00")+$t)
			uSendPacket($docRef; [Job_Forms_Items:44]ProductCode:3+$t)
			uSendPacket($docRef; String:C10([Job_Forms_Items:44]Qty_Want:24)+$t)
			$wantQtyM:=[Job_Forms_Items:44]Qty_Want:24/1000
			uSendPacket($docRef; String:C10([Job_Forms_Items:44]Qty_Actual:11)+$t)
			uSendPacket($docRef; String:C10([Job_Forms_Items:44]PldCostMatl:17)+$t)
			uSendPacket($docRef; String:C10([Job_Forms_Items:44]PldCostLab:18)+$t)
			uSendPacket($docRef; String:C10([Job_Forms_Items:44]PldCostOvhd:19)+$t)
			uSendPacket($docRef; String:C10([Job_Forms_Items:44]PldCostTotal:21)+$t)
			
			uSendPacket($docRef; String:C10(Year of:C25([Job_Forms_Items:44]Glued:33))+String:C10(Month of:C24([Job_Forms_Items:44]Glued:33); "00")+$t)
			
			RELATE ONE:C42([Job_Forms_Items:44]JobForm:1)
			//SEND PACKET($docRef;String([JobForm]EstGrossSheets)+$t)
			uSendPacket($docRef; String:C10([Job_Forms:42]EstNetSheets:28)+$t)
			//SEND PACKET($docRef;String([JobForm]ActProducedQty)+$t)
			uSendPacket($docRef; String:C10([Job_Forms:42]Caliper:49)+$t)
			uSendPacket($docRef; String:C10([Job_Forms:42]Width:23)+$t)
			uSendPacket($docRef; String:C10([Job_Forms:42]Lenth:24)+$t)
			//SEND PACKET($docRef;String([JobForm]1stPressCount)+$t)
			//SEND PACKET($docRef;[JobForm]Run_Location+$t)
			
			uSendPacket($docRef; [Job_Forms_Items:44]OrderItem:2+$t)
			QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderLine:3=[Job_Forms_Items:44]OrderItem:2)
			If (Records in selection:C76([Customers_Order_Lines:41])=1)
				$custName:=[Customers_Order_Lines:41]CustomerName:24
				$line:=[Customers_Order_Lines:41]CustomerLine:42
				$unitPrice:=[Customers_Order_Lines:41]Price_Per_M:8
				$unitCost:=[Customers_Order_Lines:41]Cost_Per_M:7
				$ordQty:=[Customers_Order_Lines:41]Quantity:6
				$salesVal:=[Customers_Order_Lines:41]Price_Per_M:8*$wantQtyM
				$salesRep:=[Customers_Order_Lines:41]SalesRep:34
				If ($ordQty>[Job_Forms_Items:44]Qty_Want:24)  //cant sell what you aint got
					$contrib:=Round:C94(($unitPrice*$wantQtyM)-([Job_Forms_Items:44]PldCostTotal:21*$wantQtyM); 0)
					If ([Job_Forms_Items:44]FormClosed:5)
						$actContr:=Round:C94(($unitPrice*$wantQtyM)-([Job_Forms_Items:44]ActCost_M:27*$wantQtyM); 0)
						$actPV:=fProfitVariable("PV"; ([Job_Forms_Items:44]ActCost_M:27*$wantQtyM); ($unitPrice*$wantQtyM); 0)
					Else 
						$actContr:=0
						$actPV:=0
					End if 
				Else 
					$contrib:=Round:C94(($unitPrice*$wantQtyM)-([Job_Forms_Items:44]PldCostTotal:21*($wantQtyM)); 0)
					If ([Job_Forms_Items:44]FormClosed:5)
						$actContr:=Round:C94(($unitPrice*$wantQtyM)-([Job_Forms_Items:44]ActCost_M:27*$wantQtyM); 0)
						$actPV:=fProfitVariable("PV"; ([Job_Forms_Items:44]ActCost_M:27*$wantQtyM); ($unitPrice*$wantQtyM); 0)
					Else 
						$actContr:=0
						$actPV:=0
					End if 
				End if 
				$jobPV:=fProfitVariable("PV"; ([Job_Forms_Items:44]PldCostTotal:21*$wantQtyM); ($unitPrice*$wantQtyM); 0)
				$bkdPV:=fProfitVariable("PV"; ($unitCost*($ordQty/1000)); ($unitPrice*($ordQty/1000)); 0)
				
			Else 
				qryFinishedGood([Job_Forms_Items:44]CustId:15; [Job_Forms_Items:44]ProductCode:3)
				If (Records in selection:C76([Finished_Goods:26])>0) & ([Job_Forms_Items:44]OrderItem:2#"Rerun")
					$line:=[Finished_Goods:26]Line_Brand:15
					QUERY:C277([Customers:16]; [Customers:16]ID:1=[Finished_Goods:26]CustID:2)
					$custName:=[Customers:16]Name:2
					$salesRep:=[Customers:16]SalesmanID:3
					If ([Finished_Goods:26]RKContractPrice:49#0)
						$unitPrice:=[Finished_Goods:26]RKContractPrice:49
					Else 
						$unitPrice:=[Finished_Goods:26]LastPrice:27
					End if 
					
					$unitCost:=0
					$ordQty:=0
					$salesVal:=$unitPrice*$wantQtyM
					$contrib:=Round:C94(($unitPrice*$wantQtyM)-([Job_Forms_Items:44]PldCostTotal:21*$wantQtyM); 0)
					If ([Job_Forms_Items:44]FormClosed:5)
						$actContr:=Round:C94(($unitPrice*$wantQtyM)-([Job_Forms_Items:44]ActCost_M:27*$wantQtyM); 0)
						$actPV:=fProfitVariable("PV"; ([Job_Forms_Items:44]ActCost_M:27*$wantQtyM); ($unitPrice*$wantQtyM); 0)
					Else 
						$actContr:=0
						$actPV:=0
					End if 
					$jobPV:=fProfitVariable("PV"; ([Job_Forms_Items:44]PldCostTotal:21*$wantQtyM); ($unitPrice*$wantQtyM); 0)  //083198
					$bkdPV:=0
					
				Else 
					$custName:="n/f"
					$salesRep:="n/f"
					$line:="n/f"
					$unitPrice:=0
					$unitCost:=0
					$ordQty:=0
					$salesVal:=$unitPrice*$wantQtyM
					$contrib:=Round:C94(($unitPrice*$wantQtyM)-([Job_Forms_Items:44]PldCostTotal:21*$wantQtyM); 0)
					If ([Job_Forms_Items:44]FormClosed:5)
						$actContr:=Round:C94(($unitPrice*$wantQtyM)-([Job_Forms_Items:44]ActCost_M:27*$wantQtyM); 0)
						$actPV:=fProfitVariable("PV"; ([Job_Forms_Items:44]ActCost_M:27*$wantQtyM); ($unitPrice*$wantQtyM); 0)
					Else 
						$actContr:=0
						$actPV:=0
					End if 
					$jobPV:=fProfitVariable("PV"; ([Job_Forms_Items:44]PldCostTotal:21*$wantQtyM); ($unitPrice*$wantQtyM); 0)  //083198
					$bkdPV:=0
				End if 
			End if 
			
			uSendPacket($docRef; $custName+$t)
			uSendPacket($docRef; $line+$t)
			uSendPacket($docRef; String:C10($unitPrice)+$t)
			uSendPacket($docRef; String:C10($unitCost)+$t)
			uSendPacket($docRef; String:C10($ordQty)+$t)
			uSendPacket($docRef; String:C10($salesVal)+$t)
			uSendPacket($docRef; String:C10($contrib)+$t)
			uSendPacket($docRef; String:C10($jobPV)+$t)
			uSendPacket($docRef; String:C10($bkdPV)+$t)
			uSendPacket($docRef; String:C10($actContr)+$t)  //•120398  MLB  
			uSendPacket($docRef; String:C10($actPV)+$t)  //•120398  MLB  
			uSendPacket($docRef; String:C10([Job_Forms_Items:44]Glued:33; <>MIDDATE)+$t)  //mlb 100598
			uSendPacket($docRef; $salesRep+$t)  //mlb 100598
			uSendPacket($docRef; $cr)
			
			NEXT RECORD:C51([Job_Forms_Items:44])
			uThermoUpdate($i)
		End while 
		
		
	Else 
		
		ARRAY LONGINT:C221($_ItemNumber; 0)
		ARRAY TEXT:C222($_ProductCode; 0)
		ARRAY LONGINT:C221($_Qty_Want; 0)
		ARRAY LONGINT:C221($_Qty_Actual; 0)
		ARRAY REAL:C219($_PldCostMatl; 0)
		ARRAY REAL:C219($_PldCostLab; 0)
		ARRAY REAL:C219($_PldCostOvhd; 0)
		ARRAY REAL:C219($_PldCostTotal; 0)
		ARRAY DATE:C224($_Glued; 0)
		ARRAY TEXT:C222($_OrderItem; 0)
		ARRAY BOOLEAN:C223($_FormClosed; 0)
		ARRAY REAL:C219($_ActCost_M; 0)
		ARRAY TEXT:C222($_CustId; 0)
		ARRAY TEXT:C222($_JobForm; 0)
		ARRAY LONGINT:C221($_EstNetSheets; 0)
		ARRAY REAL:C219($_Caliper; 0)
		ARRAY REAL:C219($_Width; 0)
		ARRAY REAL:C219($_Lenth; 0)
		
		GET FIELD RELATION:C920([Job_Forms_Items:44]JobForm:1; $lienAller; $lienRetour)
		SET FIELD RELATION:C919([Job_Forms_Items:44]JobForm:1; Automatic:K51:4; Do not modify:K51:1)
		
		SELECTION TO ARRAY:C260([Job_Forms_Items:44]ItemNumber:7; $_ItemNumber; \
			[Job_Forms_Items:44]ProductCode:3; $_ProductCode; \
			[Job_Forms_Items:44]Qty_Want:24; $_Qty_Want; \
			[Job_Forms_Items:44]Qty_Actual:11; $_Qty_Actual; \
			[Job_Forms_Items:44]PldCostMatl:17; $_PldCostMatl; \
			[Job_Forms_Items:44]PldCostLab:18; $_PldCostLab; \
			[Job_Forms_Items:44]PldCostOvhd:19; $_PldCostOvhd; \
			[Job_Forms_Items:44]PldCostTotal:21; $_PldCostTotal; \
			[Job_Forms_Items:44]Glued:33; $_Glued; \
			[Job_Forms_Items:44]OrderItem:2; $_OrderItem; \
			[Job_Forms_Items:44]FormClosed:5; $_FormClosed; \
			[Job_Forms_Items:44]ActCost_M:27; $_ActCost_M; \
			[Job_Forms_Items:44]CustId:15; $_CustId; \
			[Job_Forms_Items:44]JobForm:1; $_JobForm; \
			[Job_Forms:42]EstNetSheets:28; $_EstNetSheets; \
			[Job_Forms:42]Caliper:49; $_Caliper; \
			[Job_Forms:42]Width:23; $_Width; \
			[Job_Forms:42]Lenth:24; $_Lenth)
		
		
		SET FIELD RELATION:C919([Job_Forms_Items:44]JobForm:1; $lienAller; $lienRetour)
		
		For ($Iter; 1; Size of array:C274($_Lenth); 1)
			If (Length:C16(xText)>20000)
				SEND PACKET:C103($docRef; xText)
				xText:=""
			End if 
			
			$i:=$i+1
			
			uSendPacket($docRef; $_JobForm{$Iter}+"."+String:C10($_ItemNumber{$Iter}; "00")+$t)
			uSendPacket($docRef; $_ProductCode{$Iter}+$t)
			uSendPacket($docRef; String:C10($_Qty_Want{$Iter})+$t)
			$wantQtyM:=$_Qty_Want{$Iter}/1000
			uSendPacket($docRef; String:C10($_Qty_Actual{$Iter})+$t)
			uSendPacket($docRef; String:C10($_PldCostMatl{$Iter})+$t)
			uSendPacket($docRef; String:C10($_PldCostLab{$Iter})+$t)
			uSendPacket($docRef; String:C10($_PldCostOvhd{$Iter})+$t)
			uSendPacket($docRef; String:C10($_PldCostTotal{$Iter})+$t)
			
			uSendPacket($docRef; String:C10(Year of:C25($_Glued{$Iter}))+String:C10(Month of:C24($_Glued{$Iter}); "00")+$t)
			
			uSendPacket($docRef; String:C10($_EstNetSheets{$Iter})+$t)
			uSendPacket($docRef; String:C10($_Caliper{$Iter})+$t)
			uSendPacket($docRef; String:C10($_Width{$Iter})+$t)
			uSendPacket($docRef; String:C10($_Lenth)+$t)
			
			uSendPacket($docRef; $_OrderItem{$Iter}+$t)
			QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderLine:3=$_OrderItem{$Iter})
			If (Records in selection:C76([Customers_Order_Lines:41])=1)
				$custName:=[Customers_Order_Lines:41]CustomerName:24
				$line:=[Customers_Order_Lines:41]CustomerLine:42
				$unitPrice:=[Customers_Order_Lines:41]Price_Per_M:8
				$unitCost:=[Customers_Order_Lines:41]Cost_Per_M:7
				$ordQty:=[Customers_Order_Lines:41]Quantity:6
				$salesVal:=[Customers_Order_Lines:41]Price_Per_M:8*$wantQtyM
				$salesRep:=[Customers_Order_Lines:41]SalesRep:34
				If ($ordQty>$_Qty_Want{$Iter})  //cant sell what you aint got
					$contrib:=Round:C94(($unitPrice*$wantQtyM)-($_PldCostTotal{$Iter}*$wantQtyM); 0)
					If ($_FormClosed{$Iter})
						$actContr:=Round:C94(($unitPrice*$wantQtyM)-($_ActCost_M{$Iter}*$wantQtyM); 0)
						$actPV:=fProfitVariable("PV"; ($_ActCost_M{$Iter}*$wantQtyM); ($unitPrice*$wantQtyM); 0)
					Else 
						$actContr:=0
						$actPV:=0
					End if 
				Else 
					$contrib:=Round:C94(($unitPrice*$wantQtyM)-($_PldCostTotal{$Iter}*($wantQtyM)); 0)
					If ($_FormClosed{$Iter})
						$actContr:=Round:C94(($unitPrice*$wantQtyM)-($_ActCost_M{$Iter}*$wantQtyM); 0)
						$actPV:=fProfitVariable("PV"; ($_ActCost_M{$Iter}*$wantQtyM); ($unitPrice*$wantQtyM); 0)
					Else 
						$actContr:=0
						$actPV:=0
					End if 
				End if 
				$jobPV:=fProfitVariable("PV"; ($_PldCostTotal{$Iter}*$wantQtyM); ($unitPrice*$wantQtyM); 0)
				$bkdPV:=fProfitVariable("PV"; ($unitCost*($ordQty/1000)); ($unitPrice*($ordQty/1000)); 0)
				
			Else 
				qryFinishedGood($_CustId{$Iter}; $_ProductCode{$Iter})
				If (Records in selection:C76([Finished_Goods:26])>0) & ($_OrderItem{$Iter}#"Rerun")
					$line:=[Finished_Goods:26]Line_Brand:15
					QUERY:C277([Customers:16]; [Customers:16]ID:1=[Finished_Goods:26]CustID:2)
					$custName:=[Customers:16]Name:2
					$salesRep:=[Customers:16]SalesmanID:3
					If ([Finished_Goods:26]RKContractPrice:49#0)
						$unitPrice:=[Finished_Goods:26]RKContractPrice:49
					Else 
						$unitPrice:=[Finished_Goods:26]LastPrice:27
					End if 
					
					$unitCost:=0
					$ordQty:=0
					$salesVal:=$unitPrice*$wantQtyM
					$contrib:=Round:C94(($unitPrice*$wantQtyM)-($_PldCostTotal{$Iter}*$wantQtyM); 0)
					If ($_FormClosed{$Iter})
						$actContr:=Round:C94(($unitPrice*$wantQtyM)-($_ActCost_M{$Iter}*$wantQtyM); 0)
						$actPV:=fProfitVariable("PV"; ($_ActCost_M{$Iter}*$wantQtyM); ($unitPrice*$wantQtyM); 0)
					Else 
						$actContr:=0
						$actPV:=0
					End if 
					$jobPV:=fProfitVariable("PV"; ($_PldCostTotal{$Iter}*$wantQtyM); ($unitPrice*$wantQtyM); 0)  //083198
					$bkdPV:=0
					
				Else 
					$custName:="n/f"
					$salesRep:="n/f"
					$line:="n/f"
					$unitPrice:=0
					$unitCost:=0
					$ordQty:=0
					$salesVal:=$unitPrice*$wantQtyM
					$contrib:=Round:C94(($unitPrice*$wantQtyM)-($_PldCostTotal{$Iter}*$wantQtyM); 0)
					If ($_FormClosed{$Iter})
						$actContr:=Round:C94(($unitPrice*$wantQtyM)-($_ActCost_M{$Iter}*$wantQtyM); 0)
						$actPV:=fProfitVariable("PV"; ($_ActCost_M{$Iter}*$wantQtyM); ($unitPrice*$wantQtyM); 0)
					Else 
						$actContr:=0
						$actPV:=0
					End if 
					$jobPV:=fProfitVariable("PV"; ($_PldCostTotal{$Iter}*$wantQtyM); ($unitPrice*$wantQtyM); 0)  //083198
					$bkdPV:=0
				End if 
			End if 
			
			uSendPacket($docRef; $custName+$t)
			uSendPacket($docRef; $line+$t)
			uSendPacket($docRef; String:C10($unitPrice)+$t)
			uSendPacket($docRef; String:C10($unitCost)+$t)
			uSendPacket($docRef; String:C10($ordQty)+$t)
			uSendPacket($docRef; String:C10($salesVal)+$t)
			uSendPacket($docRef; String:C10($contrib)+$t)
			uSendPacket($docRef; String:C10($jobPV)+$t)
			uSendPacket($docRef; String:C10($bkdPV)+$t)
			uSendPacket($docRef; String:C10($actContr)+$t)  //•120398  MLB  
			uSendPacket($docRef; String:C10($actPV)+$t)  //•120398  MLB  
			uSendPacket($docRef; String:C10($_Glued{$Iter}; <>MIDDATE)+$t)  //mlb 100598
			uSendPacket($docRef; $salesRep+$t)  //mlb 100598
			uSendPacket($docRef; $cr)
			
			uThermoUpdate($i)
		End for 
		
		
	End if   // END 4D Professional Services : January 2019 
	SEND PACKET:C103($docRef; xText)
	uThermoClose
	xText:=""
	CLOSE DOCUMENT:C267($docRef)
	BEEP:C151
	ALERT:C41("Data stored in file named: "+Document)
	// obsolete call, method deleted 4/28/20 uDocumentSetType 
	$err:=util_Launch_External_App(Document)
End if 