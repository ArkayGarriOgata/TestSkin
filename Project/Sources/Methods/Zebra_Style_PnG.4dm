//%attributes = {"publishedWeb":true}
//PM: Zebra_Style_PnG() -> 
//@author mlb - 11/14/01  14:23

//*Init vars
C_TEXT:C284($lableDef; $0)
C_TEXT:C284($e; $cr; $startLabel; $endLabel; $home; $printQty; $speed)
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
$col3:=65
$col4:=75



//define the layout  
$labelDef:=""
$labelDef:=$labelDef+$startLabel+$cr
$labelDef:=$labelDef+$speed+$cr
$labelDef:=$labelDef+$home+$cr
$labelDef:=$labelDef+"^DFR:PnG.ZPL^FS"+$cr  //give the template a name

//Graphics--------------------------------------
$labelDef:=$labelDef+ZebraLabelGrid("at"; 1; 1)
$labelDef:=$labelDef+zBoxOutline+$cr

$labelDef:=$labelDef+ZebraLabelGrid("at"; 54; 1)
$labelDef:=$labelDef+zLineBisect+$cr
$labelDef:=$labelDef+ZebraLabelGrid("at"; 37; 1)
$labelDef:=$labelDef+zLineBisect+$cr
$labelDef:=$labelDef+ZebraLabelGrid("at"; 24; 1)
$labelDef:=$labelDef+zLineBisect+$cr
$labelDef:=$labelDef+ZebraLabelGrid("at"; 11; 1)
$labelDef:=$labelDef+zLineBisect+$cr
$labelDef:=$labelDef+ZebraLabelGrid("at"; 6; 1)
$labelDef:=$labelDef+zLineBisect+$cr

$labelDef:=$labelDef+ZebraLabelGrid("at"; 24; 38)
$labelDef:=$labelDef+zLineDivider+$cr
$labelDef:=$labelDef+ZebraLabelGrid("at"; 24; 51)
$labelDef:=$labelDef+zLineDivider+$cr

$labelDef:=$labelDef+ZebraLabelGrid("at"; 11; 77)
$labelDef:=$labelDef+zLineDivider+$cr

//Labels--------------------------------------
$labelDef:=$labelDef+ZebraLabelGrid("at"; 56; $col1; -8; 0)
$labelDef:=$labelDef+zFont12+$b+"CUST:"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 49; $col1)
$labelDef:=$labelDef+zFont12+$b+"CODE:"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 32; $col1)
$labelDef:=$labelDef+zFont12+$b+"QTY:"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 19; $col1)
$labelDef:=$labelDef+zFont12+$b+"LOT:"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 6; $col1)
$labelDef:=$labelDef+zFont12+$b+"DESC:"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 1; $col1)
$labelDef:=$labelDef+zFont12+$b+"FROM:"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 32; 40)
$labelDef:=$labelDef+zFont12+$b+"DATE:"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 32; 52)
$labelDef:=$labelDef+zFont12+$b+"P.O.#:"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 19; 78)
$labelDef:=$labelDef+zFont12+$b+"CASE#:"+$e

//Data--------------------------------------
$labelDef:=$labelDef+ZebraLabelGrid("at"; 53; $col2; 0; 0)  //cust
$labelDef:=$labelDef+zFont24+"^FN1"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 45; $col2)  //item
$labelDef:=$labelDef+zFont24+"^FN2"+$e
$labelDef:=$labelDef+ZebraLabelGrid("at"; 38; $col2)
$labelDef:=$labelDef+zBcode39+"^FN3"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 32; $col2; 2; 0)  //qty
$labelDef:=$labelDef+zFont18+"^FN4"+$e
$labelDef:=$labelDef+ZebraLabelGrid("at"; 25; $col2-5)
$labelDef:=$labelDef+zBcode39+"^FN5"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 19; $col2; 2; 0)  //lot
$labelDef:=$labelDef+zFont18+"^FN6"+$e
$labelDef:=$labelDef+ZebraLabelGrid("at"; 12; $col2-1)
$labelDef:=$labelDef+zBcode128+"^FN7"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 6; $col2)  //desc
$labelDef:=$labelDef+zFont18+"^FN8"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 1; $col2)  //from
$labelDef:=$labelDef+zFont12+"^FN9"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 25; 39)  //date
$labelDef:=$labelDef+zFont12+"^FN10"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 25; 52)  //po
$labelDef:=$labelDef+zFont12+"^FN11"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 25; 78)  //of
$labelDef:=$labelDef+zFont18+"^FN13"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 11; 78)  //case
$labelDef:=$labelDef+zFont18+"^FN12"+$e  //was font 24


$labelDef:=$labelDef+ZebraLabelGrid("at"; 48; 70)  //code
$labelDef:=$labelDef+zFont12+"^FN14"+$e
$labelDef:=$labelDef+ZebraLabelGrid("at"; 41; 70)  //old
$labelDef:=$labelDef+zFont14+"^FN15"+$e

$labelDef:=$labelDef+$endLabel+$cr+$cr

$0:=$labelDef  //SEND PACKET($labelDef)