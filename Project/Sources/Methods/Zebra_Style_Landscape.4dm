//%attributes = {"publishedWeb":true}
//PM: Zebra_Style_Landscape() -> 
//@author mlb - 11/13/01  15:45

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
$col2:=13
$col3:=65
$col4:=75

C_TEXT:C284($font12; $font14; $font18; $font24; $printQty; $bcode39; $bcode128)
$font12:="^A0R,55,43"
$font14:="^A0R60,48"
$font18:="^A0R75,60"
$font24:="^A0R105,85"

//barcodes
$bcode39:="^BY3^B3R,N,103,N,N"
$bcode128:="^BY3^BCR,103,N,N,N,N"
$bcode39:="^BY4,2^B3R,N,103,N,N"
$bcode128:="^BY4,2^BCR,103,N,N,N,N"

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

$labelDef:=$labelDef+ZebraLabelGrid("at"; 28; 1)  //2"
$labelDef:=$labelDef+$lineBisect+$cr

$labelDef:=$labelDef+ZebraLabelGrid("at"; 1; 64)  //4" x 2"
$labelDef:=$labelDef+$lineHorz+$cr

//Labels--------------------------------------
$labelDef:=$labelDef+ZebraLabelGrid("at"; 56; $col1)
$labelDef:=$labelDef+$font12+$b+"FROM:"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 50; $col1)
$labelDef:=$labelDef+$font12+$b+"TO:"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 43; $col1)
$labelDef:=$labelDef+$font12+$b+"ITEM:"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 28; $col1)
$labelDef:=$labelDef+$font12+$b+"DESC:"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 23; $col1)
$labelDef:=$labelDef+$font12+$b+"QTY:"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 9; $col1)
$labelDef:=$labelDef+$font12+$b+"LOT:"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 23; $col3)
$labelDef:=$labelDef+$font12+$b+"PO:"+$e

If (Length:C16(sOF)>0)
	$labelDef:=$labelDef+ZebraLabelGrid("at"; 17; $col3)
	$labelDef:=$labelDef+$font12+$b+"O/F:"+$e
	
	$labelDef:=$labelDef+ZebraLabelGrid("at"; 17; $col4+10)
	$labelDef:=$labelDef+$font12+$b+"(avg)"+$e
End if 

$labelDef:=$labelDef+ZebraLabelGrid("at"; 10; $col3)
$labelDef:=$labelDef+$font12+$b+"DATE:"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 3; $col3)
$labelDef:=$labelDef+$font12+$b+"CASE:"+$e

//Data--------------------------------------
$labelDef:=$labelDef+ZebraLabelGrid("at"; 56; $col2)  //from
$labelDef:=$labelDef+$font12+"^FN1"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 48; $col2)  //to
$labelDef:=$labelDef+$font24+"^FN2"+$e


$labelDef:=$labelDef+ZebraLabelGrid("at"; 41; $col2)  //cpn
$labelDef:=$labelDef+$font24+"^FN3"+$e
$labelDef:=$labelDef+ZebraLabelGrid("at"; 34; $col2)
$labelDef:=$labelDef+$bcode39+"^FN4"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 28; $col2)  //desc
$labelDef:=$labelDef+$font12+"^FN5"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 21; $col2)  //qty
$labelDef:=$labelDef+$font24+"^FN6"+$e
$labelDef:=$labelDef+ZebraLabelGrid("at"; 14; $col2)
$labelDef:=$labelDef+$bcode39+"^FN7"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 9; $col2)  //lot
$labelDef:=$labelDef+$font18+"^FN9"+$e
$labelDef:=$labelDef+ZebraLabelGrid("at"; 2; $col2-5)
$labelDef:=$labelDef+$bcode128+"^FN10"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 23; $col4-4)  //po
$labelDef:=$labelDef+$font12+"^FN8"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 17; $col4)
$labelDef:=$labelDef+$font18+"^FN12"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 10; $col4)
$labelDef:=$labelDef+$font18+"^FN13"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 1; $col4)
$labelDef:=$labelDef+$font24+"^FN11"+$e

$labelDef:=$labelDef+$endLabel+$cr+$cr

$0:=$labelDef  //SEND PACKET($labelDef)