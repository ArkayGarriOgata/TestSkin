//%attributes = {}
// Method: FG_CheckFiFoShipment () -> 
// ----------------------------------------------------
// by: mel: 07/29/05, 12:25:28
// ----------------------------------------------------
// Description:
// check a days shipments and look for inventory that was left that was older than what was shipped
// Updates:
// • mel (8/18/05, 08:24:27) only check FG@ bins
// • mel (10/5/05, 08:24:27) add case count
// ----------------------------------------------------

C_LONGINT:C283($cpn; $jmi; $numElements; $buffer; $cursor)
C_DATE:C307($date; $1; $glueDate; $oldestInventory)
C_TEXT:C284($t; $r)
C_TIME:C306($docRef)
C_TEXT:C284(xTitle; xText; docName)

If (Count parameters:C259=1)
	$days:=1
	$date:=$1-1  //for loop counter
Else 
	$days:=Num:C11(Request:C163("Number of Days?"))
	$date:=Date:C102(Request:C163("Starting on date?"))-1
End if 

docName:="FiFoShippingTest_"+fYYMMDD(Current date:C33)+".txt"
$buffer:=50
$cursor:=0
ARRAY DATE:C224($aShippedOn; $buffer)
ARRAY TEXT:C222($aProduct; $buffer)
ARRAY TEXT:C222($aInvJMI; $buffer)
ARRAY DATE:C224($aInvDate; $buffer)
ARRAY LONGINT:C221($aOnHand; $buffer)
ARRAY LONGINT:C221($aCaseCount; $buffer)
ARRAY TEXT:C222($aWarehouse; $buffer)
ARRAY TEXT:C222($aShipJMI; $buffer)
ARRAY DATE:C224($aShipDate; $buffer)
ARRAY LONGINT:C221($aQtyShipped; $buffer)
ARRAY TEXT:C222($aVia; $buffer)

$t:=Char:C90(9)
$r:=Char:C90(13)

READ ONLY:C145([Finished_Goods_Transactions:33])
READ ONLY:C145([Finished_Goods_Locations:35])
READ ONLY:C145([Finished_Goods_PackingSpecs:91])
READ ONLY:C145([Finished_Goods:26])

