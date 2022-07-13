//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 11/10/05, 10:48:02
// ----------------------------------------------------
// Method: Zebra_Style_Arkay
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
$col2:=14
$col3:=64
$col4:=78
$colBC:=16

//define the layout  
$labelDef:=""
$labelDef:=$labelDef+$startLabel+$cr
$labelDef:=$labelDef+$speed+$cr
$labelDef:=$labelDef+$home+$cr
$labelDef:=$labelDef+"^DFR:ARKAY128.ZPL^FS"+$cr  //give the template a name

//Graphics--------------------------------------
$labelDef:=$labelDef+ZebraLabelGrid("at"; 1; 1)
$labelDef:=$labelDef+zBoxOutline+$cr

$labelDef:=$labelDef+ZebraLabelGrid("at"; 23; 1)  //1.5"
$labelDef:=$labelDef+zLineBisect+$cr

$labelDef:=$labelDef+ZebraLabelGrid("at"; 39; 1)  //@2.5"
$labelDef:=$labelDef+zLineBisect+$cr

//Labels--------------------------------------
$labelDef:=$labelDef+ZebraLabelGrid("at"; 55; $colBC+10)
$labelDef:=$labelDef+zFont14b+$b+"ARKAY PACKAGING"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 34; $col2)
$labelDef:=$labelDef+zFont14+$b+"ORIGIN: UNITED STATES OF AMERICA"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 29; $col1)
$labelDef:=$labelDef+zFont14+$b+"LOT #:"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 24; $col1)
$labelDef:=$labelDef+zFont14+$b+"MFG ON:"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 17; $col1)
$labelDef:=$labelDef+zFont14+$b+"SKU:"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 12; $col1)
$labelDef:=$labelDef+zFont14+$b+"DESC:"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 7; $col1)
$labelDef:=$labelDef+zFont14+$b+"CUST:"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 29; $col3)
$labelDef:=$labelDef+zFont14+$b+"CASE #:"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 17; $col3)
$labelDef:=$labelDef+zFont14+$b+"    QTY:"+$e

//Data--------------------------------------
$labelDef:=$labelDef+ZebraLabelGrid("at"; 44; $colBC)  //case number
$labelDef:=$labelDef+zBcode128tall+"^FN1"+$e
$labelDef:=$labelDef+ZebraLabelGrid("at"; 39; $colBC+5)  //HUMAN READABLE
$labelDef:=$labelDef+zFont14+"^FN2"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 29; $col2+8)  //JMI
$labelDef:=$labelDef+zFont14b+"^FN3"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 24; $col2+8)  //DATE
$labelDef:=$labelDef+zFont14+"^FN4"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 17; $col2)  //SKU
$labelDef:=$labelDef+zFont14b+"^FN5"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 12; $col2)  //DESC
$labelDef:=$labelDef+zFont14t+"^FN6"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 7; $col2)  //CUST
$labelDef:=$labelDef+zFont14b+"^FN7"+$e


$labelDef:=$labelDef+ZebraLabelGrid("at"; 2; $col1)  //po
$labelDef:=$labelDef+zFont14+"^FN8"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 29; $col4)  //case#
$labelDef:=$labelDef+zFont14b+"^FN9"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 24; $col3)  //OF
$labelDef:=$labelDef+zFont14+"^FN10"+$e


$labelDef:=$labelDef+ZebraLabelGrid("at"; 17; $col4)  //qty
$labelDef:=$labelDef+zFont14b+"^FN11"+$e

$labelDef:=$labelDef+$endLabel+$cr+$cr

$0:=$labelDef  //SEND PACKET($labelDef)