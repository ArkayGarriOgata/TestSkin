//%attributes = {}
// -------
// Method: Zebra_Style_Shiseido   ( ) ->
// By: Mel Bohince @ 08/04/17, 16:12:41
// Description
// based on Zebra_Style_PnG
// ----------------------------------------------------
// Modified by: Mel Bohince (4/12/18) back from hiatus


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
$col2:=13
$col3:=25
$col3_5:=40
$col4:=60
$col5:=69
$col6:=73

//define the layout  
$labelDef:=""
$labelDef:=$labelDef+$startLabel+$cr
$labelDef:=$labelDef+$speed+$cr
$labelDef:=$labelDef+$home+$cr
$labelDef:=$labelDef+"^DFR:shiseido.ZPL^FS"+$cr  //give the template a name

//Graphics--------------------------------------
$labelDef:=$labelDef+ZebraLabelGrid("at"; 1; 1)
$labelDef:=$labelDef+zBoxOutline+$cr

$labelDef:=$labelDef+ZebraLabelGrid("at"; 16; 1)
$labelDef:=$labelDef+zLineBisect+$cr
$labelDef:=$labelDef+ZebraLabelGrid("at"; 26; 1)
$labelDef:=$labelDef+zLineBisect+$cr
$labelDef:=$labelDef+ZebraLabelGrid("at"; 36; 1)
$labelDef:=$labelDef+zLineBisect+$cr
$labelDef:=$labelDef+ZebraLabelGrid("at"; 46; 1)
$labelDef:=$labelDef+zLineBisect+$cr


//Labels--------------------------------------

$labelDef:=$labelDef+ZebraLabelGrid("at"; 5; $col1)  //;-8;0
$labelDef:=$labelDef+zFont12+$b+Zbra_tLabel_MadeInUSA+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 10; $col1)  //;-8;0
$labelDef:=$labelDef+zFont14+$b+Zbra_tLabel_Company+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 10; $col4)
$labelDef:=$labelDef+zFont14+$b+"PO#:"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 19; $col1; -8; 0)
$labelDef:=$labelDef+zFont12+$b+"QTY:"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 19; $col4)
$labelDef:=$labelDef+zFont12+$b+"DOM:"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 29; $col1; -8; 0)
$labelDef:=$labelDef+zFont12+$b+"UPC:"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 40; $col1; -8; 0)
$labelDef:=$labelDef+zFont12+$b+"Description:"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 55; $col1; -8; 0)
$labelDef:=$labelDef+zFont12+$b+"SKU #"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 55; $col4)
$labelDef:=$labelDef+zFont12+$b+Zbra_tLabel_LotBatch+$e

//Data--------------------------------------

$labelDef:=$labelDef+ZebraLabelGrid("at"; 1; $col3; 8; 0)  //caseid //;4;0
$labelDef:=$labelDef+zBcode128+"^FN1"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 10; $col3_5)  //case
$labelDef:=$labelDef+zFont14+"^FN2"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 10; $col5)  //po
$labelDef:=$labelDef+zFont14+"^FN3"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 17; $col2)
$labelDef:=$labelDef+zBcode39short+"^FN4"+$e
$labelDef:=$labelDef+ZebraLabelGrid("at"; 22; $col2)  //qty
$labelDef:=$labelDef+zFont12+"^FN5"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 19; $col5)  //date
$labelDef:=$labelDef+zFont12+"^FN6"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 27; $col2)  //upc
$labelDef:=$labelDef+zBcode39short+"^FN7"+$e
$labelDef:=$labelDef+ZebraLabelGrid("at"; 32; $col2)  //upc
$labelDef:=$labelDef+zFont12+"^FN8"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 42; $col3; -48; 0)  //desc
$labelDef:=$labelDef+zFont12+"^FN9"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 48; $col2; -16; -100)  //item
$labelDef:=$labelDef+zBcode39short+"^FN10"+$e
$labelDef:=$labelDef+ZebraLabelGrid("at"; 52; $col2)  //item
$labelDef:=$labelDef+zFont24+"^FN11"+$e

//$labelDef:=$labelDef+ZebraLabelGrid ("at";47;$col6;0;-80)  //lot, was 80
$labelDef:=$labelDef+ZebraLabelGrid("at"; 47; $col5; 0; -190)  //lot, was 80
$labelDef:=$labelDef+zBcode39short+"^FN12"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 55; $col6)
$labelDef:=$labelDef+zFont12+"^FN13"+$e

$labelDef:=$labelDef+$endLabel+$cr+$cr

$0:=$labelDef  //SEND PACKET($labelDef)