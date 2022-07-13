//%attributes = {}
// -------
// Method: Zebra_Style_LVMH   ( ) ->
// By: Mel Bohince @ 05/17/18, 14:11:58
// Description
// 
// ----------------------------------------------------

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

C_TEXT:C284($fo)
C_LONGINT:C283($col1; $col2; $col3; $col4; $col5; $col6; $col7)
$fo:=ZebraLabelGrid("init"; 16)

//columns, starting from left to right viewed in landscape
$col1:=3
$col2:=5
$col3:=14
$col4:=19
$col5:=22
$col6:=31
$col7:=47
$col8:=82
$col9:=90


//rows, starting from the bottom of the label viewed in landscape
C_LONGINT:C283($row1; $row2; $row3; $row4; $row5; $row6; $row7; $row8)
$row1:=3
$row2:=18
$row3:=22
$row4:=37
$row5:=38
$row6:=47
$row7:=51
$row8:=56

C_TEXT:C284($font12; $font14; $font14v)
$font12:="^A0R,30,20"
$font14:="^A0R,50,40"  //"^A0R,60,48"
$font18:="^A3R,55,25"

//barcodes
$bcode128:="^BY5,3^BCR,140,N,N,N,A"
$bcodeEANinverted:="^BY3^BEI,103,Y,N"

//graphics
$lineVertical:="^GB750,1,8^FS"  //"^GB0"+String($x)+","+$lineWeight+"^FS"
$lineHorzontal:="^GB1,1135,8^FS"  //"^GB,"+String($y)+",0,"+$lineWeight+"^FS"

//define the layout  
$labelDef:=""
$labelDef:=$labelDef+$startLabel+$cr
$labelDef:=$labelDef+$speed+$cr
$labelDef:=$labelDef+$home+$cr
$labelDef:=$labelDef+"^DFR:LVMH.ZPL^FS"+$cr  //give the template a name

//Graphics--------------------------------------
$labelDef:=$labelDef+ZebraLabelGrid("at"; $row4; $col1)
$labelDef:=$labelDef+$lineHorzontal+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; $row1; $col9)
$labelDef:=$labelDef+$lineVertical+$e



//Labels--------------------------------------

//$labelDef:=$labelDef+ZebraLabelGrid ("at";$row1;$col1)//inlined with fn9 below
//$labelDef:=$labelDef+$font12+$b+"PROD-DATE"+$e

//$labelDef:=$labelDef+ZebraLabelGrid ("at";$row2;$col6)
//$labelDef:=$labelDef+"^FR"+$font14+$b+"BATCH"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; $row1; $col1)
$labelDef:=$labelDef+"^FR"+$font12+$b+"arkay v0.2"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; $row5; $col1)
$labelDef:=$labelDef+"^FR"+$font14+$b+"GTIN:"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; $row6; $col1)
$labelDef:=$labelDef+"^FR"+$font14+$b+"QTY:"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; $row7; $col1)
$labelDef:=$labelDef+"^FR"+$font14+$b+"BATCH:"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; $row8; $col6)
$labelDef:=$labelDef+"^FR"+$font14+$b+"ORDER:"+$e




//Data--------------------------------------

//$labelDef:=$labelDef+ZebraLabelGrid ("at";$row1;$col4)  //caseid
//$labelDef:=$labelDef+$bcode128+"^FN1"+$e
//$labelDef:=$labelDef+ZebraLabelGrid ("at";$row2;$col7)  //caseid
//$labelDef:=$labelDef+$font14+"^FN2"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; $row2; $col5)  //readible GS1
$labelDef:=$labelDef+$font14+"^FN1"+$e
$labelDef:=$labelDef+ZebraLabelGrid("at"; $row3; $col2)  //GS1
$labelDef:=$labelDef+$bcode128+"^FN2"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; $row5; $col3)  //GTIN
$labelDef:=$labelDef+$font14+"^FN3"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; $row6; $col3)  //qty
$labelDef:=$labelDef+$font14+"^FN4"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; $row6; $col6)  //desc
$labelDef:=$labelDef+$font14+"^FN5"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; $row7; $col3)  //batch
$labelDef:=$labelDef+$font14+"^FN6"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; $row8; $col1)  //cpn
$labelDef:=$labelDef+$font18+"^FN7"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; $row8; $col7)  //po
$labelDef:=$labelDef+$font14+"^FN8"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; $row1; $col8)  //ean13
$labelDef:=$labelDef+$bcodeEANinverted+"^FN9"+$e

$labelDef:=$labelDef+$endLabel+$cr+$cr

$0:=$labelDef  //SEND PACKET($labelDef)