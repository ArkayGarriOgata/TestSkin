//%attributes = {}
//Method:  Core_Dialog_Alert(oAlert)
//Description:  This method will bring up an alert
//  Example:
//    C_OBJECT($oAsk)
//    $oAsk:=New object()
//    $oAsk.tMessage:="This is the message you use for the alert information"
//    Core_Dialog_Alert($oAsk)

If (True:C214)  //Initialize
	
	C_OBJECT:C1216($1; $oAlert)
	C_LONGINT:C283($nResult)
	
	$oAlert:=$1
	
	$oAlert.tIcon:=CorektAlert
	$oAlert.tPromptType:=CorektAlert
	
	$nResult:=0
	
End if   //Done initializing

$nResult:=Core_Dialog_PromptN($oAlert)