For ($day; 1; $days)
	$date:=$date+1
	
	If ($date>!00-00-00!)
		QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionDate:3=$date; *)
		QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]XactionType:2="Ship")
		
		If (Records in selection:C76([Finished_Goods_Transactions:33])>0)
			DISTINCT VALUES:C339([Finished_Goods_Transactions:33]ProductCode:1; $aCPN)
			$numElements:=Size of array:C274($aCPN)
			
			uThermoInit($numElements; "Checking FiFo of Shipments for "+String:C10($date; System date short:K1:1))
			For ($cpn; 1; $numElements)
				QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]ProductCode:1=$aCPN{$cpn}; *)
				QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]Location:2="FG@")  // • mel (8/18/05, 08:25:03)
				
				If (Records in selection:C76([Finished_Goods_Locations:35])>0)  //left some remaining inventory
					//find the oldest inventory
					DISTINCT VALUES:C339([Finished_Goods_Locations:35]Jobit:33; $aJobit)
					$oldestInventory:=<>MAGIC_DATE  //never happened
					$oldestJMI:=""
					For ($jmi; 1; Size of array:C274($aJobit))
						$glueDate:=JMI_getGlueDate($aJobit{$jmi})
						If ($glueDate#!00-00-00!)  //valid date
							If ($glueDate<$oldestInventory)
								$oldestInventory:=$glueDate
								$oldestJMI:=$aJobit{$jmi}
							End if 
						End if 
					End for 
					
					If ($oldestInventory#<>MAGIC_DATE)  //found a reasonable glue date
						QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionDate:3=$date; *)
						QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]ProductCode:1=$aCPN{$cpn}; *)
						QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]XactionType:2="Ship")
						DISTINCT VALUES:C339([Finished_Goods_Transactions:33]Jobit:31; $aJobit)
						$newestShipment:=!1990-12-25!  //never happened
						$newestJMI:=""
						For ($jmi; 1; Size of array:C274($aJobit))
							$glueDate:=JMI_getGlueDate($aJobit{$jmi})
							If ($glueDate#!00-00-00!)  //valid date
								If ($glueDate>$newestShipment)
									$newestShipment:=$glueDate
									$newestJMI:=$aJobit{$jmi}
								End if 
							End if 
						End for 
						
						If ($newestShipment#!1990-12-25!)
							If ($newestShipment>$oldestInventory)
								
								QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]ProductCode:1=$aCPN{$cpn})
								QUERY:C277([Finished_Goods_PackingSpecs:91]; [Finished_Goods_PackingSpecs:91]FileOutlineNum:1=[Finished_Goods:26]OutLine_Num:4)
								If (Records in selection:C76([Finished_Goods_PackingSpecs:91])>0)
									$pkSpec:=[Finished_Goods_PackingSpecs:91]CaseCount:2
								Else 
									$pkSpec:=0
								End if 
								
								$qtyOld:=0
								QUERY SELECTION:C341([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Jobit:33=$oldestJMI)
								If (Records in selection:C76([Finished_Goods_Locations:35])>0)
									$qtyOld:=Sum:C1([Finished_Goods_Locations:35]QtyOH:9)
									If (Position:C15("R"; [Finished_Goods_Locations:35]Location:2)=4)
										$wrhse:="Roanoke"
									Else 
										$wrhse:="Vista"
									End if 
								Else 
									$qtyOld:=0
								End if 
								
								QUERY SELECTION:C341([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]Jobit:31=$newestJMI)
								If (Records in selection:C76([Finished_Goods_Transactions:33])>0)
									$qtyNew:=Sum:C1([Finished_Goods_Transactions:33]Qty:6)
									If (Position:C15("R"; [Finished_Goods_Transactions:33]viaLocation:11)=4)
										$via:="Roanoke"
									Else 
										$via:="Vista"
									End if 
								Else 
									$qtyNew:=0
								End if 
								
								If ($cursor=$buffer)  //expand arrays
									$buffer:=$buffer+50
									ARRAY DATE:C224($aShippedOn; $buffer)
									ARRAY TEXT:C222($aProduct; $buffer)
									ARRAY TEXT:C222($aInvJMI; $buffer)
									ARRAY DATE:C224($aInvDate; $buffer)
									ARRAY LONGINT:C221($aOnHand; $buffer)
									ARRAY LONGINT:C221($aCaseCount; $buffer)
									ARRAY TEXT:C222($aWarehouse; $buffer)
									ARRAY TEXT:C222($aShipJMI; $buffer)
									ARRAY DATE:C224($aShipDate; $buffer)
									ARRAY LONGINT:C221($aQtyShipped; $buffer)
									ARRAY TEXT:C222($aVia; $buffer)
								End if 
								
								$cursor:=$cursor+1
								$aShippedOn{$cursor}:=$date
								$aProduct{$cursor}:=$aCPN{$cpn}
								$aCaseCount{$cursor}:=$pkSpec
								$aInvJMI{$cursor}:=$oldestJMI
								$aInvDate{$cursor}:=$oldestInventory
								$aOnHand{$cursor}:=$qtyOld
								$aWarehouse{$cursor}:=$wrhse
								$aShipJMI{$cursor}:=$newestJMI
								$aShipDate{$cursor}:=$newestShipment
								$aQtyShipped{$cursor}:=$qtyNew
								$aVia{$cursor}:=$via
							End if 
						End if 
					End if 
				End if 
				uThermoUpdate($i)
			End for 
			uThermoClose
		End if 
	End if 
End for 

$buffer:=$cursor
ARRAY DATE:C224($aShippedOn; $buffer)
ARRAY TEXT:C222($aProduct; $buffer)
ARRAY TEXT:C222($aInvJMI; $buffer)
ARRAY DATE:C224($aInvDate; $buffer)
ARRAY LONGINT:C221($aOnHand; $buffer)
ARRAY LONGINT:C221($aCaseCount; $buffer)
ARRAY TEXT:C222($aWarehouse; $buffer)
ARRAY TEXT:C222($aShipJMI; $buffer)
ARRAY DATE:C224($aShipDate; $buffer)
ARRAY LONGINT:C221($aQtyShipped; $buffer)
ARRAY TEXT:C222($aVia; $buffer)
MULTI SORT ARRAY:C718($aVia; >; $aShippedOn; >; $aProduct; >; $aInvJMI; $aInvDate; $aOnHand; $aWarehouse; $aShipJMI; $aShipDate; $aQtyShipped; $aCaseCount)

If (Count parameters:C259=1)  // | (True)  `then email
	xTitle:="Test Shipments for FiFo "+String:C10($date; System date short:K1:1)
	xText:="Listed below are items shipped on "+String:C10($date; System date short:K1:1)+" which left older stock on-hand. "+$r+$r
	xText:=xText+"The list is formatted as: "+$r
	xText:=xText+"   PRODUCT CODE:        CASE COUNT"+$r
	xText:=xText+"      OLD ON HAND JOBIT   GLUE DATE  QTY ONHAND   WAREHOUSE "+$r
	xText:=xText+"      NEW JOBIT SHIPPED   GLUE DATE  QTY SHIPPED   DATE SHIPPED "+$r
	
	$currentVia:=""
	For ($cpn; 1; $buffer)
		If ($currentVia#$aVia{$cpn})
			$currentVia:=$aVia{$cpn}
			xText:=xText+$r+$r+"SHIPPED FROM "+$currentVia+$r
		End if 
		xText:=xText+$r+"   "+$aProduct{$cpn}+"   "+String:C10($aCaseCount{$cpn})+$r
		xText:=xText+"   "+"   "+$aInvJMI{$cpn}+"   "+String:C10($aInvDate{$cpn}; Internal date short:K1:7)+"   "+String:C10($aOnHand{$cpn})+"   "+$aWarehouse{$cpn}+$r
		xText:=xText+"   "+"   "+$aShipJMI{$cpn}+"   "+String:C10($aShipDate{$cpn}; Internal date short:K1:7)+"   "+String:C10($aQtyShipped{$cpn})+"   "+String:C10($aShippedOn{$cpn}; System date short:K1:1)+$r
	End for 
	
	If ($buffer>0)
		$distributionList:=distributionList
		EMAIL_Sender(xTitle; ""; xText; $distributionList)
	End if 
	//$docRef:=util_putFileName (->docName)
	//SEND PACKET($docRef;xTitle+$r+$r)
	//SEND PACKET($docRef;xText)
	//SEND PACKET($docRef;$r+$r+"------ END OF FILE ------")
	//CLOSE DOCUMENT($docRef)
	//// obsolete call, method deleted 4/28/20 uDocumentSetType (docName)  `
	//$err:=util_Launch_External_App (docName)
	
Else   //save as excel doc
	xTitle:="Test Shipments for FiFo"
	xText:="SHIPDATE"+$t+"PRODUCT_CODE"+$t+"OLD-JOBIT"+$t+"GLUED"+$t+"QTY_ONHAND"+$t+"WAREHOUSE"+$t+"NEW_JOBIT"+$t+"NEW_GLUED"+$t+"QTY_SHIPPED"+$t+"SHIPPED_FROM"+$r
	$docRef:=util_putFileName(->docName)
	If ($docRef#?00:00:00?)
		For ($cpn; 1; $buffer)
			xText:=xText+String:C10($aShippedOn{$cpn}; System date short:K1:1)+$t+$aProduct{$cpn}+$t+$aInvJMI{$cpn}+$t+String:C10($aInvDate{$cpn}; System date short:K1:1)+$t+String:C10($aOnHand{$cpn})+$t+$aWarehouse{$cpn}+$t+$aShipJMI{$cpn}+$t+String:C10($aShipDate{$cpn}; System date short:K1:1)+$t+String:C10($aQtyShipped{$cpn})+$t+$aVia{$cpn}+$r
		End for 
		
		SEND PACKET:C103($docRef; xTitle+$r+$r)
		SEND PACKET:C103($docRef; xText)
		SEND PACKET:C103($docRef; $r+$r+"------ END OF FILE ------")
		CLOSE DOCUMENT:C267($docRef)
		
		// obsolete call, method deleted 4/28/20 uDocumentSetType (docName)  //
		$err:=util_Launch_External_App(docName)
	Else 
		BEEP:C151
		ALERT:C41("Couldn't save file "+docName)
	End if 
End if 