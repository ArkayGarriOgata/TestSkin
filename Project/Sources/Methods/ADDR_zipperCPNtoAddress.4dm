//%attributes = {}
// _______
// Method: ADDR_zipperCPNtoAddress   ( product code ; collection of customer's shiptos) -> "cpn, addressId, addressName, addressCity***{next address}
// By: MelvinBohince @ 06/17/22, 09:39:59
// Description
// get a list of shipto's that a product has/will ship to
// ready to be used in a csv export
// ----------------------------------------------------
C_TEXT:C284($cpn; $1; $shipTo)
C_COLLECTION:C1488($address_c; $2)

If (Count parameters:C259=2)
	$cpn:=$1
	$address_c:=$2
Else 
	$cpn:="2235062000"
	$address_c:=ADDR_getCustShipToAddresses(New collection:C1472("04625"; "09774"))
End if 

//where has this item shipped
$cpnShipTos_c:=ds:C1482.Customers_ReleaseSchedules.query("ProductCode = :1"; $cpn).toCollection("Shipto").distinct("Shipto")

$shipToText:=$cpn+","

For each ($shipTo; $cpnShipTos_c)
	$shipToDetail_c:=$address_c.query("ID = :1"; $shipTo)
	If ($shipToDetail_c.length>0)
		$detail:="["+$shipToDetail_c[0].ID+"] "+Replace string:C233($shipToDetail_c[0].Name; ","; " ")+" in "+$shipToDetail_c[0].City+" *** "
	Else 
		$detail:="[n/f]"+" *** "
	End if 
	$shipToText:=$shipToText+$detail
End for each 

$0:=$shipToText
