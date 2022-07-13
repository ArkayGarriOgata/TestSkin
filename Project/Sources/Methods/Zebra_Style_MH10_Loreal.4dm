//%attributes = {}

// Method: Zebra_Style_MH10_Loreal ( )  -> 
// ----------------------------------------------------
// Author: Mel Bohince
// Created: 02/07/14, 14:45:46
// ----------------------------------------------------
// Description
// based on Zebra_Style_MH10
//
// ----------------------------------------------------

//PM: Zebra_Style_MH10() -> 
//@author mlb - 11/8/01  16:13

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

C_LONGINT:C283($col1; $col2)
$col1:=2
$col2:=12
$colTo:=8
$colBC:=6

//define the layout  
$labelDef:=""
$labelDef:=$labelDef+$startLabel+$cr
$labelDef:=$labelDef+$speed+$cr
$labelDef:=$labelDef+$home+$cr
$labelDef:=$labelDef+"^DFR:MH10_LL.ZPL^FS"+$cr  //give the template a name

//Graphics--------------------------------------
$labelDef:=$labelDef+ZebraLabelGrid("at"; 1; 1)  //0 from
$labelDef:=$labelDef+zBoxOutline+$cr

$labelDef:=$labelDef+ZebraLabelGrid("at"; 1; 15)  //1" to
$labelDef:=$labelDef+zLineBisect+$cr

$labelDef:=$labelDef+ZebraLabelGrid("at"; 1; 29)  //2" po
$labelDef:=$labelDef+zLineBisect+$cr

$labelDef:=$labelDef+ZebraLabelGrid("at"; 1; 43)  //3"part
$labelDef:=$labelDef+zLineBisect+$cr

$labelDef:=$labelDef+ZebraLabelGrid("at"; 1; 57)  //4"desc
$labelDef:=$labelDef+zLineBisect+$cr

$labelDef:=$labelDef+ZebraLabelGrid("at"; 1; 62)  //5"qty
$labelDef:=$labelDef+zLineBisect+$cr

$labelDef:=$labelDef+ZebraLabelGrid("at"; 1; 76)  //6"lot
$labelDef:=$labelDef+zLineBisect+$cr

//Labels--------------------------------------
$labelDef:=$labelDef+ZebraLabelGrid("at"; $col1; 2)  //0
$labelDef:=$labelDef+zFont12N+$b+"ITEM:"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; $col1; 16)  //1
$labelDef:=$labelDef+zFont12N+$b+"DESC:"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; $col1; 30)  //2
$labelDef:=$labelDef+zFont12N+$b+"PO:"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; $col1; 44)  //3
$labelDef:=$labelDef+zFont12N+$b+"QTY:"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; $col1; 58)  //4
$labelDef:=$labelDef+zFont12N+$b+"DOM:"+$e


$labelDef:=$labelDef+ZebraLabelGrid("at"; $col1; 77)  //6
$labelDef:=$labelDef+zFont12N+$b+"LOT:"+$e

//Data section--------------------------------------
$labelDef:=$labelDef+ZebraLabelGrid("at"; $col2; 7)  //item
$labelDef:=$labelDef+zFont12N+"^FN1"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; $col2; 21)  //desc
$labelDef:=$labelDef+zFont12N+"^FN2"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; $col2; 35)  //2po
$labelDef:=$labelDef+zFont12N+"^FN3"+$e


$labelDef:=$labelDef+ZebraLabelGrid("at"; $col2; 49)  //3 qty
$labelDef:=$labelDef+zFont12N+"^FN4"+$e


$labelDef:=$labelDef+ZebraLabelGrid("at"; $col2; 58)  //4
$labelDef:=$labelDef+zFont12N+"^FN5"+$e


$labelDef:=$labelDef+ZebraLabelGrid("at"; $col2; 77)  //6
$labelDef:=$labelDef+zFont14N+"^FN6"+$e
$labelDef:=$labelDef+ZebraLabelGrid("at"; $col2; 82)  //6
$labelDef:=$labelDef+zBcode128N+"^FN7"+$e


$labelDef:=$labelDef+$endLabel+$cr+$cr

$0:=$labelDef