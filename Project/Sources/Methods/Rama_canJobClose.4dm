//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 01/31/13, 15:32:38
// ----------------------------------------------------
// Method: Rama_canJobClose
// Description
// see is all of a jobit has shipped, thus Rama charges issued to job
// ----------------------------------------------------
//defunct as costs are issued when first moved to Rama ` Modified by: Mel Bohince (9/11/14) 

C_DATE:C307($1)
C_LONGINT:C283($i; $numElements)
C_TEXT:C284($canClose; $stillInv)

QUERY:C277([Finished_Goods_Transactions:33]; [Finished_Goods_Transactions:33]XactionType:2="ship"; *)
QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]viaLocation:11="@rama@"; *)
QUERY:C277([Finished_Goods_Transactions:33];  & ; [Finished_Goods_Transactions:33]XactionDate:3=$1)

DISTINCT VALUES:C339([Finished_Goods_Transactions:33]JobForm:5; $jobform)

$numElements:=Size of array:C274($jobform)
$canClose:=""
$stillInv:=""

uThermoInit($numElements; "Processing Array")

For ($i; 1; $numElements)
	QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]JobForm:19=$jobform{$i})
	If (Records in selection:C76([Finished_Goods_Locations:35])=0)  //its all gone
		$canClose:=$canClose+", "+$jobform{$i}
	Else 
		$stillInv:=$stillInv+", "+$jobform{$i}
	End if 
	uThermoUpdate($i)
End for 

uThermoClose

If (Length:C16($canClose)>0)
	$canClose:="The following jobforms' inventories have been relieved: "+$canClose+Char:C90(13)
End if 

If (Length:C16($stillInv)>0)
	$stillInv:="The following jobforms' inventories are active but still have inventory: "+$stillInv
End if 

If ($numElements>0)  //there were shipments on this day
	xText:=$canClose+$cr+$cr+$stillInv
	EMAIL_Sender("Rama Closeouts"; ""; xText; distributionList)
End if 