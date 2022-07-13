//%attributes = {}
// -------
// Method: Loreal_DeliverySchedule   ( ) ->
// By: Mel Bohince @ 08/31/16, 11:35:50
// Description
// 
// ----------------------------------------------------
// Modified by: Mel Bohince (3/24/17) manditory column headings, add planning fence

READ WRITE:C146([Finished_Goods_DeliveryForcasts:145])
READ ONLY:C145([Customers_ReleaseSchedules:46])
READ WRITE:C146([Finished_Goods:26])
C_TEXT:C284($line; $columnHeaders)
C_TEXT:C284(COMPARE_CUSTID; $priorAsOf)
C_TIME:C306($docRef)
C_DATE:C307($version; $planningFence)
C_TEXT:C284($period)  //fYYYYMM
C_BOOLEAN:C305($continue; $make_release)
C_TEXT:C284($currentCPN)
C_TEXT:C284($t; $r)

$columnHeaders:="MRPCn\tVendor#\tVendor Name\tMaterial #\tPO #\tMaterial Description\tDeliv. date\tRequested Qty\tMonth"
COMPARE_CUSTID:="00765"
$version:=4D_Current_date
$t:="\t"
$r:="\r"
$eol:="\r"
$quit:=True:C214
$PnG_Plant:="LOREAL"
$make_release:=False:C215
$continue:=True:C214

