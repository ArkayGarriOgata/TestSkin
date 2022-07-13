//%attributes = {}
//Method:  FGTr_Verify_ShipB(tOrderLine)=>bShipExists
//Description:  This method verifies the ship record exists
//.  This is a cludge because we are having data issues

If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $tOrderLine)
	C_BOOLEAN:C305($0; $bShipExists)
	
	C_TEXT:C284($tQuery)
	
	$tOrderLine:=$1
	$bShipExists:=False:C215
	
	$tQuery:=CorektBlank
	
	$tQuery:=$tQuery+"XactionType='Return@' or "
	$tQuery:=$tQuery+"XactionType='RevShip@' or "
	$tQuery:=$tQuery+"XactionType='B&H@' or "
	$tQuery:=$tQuery+"XactionType='Ship' and "
	$tQuery:=$tQuery+"JobForm#'Price@' and "
	$tQuery:=$tQuery+"OrderItem="+CorektSingleQuote+$tOrderLine+"@"+CorektSingleQuote
	
End if   //Done initialize

$bShipExists:=(ds:C1482.Finished_Goods_Transactions.query($tQuery).length>0)

$0:=$bShipExists
