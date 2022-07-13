C_LONGINT:C283($i; $size)
$size:=Size of array:C274(aBilltos)
ARRAY TEXT:C222(asState; $size)
For ($i; 1; $size)
	asState{$i}:=aBilltos{$i}
End for 
sPickAddress(->asState; ->[Customers_ReleaseSchedules:46]Billto:22)
Text23:=fGetAddressText([Customers_ReleaseSchedules:46]Billto:22)