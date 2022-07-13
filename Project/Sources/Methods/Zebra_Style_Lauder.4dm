//%attributes = {"publishedWeb":true}
//PM: Zebra_Style_Lauder() -> 
//@author mlb - 11/14/01  14:23

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
$fo:=ZebraLabelGrid("init")
$col1:=1
$col2:=6
$col3:=30
$col4:=35

C_TEXT:C284($font12; $font14; $font18; $printQty; $bcode39; $bcode128)
$font12:="^A0R,55,43"
$font14:="^A0R60,48"
$font18:="^A0R75,60"
$font24:="^A0R120,100"
//graphics

//barcodes
$bcode39:="^BY3^B3R,N,103,N,N"
$bcode128:="^BY3^BCR,103,N,N,N,N"
$bcode39:="^BY4,2^B3R,N,103,N,N"
$bcode128:="^BY4,2^BCR,103,N,N,N,N"


$labelDef:=""
//define the layout  
$labelDef:=$labelDef+$startLabel+$cr
$labelDef:=$labelDef+$speed+$cr
$labelDef:=$labelDef+$home+$cr
$labelDef:=$labelDef+"^DFR:LAUDER.ZPL^FS"+$cr  //give the template a name

//Graphics--------------------------------------

//Labels--------------------------------------

$labelDef:=$labelDef+ZebraLabelGrid("at"; 28; $col1)
$labelDef:=$labelDef+$font12+$b+"CUST:"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 23; $col1)
$labelDef:=$labelDef+$font12+$b+"CODE:"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 15; $col1)
$labelDef:=$labelDef+$font12+$b+"DESC:"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 12; $col1)
$labelDef:=$labelDef+$font12+$b+"VEND:"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 10; $col1)
$labelDef:=$labelDef+$font12+$b+"JOB:"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 2; $col1)
$labelDef:=$labelDef+$font12+$b+"QTY:"+$e

//$labelDef:=$labelDef+ZebraLabelGrid ("at";10;$col3+1)
//$labelDef:=$labelDef+$font12+$b+"PO#:"+$e
If (Length:C16(sOF)>0)
	$labelDef:=$labelDef+ZebraLabelGrid("at"; 7; $col3+4)
	$labelDef:=$labelDef+$font12+$b+"O/F:"+$e
End if 

$labelDef:=$labelDef+ZebraLabelGrid("at"; 4; $col3+4)
$labelDef:=$labelDef+$font12+$b+"DATE:"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 1; $col3+4)
$labelDef:=$labelDef+$font12+$b+"CASE#:"+$e


//Data--------------------------------------
$labelDef:=$labelDef+ZebraLabelGrid("at"; 27; $col2)  //from
$labelDef:=$labelDef+$font24+"^FN1"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 22; $col2)  //cpn
$labelDef:=$labelDef+$font24+"^FN2"+$e
$labelDef:=$labelDef+ZebraLabelGrid("at"; 18; $col2)  //cpn
$labelDef:=$labelDef+$bcode39+"^FN3"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 15; $col2)  //desc
$labelDef:=$labelDef+$font18+"^FN4"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 12; $col2)  //vend
$labelDef:=$labelDef+$font12+"^FN5"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 10; $col2)  //job
$labelDef:=$labelDef+$font18+"^FN6"+$e
$labelDef:=$labelDef+ZebraLabelGrid("at"; 6; $col2)
$labelDef:=$labelDef+$bcode128+"^FN7"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 1; $col2)  //qty
$labelDef:=$labelDef+$font24+"^FN8"+$e
$labelDef:=$labelDef+ZebraLabelGrid("at"; 1; $col2+12)  //qty
$labelDef:=$labelDef+$bcode39+"^FN9"+$e

//$labelDef:=$labelDef+ZebraLabelGrid ("at";10;$col4)  `po
//$labelDef:=$labelDef+$font14+"^FN10"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 7; $col4+4)  //of
$labelDef:=$labelDef+$font18+"^FN10"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 4; $col4+4)  //date
$labelDef:=$labelDef+$font18+"^FN11"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 1; $col4+6)  //case
$labelDef:=$labelDef+$font18+"^FN12"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 21; $col3+8)  //certified
$labelDef:=$labelDef+$font18+"^FN13"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; 19; $col3+8)  //item
$labelDef:=$labelDef+$font18+"^FN14"+$e

$labelDef:=$labelDef+$endLabel+$cr+$cr

$0:=$labelDef  //SEND PACKET($labelDef)