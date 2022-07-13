//%attributes = {}
// _______
// Method: ADDR_getCustShipToAddresses   ( ) -> collection to use for lookups
// By: MelvinBohince @ 06/17/22, 08:41:02
// Description
// find the addresses that a collection of product codes ship to
// 
// this was done specifically for the arden/revlon exit strategy
// ----------------------------------------------------
C_COLLECTION:C1488($productCodesToTest; $1; $productsShipTo_c; $address_c; $0; $2)
C_TEXT:C284($custId)

If (Count parameters:C259=1)  //look at fg inventory
	$productCodesToTest:=$1
	
Else   //test
	//Find the products code that are in inventory for this customer
	$productCodesToTest:=ds:C1482.Finished_Goods_Locations.query("CustID = :1"; "00074").toCollection("ProductCode").distinct("ProductCode")
End if 

//Find the releases for thoses products and gather their shipTo id's
$productsShipTo_c:=ds:C1482.Customers_ReleaseSchedules.query("ProductCode in :1"; $productCodesToTest).toCollection("Shipto").distinct("Shipto")

//Make a collection that can be used as a lookup table for a shipTo id
// these are all the addresses that are in play
$address_c:=ds:C1482.Addresses.query("ID in :1"; $productsShipTo_c).toCollection("ID, Name, City")

$0:=$address_c
