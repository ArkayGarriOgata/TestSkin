//%attributes = {}
//Method: Core_Dialog_ConfirmN(oConfirm)=>nResult
//  Result - 1 (default button), 0 (cancel), 2 (non-default buton)
//Description:  This method allows you to process a Confirm from the user. 
//  That will fit just the message size and specify the button text.
//  It will also display the button order correctly for windows and mac
//  Note: tMessage is mandatory

//  Example:

//    C_OBJECT($oAsk)
//    C_LONGINT($nConfirmButton)

//    $oAsk:=New object()

//    $oAsk.tMessage:="This is the message you use for the Confirm information"

//    $oAsk.tDefault:="{Defaults to OK (Button name for yes do this)}"
//    $oAsk.tCancel:="{Defaults to Cancel (This will cancel the Confirm and close window if NonDefault is not blank it returns to form.}"
//    $oAsk.tNonDefault:="{Defaults to blank (This is usually not displayed but can be used to still leave example Don't Delete)}"

//    $nConfirmButton:=Core_Dialog_ConfirmN ($oAsk)

If (True:C214)  //Initialize
	
	C_OBJECT:C1216($1; $oConfirm)
	C_LONGINT:C283($nConfirm)
	
	$oConfirm:=$1
	
	$oConfirm.tIcon:=CorektRequest
	$oConfirm.tPromptType:=CorektConfirm
	
	$nConfirm:=0
	
End if   //Done initializing

$nConfirm:=Core_Dialog_PromptN($oConfirm)

$oConfirm.nResult:=$nConfirm

$0:=$nConfirm
