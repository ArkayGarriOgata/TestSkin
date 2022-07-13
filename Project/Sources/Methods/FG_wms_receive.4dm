//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 10/22/08, 09:17:42
// ----------------------------------------------------
// Method: FG_wms_receive
// Description
// based on FG_receive_from_WIP but avoid locking problems
//  Modified by: Mel Bohince (5/5/14) make a machineticket
// Parameters
// ----------------------------------------------------

C_POINTER:C301($1)
sCriterion3:="WiP"  // passed as a pointer just to show that it will be changed from the NULL that was sent for the "From" location

C_LONGINT:C283($numFGs; $numSubforms; $qty; $openQty; $actualQty)
C_BOOLEAN:C305($successful_transaction; $0; $fg_not_found; $fg_locked; $jobit_not_found; $jobit_locked; $bin_locked; $qtyNotPositive)
$successful_transaction:=True:C214  //be optimistic
$fg_locked:=False:C215
$fg_not_found:=False:C215
$jobit_not_found:=False:C215
$jobit_locked:=False:C215
$bin_locked:=False:C215
$qtyNotPositive:=False:C215

C_DATE:C307($xactionDate)
$xactionDate:=dDate
$xactionTime:=tTime

C_TEXT:C284($jobit)
$jobit:=JMI_makeJobIt(sCriterion5; i1)

C_TEXT:C284($fgKey)
$fgKey:=sCriterion2+":"+sCriterion1

C_TEXT:C284($skid_number)
$skid_number:=sCriter10

If (rReal1>0)
	$qty:=rReal1  //$qty is a working copy and will be changed by this method
Else 
	$qtyNotPositive:=True:C214
	$successful_transaction:=False:C215
End if 

READ WRITE:C146([Finished_Goods:26])
READ WRITE:C146([Job_Forms_Items:44])
READ WRITE:C146([Finished_Goods_Locations:35])
READ ONLY:C145([Customers_Order_Lines:41])
READ ONLY:C145([Customers_Orders:40])

//avoiding a START TRANSACTION, so test for finds and locks first
$numFGs:=qryFinishedGood("#KEY"; $fgKey)
If ($numFGs>0)
	If (Locked:C147([Finished_Goods:26]))
		$fg_locked:=True:C214
		$successful_transaction:=False:C215
	End if 
Else 
	$fg_not_found:=True:C214
	$successful_transaction:=False:C215
End if 

$numSubforms:=qryJMI($jobit)
If ($numSubforms>0)
	For ($i; 1; $numSubforms)
		If (Locked:C147([Job_Forms_Items:44]))  //if more than one subform, one may still be locked
			$jobit_locked:=True:C214
			$successful_transaction:=False:C215
		End if 
		NEXT RECORD:C51([Job_Forms_Items:44])
	End for 
	FIRST RECORD:C50([Job_Forms_Items:44])
	
Else 
	$jobit_not_found:=True:C214
	$successful_transaction:=False:C215
End if 

//search for TO bin
$numFGL:=FGL_qryBin($jobit; sCriterion4; $skid_number)
If ($numFGL=0) & (rReal1>0)
	FG_makeLocation
	
Else 
	If (Locked:C147([Finished_Goods_Locations:35]))  //locked, can't continue
		$bin_locked:=True:C214
		$successful_transaction:=False:C215
	End if 
End if 

