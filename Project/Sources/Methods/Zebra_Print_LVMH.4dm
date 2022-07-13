//%attributes = {}
// -------
// Method: Zebra_Print_LVMH   ( ) ->
// By: Mel Bohince @ 05/17/18, 14:12:36
// Description
// 
// ----------------------------------------------------

C_TEXT:C284($lableDef; $0)
$0:=""

C_TEXT:C284($e; $cr; $printQty; $lot)
$cr:=Char:C90(13)+Char:C90(10)
$e:="^FS"+$cr  //end data
$lot:=Replace string:C233(sJMI; "."; "")
$printQty:="^PQ1"  //+String(iCnt)

C_TEXT:C284($labelDef; $0)
$labelDef:=""

$labelDef:=$labelDef+"^XA"+$cr
//$labelDef:=$labelDef+"^PRA"+$cr
$labelDef:=$labelDef+"^PR"+sCriterion1+$cr
$labelDef:=$labelDef+"^XFR:LVMH.ZPL"+$cr

//$labelDef:=$labelDef+"^FN1^FD"+wmsZebra128+$e
//$labelDef:=$labelDef+"^FN2^FD"+wmsHumanReadable1+$e
$labelDef:=$labelDef+"^FN1^FD"+skidLableText+$e
$labelDef:=$labelDef+"^FN2^FD"+sCriterion4+$e
$labelDef:=$labelDef+"^FN3^FD"+sCriterion5+$e
$labelDef:=$labelDef+"^FN4^FD"+wmsCaseQtyString+$e
$labelDef:=$labelDef+"^FN5^FD"+sDesc+$e  //the alias
$labelDef:=$labelDef+"^FN6^FD"+mfg_code+$e
$labelDef:=$labelDef+"^FN7^FD"+sCPN+$e
$labelDef:=$labelDef+"^FN8^FD"+sPO+$e
$labelDef:=$labelDef+"^FN9^FD"+sCriterion5+$e
$labelDef:=$labelDef+$printQty
$labelDef:=$labelDef+"^XZ"
$0:=$labelDef  //SEND PACKET($labelDef)