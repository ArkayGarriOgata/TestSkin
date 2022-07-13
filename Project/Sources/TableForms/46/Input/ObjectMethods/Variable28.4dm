C_LONGINT:C283($i; $size)
$size:=Size of array:C274(aShiptos)
ARRAY TEXT:C222(asState; $size)
For ($i; 1; $size)
	asState{$i}:=aShiptos{$i}
End for 
sPickAddress(->asState; ->[Customers_ReleaseSchedules:46]Shipto:10)
Text25:=fGetAddressText([Customers_ReleaseSchedules:46]Shipto:10)