//%attributes = {}
//Method: Core_Dialog_PromptN(oPrompt{;ptRequest})=>nResult
//  Result - 1 (default button), 0 (cancel), 2 (non-default buton)
//Description:  This method allows you to process a Prompt from the user. 
//  That will fit just the message size and specify the button text.
//  It will also display the button order correctly for windows and mac
//  Note: oPrompt.tMessage and oPrompt.tIcon are mandatory to pass in

//  Example:

//    C_OBJECT($oPrompt)
//    C_LONGINT($nPromptButton)

//    $oPrompt:=New object()

//    $oPrompt.tMessage:="This is the message you use for the Prompt information"
//    $oPrompt.tValue:="This is the value you expect to get a result from defaults to blankif not specified"

//    $oPrompt.tEntryFilter:="{Entry Filter to use for tValue}"
//    $oPrompt.tEntryFormat:="{Entry format to use for tValue}"

//    $oPrompt.tDefault:="{Defaults to OK (Button name for yes do this)}"
//    $oPrompt.tCanel:="{Defaults to Cancel (This will cancel the Prompt and close window if NonDefault is not blank it returns to form.}"
//    $oPrompt.tNonDefault:="{Defaults to blank (This is usually not displayed but can be used to still leave example Don't Delete)}"

//    $nPromptButton:=Core_Dialog_PromptN ($oPrompt)

If (True:C214)  //Initialize
	
	C_OBJECT:C1216($1; $oPrompt)
	C_POINTER:C301($2; $ptRequest)
	C_LONGINT:C283($0; $nPrompt)
	
	C_LONGINT:C283($nWindowReference)
	C_LONGINT:C283($nNumberOfParameters)
	
	C_OBJECT:C1216($oWindow)
	
	ARRAY TEXT:C222($atLine; 0)
	
	$nNumberOfParameters:=Count parameters:C259
	
	$oPrompt:=$1
	
	$ptRequest:=Null:C1517
	
	If ($nNumberOfParameters>=2)  //Optional
		$ptRequest:=$2
	End if   //Done optional
	
	$nPrompt:=1
	
	$oWindow:=New object:C1471()
	
	$oWindow.tFormName:="Core_Prompt"
	
End if   //Done initializing

$nWindowReference:=Core_Window_OpenRelativeToN($oWindow)

DIALOG:C40("Core_Prompt"; $oPrompt)

CLOSE WINDOW:C154($nWindowReference)

Case of   //What button did the user select
		
	: (Core_nPrompt_Default=1)  //Default value
		
		$nPrompt:=CoreknDefault
		
		If ($nNumberOfParameters>=2)
			$ptRequest->:=$oPrompt.tValue
		End if 
		
	: (Core_nPrompt_NonDefault=1)  //Non Default value
		
		$nPrompt:=CoreknNonDefault
		
	: (Core_nPrompt_Cancel=1)  //Cancel
		
		$nPrompt:=CoreknCancel
		
End case   //Done checking what button the user selected

$0:=$nPrompt