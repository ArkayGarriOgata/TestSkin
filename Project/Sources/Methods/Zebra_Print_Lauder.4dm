//%attributes = {"publishedWeb":true}
//PM: Zebra_Print_Lauder() -> 
//@author mlb - 11/14/01  12:54
//based on PM: Zebra_DefaultCustomer() -> 
//@author mlb - 11/9/01  15:42

C_TEXT:C284($e; $cr; $printQty)
$cr:=Char:C90(13)+Char:C90(10)
$e:="^FS"+$cr  //end data

$printQty:="^PQ"+String:C10(iCnt)
$serialNumber:=wmsCaseNumber1

C_TEXT:C284($labelDef; $0)
$labelDef:=""

$labelDef:=$labelDef+"^XA"+$cr
//$labelDef:=$labelDef+"^PRA"+$cr
$labelDef:=$labelDef+"^PR"+sCriterion1+$cr
$labelDef:=$labelDef+"^XFR:LAUDER.ZPL"+$cr


$labelDef:=$labelDef+"^FN1^FD"+tTo+$e

$labelDef:=$labelDef+"^FN2^FD"+sCPN+$e
$labelDef:=$labelDef+"^FN3^FD"+sCPN+$e

$labelDef:=$labelDef+"^FN4^FD"+sDesc+$e

$labelDef:=$labelDef+"^FN5^FD"+tFrom+$e

$labelDef:=$labelDef+"^FN6^FD"+sJMI+$e
$labelDef:=$labelDef+"^FN7^FD"+sJMI+$e

$labelDef:=$labelDef+"^FN8^FD"+wmsCaseQtyString+$e
$labelDef:=$labelDef+"^FN9^FD"+wmsCaseQtyString+$e

//$labelDef:=$labelDef+"^FN10^FD"+sPO+$e
$labelDef:=$labelDef+"^FN10^FD"+sOF+$e
$labelDef:=$labelDef+"^FN11^FD"+String:C10(dDate; System date short:K1:1)+$e

Case of 
	: ($serialNumber>0)
		$serialNumber:=$serialNumber+iCnt-1  //print back to front
		$labelDef:=$labelDef+"^FN12"+"^SN"+String:C10($serialNumber; "####;Partial;0")+",-1,Y"+$e
	: ($serialNumber<0)
		$labelDef:=$labelDef+"^FN12"+"^FD"+"Partial"+$e
	Else 
		$labelDef:=$labelDef+"^FN12"+"^FD"+""+$e
End case 

$labelDef:=$labelDef+"^FN13^FD"+sCriterion4+$e  //certified 
$labelDef:=$labelDef+"^FN14^FD"+sCriterion5+$e  //item

$labelDef:=$labelDef+$printQty
$labelDef:=$labelDef+"^XZ"
$0:=$labelDef  //SEND PACKET($labelDef)
