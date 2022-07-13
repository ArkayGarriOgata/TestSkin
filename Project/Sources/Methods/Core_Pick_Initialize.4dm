//%attributes = {}
//Method:  Core_Pick_Initialize(tStatus{;pOption1})
//Description:  This method will inititlaize the values for the
//  Pick form it is often called from a button where the only 
//  event is on_Load.  It doesn't look for a form event so that
//  the form can be reinitialized without having to execute a
//  form event.

If (True:C214)  //Initialization
	
	C_TEXT:C284($1; $tPhase)
	C_POINTER:C301($2; $pOption1)
	C_POINTER:C301($3; $pOption2)
	
	C_LONGINT:C283($nNumberOfParameters)
	
	$nNumberOfParameters:=Count parameters:C259
	
	$tPhase:=$1
	
	$pOption1:=Null:C1517
	
	If ($nNumberOfParameters>=2)  //Options
		$pOption1:=$2
		If ($nNumberOfParameters>=3)
			$pOption2:=$3
		End if 
	End if   //Done options
	
End if   //Done initialization

Case of   //Phase
		
	: ($tPhase=CorektPhasePreDialog)
		
		Compiler_Core_Array(Current method name:C684; 0)
		COPY ARRAY:C226($pOption1->; Core_atPick_Value)
		
		Compiler_Core_Array(Current method name:C684+"2"; Size of array:C274(Core_atPick_Value))
		
		C_OBJECT:C1216(Core_oPick)
		Core_oPick:=New object:C1471()
		Core_oPick:=$pOption2->
		
		OBJECT SET PLACEHOLDER:C1295(Core_tPick_Find; "Name")
		
	: ($tPhase=CorektPhaseInitialize)
		
		Core_Pick_Initialize(CorektPhaseClear)
		
		Core_Pick_SetPicked(Core_oPick.tPicked)
		
		Core_Window_FitObject
		
	: ($tPhase=CorektPhaseClear)
		
		Core_tPick_Find:=CorektBlank
		
End case   //Done phase
