//%attributes = {}
//Method:  Core_Button_SetIcon()
//Description:  This method will set a picture button icon.

//Notes:
// Place a picture button on a form and set the following
//. Object Name = {Modl_Form_n}Icon (note icon can be the name of the icon file ie Accept for the Accept.png icon
//  Rows = 1, Columns = 1, Leave all animation checkboxes unchecked.

If (True:C214)  //Initialize
	
	
	$nSwitchWhenRollOver:=16
	$nSwitchBackWhenReleased:=32
	$nUseLastFrameAsDisabled:=128
	
	$nFlags:=$nSwitchWhenRollOver+$nSwitchBackWhenReleased+$nUseLastFrameAsDisabled
	
	$tButtonName:=OBJECT Get name:C1087(Object current:K67:2)
	
	$tFormName:=Current form name:C1298
	
	$tIcon:="AcceptRound.png"
	$tPathName:="#Skin:Master:"+$tIcon
	
	
	
	$tButtonFormat:="1; 4;"+$tPathName+";"+String:C10($nFlags)
	
	$tButtonName:="Skin_Demo_nButton12"
	
	
	
End if   //Done initialize


OBJECT SET FORMAT:C236(*; $tButtonName; $tButtonFormat)