Case of   //perform jobit update
	: ($successful_transaction)
		[Finished_Goods:26]LastJobNo:16:=Substring:C12($jobit; 1; 8)
		[Finished_Goods:26]LastRecdDate:17:=$xactionDate
		SAVE RECORD:C53([Finished_Goods:26])
		
		[Finished_Goods_Locations:35]QtyOH:9:=[Finished_Goods_Locations:35]QtyOH:9+rReal1
		If ([Finished_Goods_Locations:35]QtyOH:9#0)
			[Finished_Goods_Locations:35]ModDate:21:=$xactionDate
			[Finished_Goods_Locations:35]ModWho:22:=<>zResp
			[Finished_Goods_Locations:35]Cases:24:=[Finished_Goods_Locations:35]Cases:24+wms_number_cases
			SAVE RECORD:C53([Finished_Goods_Locations:35])
		Else 
			If (Not:C34([Finished_Goods_Locations:35]PiDoNotDelete:29))
				DELETE RECORD:C58([Finished_Goods_Locations:35])
			End if 
		End if 
		
		RELATE ONE:C42([Job_Forms_Items:44]OrderItem:2)  //job may have cpns from diff customers
		RELATE ONE:C42([Customers_Order_Lines:41]OrderNumber:1)  //therefore, traverse back through the order
		
		ORDER BY:C49([Job_Forms_Items:44]; [Job_Forms_Items:44]SubFormNumber:32; >)  //FIFO
		While (Not:C34(End selection:C36([Job_Forms_Items:44])))  //may only be one
			If (Not:C34(Locked:C147([Job_Forms_Items:44])))
				If ([Job_Forms_Items:44]Glued:33=!00-00-00!)
					[Job_Forms_Items:44]Glued:33:=$xactionDate
					[Job_Forms_Items:44]CasePackUsed:45:=PK_getCaseCount([Job_Forms_Items:44]OutlineNumber:43)
				End if 
				
				$openQty:=[Job_Forms_Items:44]Qty_Yield:9-[Job_Forms_Items:44]Qty_Actual:11
				Case of 
					: ($numSubforms=Selected record number:C246([Job_Forms_Items:44]))  //dump it all on the last or only
						[Job_Forms_Items:44]Qty_Actual:11:=[Job_Forms_Items:44]Qty_Actual:11+$qty
						$qty:=0
						
					: ($openQty<=0)  //met yield, skip
						//skip
					: ($qty<=$openQty)  //it all fits
						[Job_Forms_Items:44]Qty_Actual:11:=[Job_Forms_Items:44]Qty_Actual:11+$qty
						$qty:=0
						
					: ($qty>$openQty)  //fill the remainder
						[Job_Forms_Items:44]Qty_Actual:11:=[Job_Forms_Items:44]Qty_Actual:11+$openQty
						$qty:=$qty-$openQty  //carry the qty to the next jobit
						
				End case 
				SAVE RECORD:C53([Job_Forms_Items:44])
				
				If ($qty=0)  //no reason to continue
					LAST RECORD:C200([Job_Forms_Items:44])  //break out of the loop
				End if 
			End if   //locked
			
			NEXT RECORD:C51([Job_Forms_Items:44])
		End while 
		FIRST RECORD:C50([Job_Forms_Items:44])
		
		//next create transfer IN record
		FGX_post_transaction($xactionDate; 1; "Receipt"; $xactionTime)
		
		If (<>MTfromScan)  // Modified by: Mel Bohince (5/6/14) 
			iSeq:=Job_getGlueSequence(sCriterion5)  // Modified by: Mel Bohince (5/5/14) make a machineticket
			If (iSeq>0)
				//QUERY([Job_Forms_Machine_Tickets];[Job_Forms_Machine_Tickets]Jobit=$jobit;*)
				//QUERY([Job_Forms_Machine_Tickets]; & ;[Job_Forms_Machine_Tickets]DateEntered=$xactionDate)
				//If(Records in selection([Job_Forms_Machine_Tickets])=0) | (locked([Job_Forms_Machine_Tickets]))
				
				CREATE RECORD:C68([Job_Forms_Machine_Tickets:61])
				[Job_Forms_Machine_Tickets:61]JobForm:1:=sCriterion5
				[Job_Forms_Machine_Tickets:61]Sequence:3:=iSeq
				If (Position:C15([Job_Forms_Items:44]Gluer:47; <>GLUERS)>0)
					[Job_Forms_Machine_Tickets:61]CostCenterID:2:=[Job_Forms_Items:44]Gluer:47
				Else 
					[Job_Forms_Machine_Tickets:61]CostCenterID:2:=""
				End if 
				[Job_Forms_Machine_Tickets:61]DateEntered:5:=$xactionDate
				[Job_Forms_Machine_Tickets:61]Shift:18:=SF_GetShift(TSTimeStamp($xactionDate; $xactionTime))
				[Job_Forms_Machine_Tickets:61]GlueMachItemNo:4:=i1
				[Job_Forms_Machine_Tickets:61]Reference_id:22:=sCriter10
				[Job_Forms_Machine_Tickets:61]TimeStampEntered:17:=TSTimeStamp
				//end if
				[Job_Forms_Machine_Tickets:61]Good_Units:8:=rReal1  //[Job_Forms_Machine_Tickets]Good_Units+
				SAVE RECORD:C53([Job_Forms_Machine_Tickets:61])
				If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) REDUCE SELECTION
					
					UNLOAD RECORD:C212([Job_Forms_Machine_Tickets:61])
					REDUCE SELECTION:C351([Job_Forms_Machine_Tickets:61]; 0)
					
				Else 
					
					REDUCE SELECTION:C351([Job_Forms_Machine_Tickets:61]; 0)
					
				End if   // END 4D Professional Services : January 2019 
				
			End if 
		End if 
		
	: ($fg_not_found)
		utl_Logfile("wms_api.log"; String:C10([WMS_aMs_Exports:153]id:1)+": "+"Could not find F/G "+$fgKey)
	: ($jobit_not_found)
		utl_Logfile("wms_api.log"; String:C10([WMS_aMs_Exports:153]id:1)+": "+"Could not find Jobit "+$jobit)
	: ($jobit_locked)
		utl_Logfile("wms_api.log"; String:C10([WMS_aMs_Exports:153]id:1)+": "+"Jobit Record was locked "+$jobit)
	: ($fg_locked)
		utl_Logfile("wms_api.log"; String:C10([WMS_aMs_Exports:153]id:1)+": "+"F/G Record was locked "+$fgKey)
	: ($bin_locked)
		utl_Logfile("wms_api.log"; String:C10([WMS_aMs_Exports:153]id:1)+": "+"F/G Location Record was locked "+$jobit+":"+sCriterion4)
	: ($qtyNotPositive)
		utl_Logfile("wms_api.log"; String:C10([WMS_aMs_Exports:153]id:1)+": "+"Quantity was not positive")
	Else   //other problem found
		utl_Logfile("wms_api.log"; String:C10([WMS_aMs_Exports:153]id:1)+": "+"Could not complete this transaction.")
