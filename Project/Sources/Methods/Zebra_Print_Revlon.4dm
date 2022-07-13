//%attributes = {}
// -------
// Method: Zebra_Print_Revlon   ( ) ->
// By: Mel Bohince @ 05/02/18, 14:59:42
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
$labelDef:=$labelDef+"^XFR:revlon.ZPL"+$cr

$labelDef:=$labelDef+"^FN1^FD"+wmsCaseQtyString+$e
$labelDef:=$labelDef+"^FN2^FD"+sPO+$e
$labelDef:=$labelDef+"^FN3^FD"+[Finished_Goods:26]CartonDesc:3+$e
$labelDef:=$labelDef+"^FN4^FD"+sCriterion5+" / "+sCPN+$e

$labelDef:=$labelDef+"^FN5^FD"+wmsCaseQtyString+$e

$dateStr:=String:C10(wmsDateMfg; Internal date short special:K1:4)
$labelDef:=$labelDef+"^FN6^FD"+$dateStr+$e
$codedDOM:=(Char:C90(64+Month of:C24(wmsDateMfg)))+String:C10(Day of:C23(wmsDateMfg); "00")+Substring:C12(String:C10(Year of:C25(wmsDateMfg); "0000"); 3)
$labelDef:=$labelDef+"^FN7^FD"+$codedDOM+$e

$labelDef:=$labelDef+"^FN8^FD"+sCriterion5+$e
$labelDef:=$labelDef+"^FN9^FD"+sCriterion5+$e

$lotNumber:=Replace string:C233([Job_Forms_Items:44]Jobit:4; "."; "")
$labelDef:=$labelDef+"^FN10^FD"+$lotNumber+$e
$labelDef:=$labelDef+"^FN11^FD"+$lotNumber+$e
$labelDef:=$labelDef+$printQty
$labelDef:=$labelDef+"^XZ"
$0:=$labelDef  //SEND PACKET($labelDef)