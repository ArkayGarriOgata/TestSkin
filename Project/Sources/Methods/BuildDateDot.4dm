//%attributes = {}
//© 2015 Footprints Inc. All Rights Reserved.
//Method: Method: BuildDateDot - Created `v1.0.0-PJK (12/18/15)
C_BOOLEAN:C305(<>fDebug)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

//$1=Width
//$2=Start Date to plot
//$3=Start Time to plot

//$4=End Date to plot
//$5=End Time to plot

//$6=Minimum Date
//$7=Maximum Date
C_LONGINT:C283($1)
C_DATE:C307($2; $6; $7)
C_PICTURE:C286($iPict; $0)
C_TIME:C306($3; $hStart; $hEnd)
C_TEXT:C284($ttID; $ttObjectID)
C_LONGINT:C283($xlBarWidth; $xlCenterH; $xlHeight; $xlLeftOffset; $xlPixPerSection; $xlPos; $xlRadius; $xlSecondsInDay; $xlSections; $xlWidth)
C_REAL:C285($xrLeft; $xrRight; $xrTime)

$xlRadius:=6
$xlLeftOffset:=$xlRadius

$hStart:=?00:00:00?
$hEnd:=?23:23:59?
$xlSecondsInDay:=$hEnd+0

$dMinDate:=$6
$dMaxDate:=$7+1

$xlSections:=$dMaxDate-$dMinDate


$dPlotStartDate:=$2
$hPlotStartDate:=$3


$dPlotEndDate:=$4
$hPlotEndDate:=$5

If ($dPlotEndDate<$dPlotStartDate)
	$dPlotEndDate:=$dPlotStartDate
	$hPlotEndDate:=$hPlotStartDate
End if 

$xlWidth:=$1
$xlHeight:=20

$xlPixPerSection:=$xlWidth/$xlSections

$xrLeft:=($dPlotStartDate-$6)*$xlPixPerSection
$xrTime:=(($hPlotStartDate+0)/$xlSecondsInDay)*$xlPixPerSection

$xrLeft:=$xrLeft+$xrTime


$xrRight:=($dPlotEndDate-$6)*$xlPixPerSection
$xrTime:=(($hPlotEndDate+0)/$xlSecondsInDay)*$xlPixPerSection

$xrRight:=$xrRight+$xrTime


$ttID:=SVG_New($xlWidth+($xlRadius*2); $xlHeight)
$xlCenterH:=$xlHeight/2

// Plot the Start Date/Time
Case of 
	: ($dPlotStartDate=!1900-01-01!)
		$ttObjectID:=SVG_New_text($ttID; "NOT SCHEDULED"; $xlWidth/2; 2; "Arial"; 12; Bold:K14:2; 3; PKSVG_GetColor("Red"))  // 3=Center Allign
		
	: ($xrLeft<0)
		//$ttObjectID:=SVG_New_text ($ttID;"<<=";0;2;"Arial";14;Bold;2;PKSVG_GetColor ("Green"))  // 3=Center Allign
		
		$ttObjectID:=SVG_New_polygon($ttID; ""; PKSVG_GetColor("Green"); PKSVG_GetColor("Green"); 1)
		$xlPos:=0
		SVG_ADD_POINT($ttObjectID; $xlPos; $xlCenterH)
		SVG_ADD_POINT($ttObjectID; $xlPos+$xlRadius; $xlCenterH-$xlRadius)
		SVG_ADD_POINT($ttObjectID; $xlPos+$xlRadius; $xlCenterH+$xlRadius)
		
	: ($xrLeft>$xlWidth)
		//$ttObjectID:=SVG_New_text ($ttID;"=>>";$xlWidth;2;"Arial";14;Bold;4;PKSVG_GetColor ("Green"))  // 3=Center Allign
		$ttObjectID:=SVG_New_polygon($ttID; ""; PKSVG_GetColor("Green"); PKSVG_GetColor("Green"); 1)
		$xlPos:=$xlWidth+$xlLeftOffset
		SVG_ADD_POINT($ttObjectID; $xlPos; $xlCenterH)
		SVG_ADD_POINT($ttObjectID; $xlPos-$xlRadius; $xlCenterH-$xlRadius)
		SVG_ADD_POINT($ttObjectID; $xlPos-$xlRadius; $xlCenterH+$xlRadius)
		
	Else 
		//$ttObjectID:=SVG_New_polygon ($ttID;"";PKSVG_GetColor ("Green");PKSVG_GetColor ("Green");1)
		//SVG_ADD_POINT ($ttObjectID;$xrLeft-$xlRadius;$xlCenterH)
		//SVG_ADD_POINT ($ttObjectID;$xrLeft;$xlCenterH-$xlRadius)
		//SVG_ADD_POINT ($ttObjectID;$xrLeft+$xlRadius;$xlCenterH)
		//SVG_ADD_POINT ($ttObjectID;$xrLeft;$xlCenterH+$xlRadius)
		
		
		//$ttObjectID:=SVG_New_ellipse ($ttID;$xrLeft;$xlHeight/2;5;5;PKSVG_GetColor ("Green");PKSVG_GetColor ("Green");1)
		//$ttObjectID:=SVG_New_line ($ttID;$xrLeft+$xlLeftOffset;$xlCenterH-$xlRadius;$xrLeft+$xlLeftOffset;$xlCenterH+$xlRadius;PKSVG_GetColor ("Green");2)
