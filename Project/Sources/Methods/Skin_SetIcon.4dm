//%attributes = {}
/*
Method:  Skin_SetIcon({tButtonName}{;tIcon}{;tFamily})
Description:  This method will set a picture button icon.

 How To Use:
    No parameters passed in
      Place a picture button on a form and set the following:
      Object Name = {Modl_Form_n}Icon
         (note icon is the name of the icon file in the family folder. (Accept.png) icon
         You do not need to add the .png to the object name
      Rows = 1, Columns = 1, Leave all animation checkboxes unchecked.

     In the on load form event of the object call Skin_SetIcon 

  Parameters passed in
         In this case you can all it in the on load or from anywhere else
         Just make sure to pass in the appropriate information for the task
  */

If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $tButtonName)
	C_TEXT:C284($2; $tIcon)
	C_TEXT:C284($3; $tFamily)
	
	C_LONGINT:C283($nFlags)
	C_LONGINT:C283($nSwitchBackWhenReleased; $nSwitchWhenRollOver)
	C_LONGINT:C283($nUseLastFrameAsDisabled)
	
	C_TEXT:C284($tButtonFormat; $tButtonName)
	C_TEXT:C284($tFormName; $tIcon; $tPathName)
	C_TEXT:C284($tFamily)
	
	$nNumberOfParameters:=Count parameters:C259
	
	If ($nNumberOfParameters>=1)  //Button name
		
		$tButtonName:=$1
		
	Else 
		
		$tButtonName:=OBJECT Get name:C1087(Object current:K67:2)  //{FormName}_n{Icon}
		
	End if   //Done button name
	
	If ($nNumberOfParameters>=2)  //Icon
		
		$tIcon:=$2
		
	Else 
		
		$tFormName:=Current form name:C1298
		$nStart:=Length:C16($tFormName)+3  //3="_n[]"
		
		$tIcon:=Substring:C12($tButtonName; $nStart)+".png"
		
	End if   //Done icon
	
	If ($nNumberOfParameters>=3)  //Family
		
		$tFamily:=$3
		
	Else 
		
		$tFamily:="Master"
		
	End if   //Done family
	
	$nSwitchWhenRollOver:=16
	$nSwitchBackWhenReleased:=32
	$nUseLastFrameAsDisabled:=128
	
	$nFlags:=$nSwitchWhenRollOver+$nSwitchBackWhenReleased+$nUseLastFrameAsDisabled
	
	$tPathName:="#Skin"+Folder separator:K24:12+$tFamily+Folder separator:K24:12+$tIcon
	
	$tButtonFormat:="1; 4;"+$tPathName+";"+String:C10($nFlags)
	
End if   //Done initialize

OBJECT SET FORMAT:C236(*; $tButtonName; $tButtonFormat)
