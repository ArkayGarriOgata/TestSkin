//%attributes = {"publishedWeb":true}
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
$labelDef:=$labelDef+"^DFR:MH10_8.ZPL^FS"+$cr  //give the template a name

//Graphics--------------------------------------
$labelDef:=$labelDef+ZebraLabelGrid("at"; 1; 1)  //0 from
$labelDef:=$labelDef+zBoxOutline+$cr

$labelDef:=$labelDef+ZebraLabelGrid("at"; 1; 15)  //1" to
$labelDef:=$labelDef+zLineBisectH+$cr

$labelDef:=$labelDef+ZebraLabelGrid("at"; 1; 29)  //2" po
$labelDef:=$labelDef+zLineBisectH+$cr

$labelDef:=$labelDef+ZebraLabelGrid("at"; 1; 43)  //3"part
$labelDef:=$labelDef+zLineBisectH+$cr

$labelDef:=$labelDef+ZebraLabelGrid("at"; 1; 57)  //4"desc
$labelDef:=$labelDef+zLineBisectH+$cr

$labelDef:=$labelDef+ZebraLabelGrid("at"; 1; 62)  //5"qty
$labelDef:=$labelDef+zLineBisectH+$cr

$labelDef:=$labelDef+ZebraLabelGrid("at"; 1; 76)  //6"lot
$labelDef:=$labelDef+zLineBisectH+$cr

$labelDef:=$labelDef+ZebraLabelGrid("at"; 47; 62)  //4" x 2"
$labelDef:=$labelDef+zLineVert+$cr

//Labels--------------------------------------
$labelDef:=$labelDef+ZebraLabelGrid("at"; $col1; 2)  //0
$labelDef:=$labelDef+zFont12N+$b+"FROM:"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; $col1; 16)  //1
$labelDef:=$labelDef+zFont12N+$b+"TO:"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; $col1; 30)  //2
$labelDef:=$labelDef+zFont12N+$b+"P.O.:"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; $col1; 44)  //3
$labelDef:=$labelDef+zFont12N+$b+"ITEM:"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; $col1; 58)  //4
$labelDef:=$labelDef+zFont12N+$b+"DESC:"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; $col1; 63)  //5
$labelDef:=$labelDef+zFont12N+$b+"QTY:"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; $col1; 77)  //6
$labelDef:=$labelDef+zFont12N+$b+"LOT:"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 48; 63)
$labelDef:=$labelDef+zFont12N+$b+"DATE:"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 48; 77)
$labelDef:=$labelDef+zFont12N+$b+"CASE:"+$e

//Data section--------------------------------------


$labelDef:=$labelDef+ZebraLabelGrid("at"; $col2; 2)  //0
$labelDef:=$labelDef+zFont18N+"^FN1"+$e
$labelDef:=$labelDef+ZebraLabelGrid("at"; $col2; 7)  //0
$labelDef:=$labelDef+zFont12N+"^FN2"+$e
$labelDef:=$labelDef+ZebraLabelGrid("at"; $col2; 11)  //0
$labelDef:=$labelDef+zFont12N+"^FN3"+$e


$labelDef:=$labelDef+ZebraLabelGrid("at"; $colTo; 16)  //1to
$labelDef:=$labelDef+zFont18N+"^FN4"+$e
$labelDef:=$labelDef+ZebraLabelGrid("at"; $colTo; 21)  //1
$labelDef:=$labelDef+zFont12N+"^FN5"+$e
$labelDef:=$labelDef+ZebraLabelGrid("at"; $colTo; 25)  //1
$labelDef:=$labelDef+zFont12N+"^FN6"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; $col2; 30)  //2po
$labelDef:=$labelDef+zFont14N+"^FN7"+$e
$labelDef:=$labelDef+ZebraLabelGrid("at"; $colBC; 35)  //2
$labelDef:=$labelDef+zBcode39N+"^FN8"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; $col2; 44)  //3 item
$labelDef:=$labelDef+zFont14N+"^FN9"+$e
$labelDef:=$labelDef+ZebraLabelGrid("at"; $colBC; 49)  //2
$labelDef:=$labelDef+zBcode39N+"^FN10"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; $col2; 58)  //4
$labelDef:=$labelDef+zFont12N+"^FN11"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; $col2; 63)  //5
$labelDef:=$labelDef+zFont14N+"^FN12"+$e
$labelDef:=$labelDef+ZebraLabelGrid("at"; $colBC; 68)  //5
$labelDef:=$labelDef+zBcode39N+"^FN13"+$e


$labelDef:=$labelDef+ZebraLabelGrid("at"; $colBC; 82)  //6
$labelDef:=$labelDef+zBcode128N+"^FN15"+$e
$labelDef:=$labelDef+ZebraLabelGrid("at"; $col1; 88)  //6
$labelDef:=$labelDef+zFont12N+"^FN14"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 49; 70)  //date
$labelDef:=$labelDef+zFont12N+"^FN16"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 52; 85)  //case
$labelDef:=$labelDef+zFont14N+"^FN17"+$e

$labelDef:=$labelDef+$endLabel+$cr+$cr

//SEND PACKET($labelDef)
$0:=$labelDef