End case 

// Now plot the END Date/Time
Case of 
	: ($dPlotEndDate=!1900-01-01!)
		$ttObjectID:=SVG_New_text($ttID; "NOT SCHEDULED"; $xlWidth/2; 2; "Arial"; 12; Bold:K14:2; 3; PKSVG_GetColor("Red"))  // 3=Center Allign
		
	: ($xrRight<0)
		//$ttObjectID:=SVG_New_text ($ttID;"<<=";0;2;"Arial";14;Bold;2;PKSVG_GetColor ("Green"))  // 3=Center Allign
		$ttObjectID:=SVG_New_polygon($ttID; ""; PKSVG_GetColor("Green"); PKSVG_GetColor("Green"); 1)
		$xlPos:=0
		SVG_ADD_POINT($ttObjectID; $xlPos; $xlCenterH)
		SVG_ADD_POINT($ttObjectID; $xlPos+$xlRadius; $xlCenterH-$xlRadius)
		SVG_ADD_POINT($ttObjectID; $xlPos+$xlRadius; $xlCenterH+$xlRadius)
		
	: ($xrRight>$xlWidth)
		//$ttObjectID:=SVG_New_text ($ttID;"=>>";$xlWidth;2;"Arial";14;Bold;4;PKSVG_GetColor ("Green"))  // 3=Center Allign
		$ttObjectID:=SVG_New_polygon($ttID; ""; PKSVG_GetColor("Green"); PKSVG_GetColor("Green"); 1)
		$xlPos:=$xlWidth+($xlLeftOffset*2)
		SVG_ADD_POINT($ttObjectID; $xlPos; $xlCenterH)
		SVG_ADD_POINT($ttObjectID; $xlPos-$xlRadius; $xlCenterH-$xlRadius)
		SVG_ADD_POINT($ttObjectID; $xlPos-$xlRadius; $xlCenterH+$xlRadius)
		
	Else 
		//$ttObjectID:=SVG_New_polygon ($ttID;"";PKSVG_GetColor ("Green");PKSVG_GetColor ("Green");1)
		//SVG_ADD_POINT ($ttObjectID;$xrRight-$xlRadius;$xlCenterH)
		//SVG_ADD_POINT ($ttObjectID;$xrRight;$xlCenterH-$xlRadius)
		//SVG_ADD_POINT ($ttObjectID;$xrRight+$xlRadius;$xlCenterH)
		//SVG_ADD_POINT ($ttObjectID;$xrRight;$xlCenterH+$xlRadius)
		
		
		//$ttObjectID:=SVG_New_line ($ttID;$xrRight+$xlLeftOffset;$xlCenterH-$xlRadius;$xrRight+$xlLeftOffset;$xlCenterH+$xlRadius;PKSVG_GetColor ("Green");2)
End case 

If ($xrRight>$xlWidth)
	$xrRight:=$xlWidth
End if 
If ($xrRight<0)
	$xrRight:=0
End if 

If ($xrLeft>$xlWidth)
	$xrLeft:=$xlWidth
End if 
If ($xrLeft<0)
	$xrLeft:=0
End if 


$xlBarWidth:=($xrRight+$xlLeftOffset)-($xrLeft+$xlLeftOffset)
If ($xlBarWidth=0)
	$xlBarWidth:=1
End if 

If ($dPlotEndDate#!1900-01-01!)
	$ttObjectID:=SVG_New_rect($ttID; $xrLeft+$xlLeftOffset; $xlCenterH-$xlRadius; $xlBarWidth; ($xlRadius*2); 0; 0; PKSVG_GetColor("Green"); PKSVG_GetColor("Green"); 1)
End if 

SVG EXPORT TO PICTURE:C1017($ttID; $iPict)

SVG_CLEAR($ttID)

$0:=$iPict