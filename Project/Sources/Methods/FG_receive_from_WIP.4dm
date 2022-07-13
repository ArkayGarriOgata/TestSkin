//%attributes = {"publishedWeb":true}
// Method: FG_receive_from_WIP
//(WAS) uFGreceive..
//9/30/94
//5/4/95
//•080395  MLB  UPR 1490 add jobit
//•051796  MLB  make sure that JMI record is not locked, moved somethings around
//•032097  MLB  permit batch mode
//•101398  MLB  UPR subforms problem, distribute input qty over all the sub
//•111599  mlb JIC maintenance see JIC_RemainingAddTo
//•2/03/00  mlb  JIC_RemainingAddTo moved to fg–x trigger
// • mel (8/11/04, 15:59:11) skid based 
// • mel (8/19/04, 15:59:11) skid based negative adjustments
C_LONGINT:C283($1; wms_number_cases)
C_BOOLEAN:C305($batch; $successful_transaction; $0; fromWMS)
If (Count parameters:C259=1)
	$batch:=True:C214
Else 
	$batch:=False:C215
End if 

If (sCriterion3="WMS")
	fromWMS:=True:C214
	sCriterion3:="WiP"
Else 
	fromWMS:=False:C215
End if 

C_LONGINT:C283($numFGs; $numSubforms)
C_BOOLEAN:C305($continue; $unique_skid_number; $existing_skid_number; $last_receipt_this_job; $fg_not_found; $jobit_not_found)
$receipt:=False:C215
$reverse:=False:C215
$fg_locked:=False:C215
$fg_not_found:=False:C215
$unique_skid_number:=False:C215
$existing_skid_number:=False:C215
$jobit_not_found:=False:C215

<>USE_SUBCOMPONENT:=True:C214
$hit:=Find in array:C230(aAssemblyJobs; sCriterion5)
If ($hit>-1)
	$backflush:=True:C214
Else 
	$backflush:=False:C215
End if 

$last_receipt_this_job:=(bLastSkid2=1)
C_DATE:C307($xactionDate)
If (fromWMS)
	$xactionDate:=dDate
	$xactionTime:=tTime
Else 
	$xactionDate:=4D_Current_date
	$xactionTime:=4d_Current_time
End if 
C_TEXT:C284($jobit)
$jobit:=JMI_makeJobIt(sCriterion5; i1)
C_TEXT:C284($fgKey)
$fgKey:=sCriterion2+":"+sCriterion1
C_TEXT:C284($skid_number)
$skid_number:=sCriter10
C_LONGINT:C283($qty; $openQty; $actualQty)
$qty:=rReal1  //$qty is a working copy and will be changed by this method

If ($qty>0)  //=0 shouldn't get past dialog validation
	$receipt:=True:C214
	$unique_skid_number:=(Not:C34(wms_itemExists($skid_number)))
Else 
	$reverse:=True:C214
	$existing_skid_number:=wms_itemExists($skid_number)
End if 

$successful_transaction:=True:C214  //be optimistic
START TRANSACTION:C239

$numFGs:=qryFinishedGood("#KEY"; $fgKey)
If ($numFGs>0)
	If (fLockNLoad(->[Finished_Goods:26]))
		[Finished_Goods:26]LastJobNo:16:=Substring:C12($jobit; 1; 8)
		[Finished_Goods:26]LastRecdDate:17:=$xactionDate
		SAVE RECORD:C53([Finished_Goods:26])
	Else 
		$fg_locked:=True:C214
		$reverse:=False:C215
		$receipt:=False:C215
	End if 
Else 
	$fg_not_found:=True:C214
	$reverse:=False:C215
	$receipt:=False:C215
End if 

$numSubforms:=qryJMI($jobit)
If ($numSubforms>0)
	RELATE ONE:C42([Job_Forms_Items:44]OrderItem:2)  //job may have cpns from diff customers
	RELATE ONE:C42([Customers_Order_Lines:41]OrderNumber:1)  //therefore, traverse back through the order
Else 
	$jobit_not_found:=True:C214
	$reverse:=False:C215
	$receipt:=False:C215
End if 

