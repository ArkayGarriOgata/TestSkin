//%attributes = {}
// ----------------------------------------------------
// User name: Mel Bohince
// Created: 04/03/07, 16:29:01
// ----------------------------------------------------
// Method: Zebra_Print_LOreal()  --> 
// Description
// 
//
// ----------------------------------------------------

// ----------------------------------------------------
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

$labelDef:=$labelDef+"^FN1"+"^FD"+wmsZebra128+$e
$labelDef:=$labelDef+"^FN2"+"^FD"+wmsHumanReadable1+$e
$labelDef:=$labelDef+"^FN3^FD"+sJMI+$e
$labelDef:=$labelDef+"^FN4^FD"+String:C10(wmsDateMfg; Internal date short:K1:7)+$e
$labelDef:=$labelDef+"^FN5^FD"+sCPN+$e
$labelDef:=$labelDef+"^FN6^FD"+sCriterion4+$e
$labelDef:=$labelDef+"^FN7^FD"+Uppercase:C13(Substring:C12(sDesc; 1; 45))+$e
$labelDef:=$labelDef+"^FN8^FD"+Uppercase:C13(tTo)+$e
$labelDef:=$labelDef+"^FN9^FD"+sPO+$e
If (wmsCaseNumber1>0)
	$labelDef:=$labelDef+"^FN10^FD"+String:C10(wmsCaseNumber1)+$e
Else 
	$labelDef:=$labelDef+"^FN10^FD"+" "+$e
End if 
$labelDef:=$labelDef+"^FN11^FD"+sOF+$e
$labelDef:=$labelDef+"^FN12^FD"+wmsCaseQtyString+$e

$labelDef:=$labelDef+$printQty
$labelDef:=$labelDef+"^XZ"+$cr
$0:=$labelDef
