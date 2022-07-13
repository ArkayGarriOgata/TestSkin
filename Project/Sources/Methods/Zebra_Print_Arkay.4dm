//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 11/10/05, 10:48:33
// ----------------------------------------------------
// Method: Zebra_Print_Arkay
// Description

//PM: Zebra_Print_MaryKay() -> 
//@author mlb - 4/30/03  14:15
//see also Zebra_Style_MaryKay
C_TEXT:C284($e; $cr; $printQty)
$cr:=Char:C90(13)+Char:C90(10)
$e:="^FS"+$cr  //end data

$printQty:="^PQ1"  //+String(iCnt)
$serialNumber:=iItemNumber
$nextSeries:=WMS_setNextItemId(->[WMS_ItemMasters:123]; (iLastLabel+1))  //release the lock

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
$labelDef:=$labelDef+"^FN6^FD"+Uppercase:C13(Substring:C12(sDesc; 1; 45))+$e
$labelDef:=$labelDef+"^FN7^FD"+Uppercase:C13(tTo)+$e
$labelDef:=$labelDef+"^FN8^FD"+sPO+$e
If (wmsCaseNumber1>0)
	$labelDef:=$labelDef+"^FN9^FD"+String:C10(wmsCaseNumber1)+$e
Else 
	$labelDef:=$labelDef+"^FN9^FD"+" "+$e
End if 
$labelDef:=$labelDef+"^FN10^FD"+sOF+$e
$labelDef:=$labelDef+"^FN11^FD"+wmsCaseQtyString+$e

$labelDef:=$labelDef+$printQty
$labelDef:=$labelDef+"^XZ"+$cr
$0:=$labelDef  //SEND PACKET($labelDef)

//