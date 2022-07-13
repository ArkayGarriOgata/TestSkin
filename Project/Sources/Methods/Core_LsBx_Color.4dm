//%attributes = {}
//Method: Core_LsBx_Color(oColor)
//Description: This method will set row colors in the LxBx module

0000_Constants_ToDo

If (True:C214)  //Initialize
	
	C_OBJECT:C1216($1; $oColor)
	C_LONGINT:C283($nRow; $nNumberOfRows)
	
	$oColor:=New object:C1471()
	
	$oColor:=$1
	
	$pListBox:=Get pointer:C304("Core_abLsBx_"+$oColor.tID)
	
	$panRowColorFont:=Get pointer:C304("Core_anLsBx_RowFont"+$oColor.tID)
	$panRowColorBack:=Get pointer:C304("Core_anLsBx_RowBack"+$oColor.tID)
	
End if   //Done initialize

$nNumberOfRows:=Size of array:C274($pListBox->)

LISTBOX SET ARRAY:C1279($pListBox->; lk font color array:K53:27; $panRowColorFont)
LISTBOX SET ARRAY:C1279($pListBox->; lk background color array:K53:28; $panRowColorBack)

For ($nRow; 1; $nNumberOfRows)
	
	If (Mod:C98($nRow; 2)=0)  //Even
		
		APPEND TO ARRAY:C911($panRowColorFont->; Core_Color_GetRGBValueN(White:K11:1))
		APPEND TO ARRAY:C911($panRowColorBack->; Core_Color_GetRGBValueN(CoreknColorLightSteelBlue))
		
	Else   //Odd
		
		APPEND TO ARRAY:C911($panRowColorFont->; Core_Color_GetRGBValueN(Black:K11:16))
		APPEND TO ARRAY:C911($panRowColorBack->; Core_Color_GetRGBValueN(White:K11:1))
		
	End if   //Done even
	
End for 


LISTBOX SET ARRAY:C1279($pListBox->; lk font color array:K53:27; $panColumnColorFont)
LISTBOX SET ARRAY:C1279($pListBox->; lk background color array:K53:28; $panColumnColorBack)
