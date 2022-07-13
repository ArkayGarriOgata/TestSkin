//%attributes = {}
// -------
// Method: Zebra_Print_ELCv4   ( ) ->
// By: Mel Bohince @ 05/01/18, 14:32:04
// Description
// 
// ----------------------------------------------------
// Modified by: Mel Bohince (5/6/18) remove prod-date and batch (caseid) codes
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
$labelDef:=$labelDef+"^XFR:elcv4.ZPL"+$cr

//$labelDef:=$labelDef+"^FN1^FD"+wmsZebra128+$e
//$labelDef:=$labelDef+"^FN2^FD"+wmsHumanReadable1+$e
$labelDef:=$labelDef+"^FN1^FD"+wmsCaseQtyString+$e
$labelDef:=$labelDef+"^FN2^FD"+wmsCaseQtyString+$e
$labelDef:=$labelDef+"^FN3^FD"+sCPN+$e
$labelDef:=$labelDef+"^FN4^FD"+sCPN+$e
$labelDef:=$labelDef+"^FN5^FD"+sCriterion4+$e  //the alias
$labelDef:=$labelDef+"^FN6^FD"+sCriterion5+$e
//$dateStr:=String(wmsDateMfg;Internal date abbreviated)
//$labelDef:=$labelDef+"^FN9^FD"+"PROD-DATE-"+String(Day of(wmsDateMfg))+"-"+Substring($dateStr;1;3)+"-"+String(Year of(wmsDateMfg))+$e
$labelDef:=$labelDef+"^FN7^FD"+sCPN+$e
$labelDef:=$labelDef+"^FN8^FD"+sCPN+$e
$labelDef:=$labelDef+$printQty
$labelDef:=$labelDef+"^XZ"
$0:=$labelDef  //SEND PACKET($labelDef)