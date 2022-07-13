//%attributes = {}
//Method: Skin_4State(gOriginal)=>g4State
//Description:  This method will an image and create a
//  4 state picture button with it.
//  ?? Add reference to 4D Depot here ... ??

If (True:C214)  //Initialize
	
	C_PICTURE:C286($1; $gOriginal; $0; $g4State)
	
	C_TEXT:C284($tGroup; $tImage; $tSvg)
	
	C_PICTURE:C286($gClick; $gHover; $gDisabled)
	
	$gOriginal:=$1
	
End if   //Done initialize

$tSvg:=SVG_New
$tGroup:=SVG_New_group($tSvg)
$tImage:=SVG_New_embedded_image($tGroup; $gOriginal)

//Click: add more bright and translate
SVG_SET_BRIGHTNESS($tGroup; 1.2)
$gClick:=SVG_Export_to_picture($tSvg)
TRANSFORM PICTURE:C988($gClick; Translate:K61:3; 3; 0)
TRANSFORM PICTURE:C988($gClick; Scale:K61:2; 0.95; 0.95)

//Hover: add more bright to previous image
SVG_SET_BRIGHTNESS($tGroup; 1.35)
$gHover:=SVG_Export_to_picture($tSvg)
TRANSFORM PICTURE:C988($gHover; Translate:K61:3; 0; 1)

//Disabled: reduce brightness and set grayscale
SVG_SET_BRIGHTNESS($tGroup; 0.7)
$gDisabled:=SVG_Export_to_picture($tSvg)
TRANSFORM PICTURE:C988($gDisabled; Fade to grey scale:K61:6)

SVG_CLEAR($tSvg)

$g4State:=$gOriginal/$gClick/$gHover/$gDisabled

$0:=$g4State
