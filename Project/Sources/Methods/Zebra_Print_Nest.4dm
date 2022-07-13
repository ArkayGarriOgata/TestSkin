//%attributes = {}
// -------
// Method: Zebra_Print_Nest   ( ) ->
// By: Mel Bohince @ 07/24/17, 11:15:49
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
$labelDef:=$labelDef+"^XFR:nest.ZPL"+$cr

$labelDef:=$labelDef+"^FN1^FD"+wmsZebra128+$e  //Caseid Barcode
$labelDef:=$labelDef+"^FN2^FD"+String:C10(wmsCaseNumber1; "00000")+$e  //case #
$labelDef:=$labelDef+"^FN3^FD"+fYYMMDD(dDate; 4)+$e  //dom
$labelDef:=$labelDef+"^FN4^FD"+"*"+Replace string:C233(sJMI; "."; "")+"*"+$e  //batch barcode
$labelDef:=$labelDef+"^FN5^FD"+sJMI+$e  //batch

$labelDef:=$labelDef+"^FN6^FD"+String:C10(iWgtPerCase)+"  LBS"+$e  //wgt
$labelDef:=$labelDef+"^FN7^FD"+String:C10(wmsCaseQty)+$e  //qty

$labelDef:=$labelDef+"^FN8^FD"+sDesc+$e  //description
$labelDef:=$labelDef+"^FN9^FD"+sCPN+$e  //nest sku

C_TEXT:C284($upc)
$upc:=sCriterion5
//Begin SQL
//select UPC from Finished_Goods where ProductCode = :sCPN into :$upc
//End SQL

If (Length:C16($upc)=0)  //planners seem to put the check digit into the field on the fg record
	$upc:="000000000000"
End if 
// Modified by: Mel Bohince (8/22/19) remove the * leftover from code39 and let zebra calc check digit
$labelDef:=$labelDef+"^FN10^FD"+Substring:C12($upc; 1; 11)+$e  //upc barcode
$labelDef:=$labelDef+"^FN11^FD"+$upc+$e  //upc

$labelDef:=$labelDef+"^FN12^FD"+"*"+sPO+"*"+$e  //po barcode
$labelDef:=$labelDef+"^FN13^FD"+sPO+$e  //po # 
$labelDef:=$labelDef+"^FN14^FD"+tTo+$e  //customer

$labelDef:=$labelDef+$printQty
$labelDef:=$labelDef+"^XZ"
$0:=$labelDef  //SEND PACKET($labelDef)