Case of   //perform jobit update
	: ($receipt)
		If ($unique_skid_number)
			ORDER BY:C49([Job_Forms_Items:44]; [Job_Forms_Items:44]SubFormNumber:32; >)  //FIFO
			While (Not:C34(End selection:C36([Job_Forms_Items:44])))  //may only be one
				If (fLockNLoad(->[Job_Forms_Items:44]))
					If ([Job_Forms_Items:44]Glued:33=!00-00-00!)
						[Job_Forms_Items:44]Glued:33:=$xactionDate
						[Job_Forms_Items:44]CasePackUsed:45:=PK_getCaseCount([Job_Forms_Items:44]OutlineNumber:43)
					End if 
					
					If ($last_receipt_this_job)
						[Job_Forms_Items:44]Completed:39:=$xactionDate
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
					
				Else 
					uConfirm("Job Item Locked, try again later."; "Try Again"; "Cancel")
					$successful_transaction:=False:C215
					LAST RECORD:C200([Job_Forms_Items:44])  //break out of the loop
				End if   //locked
				
				NEXT RECORD:C51([Job_Forms_Items:44])
			End while 
			FIRST RECORD:C50([Job_Forms_Items:44])
			
		Else 
			uConfirm("The Skid number your entered is not unique."; "Try Again"; "Cancel")
			$successful_transaction:=False:C215
		End if 
		
	: ($reverse)
		If ($existing_skid_number)
			ORDER BY:C49([Job_Forms_Items:44]; [Job_Forms_Items:44]SubFormNumber:32; <)  //LIFO
			While (Not:C34(End selection:C36([Job_Forms_Items:44])))  //may only be one
				If (fLockNLoad(->[Job_Forms_Items:44]))
					If ([Job_Forms_Items:44]Glued:33=!00-00-00!)
						[Job_Forms_Items:44]Glued:33:=$xactionDate
						[Job_Forms_Items:44]CasePackUsed:45:=PK_getCaseCount([Job_Forms_Items:44]OutlineNumber:43)
					End if 
					
					If ($last_receipt_this_job)
						[Job_Forms_Items:44]Completed:39:=$xactionDate
					End if 
					
					$actualQty:=[Job_Forms_Items:44]Qty_Actual:11
					Case of 
						: ($numSubforms=Selected record number:C246([Job_Forms_Items:44]))  //dump it all on the last or only
							[Job_Forms_Items:44]Qty_Actual:11:=[Job_Forms_Items:44]Qty_Actual:11+$qty
							$qty:=0
						: ($actualQty=0)  //met yield, skip
							//skip
						: ((Abs:C99($qty))<=$actualQty)  //it all fits
							[Job_Forms_Items:44]Qty_Actual:11:=[Job_Forms_Items:44]Qty_Actual:11+$qty
							$qty:=0
							
						: ((Abs:C99($qty))>$actualQty)  //fill the remainder
							[Job_Forms_Items:44]Qty_Actual:11:=0
							$qty:=$qty+$actualQty  //carry the qty to the next jobit
							
					End case 
					
					If ([Job_Forms_Items:44]Qty_Good:10>[Job_Forms_Items:44]Qty_Actual:11)
						[Job_Forms_Items:44]Qty_Good:10:=[Job_Forms_Items:44]Qty_Actual:11
					End if 
					
					If ([Job_Forms_Items:44]Qty_Actual:11=0)
						[Job_Forms_Items:44]Completed:39:=!00-00-00!
						[Job_Forms_Items:44]Glued:33:=!00-00-00!
					End if 
					
					SAVE RECORD:C53([Job_Forms_Items:44])
					
					If ($qty=0)  //no reason to continue
						LAST RECORD:C200([Job_Forms_Items:44])  //break out of the loop
					End if 
					
				Else 
					uConfirm("Job Item Locked, try again later."; "Try Again"; "Cancel")
					$successful_transaction:=False:C215
					LAST RECORD:C200([Job_Forms_Items:44])  //break out of the loop
				End if   //locked
				
				NEXT RECORD:C51([Job_Forms_Items:44])
			End while 
			FIRST RECORD:C50([Job_Forms_Items:44])
			
		Else 
			uConfirm("The Skid number your entered does not exist. Can't reverse the Receipt."; "Try Again"; "Cancel")
			$successful_transaction:=False:C215
		End if 
		
	: ($fg_not_found)
		uConfirm("Could not find F/G "+$fgKey; "Try Again"; "Cancel")
		$successful_transaction:=False:C215
		
	: ($jobit_not_found)
		uConfirm("Could not find Jobit "+$jobit; "Try Again"; "Cancel")
		$successful_transaction:=False:C215
	: ($fg_locked)
		uConfirm("F/G Record was locked "+$fgKey; "Try Again"; "Cancel")
		$successful_transaction:=False:C215
	Else   //other problem found
		uConfirm("Could not complete this transaction."; "Try Again"; "Cancel")
		$successful_transaction:=False:C215  //