End case 
If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) REDUCE SELECTION
	
	UNLOAD RECORD:C212([Finished_Goods:26])
	UNLOAD RECORD:C212([Job_Forms_Items:44])
	UNLOAD RECORD:C212([Finished_Goods_Locations:35])
	UNLOAD RECORD:C212([Customers_Order_Lines:41])
	UNLOAD RECORD:C212([Customers_Orders:40])
	
	REDUCE SELECTION:C351([Finished_Goods:26]; 0)
	REDUCE SELECTION:C351([Job_Forms_Items:44]; 0)
	REDUCE SELECTION:C351([Finished_Goods_Locations:35]; 0)
	REDUCE SELECTION:C351([Customers_Order_Lines:41]; 0)
	REDUCE SELECTION:C351([Customers_Orders:40]; 0)
	
Else 
	
	REDUCE SELECTION:C351([Finished_Goods:26]; 0)
	REDUCE SELECTION:C351([Job_Forms_Items:44]; 0)
	REDUCE SELECTION:C351([Finished_Goods_Locations:35]; 0)
	REDUCE SELECTION:C351([Customers_Order_Lines:41]; 0)
	REDUCE SELECTION:C351([Customers_Orders:40]; 0)
	
End if   // END 4D Professional Services : January 2019 

$0:=$successful_transaction
