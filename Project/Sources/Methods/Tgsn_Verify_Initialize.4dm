//%attributes = {}
//Method:  Tgsn_Verify_Initialize(tStatus{;pOption1})
//Description:  This method will inititlaize the values for the
//  Verify form it is often called from a button where the only 
//  event is on_Load.  It doesn't look for a form event so that
//  the form can be reinitialized without having to execute a
//  form event.

If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $tPhase)
	C_POINTER:C301($2; $pOption1)
	
	C_LONGINT:C283($nNumberOfParameters)
	
	$tPhase:=$1
	$pOption1:=Null:C1517
	
	$nNumberOfParameters:=Count parameters:C259
	
	If ($nNumberOfParameters>=2)  //Optional parameters
		$pOption1:=$2
	End if   //Done optional parameters
	
End if   //Done initialize

Case of   //Phase
		
	: ($tPhase=CorektPhasePreDialog)
		
		Tgsn_Verify_LoadColumn($pOption1)
		
	: ($tPhase=CorektPhaseInitialize)
		
		Tgsn_Verify_Initialize(CorektPhaseClear)
		
		Core_Window_FitObject
		
		Tgsn_nVerify_Tungsten:=1
		
	: ($tPhase=CorektPhaseClear)
		
		Tgsn_nVerify_Tungsten:=0
		Tgsn_nVerify_EDI:=0
		
End case   //Done phase
