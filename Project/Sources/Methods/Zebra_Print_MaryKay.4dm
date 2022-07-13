//%attributes = {"publishedWeb":true}
//PM: Zebra_Print_MaryKay() -> 
//@author mlb - 4/30/03  14:15
//see also Zebra_Style_MaryKay
C_TEXT:C284($e; $cr; $printQty)
$cr:=Char:C90(13)+Char:C90(10)
$e:="^FS"+$cr  //end data

$printQty:="^PQ"+String:C10(iCnt)
$serialNumber:=iItemNumber
$nextSeries:=WMS_setNextItemId(->[WMS_ItemMasters:123]; (iLastLabel+1))  //release the lock

C_TEXT:C284($labelDef; $0)
$labelDef:=""

$labelDef:=$labelDef+"^XA"+$cr
//$labelDef:=$labelDef+"^PRA"+$cr
$labelDef:=$labelDef+"^PR"+sCriterion1+$cr
$labelDef:=$labelDef+"^XFR:SIDEWAYS.ZPL"+$cr

$serialNumber:=$serialNumber+iCnt-1  //print back to front

$labelDef:=$labelDef+"^FN1"+"^SN"+"RK"+String:C10($serialNumber; "000000000")+",-1,Y"+$e
$labelDef:=$labelDef+"^FN2"+"^SN"+"RK"+String:C10($serialNumber; "000000000")+",-1,Y"+$e
$labelDef:=$labelDef+"^FN3^FD"+String:C10(dDate; Internal date short:K1:7)+$e
$labelDef:=$labelDef+"^FN4^FD"+sCPN+$e
$labelDef:=$labelDef+"^FN5^FD"+Uppercase:C13(Substring:C12(sDesc; 1; 45))+$e
$labelDef:=$labelDef+"^FN6^FD"+sJMI+$e
$labelDef:=$labelDef+"^FN7^FD"+String:C10(iQty)+$e

$labelDef:=$labelDef+$printQty
$labelDef:=$labelDef+"^XZ"
$0:=$labelDef  //SEND PACKET($labelDef)

For ($i; iItemNumber; iLastLabel)
	WMS_newItem(("RK"+String:C10($i; "000000000")); sCPN; sJMI; iQty; dDate)
End for 
iItemNumber:=0
//