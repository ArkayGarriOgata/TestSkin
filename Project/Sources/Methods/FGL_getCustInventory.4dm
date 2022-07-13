//%attributes = {}
// _______
// Method: FGL_getCustInventory   ( custID:text {exportOption:boolean}) -> productCodesInInventory:collection
// By: MelvinBohince @ 06/17/22, 10:04:30
// Description
// find and return the distinct product codes on hand
// for a given customer
//note: can be used in excel with the fifo inventory report
// ----------------------------------------------------

C_COLLECTION:C1488($cpnOnhand_c; $0)
C_TEXT:C284($custId; $1)
C_BOOLEAN:C305($export; $2)

If (Count parameters:C259>0)
	$custId:=$1
	If (Count parameters:C259>1)
		$export:=$2
	Else 
		$export:=False:C215
	End if 
	
Else   //test
	$custId:="00074"
	$export:=True:C214
End if 

//Find the products that are in inventory
$cpnOnhand_c:=ds:C1482.Finished_Goods_Locations.query("CustID = :1"; $custId).toCollection("ProductCode").distinct("ProductCode")

$0:=$cpnOnhand_c

If ($export)
	util_EntitySelectionToCSV($jobits_es; New collection:C1472("JobForm"; "Jobit"; "ProductCode"); "JobitsInWIP_")
End if 
