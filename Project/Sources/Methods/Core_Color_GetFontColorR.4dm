//%attributes = {}
//Method:  Core_Color_GetFontColorR({pFormObject})=>rDecimalFontColor
//Description:  This method can be called from an object
//.   or passed a pointer to an object and will alert and return the font color
//.  it will also copy it to the clipboard so you can paste it in code.

If (True:C214)  //Initialize
	
	C_POINTER:C301($1; $pFormObject)
	C_REAL:C285($rDecimalFontColor)
	C_TEXT:C284($tDecimalFontColor)
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
	
	$rDecimalFontColor:=0
	$tDecimalFontColor:=CorektBlank
	
	$oConfirm:=New object:C1471()
	
	$oConfirm.tMessage:="The decimal color for this font is "+$tDecimalFontColor+CorektPeriod
	$oConfirm.tMessage:=$oConfirm.tMessage+" Would you like to copy "+$tDecimalFontColor+" to your clipboard?"
	
End if   //Done initialize

OBJECT GET RGB COLORS:C1074($pFormObject->; $rDecimalFontColor)

$tDecimalFontColor:=String:C10($rDecimalFontColor)

If (Core_Dialog_ConfirmN($oConfirm)=CoreknDefault)
	
	SET TEXT TO PASTEBOARD:C523($tDecimalFontColor)
	
End if 

$0:=$rFontColor
