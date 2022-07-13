//%attributes = {"publishedWeb":true}
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

C_TEXT:C284($fo)
C_LONGINT:C283($col1; $col2; $col3; $col4)
$fo:=ZebraLabelGrid("init"; 16)
$col1:=3
$col2:=15
$col3:=37
$col4:=70
$colBC:=12

C_TEXT:C284($font14; $font24; $printQty; $bcode39; $font14b)
$font14:="^A0R,60,54"
$font14b:="^A0R,60,48"
$font24:="^A0R,125,100"

//barcodes
$bcode39:="^BY5,2.5^B3R,N,180,N,N"

C_LONGINT:C283($xT; $yT; $edge; $x; $y)
//label boundary
$xT:=812  //4"
$yT:=1218  //6"
//boarder area
$edge:=13  //.0625    1/16"
$x:=$xT-(2*$edge)
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
$labelDef:=$labelDef+"^DFR:SIDEWAYS.ZPL^FS"+$cr  //give the template a name

//Graphics--------------------------------------
$labelDef:=$labelDef+ZebraLabelGrid("at"; 1; 1)
$labelDef:=$labelDef+$boxOutline+$cr

$labelDef:=$labelDef+ZebraLabelGrid("at"; 26; 1)  //1.5"
$labelDef:=$labelDef+$lineBisect+$cr

$labelDef:=$labelDef+ZebraLabelGrid("at"; 39; 1)  //@2.5"
$labelDef:=$labelDef+$lineBisect+$cr

//Labels--------------------------------------
$labelDef:=$labelDef+ZebraLabelGrid("at"; 40; $col1)
$labelDef:=$labelDef+$font14+$b+"CASE NUMBER:"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 33; $col1)
$labelDef:=$labelDef+$font14b+$b+"COUNTRY OF ORIGIN:"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 33; $col3)
$labelDef:=$labelDef+$font14+$b+"U.S.A."+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 27; $col4)
$labelDef:=$labelDef+$font24+$b+"M.K.I."+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 27; $col1)
$labelDef:=$labelDef+$font14+$b+"MFG DATE:"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 20; $col1)
$labelDef:=$labelDef+$font14+$b+"SKU:"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 14; $col1)
$labelDef:=$labelDef+$font14+$b+"DESC:"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 8; $col1)
$labelDef:=$labelDef+$font14+$b+"LOT#:"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 2; $col1)
$labelDef:=$labelDef+$font14+$b+"QTY:"+$e

//Data--------------------------------------
$labelDef:=$labelDef+ZebraLabelGrid("at"; 46; $colBC)  //case number
$labelDef:=$labelDef+$bcode39+"^FN1"+$e
$labelDef:=$labelDef+ZebraLabelGrid("at"; 40; $col3)
$labelDef:=$labelDef+$font14+"^FN2"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 27; $col3)  //date
$labelDef:=$labelDef+$font14+"^FN3"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 20; $col2)  //cpn
$labelDef:=$labelDef+$font14+"^FN4"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 14; $col2)  //desc
$labelDef:=$labelDef+$font14b+"^FN5"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 8; $col2)  //lot
$labelDef:=$labelDef+$font14+"^FN6"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 2; $col2)  //qty
$labelDef:=$labelDef+$font14+"^FN7"+$e

$labelDef:=$labelDef+$endLabel+$cr+$cr

$0:=$labelDef  //SEND PACKET($labelDef)