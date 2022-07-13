//%attributes = {}
// ----------------------------------------------------
// User name: Mel Bohince
// Created: 04/03/07, 16:16:39
// ----------------------------------------------------
// Method: Zebra_Style_LOreal()  --> 
// Description
// 
//
// ----------------------------------------------------

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
$col2:=14
$col3:=64
$col4:=78
$colBC:=12

C_TEXT:C284($font14; $font24; $printQty; $bcode39; $font14b)
$font14:="^A0R,60,54"
$font14b:="^A0R,60,67"
//$font14b:="^AVR,2,2"
$font14t:="^A0R,60,52"
$font24:="^A0R,125,100"

//barcodes
//$bcode128:="^BY5,2.5^B3R,N,180,N,N"
$bcode128:="^BY5,3^BCR,155,N,N,N,A"

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

$labelDef:=$labelDef+ZebraLabelGrid("at"; 23; 1)  //1.5"
$labelDef:=$labelDef+$lineBisect+$cr

$labelDef:=$labelDef+ZebraLabelGrid("at"; 39; 1)  //@2.5"
$labelDef:=$labelDef+$lineBisect+$cr

//Labels--------------------------------------
$labelDef:=$labelDef+ZebraLabelGrid("at"; 55; $colBC+10)
$labelDef:=$labelDef+$font14b+$b+"ARKAY PACKAGING"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 34; $col2)
$labelDef:=$labelDef+$font14+$b+"ORIGIN: UNITED STATES OF AMERICA"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 29; $col1)
$labelDef:=$labelDef+$font14+$b+"LOT #:"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 24; $col1)
$labelDef:=$labelDef+$font14+$b+"MFG ON:"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 17; $col1)
$labelDef:=$labelDef+$font14+$b+"CODE:"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 7; $col1)
$labelDef:=$labelDef+$font14+$b+"DESC:"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 2; $col1)
$labelDef:=$labelDef+$font14+$b+"CUST:"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 29; $col3)
$labelDef:=$labelDef+$font14+$b+"CASE #:"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 17; $col3)
$labelDef:=$labelDef+$font14+$b+"    QTY:"+$e

//Data--------------------------------------
$labelDef:=$labelDef+ZebraLabelGrid("at"; 44; $colBC)  //case number
$labelDef:=$labelDef+$bcode128+"^FN1"+$e
$labelDef:=$labelDef+ZebraLabelGrid("at"; 39; $colBC+10)  //HUMAN READABLE
$labelDef:=$labelDef+$font14+"^FN2"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 29; $col2+8)  //JMI
$labelDef:=$labelDef+$font14b+"^FN3"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 24; $col2+8)  //DATE
$labelDef:=$labelDef+$font14+"^FN4"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 17; $col2)  //code
$labelDef:=$labelDef+$font14b+"^FN5"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 12; $col1)  //new code
$labelDef:=$labelDef+$font14b+"^FN6"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 7; $col2)  //DESC
$labelDef:=$labelDef+$font14t+"^FN7"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 2; $col2)  //CUST
$labelDef:=$labelDef+$font14b+"^FN8"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 2; $col3-4)  //po
$labelDef:=$labelDef+$font14+"^FN9"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 29; $col4)  //case#
$labelDef:=$labelDef+$font14b+"^FN10"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 24; $col3)  //OF
$labelDef:=$labelDef+$font14+"^FN11"+$e


$labelDef:=$labelDef+ZebraLabelGrid("at"; 17; $col4)  //qty
$labelDef:=$labelDef+$font14b+"^FN12"+$e

$labelDef:=$labelDef+$endLabel+$cr+$cr

$0:=$labelDef  //SEND PACKET($labelDef)