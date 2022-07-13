//%attributes = {}
// _______
// Method: ADDR_getAddressObj   ( ) ->
// By: Mel Bohince @ 03/29/19, 07:14:19
// Description
// 
// ----------------------------------------------------

C_OBJECT:C1216($0; $entity; $entitySel)
C_TEXT:C284($1; $find; $name)

If (Count parameters:C259=1)
	$find:=$1
Else 
	$find:="09626"
End if 

$entitySel:=ds:C1482.Addresses.query("ID = :1"; $find)
If ($entitySel.length#0)
	$entity:=$entitySel.first()
Else 
	$entity:=New object:C1471("ID"; "-n/f-"; "Name"; "Not found")
End if 

//$name:=$entity.Name

$0:=$entity
