//%attributes = {}
// _______
// Method: ADDR_ExportFGLookupTable   (collectionOfProductCodes ) ->
// By: MelvinBohince @ 06/17/22, 23:28:19
// Description
// create key value pair for productcode and shipto address
// ----------------------------------------------------

C_COLLECTION:C1488($productCodes_c; $1; $address_c; $2; $lookUpTable_c)
$productCodes_c:=$1
$address_c:=$2

//create key value pair for productcode and shipto address
$lookUpTable_c:=New collection:C1472
For each ($cpn; $productCodes_c)
	$lookUpTable_c.push(ADDR_zipperCPNtoAddress($cpn; $address_c))  //[ cpn, addressId, addressName, addressCity***{next address}]
End for each 

$csvToExport:=$lookUpTable_c.join("\n")  //prep the text to send to file

util_SaveTextToDocument("FG_Addr_Lookup"; ->$csvToExport)
