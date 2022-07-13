//%attributes = {}

// Method: FG_Receive_via_SSCC ( )  -> 
// ----------------------------------------------------
// Author: Mel Bohince
// Created: 10/23/13, 11:59:09
// ----------------------------------------------------
// Description
// based on FG_receive_from_WIP & FG_wms_receive, this creates an fg receipt  
//    based on info provided in the SSCC label printing
//
// ----------------------------------------------------

READ WRITE:C146([Finished_Goods:26])
READ WRITE:C146([Job_Forms_Items:44])
READ WRITE:C146([Finished_Goods_Locations:35])
READ ONLY:C145([Customers_Order_Lines:41])
READ ONLY:C145([Customers_Orders:40])

C_LONGINT:C283($numFGs; $numSubforms; $qty; $openQty; $actualQty)

sCriter12:=""  //release
bLastSkid2:=0  //still need to do this with the Receive dialog manually

sCriter10:=[WMS_SerializedShippingLabels:96]HumanReadable:5
rReal1:=[WMS_SerializedShippingLabels:96]Quantity:4
wms_number_cases:=[WMS_aMs_Exports:153]number_of_cases:16

sJobit:=[WMS_SerializedShippingLabels:96]Jobit:3  //put the periods back in
sCriterion5:=Substring:C12(sJobit; 1; 8)
i1:=Num:C11(Substring:C12(sJobit; 10; 2))
$numSubforms:=qryJMI(sJobit)

sCriterion1:=[Job_Forms_Items:44]ProductCode:3
sCriterion2:=[Job_Forms_Items:44]CustId:15
sCriterion3:="WIP"  //from
sCriterion4:="CC:R"  //to
sCriterion6:=[Job_Forms_Items:44]OrderItem:2

sCriterion8:="SSCC PRINTED"  //actiontaken
sCriterion9:=""  //reason
sCriterion7:=""  //reasonNotes

sCriter11:=<>zResp
dDate:=4D_Current_date
tTime:=4d_Current_time



C_BOOLEAN:C305($successful_transaction; $0; $fg_not_found; $fg_locked; $jobit_not_found; $jobit_locked; $bin_locked; $qtyNotPositive)
$successful_transaction:=True:C214  //be optimistic
$fg_locked:=False:C215
$fg_not_found:=False:C215
$jobit_not_found:=False:C215
$jobit_locked:=False:C215
$bin_locked:=False:C215
$qtyNotPositive:=False:C215

C_TEXT:C284($fgKey)
$fgKey:=sCriterion2+":"+sCriterion1


If (rReal1>0)
	$qty:=rReal1  //$qty is a working copy and will be changed by this method
Else 
	$qtyNotPositive:=True:C214
	$successful_transaction:=False:C215
End if 

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
$numFGL:=FGL_qryBin(sJobit; sCriterion4; sCriter10)
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
		[Finished_Goods:26]LastJobNo:16:=Substring:C12(sJobit; 1; 8)
		[Finished_Goods:26]LastRecdDate:17:=dDate
		SAVE RECORD:C53([Finished_Goods:26])
		
		[Finished_Goods_Locations:35]QtyOH:9:=[Finished_Goods_Locations:35]QtyOH:9+rReal1
		If ([Finished_Goods_Locations:35]QtyOH:9#0)
			[Finished_Goods_Locations:35]ModDate:21:=dDate
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
					[Job_Forms_Items:44]Glued:33:=dDate
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
		FGX_post_transaction(dDate; 1; "Receipt"; tTime)
		
		//display problems
		If ($fg_not_found)
			uConfirm("FG Receipt failed, do it manually"+": "+"Could not find F/G "+$fgKey)
		End if 
		If ($jobit_not_found)
			uConfirm("FG Receipt failed, do it manually"+": "+"Could not find Jobit "+sJobit)
		End if 
		If ($jobit_locked)
			uConfirm("FG Receipt failed, do it manually"+": "+"Jobit Record was locked "+$jobit)
		End if 
		If ($fg_locked)
			uConfirm("FG Receipt failed, do it manually"+": "+"F/G Record was locked "+$fgKey)
		End if 
		If ($bin_locked)
			uConfirm("FG Receipt failed, do it manually"+": "+"F/G Location Record was locked "+$jobit+":"+sCriterion4)
		End if 
		If ($bin_locked)
			uConfirm("FG Receipt failed, do it manually"+": "+"Quantity was not positive")
		End if 
		If (Not:C34($successful_transaction))  //other problem found
			uConfirm("FG Receipt failed, do it manually"+": "+"Could not complete this transaction.")
		End if 
		
End case 


$0:=$successful_transaction
