//%attributes = {}
//Method:  PO_RwMt_ExistsB(ptPOItemKey;$tRawMatlCode)=>bExists
//Description:  This method verifies the PO for the raw material still exists

If (True:C214)  //Initialize
	
	C_POINTER:C301($1; $ptPOItemKey)
	C_TEXT:C284($2; $tRawMatlCode)
	C_BOOLEAN:C305($0; $bExists)
	
	C_OBJECT:C1216($esPurchaseOrdersItems)
	C_OBJECT:C1216($ePurchaseOrdersItems)
	
	$ptPOItemKey:=$1
	$tRawMatlCode:=$2
	
	$bExists:=False:C215
	
	$esPurchaseOrdersItems:=New object:C1471()
	$ePurchaseOrdersItems:=New object:C1471()
	
End if   //Done initialize

$esPurchaseOrdersItems:=ds:C1482.Purchase_Orders_Items.query("POItemKey = :1"; $ptPOItemKey->)

$bExists:=($esPurchaseOrdersItems.length>0)

If (Not:C34($bExists))  //PO doesn't exist
	
	$esPurchaseOrdersItems:=ds:C1482.Purchase_Orders_Items.query("Raw_Matl_Code = :1"; $tRawMatlCode).orderBy("RecvdDate desc")
	
	If ($esPurchaseOrdersItems.length>0)  //Raw_Matl_Code exists
		
		$bExists:=True:C214
		
		$ePurchaseOrdersItems:=$esPurchaseOrdersItems.first()
		
		$ptPOItemKey->:=$ePurchaseOrdersItems.POItemKey
		
	End if   //Done Raw_Matl_Code exists
	
End if   //Done PO doesn't exist

$0:=$bExists