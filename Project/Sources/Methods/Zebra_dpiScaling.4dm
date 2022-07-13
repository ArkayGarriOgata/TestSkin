//%attributes = {}

// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 05/14/19, 11:55:03
// ----------------------------------------------------
// Method: Zebra_dpiScaling
// Description
// change scaling for 203 dpi for old zebras to 300dpi for newer model
//
// Parameters
// ----------------------------------------------------
// clipboards 1 Zebra_dpiScaling (lValue1) 2 zBoxOutline 3 zLineBisect 4 zLineDivider

C_TEXT:C284(zFont12; zFont14; zFont18; zFont24; $lineWeight; zBcode39; zBcode128)
C_LONGINT:C283($1; $dpi; $xT; $yT; $edge; $x; $y)

$lineWeight:="6"

$dpi:=$1
If ($dpi=300)
	$fo:=ZebraLabelGrid("init"; 16; $dpi)  // Modified by: Mel Bohince (5/14/19)
	//barcodes
	zBcode39:="^BY5,3^B3R,N,150,N,N"
	zBcode39short:="^BY4,4s^B3R,N,109,N,N"
	zBcode128:="^BY7,5^BCR,140,N,N,N,A"
	zBcode128tall:="^BY7,5^BCR,200,N,N,N,A"
	zBcodeUPC_A:="^BUR,109,Y,N,Y"  //show human and chk digit below
	
	zBcode39N:="^BY4,2^B3N,N,103,N,N"
	zBcode128N:="^BY4,2^BCN,111,N,N,N,A"
	zBcode39inverted:="^BY4,2^B3I,N,250,N,N"
	zBcode128rotated:="^BY5,3^BCN,226,N,N,N,A"
	//label boundary
	$xT:=1200  //4" // Modified by: Mel Bohince (5/14/19)
	$yT:=1800  //6" // Modified by: Mel Bohince (5/14/19)
	//fonts
	zFont12:="^A0R,72,64"
	zFont14:="^A0R89,79"
	zFont14b:="^A0R,89,99"  //bold
	zFont14t:="^A0R,89,72"  //narrow
	zFont18:="^A0R111,78"
	zFont24:="^A0R126,133"
	
	//fonts normal
	zFont12N:="^A0N,72,64"
	zFont14N:="^A0N89,79"
	zFont18N:="^A0N133,110"
	zFont14inverted:="^A0I,100,70"
	zFont14rotated:="^A0N,74,59"
	zLineVert:="^GB0,"+String:C10(602)+","+$lineWeight+"^FS"
	zLineDivider:="^GB"+String:C10(250)+",0,"+$lineWeight+"^FS"  //5/8"// Modified by: Mel Bohince (5/14/19)
	
Else 
	$fo:=ZebraLabelGrid("init"; 16)
	zBcode39:="^BY4,2^B3R,N,103,N,N"
	zBcode39short:="^BY5,3^B3R,N,90,N,N"
	zBcode128:="^BY5,3^BCR,103,N,N,N,A"
	zBcode128tall:="^BY5,3^BCR,155,N,N,N,A"
	zBcode128rotated:="^BY5,3^BCN,153,N,N,N,A"
	
	//mh10
	zBcode39N:="^BY3^B3N,N,103,N,N"
	zBcode128N:="^BY3,2^BCN,103,N,N,N,A"  // Modified by: Mel Bohince (2/5/14) don't rotate barcode BCN not BCR
	zBcode39inverted:="^BY3^B3I,N,103,N,N"
	
	//label boundary
	$xT:=812  //4"
	$yT:=1218  //6"
	//fonts rotated
	zFont12:="^A0R,55,43"
	zFont14:="^A0R,60,54"  //"^AVR,2,2"
	zFont14b:="^A0R,60,67"  //bold
	zFont14t:="^A0R,60,52"  //narrow
	zFont18:="^A0R75,53"
	zFont24:="^A0R85,90"
	//fonts normal
	zFont12N:="^A0N,55,43"
	zFont14N:="^A0N60,48"
	zFont18N:="^A0N90,75"
	zFont14inverted:="^A0I,50,40"
	zFont14rotated:="^A0N,50,40"
	zLineVert:="^GB0,"+String:C10(395)+","+$lineWeight+"^FS"
	zLineDivider:="^GB"+String:C10(174)+",0,"+$lineWeight+"^FS"  //5/8"
End if 

//boarder area
$edge:=13  //.0625    1/16"
$x:=$xT-(3*$edge)
$y:=$yT-(2*$edge)

//graphics
zBoxOutline:="^GB"+String:C10($x)+","+String:C10($y)+","+$lineWeight+"^FS"
zLineBisect:="^GB0,"+String:C10($y)+","+$lineWeight+"^FS"
zLineBisectH:="^GB"+String:C10($x)+",0,"+$lineWeight+"^FS"
