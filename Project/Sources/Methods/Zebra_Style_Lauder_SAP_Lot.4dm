//%attributes = {}

// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 06/11/13, 14:49:20
// ----------------------------------------------------
// Method: Zebra_Style_Lauder_SAP_Lot
// Description
// based on Zebra_Style_Lauder08012000
//
// Parameters
// ----------------------------------------------------

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

C_TEXT:C284($fo)
C_LONGINT:C283($col1; $col2; $col3; $col4)
$fo:=ZebraLabelGrid("init"; 16)
$col1:=3
$col2:=20
$col3:=72
$colBC:=20

C_TEXT:C284($font14; $font24; $printQty; $bcode39; $font14b)
$font14:="^A0R,60,54"
$font14b:="^A0R,60,67"
//$font14b:="^AVR,2,2"
$font14t:="^A0R,60,52"
$font18:="^A0R75,60"
$font24:="^A0R,125,100"

//barcodes
$bcode39:="^BY4,3^B3R,N,100,N,N"
$bcode128:="^BY5,3^BCR,100,N,N,N,A"

C_LONGINT:C283($xT; $yT; $edge; $x; $y)
//label boundary  
$xT:=812  //4" WIDTH
$yT:=1218  //6" LENGTH
//boarder area
$edge:=13  //.0625    1/16"
$x:=$xT-(3*$edge)
$y:=$yT-(2*$edge)

//graphics
$lineWeight:="6"
$boxOutline:="^GB"+String:C10($x)+","+String:C10($y)+","+$lineWeight+"^FS"
$lineBisect:="^GB0,"+String:C10($y)+","+$lineWeight+"^FS"
$lineHorz:="^GB"+String:C10(352)+",0,"+$lineWeight+"^FS"  //5/8"

//define the layout  
$labelDef:=""
$labelDef:=$labelDef+$startLabel+$cr
$labelDef:=$labelDef+$speed+$cr
$labelDef:=$labelDef+$home+$cr
$labelDef:=$labelDef+"^DFR:ARKAY128.ZPL^FS"+$cr  //give the template a name

//Graphics--------------------------------------
$labelDef:=$labelDef+ZebraLabelGrid("at"; 1; 1)
$labelDef:=$labelDef+$boxOutline+$cr

//Labels--------------------------------------
$labelDef:=$labelDef+ZebraLabelGrid("at"; 55; $col1)
$labelDef:=$labelDef+$font14+$b+"Description:"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 50; $col1)
$labelDef:=$labelDef+$font14+$b+"Code:"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 38; $col1)
$labelDef:=$labelDef+$font14+$b+"Quantity:"+$e

//PO NUMBER

$labelDef:=$labelDef+ZebraLabelGrid("at"; 30; $col1)  //*****
$labelDef:=$labelDef+$font14+$b+"Lot No:"+$e  //*****

$labelDef:=$labelDef+ZebraLabelGrid("at"; 21; $col1)
$labelDef:=$labelDef+$font14+$b+"Vendor: ARKAY PACKAGING CORPORATION"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 16; $col1)
$labelDef:=$labelDef+$font14+$b+"Vendor Case:"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 1; $col1)
$labelDef:=$labelDef+$font14+$b+"Date:"+$e


//Data--------------------------------------
$labelDef:=$labelDef+ZebraLabelGrid("at"; 55; $col2+6)  //DESC
$labelDef:=$labelDef+$font14t+"^FN1"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 50; $col2-4)  //SKU
$labelDef:=$labelDef+$font14b+"^FN2"+$e
$labelDef:=$labelDef+ZebraLabelGrid("at"; 43; $colbc)  //SKU BC
$labelDef:=$labelDef+$bcode39+"^FN3"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 38; $col2)  //qty
$labelDef:=$labelDef+$font14b+"^FN4"+$e
$labelDef:=$labelDef+ZebraLabelGrid("at"; 35; $colbc+16)  //qty *****
$labelDef:=$labelDef+$bcode39+"^FN5"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 37; $col3)  //certified
$labelDef:=$labelDef+$font18+"^FN6"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 33; $col3)  //item
$labelDef:=$labelDef+$font18+"^FN7"+$e


$labelDef:=$labelDef+ZebraLabelGrid("at"; 26; $col1)  //lot no
$labelDef:=$labelDef+$font14+"^FN8"+$e
$labelDef:=$labelDef+ZebraLabelGrid("at"; 26; $colbc+6)  //lot no *****
$labelDef:=$labelDef+$bcode39+"^FN9"+$e


$labelDef:=$labelDef+ZebraLabelGrid("at"; 16; $col2+6)  //case number
$labelDef:=$labelDef+$font14b+"^FN10"+$e
$labelDef:=$labelDef+ZebraLabelGrid("at"; 7; $colBC)  //HUMAN READABLE
$labelDef:=$labelDef+$bcode128+"^FN11"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 1; $col2-4)  //DATE
$labelDef:=$labelDef+$font14+"^FN12"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 1; $col3)  //OF
$labelDef:=$labelDef+$font14+"^FN13"+$e

$labelDef:=$labelDef+$endLabel+$cr+$cr

$0:=$labelDef  //SEND PACKET($labelDef)