End case 

//search for TO bin
$numFGL:=FGL_qryBin($jobit; sCriterion4; $skid_number)
If ($numFGL=0)
	FG_makeLocation
Else 
	If (Not:C34(fLockNLoad(->[Finished_Goods_Locations:35])))  //locked, can't continue
		$successful_transaction:=False:C215
	End if 
End if 

If ($successful_transaction)
	[Finished_Goods_Locations:35]QtyOH:9:=[Finished_Goods_Locations:35]QtyOH:9+rReal1
	If ([Finished_Goods_Locations:35]QtyOH:9#0)
		[Finished_Goods_Locations:35]ModDate:21:=$xactionDate
		[Finished_Goods_Locations:35]ModWho:22:=<>zResp
		SAVE RECORD:C53([Finished_Goods_Locations:35])
		UNLOAD RECORD:C212([Finished_Goods_Locations:35])
	Else 
		If (Not:C34([Finished_Goods_Locations:35]PiDoNotDelete:29))
			DELETE RECORD:C58([Finished_Goods_Locations:35])
		End if 
	End if 
	
	//next create transfer IN record
	FGX_post_transaction($xactionDate; 1; "Receipt"; $xactionTime)
	
	If (wms_itemExists($skid_number))
		[WMS_ItemMasters:123]QTY:7:=[WMS_ItemMasters:123]QTY:7+rReal1
		If ([WMS_ItemMasters:123]QTY:7=0)
			DELETE RECORD:C58([WMS_ItemMasters:123])
		Else 
			SAVE RECORD:C53([WMS_ItemMasters:123])
			UNLOAD RECORD:C212([WMS_ItemMasters:123])
		End if 
		
	Else 
		If ($receipt) & Not:C34(fromWMS)
			WMS_newItem($skid_number; sCriterion1; $jobit; rReal1; $xactionDate; sCriterion4; sCriterion2)
		End if 
	End if 
	
End if   //continue

If ($successful_transaction)
	VALIDATE TRANSACTION:C240
	$0:=True:C214
	//wms_api_SendJobits` Modified by: Mel Bohince (10/3/13) 
	If ($backflush)
		//need to set [Job_Forms_Materials]Actual_Qty and [Job_Forms_Materials]Actual_Price
		//and relieve inventory of components
		QUERY:C277([Job_Forms_Materials:55]; [Job_Forms_Materials:55]JobForm:1=sCriterion5; *)
		QUERY:C277([Job_Forms_Materials:55];  & ; [Job_Forms_Materials:55]Real2:18=i1; *)  //item used in
		QUERY:C277([Job_Forms_Materials:55];  & ; [Job_Forms_Materials:55]Commodity_Key:12="33@")
		C_LONGINT:C283($i; $numRecs)
		C_BOOLEAN:C305($break)
		$break:=False:C215
		$numRecs:=Records in selection:C76([Job_Forms_Materials:55])
		$number_of_assemblies:=rReal1
		For ($i; 1; $numRecs)
			If ($break)
				$i:=$i+$numRecs
			End if 
			$usage:=$number_of_assemblies*[Job_Forms_Materials:55]Real1:17  //number of parents received times usage per assembly
			[Job_Forms_Materials:55]Actual_Qty:14:=[Job_Forms_Materials:55]Actual_Qty:14+$usage
			//fifo out the qty leaving transactions in the wake
			[Job_Forms_Materials:55]Actual_Price:15:=[Job_Forms_Materials:55]Actual_Price:15+Job_price_component([Job_Forms_Materials:55]Raw_Matl_Code:7; "inventoried"; $usage; [Job_Forms_Materials:55]JobForm:1)
			SAVE RECORD:C53([Job_Forms_Materials:55])
			NEXT RECORD:C51([Job_Forms_Materials:55])
		End for 
		
	End if 
Else 
	CANCEL TRANSACTION:C241
	$0:=False:C215
End if 

UNLOAD RECORD:C212([Finished_Goods:26])
UNLOAD RECORD:C212([Job_Forms_Items:44])

