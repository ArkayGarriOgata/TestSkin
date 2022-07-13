//%attributes = {}
// ---------------
// Method: RM_onHandRptToText( )
// ---------------
// User name (OS): Mel Bohince
// Date and time: 12/03/15, 08:06:55

// Description
// dump the rm locations subtotaled by comm and commkey
//
// ----------------------------------------------------
// Modified by: Garri Ogata (9/23/21) added $tEmailTo
// Modified by: MelvinBohince (1/10/22) change to csv, remove subtotals, use all records
// Modified by: MelvinBohince (2/3/22) add option for embedded subtotals 
// Modified by: MelvinBohince (4/4/22) quote vendor name
// Modified by: MelvinBohince (6/6/22) don't open doc if executed in batch mode

C_TEXT:C284($1; $tEmailTo)
C_TIME:C306($docRef)
C_TEXT:C284($docName; $lastComm)
C_TEXT:C284($t; $r)
$t:=","
$r:="\r"
C_BOOLEAN:C305($addSubtotals)

If (Count parameters:C259>=1)
	$addSubtotals:=True:C214
	$tEmailTo:=$1
Else 
	$tEmailTo:=""
	$addSubtotals:=False:C215
End if 

$docName:="RM_INVENTORY_"+fYYMMDD(Current date:C33)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".csv"
$docRef:=util_putFileName(->$docName)
If ($docRef#?00:00:00?)  //doc created
	zwStatusMsg("RM INV"; "Reporting Bins")
	
	READ ONLY:C145([Vendors:7])
	READ ONLY:C145([Purchase_Orders_Items:12])
	READ ONLY:C145([Raw_Materials_Locations:25])
	ALL RECORDS:C47([Raw_Materials_Locations:25])
	
	
	If (Records in selection:C76([Raw_Materials_Locations:25])>0)
		ARRAY TEXT:C222($aComKey; 0)
		ARRAY TEXT:C222($aRMcode; 0)
		ARRAY TEXT:C222($aLocation; 0)
		ARRAY TEXT:C222($aPOitem; 0)
		ARRAY REAL:C219($aConsign; 0)
		ARRAY REAL:C219($aOnHand; 0)
		ARRAY REAL:C219($aActCost; 0)
		
		SELECTION TO ARRAY:C260([Raw_Materials_Locations:25]Commodity_Key:12; $aComKey; [Raw_Materials_Locations:25]Raw_Matl_Code:1; $aRMcode; [Raw_Materials_Locations:25]ConsignmentQty:26; $aConsign; [Raw_Materials_Locations:25]Location:2; $aLocation; [Raw_Materials_Locations:25]POItemKey:19; $aPOitem; [Raw_Materials_Locations:25]QtyOH:9; $aOnHand; [Raw_Materials_Locations:25]ActCost:18; $aActCost)
		MULTI SORT ARRAY:C718($aComKey; >; $aRMcode; >; $aPOitem; >; $aConsign; $aLocation; $aOnHand; $aActCost)
		
		C_LONGINT:C283($i; $numElements)
		
		$lastComm:=Substring:C12($aComKey{1}; 1; 2)
		$commTotal:=0
		$rptTotal:=0
		$numElements:=Size of array:C274($aComKey)
		xText:="COMM"+$t+"COMM_KEY"+$t+"RM_CODE"+$t+"POITEM"+$t+"LOCATION"+$t+"ON_HAND"+$t+"CONSIGNMENT"+$t+"COST"+$t+"EXTENDED"+$t+"UOM"+$t+"VENDOR"+$r
		uThermoInit($numElements; "Reporting R/M Inventories...")
		For ($i; 1; $numElements)
			
			If ($addSubtotals)
				If (Substring:C12($aComKey{$i}; 1; 2)#$lastComm)  //subtotal
					xText:=xText+$lastComm+" Total"+(8*$t)+String:C10($commTotal)+$r
					
					$lastComm:=Substring:C12($aComKey{$i}; 1; 2)
					$commTotal:=0
				End if 
			End if 
			
			QUERY:C277([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]POItemKey:1=$aPOitem{$i})
			$uom:=[Purchase_Orders_Items:12]UM_Arkay_Issue:28
			QUERY:C277([Vendors:7]; [Vendors:7]ID:1=[Purchase_Orders_Items:12]VendorID:39)
			$vendor:=[Vendors:7]Name:2
			
			$extended:=Round:C94(($aActCost{$i}*$aOnHand{$i}); 2)
			xText:=xText+Substring:C12($aComKey{$i}; 1; 2)+$t+$aComKey{$i}+$t+$aRMcode{$i}+$t+$aPOitem{$i}+$t+$aLocation{$i}+$t+String:C10($aOnHand{$i})+$t+String:C10($aConsign{$i})+$t+String:C10(Round:C94($aActCost{$i}; 4))+$t+String:C10($extended)+$t+$uom+$t+txt_quote($vendor)+$r  // Modified by: MelvinBohince (4/4/22) quite vendor name
			
			$commTotal:=$commTotal+$extended
			
			If ($addSubtotals)
				$rptTotal:=$rptTotal+$extended
			End if 
			
			uThermoUpdate($i)
		End for 
		uThermoClose
		
		If ($addSubtotals)
			xText:=xText+$lastComm+" Total"+(8*$t)+String:C10($commTotal)+$r
			xText:=xText+"Report"+" Total"+(8*$t)+String:C10($rptTotal)+$r
		End if 
		
		SEND PACKET:C103($docRef; xText)
		CLOSE DOCUMENT:C267($docRef)
		
		If (Length:C16($tEmailTo)=0)  // Modified by: Garri Ogata (9/23/21) added $tEmailTo
			
			EMAIL_Sender("RM_INVENTORY_"+fYYMMDD(Current date:C33); ""; "Copy attached"; $tEmailTo; $docName)
			
		Else   // Modified by: MelvinBohince (6/6/22) 
			$err:=util_Launch_External_App($docName)
		End if 
		
	End if   // records
End if   //doc
