//%attributes = {}
// -------
// Method: Zebra_Style_Nest   ( ) ->
// By: Andrew Byrud @ 07/23/19, 9:29:41
// Description
// based on Zebra_Style_Shiseido
// --------------------------------------------------


//*Init vars
C_TEXT:C284($lableDef; $0)
C_TEXT:C284($s; $e; $cr; $startLabel; $endLabel; $home; $printQty; $speed)
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
$col3:=23
$col3_5:=40
$col4:=55
$col5:=65


//define the layout  
$labelDef:=""
$labelDef:=$labelDef+$startLabel+$cr
$labelDef:=$labelDef+$speed+$cr
$labelDef:=$labelDef+$home+$cr
$labelDef:=$labelDef+"^DFR:nest.ZPL^FS"+$cr  //give the template a name

//Graphics--------------------------------------
$labelDef:=$labelDef+ZebraLabelGrid("at"; 1; 1)
$labelDef:=$labelDef+zBoxOutline+$cr

$labelDef:=$labelDef+ZebraLabelGrid("at"; 16; 1)
$labelDef:=$labelDef+zLineBisect+$cr
$labelDef:=$labelDef+ZebraLabelGrid("at"; 17; 1)
$labelDef:=$labelDef+zLineBisect+$cr
$labelDef:=$labelDef+ZebraLabelGrid("at"; 32; 1)
$labelDef:=$labelDef+zLineBisect+$cr
$labelDef:=$labelDef+ZebraLabelGrid("at"; 46; 1)
$labelDef:=$labelDef+zLineBisect+$cr


//Labels--------------------------------------

$labelDef:=$labelDef+ZebraLabelGrid("at"; 5; $col1)  //;-8;0
$labelDef:=$labelDef+zFont12+$b+"Made in"+$e
$labelDef:=$labelDef+ZebraLabelGrid("at"; 2; $col1)  //;-8;0
$labelDef:=$labelDef+zFont12+$b+"USA"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 10; $col4)
$labelDef:=$labelDef+zFont14+$b+"DOM:"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 10; $col1)  //;-8;0
$labelDef:=$labelDef+zFont14+$b+"ARKAY PACKAGING"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 19; $col4)
$labelDef:=$labelDef+zFont12+$b+"WGT:"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 27; $col4)
$labelDef:=$labelDef+zFont12+$b+"QTY:"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 27; $col1)
$labelDef:=$labelDef+zFont12+$b+"BATCH:"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 34; $col1)
$labelDef:=$labelDef+zFont12+$b+"DESC:"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 38; $col4)
$labelDef:=$labelDef+zFont12+$b+"UPC:"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 41; $col1)
// Modified by: Mel Bohince (3/9/20) change Nest SKU to just SKU
$labelDef:=$labelDef+zFont12+$b+"SKU:"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 48; $col3_5-1)  //+4
$labelDef:=$labelDef+zFont12+$b+"PO:"+$e

//$labelDef:=$labelDef+ZebraLabelGrid ("at";53;$col1)
// Modified by: Mel Bohince (3/9/20) use field, not hardcode
//$labelDef:=$labelDef+zFont12+$b+"NEST FRAGRANCES"+$e

//Data--------------------------------------

$labelDef:=$labelDef+ZebraLabelGrid("at"; 1; $col3; 8; 0)  //caseid barcode
$labelDef:=$labelDef+zBcode128+"^FN1"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 10; $col3_5)  //case #
$labelDef:=$labelDef+zFont14+"^FN2"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 10; $col5)  //dom
$labelDef:=$labelDef+zFont14+"^FN3"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 20; $col1+2; 5; 0)  //Batch Barcode
$labelDef:=$labelDef+zBcode39short+"^FN4"+$e
$labelDef:=$labelDef+ZebraLabelGrid("at"; 27; $col2)  //Batch
$labelDef:=$labelDef+zFont12+"^FN5"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 19; $col5)  //wgt #
$labelDef:=$labelDef+zFont12+"^FN6"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 27; $col5)  //qty #
$labelDef:=$labelDef+zFont12+"^FN7"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 34; $col2)  //Description
$labelDef:=$labelDef+zFont12+"^FN8"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 41; $col2)  //Nest SKU
$labelDef:=$labelDef+zFont12+"^FN9"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 39; $col5)  //UPC Barcode
$labelDef:=$labelDef+zBcodeUPC_A+"^FN10"+$e
$labelDef:=$labelDef+ZebraLabelGrid("at"; 32; $col5)  //UPC 
$labelDef:=$labelDef+zFont12+"^FN11"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 53; $col3_5+5)  //PO Barcode
$labelDef:=$labelDef+zBcode39short+"^FN12"+$e
$labelDef:=$labelDef+ZebraLabelGrid("at"; 48; $col3_5+5)  //PO Barcode # //;5;5
$labelDef:=$labelDef+zFont12+"^FN13"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 53; $col1)  //cust
$labelDef:=$labelDef+zFont14b+"^FN14"+$e

$labelDef:=$labelDef+$endLabel+$cr+$cr

$0:=$labelDef  //SEND PACKET($labelDef)