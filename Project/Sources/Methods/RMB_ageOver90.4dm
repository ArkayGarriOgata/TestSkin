//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 06/13/07, 14:26:31
// ----------------------------------------------------
// Method: RMB_ageOver90
// Description
// based on RMB_ageInventory, rtn flag if rm has inventory greater than 90 days old
// ----------------------------------------------------

C_TEXT:C284($rm_code; $1; $0)
C_DATE:C307($age90)
C_LONGINT:C283($transaction; $bin; $poi)
C_BOOLEAN:C305($hasOld)  //change this to true if old shit is discovered

$rm_code:=$1
$age90:=Add to date:C393(4D_Current_date; 0; 0; -90)
$hasOld:=False:C215

QUERY:C277([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]Raw_Matl_Code:1=$rm_code)
If (Records in selection:C76([Raw_Materials_Locations:25])>0)  //test each lot number
	//get total onhand for each lot
	ARRAY TEXT:C222($aPOI; 0)
	ARRAY REAL:C219($aOnHand; 0)
	ARRAY TEXT:C222($aLot; 0)  //summarize by lot#
	ARRAY LONGINT:C221($aLotQty; 0)
	SELECTION TO ARRAY:C260([Raw_Materials_Locations:25]POItemKey:19; $aPOI; [Raw_Materials_Locations:25]QtyOH:9; $aOnHand)
	DISTINCT VALUES:C339([Raw_Materials_Locations:25]POItemKey:19; $aLot)
	ARRAY LONGINT:C221($aLotQty; Size of array:C274($aLot))
	For ($bin; 1; Size of array:C274($aPOI))
		$hit:=Find in array:C230($aLot; $aPOI{$bin})
		If ($hit>0)
			$aLotQty{$hit}:=$aLotQty{$hit}+$aOnHand{$bin}
		End if 
	End for 
	ARRAY TEXT:C222($aPOI; 0)  //done with the bins
	ARRAY REAL:C219($aOnHand; 0)
	
	For ($poi; 1; Size of array:C274($aLot))
		If ($aLotQty{$poi}>0)
			QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]POItemKey:4=$aLot{$poi}; *)
			QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]Xfer_Type:2="Receipt")
			SELECTION TO ARRAY:C260([Raw_Materials_Transactions:23]XferDate:3; $aDate; [Raw_Materials_Transactions:23]Qty:6; $aQty)
			SORT ARRAY:C229($aDate; $aQty; <)
			$onhand:=$aLotQty{$poi}
			
			For ($transaction; 1; Size of array:C274($aDate))
				If ($onhand>0)
					Case of 
						: ($aQty{$transaction}>$onhand)  //entire amount is this old
							$onhand:=0
						: ($aQty{$transaction}<=$onhand)  //some is this old
							$onhand:=$onhand-$aQty{$transaction}
					End case 
					
					If ($aDate{$transaction}<$age90)
						$hasOld:=True:C214
						$transaction:=$transaction+Size of array:C274($aDate)
					End if 
					
				Else   //break
					$transaction:=$transaction+Size of array:C274($aDate)
				End if 
			End for   //each transaction
			
			If ($hasOld)  //break
				$poi:=$poi+Size of array:C274($aLot)
			End if 
		End if   //have qty
	End for   //each poi
End if   //locations

If ($hasOld)
	$0:=">90"
Else 
	$0:=""
End if 