//%attributes = {}
// _______
// Method: e_OnTriggerError   ( {tPhase}{;tCallingMethodName} )
// By: Garri @ 03/30/20, 14:04:09
//Description:  This method can be called before and after code 
//.  in a trigger method.

//Example:

//.   e_OnTriggerError (CorektTriggerPre;Current method name)
//.   ON ERR CALL("e_OnTriggerError")
//.   trigger_{TableMethodName}  //Call trigger method
//.   e_OnTriggerError (CorektTriggerPost)

If (True:C214)  //Initialize 
	
	C_TEXT:C284($1; $tPhase)
	C_TEXT:C284($2; $tCallingMethodName)
	
	C_TEXT:C284($tLogName; $tLogEntry)
	C_LONGINT:C283($nNumberOfParameters)
	C_LONGINT:C283($nError; $nNumberOfErrors)
	
	ARRAY LONGINT:C221($anErrorCode; 0)
	ARRAY TEXT:C222($atInternalError; 0)
	ARRAY TEXT:C222($atErrorMessage; 0)
	
	$nNumberOfParameters:=Count parameters:C259
	
	$tPhase:=CorektBlank
	$tCallingMethodName:=CorektBlank
	
	$tLogName:="UtilTrigger.log"
	$tLogEntry:=CorektBlank
	
	If ($nNumberOfParameters>=1)  //Get parameters
		$tPhase:=$1
		If ($nNumberOfParameters>=2)
			$tCallingMethodName:=$2
		End if 
	End if   //Done get parameters
	
End if   //Done Initialize

Case of   //Trigger phase
		
	: ($tPhase=CorektTriggerPre)  //Set trigger method
		
		Util_tTrigger_PreviousErrMethod:=Method called on error:C704
		Util_tTrigger_CallingMethod:=$tCallingMethodName
		
	: ($tPhase=CorektTriggerPost)
		
		ON ERR CALL:C155(Util_tTrigger_PreviousErrMethod)
		
		Util_tTrigger_PreviousErrMethod:=CorektBlank
		Util_tTrigger_CallingMethod:=CorektBlank
		
	Else   //Error occured and needs to be handled
		
		GET LAST ERROR STACK:C1015($anErrorCode; $atInternalError; $atErrorMessage)
		
		$nNumberOfErrors:=Size of array:C274($anErrorCode)
		
		$tLogEntry:="The following "
		$tLogEntry:=$tLogEntry+Choose:C955(($nNumberOfErrors>1); "errors"; "error")
		$tLogEntry:=$tLogEntry+" occurred when executing method "+Util_tTrigger_CallingMethod+":  "+Char:C90(Carriage return:K15:38)
		
		For ($nError; 1; $nNumberOfErrors)  //Loop thru errors
			
			$tLogEntry:=$tLogEntry+"Error Code:  "+String:C10($anErrorCode{$nError})+", "
			$tLogEntry:=$tLogEntry+"Internal Error:  "+$atInternalError{$nError}+", "
			$tLogEntry:=$tLogEntry+"Error Message:  "+$atErrorMessage{$nError}+Char:C90(Carriage return:K15:38)
			
		End for   //Done looping thru errors
		
		utl_Logfile($tLogName; $tLogEntry)  //Store logs
		
End case   //Done trigger phase
