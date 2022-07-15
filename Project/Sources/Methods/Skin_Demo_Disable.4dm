//%attributes = {}
/*  Method:  Skin_Demo_Disable
   Description:  This method handles the disable check box
      It will diable all the buttons if checked
      It will enable all the buttons if unchecked
*/

If (True:C214)  //Initialize
	
	C_BOOLEAN:C305($bEnabled)
	
	C_LONGINT:C283($nColumn; $nNumberOfColumns)
	C_LONGINT:C283($nRow; $nNumberOfRows)
	
	C_POINTER:C301($pnButton; $pnCheckBox)
	
	C_TEXT:C284($tButtonName; $tCheckBox)
	
	$tCheckBox:=OBJECT Get name:C1087(Object current:K67:2)
	
	$pnCheckBox:=OBJECT Get pointer:C1124(*; $tCheckBox)
	
	$bEnabled:=($pnCheckBox->=0)
	
	$nNumberOfColumns:=3
	$nNumberOfRows:=6
	
End if   //Done initialize

For ($nRow; 1; $nNumberOfRows)  //Row
	
	For ($nColumn; 1; $nNumberOfColumns)  //Column
		
		$tButtonName:="Skin_Demo_nButton"+String:C10($nRow)+String:C10($nColumn)
		
		$pnButton:=OBJECT Get pointer:C1124(*; $tButtonName)
		
		OBJECT SET ENABLED:C1123($pnButton->; $bEnabled)
		
	End for   //Done column
	
End for   //Done row
