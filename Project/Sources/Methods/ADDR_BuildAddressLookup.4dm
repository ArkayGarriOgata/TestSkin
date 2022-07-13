//%attributes = {}
// _______
// Method: ADDR_BuildAddressLookup   ( productCode collection) -> saves a document
// By: MelvinBohince @ 06/17/22, 16:28:07
// Description
// build an address lookup table for product codes passed in
// ----------------------------------------------------
C_COLLECTION:C1488($productCode_c; $1; $address_c)
C_TEXT:C284($cpn; $csvToExport)

$productCode_c:=$1

$address_c:=ADDR_getCustShipToAddresses($productCode_c)

ADDR_ExportFGLookupTable($productCode_c; $address_c)
