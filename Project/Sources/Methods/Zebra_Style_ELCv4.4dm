//%attributes = {}
// -------
// Method: Zebra_Style_ELCv4   ( ) ->
// By: Mel Bohince @ 05/01/18, 14:30:20
// Description
// 
// ----------------------------------------------------
// Modified by: Mel Bohince (5/6/18) remove prod-date and batch (caseid) codes, add COL
// Modified by: Mel Bohince (5/11/18) chg barcode ratios, remove C39 pre/post "*" from data

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

C_LONGINT:C283($col1; $col2; $col3; $col4; $col5; $col6; $col7)

//columns, starting from left to right viewed in landscape
$col1:=5
$col2:=12
$col3:=18
$col4:=32
$col5:=31
$col6:=32
$col7:=54
$col8:=74  // Modified by: Mel Bohince (5/6/18) add 'COL'

//rows, starting from the bottom of the label viewed in landscape
C_LONGINT:C283($row1; $row2; $row3; $row4; $row5; $row6; $row7; $row8)
$row1:=1
$row2:=9
$row3:=15
$row4:=23
$row5:=30
$row6:=38
$row7:=45
$row8:=53

//$font14:="^A0R,50,40"  //"^A0R,60,48"
zFont12inverted:="^A0I,50,40"

//barcodes
zBcode39:="^BY4,2^B3R,N,103,N,N"
//zBcode39narrow:="^BY3,2^B3R,N,103,N,N"  // Modified by: Mel Bohince (5/11/18) 
zBcode39wide:="^BY5,2^B3R,N,103,N,N"  // Modified by: Mel Bohince (5/11/18) 
//$bcode128:="^BY5,3^BCR,103,N,N,N,A"
zBcode39inverted:="^BY5^B3I,N,103,N,N"
C_LONGINT:C283($xT; $yT; $edge; $x; $y)
//label boundary
//$xT:=812  //4"
//$yT:=1218  //6"
//  //boarder area
//$edge:=13  //.0625    1/16"
//$x:=$xT-(3*$edge)
//$y:=$yT-(2*$edge)
$x:=75
$y:=320

//graphics
$lineWeight:="60"
$boxOutline:="^GB"+String:C10($x)+","+String:C10($y)+","+$lineWeight+"^FS"
//$lineBisect:="^GB0,"+String($y)+","+$lineWeight+"^FS"

//define the layout  
$labelDef:=""
$labelDef:=$labelDef+$startLabel+$cr
$labelDef:=$labelDef+$speed+$cr
$labelDef:=$labelDef+$home+$cr
$labelDef:=$labelDef+"^DFR:elcv4.ZPL^FS"+$cr  //give the template a name

//Graphics--------------------------------------
//$labelDef:=$labelDef+ZebraLabelGrid ("at";1;1)
//$labelDef:=$labelDef+$boxOutline+$cr

//$labelDef:=$labelDef+ZebraLabelGrid ("at";$row2;$col6;4;-4)
//$labelDef:=$labelDef+$boxOutline+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; $row4; $col6; 4; -4)
$labelDef:=$labelDef+$boxOutline+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; $row6; $col6; 4; -4)
$labelDef:=$labelDef+$boxOutline+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; $row8; $col6; 4; -4)
$labelDef:=$labelDef+$boxOutline+$e


//Labels--------------------------------------

//$labelDef:=$labelDef+ZebraLabelGrid ("at";$row1;$col1)//inlined with fn9 below
//$labelDef:=$labelDef+$font12+$b+"PROD-DATE"+$e

//$labelDef:=$labelDef+ZebraLabelGrid ("at";$row2;$col6)
//$labelDef:=$labelDef+"^FR"+zFont12+$b+"BATCH"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; $row4; $col6)
$labelDef:=$labelDef+"^FR"+zFont12+$b+"QTY"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; $row4; $col8)
$labelDef:=$labelDef+"^FR"+zFont12+$b+mfg_code+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; $row6; $col6)
$labelDef:=$labelDef+"^FR"+zFont12+$b+"ITEM CODE"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; $row8; $col6)
$labelDef:=$labelDef+"^FR"+zFont12+$b+"EURO CODE"+$e




//Data--------------------------------------

//$labelDef:=$labelDef+ZebraLabelGrid ("at";$row1;$col4)  //caseid
//$labelDef:=$labelDef+$bcode128+"^FN1"+$e
//$labelDef:=$labelDef+ZebraLabelGrid ("at";$row2;$col7)  //caseid
//$labelDef:=$labelDef+zFont12+"^FN2"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; $row3; $col5)  //qty
$labelDef:=$labelDef+zBcode39wide+"^FN1"+$e
$labelDef:=$labelDef+ZebraLabelGrid("at"; $row4; $col7)  //qty
$labelDef:=$labelDef+zFont12+"^FN2"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; $row5; $col5)  //item code
$labelDef:=$labelDef+zBcode39+"^FN3"+$e
$labelDef:=$labelDef+ZebraLabelGrid("at"; $row6; $col7)  //item code
$labelDef:=$labelDef+zFont12+"^FN4"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; $row7; $col5)  //euro code
$labelDef:=$labelDef+zBcode39+"^FN5"+$e  //zBcode39narrow fails on verification test
$labelDef:=$labelDef+ZebraLabelGrid("at"; $row8; $col7)  //euro code
$labelDef:=$labelDef+zFont12+"^FN6"+$e

//$labelDef:=$labelDef+ZebraLabelGrid ("at";$row1;$col1)  //dom
//$labelDef:=$labelDef+$font12+"^FN9"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; $row4; $col2)  //material code
$labelDef:=$labelDef+zFont14inverted+"^FN7"+$e
$labelDef:=$labelDef+ZebraLabelGrid("at"; $row3; $col3)  //material code
$labelDef:=$labelDef+zBcode39inverted+"^FN8"+$e


$labelDef:=$labelDef+$endLabel+$cr+$cr

$0:=$labelDef  //SEND PACKET($labelDef)