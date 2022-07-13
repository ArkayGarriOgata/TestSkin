//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 02/28/08, 14:24:31
// ----------------------------------------------------
// Method: Zebra_Style_Skid_SSCC
// Description
// 

// see also: Zebra_Style_Arkay
//skidLableText
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
$colBC:=10

//define the layout  
$labelDef:=""
$labelDef:=$labelDef+$startLabel+$cr
$labelDef:=$labelDef+$speed+$cr
$labelDef:=$labelDef+$home+$cr
$labelDef:=$labelDef+"^DFR:SSCC.ZPL^FS"+$cr  //give the template a name

//Graphics--------------------------------------
$labelDef:=$labelDef+ZebraLabelGrid("at"; 1; 1)
$labelDef:=$labelDef+zBoxOutline+$cr

$labelDef:=$labelDef+ZebraLabelGrid("at"; 36; 1)  //@2.5"
$labelDef:=$labelDef+zLineBisect+$cr

//Labels--------------------------------------
$labelDef:=$labelDef+ZebraLabelGrid("at"; 55; $colBC+10)
$labelDef:=$labelDef+zFont14b+$b+"ARKAY PACKAGING"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 2; $col2)
$labelDef:=$labelDef+zFont14+$b+"ORIGIN: UNITED STATES OF AMERICA"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 12; $col2)
$labelDef:=$labelDef+zFont24+$b+skidLableText+$e

//Data--------------------------------------
$labelDef:=$labelDef+ZebraLabelGrid("at"; 44; $colBC+5)  //sscc number
$labelDef:=$labelDef+zBcode128+"^FN1"+$e
$labelDef:=$labelDef+ZebraLabelGrid("at"; 37; $colBC+10)  //HUMAN READABLE
$labelDef:=$labelDef+zFont14+"^FN2"+$e


$labelDef:=$labelDef+$endLabel+$cr+$cr

$0:=$labelDef  //SEND PACKET($labelDef)