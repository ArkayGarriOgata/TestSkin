//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 11/12/05, 20:21:11
// ----------------------------------------------------
// Method: Zebra_Print_Lauder08012000
// Description

C_TEXT:C284($e; $cr; $printQty)
$cr:=Char:C90(13)+Char:C90(10)
$e:="^FS"+$cr  //end data

$printQty:="^PQ1"  //+String(iCnt)

C_TEXT:C284($labelDef; $0)
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
If (Length:C16(sPO)>5)
	$labelDef:=$labelDef+"^FN8^FD"+sPO+$e
Else 
	$labelDef:=$labelDef+"^FN8^FD"+""+$e
End if 
$labelDef:=$labelDef+"^FN9^FD"+wmsHumanReadable1+$e
$labelDef:=$labelDef+"^FN10^FD"+wmsZebra128+$e
$labelDef:=$labelDef+"^FN11^FD"+String:C10(wmsDateMfg; Internal date short:K1:7)+$e
$labelDef:=$labelDef+"^FN12^FD"+sOF+$e

$labelDef:=$labelDef+$printQty
$labelDef:=$labelDef+"^XZ"+$cr
$0:=$labelDef  //SEND PACKET($labelDef)

//