//%attributes = {}
// _______
// Method: CUST_getCustomerObj   ( ) ->
// By: Mel Bohince @ 03/29/19, 07:45:53
// Description
// 
// ----------------------------------------------------

C_OBJECT:C1216($0; $entity; $entitySel; $billto; $billtos)
C_TEXT:C284($1; $find; $name; $id)

If (Count parameters:C259=1)
	$find:=$1
Else 
	$find:="00121"
End if 

$entitySel:=ds:C1482.Customers.query("ID = :1"; $find)
If ($entitySel.length#0)
	$entity:=$entitySel.first()
Else 
	$entity:=New object:C1471("ID"; "-n/f-"; "Name"; "Not found")
End if 

$name:=$entity.Name
$billtos:=$entity.Addresses.query("AddressType = :1"; "Bill to").orderBy("CustAddrID desc")

$billto:=$billtos.first()
$id:=$billto.CustAddrID

$0:=$entity