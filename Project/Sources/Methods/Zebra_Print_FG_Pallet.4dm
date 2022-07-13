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

C_TEXT:C284($labelDef; $0)
$labelDef:=""

$labelDef:=$labelDef+"^XA"+$cr

$labelDef:=$labelDef+"^PR"+zebraSpeed+$cr
$labelDef:=$labelDef+"^XFR:PALLET1.ZPL"+$cr

$labelDef:=$labelDef+"^FN1"+"^FD"+wmsZebra128+$e
$labelDef:=$labelDef+"^FN2"+"^FD"+t1+$e
$labelDef:=$labelDef+"^FN3^FD"+"#: "+[WMS_ItemMasters:123]Skidid:1+$e
$labelDef:=$labelDef+"^FN4^FD"+"QTY: "+String:C10([WMS_ItemMasters:123]QTY:7)+$e
$labelDef:=$labelDef+"^FN5^FD"+"MFG'D: "+String:C10([WMS_ItemMasters:123]DATE_MFG:8; Internal date short special:K1:4)+"  CASES: "+String:C10([WMS_ItemMasters:123]CASES:10)+$e
$labelDef:=$labelDef+"^FN6^FD"+[WMS_ItemMasters:123]SKU:2+$e
$labelDef:=$labelDef+"^FN7^FD"+Uppercase:C13(Substring:C12([Finished_Goods:26]CartonDesc:3; 1; 45))+$e
$labelDef:=$labelDef+"^FN8^FD"+Uppercase:C13([Customers:16]Name:2)+$e
$labelDef:=$labelDef+"^FN9^FD"+[Finished_Goods:26]Line_Brand:15+$e
$labelDef:=$labelDef+"^FN10^FD"+"S&S:"+[Finished_Goods:26]OutLine_Num:4+" Control#:"+[Finished_Goods:26]ControlNumber:61+$e
$labelDef:=$labelDef+"^FN11^FD"+"Color:"+[Finished_Goods:26]ColorSpecMaster:77+"TestStd:"+[Finished_Goods:26]TestingStandard:97+$e
$labelDef:=$labelDef+"^FN12^FD"+"PROCESS:"+[Finished_Goods:26]ProcessSpec:33+$e
$labelDef:=$labelDef+"^FN13^FD"+t4+$e

$labelDef:=$labelDef+$printQty
$labelDef:=$labelDef+"^XZ"+$cr
$0:=$labelDef  //SEND PACKET($labelDef)