SET MENU BAR:C67(<>DefaultMenu)
$planningFence:=Add to date:C393(Current date:C33; 0; 3; 0)
$planningFence:=Date:C102(Request:C163("Include forecasts out to: "; String:C10($planningFence; Internal date short special:K1:4); "Ok"; "Cancel"))
If (ok=1) & ($planningFence>Current date:C33)
	
	Repeat 
		$docRef:=Open document:C264("")
		If ($docRef#?00:00:00?)
			//check if the column headers look rite
			RECEIVE PACKET:C104($docRef; $line; $eol)  //this should be the column headings
			util_TextParser(9; $line; Character code:C91($t); Character code:C91($r))
			$delivery_date_header:=util_TextParser(1)
			If (Position:C15("MRPCn"; $delivery_date_header)>0)  //looks like a header
				$continue:=True:C214
				$ib_delv_qty_col:=util_TextParser(8)
				If (Position:C15("Requested"; $ib_delv_qty_col)>0)  //Requested Qty 
					$delivery_qty_col:=8
				Else 
					$delivery_qty_col:=8
				End if 
				
			Else 
				$continue:=False:C215
				ALERT:C41("The import text needs column headings, like MRPCn Vendor# Vendor Name ...")  // Modified by: Mel Bohince (3/23/17) 
			End if 
			
			If ($continue)  //header are good
				//offer to delete prior import
				QUERY:C277([Finished_Goods_DeliveryForcasts:145]; [Finished_Goods_DeliveryForcasts:145]Custid:12=COMPARE_CUSTID)
				If (Records in selection:C76([Finished_Goods_DeliveryForcasts:145])>0)
					$priorAsOf:=[Finished_Goods_DeliveryForcasts:145]asOf:9
					
					uConfirm("Clear a prior import for cust "+COMPARE_CUSTID+" "+$priorAsOf+"?"; "Delete"; "Leave")
					If (ok=1)  //clear prior imports
						$asOfRef:=Request:C163("What is the AsOf reference?"; $priorAsOf; "Ok"; "Abort")
						If (ok=1)
							READ WRITE:C146([Finished_Goods_DeliveryForcasts:145])
							QUERY:C277([Finished_Goods_DeliveryForcasts:145]; [Finished_Goods_DeliveryForcasts:145]Custid:12=COMPARE_CUSTID; *)
							QUERY:C277([Finished_Goods_DeliveryForcasts:145];  & ; [Finished_Goods_DeliveryForcasts:145]asOf:9=$asOfRef)
							If (Records in selection:C76([Finished_Goods_DeliveryForcasts:145])>0)
								util_DeleteSelection(->[Finished_Goods_DeliveryForcasts:145]; "*")
								QUERY:C277([Finished_Goods_DeliveryForcasts:145]; [Finished_Goods_DeliveryForcasts:145]ShipTo:8="")
								util_DeleteSelection(->[Finished_Goods_DeliveryForcasts:145]; "*")
							End if   //found matches
						End if   // refer asof
						
					End if   //yes, clear
				End if   //has priors
				
				
				If (OK=1)
					utl_LogIt("init")
					utl_LogIt("CPN's SKIPPED DURING IMPORT"; 1)
					ARRAY TEXT:C222($aSkippedCPNs; 0)
					
					$currentSize:=300  //create buffers
					ARRAY TEXT:C222($cpn; $currentSize)
					ARRAY DATE:C224($schd; $currentSize)
					ARRAY LONGINT:C221($qty; $currentSize)
					ARRAY LONGINT:C221($qtyOrd; $currentSize)
					ARRAY LONGINT:C221($qtyRec; $currentSize)
					ARRAY TEXT:C222($refer; $currentSize)
					ARRAY TEXT:C222($asOf; $currentSize)
					ARRAY TEXT:C222($PnG_planner; $currentSize)
					ARRAY TEXT:C222($plant; $currentSize)  //:=util_TextParser (16)
					C_LONGINT:C283($cursor)
					$cursor:=0  //got the first line up above
					uThermoInit(200; "Importing from "+document)
					$thermo:=0
					
					RECEIVE PACKET:C104($docRef; $line; $eol)  //get next line
					util_TextParser(9; $line; Character code:C91($t); Character code:C91($r))
					
					
					SET QUERY LIMIT:C395(1)
					$asOfRef:=String:C10(4D_Current_date; Internal date short special:K1:4)
					While (Length:C16($line)>0)
						$currentCPN:=util_TextParser(4)
						$currentQty:=Num:C11(util_TextParser($delivery_qty_col))
						If ($currentQty>0)
							$scheduledDate:=Date:C102(util_TextParser(7))
							If ($scheduledDate<$planningFence)  // Modified by: Mel Bohince (3/24/17) 
								
								QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]FG_KEY:47=(COMPARE_CUSTID+":"+$currentCPN))
								If (Records in selection:C76([Finished_Goods:26])=1)
									$cursor:=$cursor+1
									$schd{$cursor}:=$scheduledDate
									$cpn{$cursor}:=$currentCPN
									$refer{$cursor}:=util_TextParser(5)
									$qty{$cursor}:=$currentQty
									$PnG_planner{$cursor}:=util_TextParser(1)
									$plant{$cursor}:=util_TextParser(1)
									$asOf{$cursor}:=$asOfRef
									
								Else   //skipped
									$hit:=Find in array:C230($aSkippedCPNs; $currentCPN)
									If ($hit=-1)
										APPEND TO ARRAY:C911($aSkippedCPNs; $currentCPN)
										utl_LogIt($currentCPN+"   "+"unknown F/G")
									End if 
								End if   //in f/g item master
								
							Else 
								APPEND TO ARRAY:C911($aSkippedCPNs; $currentCPN)
								utl_LogIt($currentCPN+"   "+"planning fence")
							End if   //planningfence
							
						Else 
							APPEND TO ARRAY:C911($aSkippedCPNs; $currentCPN)
							utl_LogIt($currentCPN+"   "+"zero qty")
						End if   //qty>0
						
						//get next line
						RECEIVE PACKET:C104($docRef; $line; $eol)
						util_TextParser(9; $line; Character code:C91($t); Character code:C91($r))
						$thermo:=$thermo+1
						$currentSize:=Size of array:C274($qty)
						If ($cursor>=$currentSize)  //expand the buffers
							$currentSize:=$currentSize+20
							ARRAY TEXT:C222($cpn; $currentSize)
							ARRAY DATE:C224($schd; $currentSize)
							ARRAY LONGINT:C221($qty; $currentSize)
							ARRAY LONGINT:C221($qtyOrd; $currentSize)
							ARRAY LONGINT:C221($qtyRec; $currentSize)
							ARRAY TEXT:C222($refer; $currentSize)
							ARRAY TEXT:C222($asOf; $currentSize)
							ARRAY TEXT:C222($PnG_planner; $currentSize)
							ARRAY TEXT:C222($plant; $currentSize)
						End if 
						uThermoUpdate($thermo)
					End while 
					
					SET QUERY LIMIT:C395(0)
					utl_LogIt("show")
					
					ARRAY TEXT:C222($cpn; $cursor)
					ARRAY DATE:C224($schd; $cursor)
					ARRAY LONGINT:C221($qty; $cursor)
					ARRAY LONGINT:C221($qtyOrd; $cursor)
					ARRAY LONGINT:C221($qtyRec; $cursor)
					ARRAY TEXT:C222($refer; $cursor)
					ARRAY TEXT:C222($asOf; $cursor)
					ARRAY TEXT:C222($PnG_planner; $cursor)
					ARRAY TEXT:C222($plant; $cursor)
					MULTI SORT ARRAY:C718($cpn; >; $schd; >; $qty; $qtyOrd; $qtyRec; $refer; $asOf; $PnG_planner; $plant)
					
					ARRAY TEXT:C222($id; $cursor)
					ARRAY TEXT:C222($aCustid; $cursor)
					
					C_LONGINT:C283($i; $numElements)
					$numElements:=Size of array:C274($cpn)
					For ($i; 1; $numElements)  //set the plant and cust id's
						$id{$i}:=String:C10($i; "00000")
						$aCustid{$i}:=COMPARE_CUSTID
					End for 
					$thermo:=$thermo+((200-$thermo)/2)
					uThermoUpdate($thermo)
					
					REDUCE SELECTION:C351([Finished_Goods_DeliveryForcasts:145]; 0)
					ARRAY TO SELECTION:C261($id; [Finished_Goods_DeliveryForcasts:145]id:1; $cpn; [Finished_Goods_DeliveryForcasts:145]ProductCode:2; $schd; [Finished_Goods_DeliveryForcasts:145]DateDock:4; $qty; [Finished_Goods_DeliveryForcasts:145]QtyOpen:7; $refer; [Finished_Goods_DeliveryForcasts:145]refer:3; $plant; [Finished_Goods_DeliveryForcasts:145]ShipTo:8; $asOf; [Finished_Goods_DeliveryForcasts:145]asOf:9; $qty; [Finished_Goods_DeliveryForcasts:145]QtyWanted:5; $aCustid; [Finished_Goods_DeliveryForcasts:145]Custid:12; $PnG_planner; [Finished_Goods_DeliveryForcasts:145]edi_buyer:15; $plant; [Finished_Goods_DeliveryForcasts:145]BillTo:16)
					$thermo:=$thermo+1
					// 
					$thermo:=200
					uThermoUpdate($thermo)
					uThermoClose
					
				End if   //headers looked OK
				CLOSE DOCUMENT:C267($docRef)
				BEEP:C151
			End if   //OK and continue
			
			$quit:=True:C214
			
		Else 
			uConfirm("File not opened?"; "Done"; "Try again")
			If (OK=1)
				$quit:=True:C214
			Else 
				$quit:=False:C215
			End if 
		End if   //doc opened
	Until ($quit)
	
End if   //planning fence

REDUCE SELECTION:C351([Finished_Goods_DeliveryForcasts:145]; 0)