//%attributes = {}
// -------
// Method: Loreal_GTIN_Label   ( ) ->
// By: Mel Bohince @ 08/30/16, 10:39:28
// Description
// print a sample label
// ----------------------------------------------------

$a:="01"  //packing unit
tUL:="03605971072512"  //gtin ul
$c:="20"  //variant to follow
$d:="00"  //variant
$e:="10"  //lot to follow
tLot:="18M402"  //6 char lot
iQty:=10
tSKU:="T1871100"
tUC:="3605971072499"

If (Count parameters:C259>0)
	tUL:=$1  //gtin ul
	tSKU:=$2
	tUC:=$3
	iQty:=$4
	tLot:=Replace string:C233(String:C10(Current date:C33; Internal date short special:K1:4); "/"; "")
	tLot:=Request:C163("6 digit Lot Code or DOM:"; tLot; "Ok"; "Cancel")
	$f:=tLot
End if 
$encodeThis:=$a+tUL+$c+$d+$e+tLot  //"010360597107251220001018M402"

$chkDigit:=fBarCodeMod10Digit($encodeThis)
tGTIN:=fBarCodeSym(129; $encodeThis+$chkDigit)
tHumanReadable:="("+$a+")"+tUL+"("+$c+")"+$d+"("+$e+")"+tLot

PRINT SETTINGS:C106
Print form:C5([WMS_SerializedShippingLabels:96]; "Loreal_GTIN")
