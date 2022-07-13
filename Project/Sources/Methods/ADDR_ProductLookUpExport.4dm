//%attributes = {}
// _______
// Method: ADDR_ProductLookUpExport   ( customer's id:text) -> fileOutput:csv
// By: MelvinBohince @ 06/21/22, 09:08:08
// Description
// find all the product codes in WIP and combine 
// them with all the product codes on hand
// then find where each product code ships
// and save this in a form that can be used by excel 
// as a lookup table
// ----------------------------------------------------


$custID:="00074"

C_COLLECTION:C1488($productCodesInWIP_c; $productCodesOnHand_c; $customersProductCodes_c)
$productCodesInWIP_c:=JMI_getCustWIP(Current date:C33; $custID)

$productCodesOnHand_c:=FGL_getCustInventory($custID)

$productCodesInWIP_c.combine($productCodesOnHand_c)

$customersProductCodes_c:=$productCodesInWIP_c.distinct()

ADDR_BuildAddressLookup($customersProductCodes_c)
