//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 11/18/05, 10:11:02
// ----------------------------------------------------
// Method: Zebra_Style_Custom
// Description
// 
//
// Parameters
// ----------------------------------------------------
C_TEXT:C284($lableDef; $0)
C_TEXT:C284($s; $e; $cr; $startLabel; $endLabel; $home; $speed)
$cr:=Char:C90(13)+Char:C90(10)  //Linefeed and carriage return
$b:="^FD"  //begin data
$e:="^FS"+$cr  //end data
$startLabel:="^XA"
$printQty:="^PQ"+String:C10(iCnt)
$endLabel:=$printQty+"^XZ"
$speed:="^PR"+sCriterion1
$home:="^LH"+sCriterion2+","+sCriterion3
$zebraCRLF:=Char:C90(92)+Char:C90(38)  //"\&"

C_LONGINT:C283($xT; $yT; $edge; $x; $y; $inchInDots)
//label boundary  
$inchInDots:=203
$xT:=812  //4" WIDTH
If (rReal12=6)
	$yT:=1218  //6" LENGTH
Else 
	$yT:=2820  //14"
End if 
//boarder area
$edge:=13  //.0625    1/16"
$x:=$xT-(3*$edge)
$y:=$yT-(2*$edge)

$xOrigin:=String:C10($xT-(($inchInDots*rReal1)+($inchInDots*rReal3)); "####")  //labelwidth-(from top+fontheight)
$yOrigin:=String:C10(($inchInDots*rReal2); "####")

$widthProportion:=12/15
$fontHeight:=String:C10(($inchInDots*rReal3); "####")
$fontWidth:=String:C10(($inchInDots*rReal13); "####")  //String((($inchInDots*rReal3)*$widthProportion);"####")
C_TEXT:C284($font)
$font:="^A0R,"+$fontHeight+","+$fontWidth
If (rReal4>1)  //blockprint
	$xOrigin:=String:C10($xT-(($inchInDots*rReal1)+($inchInDots*(rReal3*rReal4))); "####")  //labelwidth-(from top+fontheight)
	$fb:="^FB"+String:C10(($yT-25); "####")+","+String:C10(rReal4)  //"^FB750,34,,"
	sDesc:=Replace string:C233(sDesc; Char:C90(13); $zebraCRLF)
Else 
	$fb:=""
	sDesc:=Replace string:C233(sDesc; Char:C90(13); ";")
End if 

//graphics
$lineWeight:="6"
$boxOutline:="^GB"+String:C10($x)+","+String:C10($y)+","+$lineWeight+"^FS"

$labelDef:=""
$labelDef:=$labelDef+$startLabel+$cr
$labelDef:=$labelDef+$speed+$cr
$labelDef:=$labelDef+$home+$cr

$labelDef:=$labelDef+"^FO13,13"
$labelDef:=$labelDef+$boxOutline+$cr

$labelDef:=$labelDef+"^FO"+$xOrigin+","+$yOrigin
$labelDef:=$labelDef+$font+$fb+$b+sDesc+$e

$labelDef:=$labelDef+$endLabel+$cr+$cr

$0:=$labelDef