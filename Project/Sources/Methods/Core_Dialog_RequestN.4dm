//%attributes = {}
//Method: Core_Dialog_RequestN(oRequest{;ptRequest})=>nResult
//  Result - 1 (default button), 0 (cancel), 2 (non-default buton)
//Description:  This method allows you to process a request from the user. 
//  That will fit just the message size and specify the button text.
//  It will also display the button order correctly for windows and mac
//  Note: tMessage and tValue are mandatory

//  Example:

//    C_OBJECT($oAsk)
//    C_LONGINT($nRequestButton)

//    $oAsk:=New object()

//    $oAsk.tMessage:="This is the message you use for the request information"
//    $oAsk.tValue:="This is the value you expect to get a result from defaults to blankif not specified"

//    $oAsk.tEntryFilter:="{Entry Filter to use for tValue}"
//    $oAsk.tEntryFormat:="{Entry format to use for tValue}"

//    $oAsk.tDefault:="{Defaults to OK (Button name for yes do this)}"
//    $oAsk.tCancel:="{Defaults to Cancel (This will cancel the request and close window if NonDefault is not blank it returns to form.}"
//    $oAsk.tNonDefault:="{Defaults to blank (This is usually not displayed but can be used to still leave example Don't Delete)}"

//    $nRequestButton:=Core_Dialog_RequestN ($oAsk)

If (True:C214)  //Initialize
	
	C_OBJECT:C1216($1; $oRequest)
	C_POINTER:C301($2; $ptRequest)
	C_LONGINT:C283($nRequest)
	
	$oRequest:=$1
	
	If (Count parameters:C259>=2)
		$ptRequest:=$2
	End if 
	
	$oRequest.tIcon:=CorektRequest
	$oRequest.tPromptType:=CorektRequest
	
	$nRequest:=0
	
End if   //Done initializing

Case of 
		
	: (Count parameters:C259=1)
		
		$nRequest:=Core_Dialog_PromptN($oRequest)
		
	: (Count parameters:C259=2)
		
		$nRequest:=Core_Dialog_PromptN($oRequest; $ptRequest)
		
End case 

$0:=$nRequest