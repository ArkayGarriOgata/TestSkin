//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 11/12/05, 20:20:32
// ----------------------------------------------------
// Method: Zebra_Style_Lauder08012000
// Description
// 
//
// Parameters
// ----------------------------------------------------

//PM: Zebra_Style_MaryKay() -> 
//@author mlb - 4/30/03  14:13
//see also Zebra_Print_MaryKay
//*Init vars
C_TEXT:C284($lableDef; $0)
C_TEXT:C284($s; $e; $cr; $startLabel; $endLabel; $home; $speed)
$cr:=Char:C90(13)+Char:C90(10)  //Linefeed and carriage return
$b:="^FD"  //begin data
$e:="^FS"+$cr  //end data
$startLabel:="^XA"
$endLabel:="^XZ"
$speed:="^PR"+sCriterion1
$home:="^LH"+sCriterion2+","+sCriterion3

Zebra_dpiScaling(lValue1)

C_LONGINT:C283($col1; $col2; $col3; $col4)
$col1:=3
$col2:=20
$col3:=72
$colBC:=20

//define the layout  
$labelDef:=""
$labelDef:=$labelDef+$startLabel+$cr
$labelDef:=$labelDef+$speed+$cr
$labelDef:=$labelDef+$home+$cr
$labelDef:=$labelDef+"^DFR:ARKAY128.ZPL^FS"+$cr  //give the template a name

//Graphics--------------------------------------
$labelDef:=$labelDef+ZebraLabelGrid("at"; 1; 1)
$labelDef:=$labelDef+zBoxOutline+$cr

//Labels--------------------------------------
$labelDef:=$labelDef+ZebraLabelGrid("at"; 55; $col1)
$labelDef:=$labelDef+zFont14+$b+"Description:"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 50; $col1)
$labelDef:=$labelDef+zFont14+$b+"Code:"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 38; $col1)
$labelDef:=$labelDef+zFont14+$b+"Quantity:"+$e

//PO NUMBER

$labelDef:=$labelDef+ZebraLabelGrid("at"; 21; $col1)
$labelDef:=$labelDef+zFont14+$b+"Vendor: ARKAY PACKAGING CORPORATION"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 16; $col1)
$labelDef:=$labelDef+zFont14+$b+"Vendor Lot:"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 1; $col1)
$labelDef:=$labelDef+zFont14+$b+"Date:"+$e


//Data--------------------------------------
$labelDef:=$labelDef+ZebraLabelGrid("at"; 55; $col2+6)  //DESC
$labelDef:=$labelDef+zFont14t+"^FN1"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 50; $col2-4)  //SKU
$labelDef:=$labelDef+zFont14b+"^FN2"+$e
$labelDef:=$labelDef+ZebraLabelGrid("at"; 43; $colbc)  //SKU BC
$labelDef:=$labelDef+zBcode39+"^FN3"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 38; $col2)  //qty
$labelDef:=$labelDef+zFont14b+"^FN4"+$e
$labelDef:=$labelDef+ZebraLabelGrid("at"; 32; $colbc+16)  //qty
$labelDef:=$labelDef+zBcode39+"^FN5"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 37; $col3)  //certified
$labelDef:=$labelDef+zFont18+"^FN6"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 32; $col3)  //item
$labelDef:=$labelDef+zFont18+"^FN7"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 26; $col1)  //po
$labelDef:=$labelDef+zFont14+"^FN8"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 16; $col2+6)  //case number
$labelDef:=$labelDef+zFont14b+"^FN9"+$e
$labelDef:=$labelDef+ZebraLabelGrid("at"; 7; $colBC)  //HUMAN READABLE
$labelDef:=$labelDef+zBcode128+"^FN10"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 1; $col2-4)  //DATE
$labelDef:=$labelDef+zFont14+"^FN11"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 1; $col3)  //OF
$labelDef:=$labelDef+zFont14+"^FN12"+$e

$labelDef:=$labelDef+$endLabel+$cr+$cr

$0:=$labelDef  //SEND PACKET($labelDef)