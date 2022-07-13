//%attributes = {}
//Method:  Util_Trigger_OnErr({tPhase}{;tCallingMethodName})
//Description:  This method can be called before and after code 
//  in a trigger method
//Example:
//   Util_Trigger_OnErr (CorektTriggerPre;Current method name)
//   ON ERR CALL("Util_Trigger_OnErr")
//   trigger_{TableMethodName}
//   Util_Trigger_OnErr (CorektTriggerPost)

If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $tPhase)
	C_TEXT:C284($2; $tCallingMethodName)
	
	C_LONGINT:C283($nNumberOfParameters)
	$nNumberOfParameters:=Count parameters:C259
	
	$tPhase:=CorektBlank
	$tCallingMethodName:=CorektBlank
	
	If ($nNumberOfParameters>=1)  //Options
		$tPhase:=$1
		If ($nNumberOfParameters>=1)
			$tCallingMethodName:=$2
		End if 
	End if   //Done options
	
End if   //Done Initialize

Case of   //Trigger phase
		
	: ($tPhase=CorektTriggerPre)  //Set trigger method
		
		Util_tTrigger_PreviousErrMethod:=Method called on error:C704
		Util_tTrigger_CallingMethod:=$tCallingMethodName
		
	: ($tPhase=CorektTriggerPost)
		
		ON ERR CALL:C155(Util_tTrigger_PreviousErrMethod)
		
		Util_tTrigger_PreviousMethod:=CorektBlank
		Util_tTrigger_CallingMethod:=CorektBlank
		
	Else   //Error occured and needs to be handled
		
		//utl_Logfile ()
		
End case   //Done trigger phase

