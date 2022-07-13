//%attributes = {}
//Method:  Core_Color_GetFontColorR({pFormObject})=>rDecimalFontColor
//Description:  This method can be called from an object
//.   or passed a pointer to an object and will alert and return the font color
//.  it will also copy it to the clipboard so you can paste it in code.

If (True:C214)  //Initialize
	
	C_POINTER:C301($1; $pFormObject)
	C_LONGINT:C283($nRGBForeground; $nRGBBackground; $nRGBAltBackground)
	C_TEXT:C284($tFrontBckGrndColor)
	C_OBJECT:C1216($oConfirm)
	
	Case of   //FormObject
			
		: (Count parameters:C259=0)
			
			$pFormObject:=OBJECT Get pointer:C1124
			
		: (Count parameters:C259=1)
			
			$pFormObject:=$1
			
	End case   //Done FormObject
	
	If (Count parameters:C259>=1)
		$pFormObject:=$1
	End if 
	
	$nRGBForeground:=0
	$tFrontBckGrndColor:=CorektBlank
	
	$oConfirm:=New object:C1471()
	
End if   //Done initialize

OBJECT GET RGB COLORS:C1074($pFormObject->; $nRGBForeground; $nRGBBackground; $nRGBAltBackground)

$tFrontBckGrndColor:=String:C10($nRGBForeground)

$oConfirm.tMessage:="The decimal color for the front and background is "+$tFrontBckGrndColor+CorektPeriod+CorektSpace+\
"Would you like to copy "+$tFrontBckGrndColor+" to your clipboard?"

If (Core_Dialog_ConfirmN($oConfirm)=CoreknDefault)
	
	SET TEXT TO PASTEBOARD:C523($tFrontBckGrndColor)
	
End if 

$0:=$rFontColor
