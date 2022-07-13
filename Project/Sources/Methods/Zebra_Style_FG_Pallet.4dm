//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 11/16/05, 11:48:26
// ----------------------------------------------------
// Method: Zebra_Style_FG_Pallet
// Description
// 
//
// Parameters
// ----------------------------------------------------


//*Init vars
C_TEXT:C284($lableDef; $0)
C_TEXT:C284($s; $e; $cr; $startLabel; $endLabel; $home; $speed)
$cr:=Char:C90(13)+Char:C90(10)  //Linefeed and carriage return
$b:="^FD"  //begin data
$e:="^FS"+$cr  //end data
$startLabel:="^XA"
$endLabel:="^XZ"
$speed:="^PR"+zebraSpeed
$home:="^LH"+zebraOffsetX+","+zebraOffsetY

C_TEXT:C284($fo)
C_LONGINT:C283($col1; $col2)
$fo:=ZebraLabelGrid("init"; 16)
$col1:=2
$col2:=4
$col3:=10
$col4:=16
$col5:=32

C_TEXT:C284($fontS; $fontM; $fontL; $fontXL; $bcode128)
$fontS:="^A0N,30,30"
$fontM:="^A0N60,60"
$fontMC:="^A0N60,45"
$fontL:="^A0N102,90"
$fontXL:="^A0N135,135"
$fontML:="^ADN,36,20"
$bcode128:="^BY3,3^BCN,230,N,N,N,A"

C_LONGINT:C283($xT; $yT; $edge; $x; $y)
//label boundary
$xT:=800  //4"
$yT:=2820  //14"
//boarder area
$edge:=13  //.0625    1/16"
$x:=$xT-(3*$edge)
$y:=$yT-(2*$edge)

//graphics
$lineWeight:="4"
$boxOutline:="^GB"+String:C10($x)+","+String:C10($y)+","+$lineWeight+"^FS"
$lineBisect:="^GB"+String:C10($x)+",0,"+$lineWeight+"^FS"
$lineVert:="^GB0,"+String:C10(395)+","+$lineWeight+"^FS"

//define the layout  
$labelDef:=""
$labelDef:=$labelDef+$startLabel+$cr
$labelDef:=$labelDef+$speed+$cr
$labelDef:=$labelDef+$home+$cr
$labelDef:=$labelDef+"^DFR:PALLET1.ZPL^FS"+$cr  //give the template a name

//Graphics--------------------------------------
$labelDef:=$labelDef+ZebraLabelGrid("at"; 1; 2)  //0 from
$labelDef:=$labelDef+$boxOutline+$cr
//black box
$labelDef:=$labelDef+ZebraLabelGrid("at"; 1; 2)  //0 from
$labelDef:=$labelDef+"^GB"+String:C10($x)+","+"100,50^FS"+$cr
//Arkay Packaging
//United States of America
$labelDef:=$labelDef+ZebraLabelGrid("at"; 1; 14)
$labelDef:=$labelDef+$lineBisect+$cr
//code 128
//human readable
$labelDef:=$labelDef+ZebraLabelGrid("at"; 1; 40)
$labelDef:=$labelDef+$lineBisect+$cr
//skid num  qty
//date   cases
$labelDef:=$labelDef+ZebraLabelGrid("at"; 1; 56)
$labelDef:=$labelDef+$lineBisect+$cr
//cpn
//desc
$labelDef:=$labelDef+ZebraLabelGrid("at"; 1; 72)
$labelDef:=$labelDef+$lineBisect+$cr
//black box
$labelDef:=$labelDef+ZebraLabelGrid("at"; 1; 75)
$labelDef:=$labelDef+"^GB"+String:C10($x)+",70,35^FS"+$cr
//customer
//line
$labelDef:=$labelDef+ZebraLabelGrid("at"; 1; 88)  //6"lot
$labelDef:=$labelDef+$lineBisect+$cr
//specs
//$labelDef:=$labelDef+ZebraLabelGrid ("at";1;104)  `6"lot
//$labelDef:=$labelDef+$lineBisect+$cr
//case list


//Labels--------------------------------------
$labelDef:=$labelDef+ZebraLabelGrid("at"; $col1; 3; 10; 5)  //0
$labelDef:=$labelDef+$fontL+"^FR"+$b+"ARKAY PACKAGING"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; $col1; 10; 10; 0)  //1
$labelDef:=$labelDef+$fontM+$b+"UNITED STATES OF AMERICA"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; $col1; 15)  //2
$labelDef:=$labelDef+$fontS+$b+"PALLET"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; $col1; 41)  //3
$labelDef:=$labelDef+$fontS+$b+"SKID:"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; $col1; 57)  //4
$labelDef:=$labelDef+$fontS+$b+"ITEM CODE:"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; $col1; 73)  //5
$labelDef:=$labelDef+$fontS+$b+"CUSTOMER:"+$e

//$labelDef:=$labelDef+ZebraLabelGrid ("at";$col1;89)  `6
//$labelDef:=$labelDef+$fontS+$b+"SPECIFICATIONS:"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; $col1; 89)  //105)
$labelDef:=$labelDef+$fontS+$b+"CASE LIST:"+$e



//Data section--------------------------------------

$labelDef:=$labelDef+ZebraLabelGrid("at"; $col3+3; 18)  //BC
$labelDef:=$labelDef+$bcode128+"^FN1"+$e
$labelDef:=$labelDef+ZebraLabelGrid("at"; $col2; 36)  //HR
$labelDef:=$labelDef+$fontM+"^FN2"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; $col2; 44)  //skid
$labelDef:=$labelDef+$fontM+"^FN3"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; $col5; 44)  //qty
$labelDef:=$labelDef+$fontM+"^FN4"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; $col2; 50)  //date and cases
$labelDef:=$labelDef+$fontM+"^FN5"+$e


$labelDef:=$labelDef+ZebraLabelGrid("at"; $col2; 60)  //cpn
Case of 
	: (Length:C16([WMS_ItemMasters:123]SKU:2)<11)
		$labelDef:=$labelDef+$fontXL+"^FN6"+$e
	: (Length:C16([WMS_ItemMasters:123]SKU:2)<13)
		$labelDef:=$labelDef+$fontL+"^FN6"+$e
	Else 
		$labelDef:=$labelDef+$fontMC+"^FN6"+$e
End case 

$labelDef:=$labelDef+ZebraLabelGrid("at"; $col2; 69)  //desc
$labelDef:=$labelDef+$fontMC+"^FN7"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; $col2; 76)  //cust
//$labelDef:=$labelDef+$fontM+"^FR"+"^FN8"+$e
$labelDef:=$labelDef+$fontM+"^FN8"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; $col2; 82)  //line
$labelDef:=$labelDef+$fontM+"^FN9"+$e

//$labelDef:=$labelDef+ZebraLabelGrid ("at";$col2;92)  `spec line1
//$labelDef:=$labelDef+$fontML+"^FN10"+$e
//
//$labelDef:=$labelDef+ZebraLabelGrid ("at";$col2;96)  `spec line2
//$labelDef:=$labelDef+$fontML+"^FN11"+$e
//
//$labelDef:=$labelDef+ZebraLabelGrid ("at";$col2;100)  `spec line2
//$labelDef:=$labelDef+$fontML+"^FN12"+$e

$labelDef:=$labelDef+ZebraLabelGrid("at"; $col2; 92)  //108)  `case list
$labelDef:=$labelDef+$fontML+"^FB750,34,,"+"^FN13"+$e

$labelDef:=$labelDef+$endLabel+$cr+$cr

$0:=$labelDef