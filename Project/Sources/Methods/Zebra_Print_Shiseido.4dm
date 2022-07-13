//%attributes = {}
// -------
// Method: Zebra_Print_Shiseido   ( ) ->
// By: Mel Bohince @ 08/04/17, 16:13:49
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
$labelDef:=$labelDef+"^XFR:shiseido.ZPL"+$cr

$labelDef:=$labelDef+"^FN1^FD"+wmsZebra128+$e
$labelDef:=$labelDef+"^FN2^FD"+String:C10(wmsCaseNumber1; "00000")+$e
$labelDef:=$labelDef+"^FN3^FD"+sPO+$e
$labelDef:=$labelDef+"^FN4^FD"+"*"+wmsCaseQtyString+"*"+$e
$labelDef:=$labelDef+"^FN5^FD"+wmsCaseQtyString+$e
$labelDef:=$labelDef+"^FN6^FD"+String:C10(dDate; Internal date short special:K1:4)+$e
$labelDef:=$labelDef+"^FN7^FD"+sCriterion4+$e  //upc
$labelDef:=$labelDef+"^FN8^FD"+sCriterion5+$e
$labelDef:=$labelDef+"^FN9^FD"+sDesc+$e
$labelDef:=$labelDef+"^FN10^FD"+"*"+sCPN+"*"+$e
$labelDef:=$labelDef+"^FN11^FD"+sCPN+$e
$labelDef:=$labelDef+"^FN12^FD"+"*"+Substring:C12($lot; 1; 7)+"*"+$e
$labelDef:=$labelDef+"^FN13^FD"+$lot+$e

$labelDef:=$labelDef+$printQty
$labelDef:=$labelDef+"^XZ"
$0:=$labelDef  //SEND PACKET($labelDef)