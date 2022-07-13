//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 06/11/13, 14:47:15
// ----------------------------------------------------
// Method: Zebra_Print_Lauder_SAP_Lot
// Description
// they can't read the arkay lot prefixing the case id, so put the lot on a separate line
//  based on Zebra_Print_Lauder08012000
// ----------------------------------------------------

C_TEXT:C284($e; $cr; $printQty)
C_TEXT:C284($labelDef; $0)

$cr:=Char:C90(13)+Char:C90(10)
$e:="^FS"+$cr  //end data

$printQty:="^PQ1"  //+String(iCnt)

$labelDef:=""
$labelDef:=$labelDef+"^XA"+$cr
//$labelDef:=$labelDef+"^PRA"+$cr
$labelDef:=$labelDef+"^PR"+sCriterion1+$cr
$labelDef:=$labelDef+"^XFR:ARKAY128.ZPL"+$cr

//$serialNumber:=$serialNumber+iCnt-1  `print back to front
$labelDef:=$labelDef+"^FN1"+"^FD"+Uppercase:C13(Substring:C12(sDesc; 1; 45))+$e
$labelDef:=$labelDef+"^FN2"+"^FD"+sCPN+$e
$labelDef:=$labelDef+"^FN3^FD"+sCPN+$e
$labelDef:=$labelDef+"^FN4^FD"+wmsCaseQtyString+$e
$labelDef:=$labelDef+"^FN5^FD"+wmsCaseQtyString+$e
$labelDef:=$labelDef+"^FN6^FD"+sCriterion4+$e  //certified 
$labelDef:=$labelDef+"^FN7^FD"+sCriterion5+$e  //item

If (Length:C16(sPO)>5)  //coc #
	$labelDef:=$labelDef+"^FN8^FD"+sPO+$e
	$labelDef:=$labelDef+"^FN9^FD"+""+$e
Else 
	$lot_number:=Substring:C12(wmsHumanReadable1; 1; 9)
	$labelDef:=$labelDef+"^FN8^FD"+$lot_number+$e
	$labelDef:=$labelDef+"^FN9^FD"+$lot_number+$e
End if 

$labelDef:=$labelDef+"^FN10^FD"+wmsHumanReadable1+$e
$labelDef:=$labelDef+"^FN11^FD"+wmsZebra128+$e
$labelDef:=$labelDef+"^FN12^FD"+String:C10(wmsDateMfg; Internal date short:K1:7)+$e
$labelDef:=$labelDef+"^FN13^FD"+sOF+$e

$labelDef:=$labelDef+$printQty
$labelDef:=$labelDef+"^XZ"+$cr

$0:=$labelDef  //SEND PACKET($labelDef)