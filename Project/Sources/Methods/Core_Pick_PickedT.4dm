//%attributes = {}
//Method: Core_Pick_PickedT=>tPicked
//Description:  This method returns the values that were picked

If (True:C214)  //Initialization
	
	C_TEXT:C284($0; $tPicked)
	
	C_LONGINT:C283($nPicked; $nNumberOfPicked)
	
	$tPicked:=CorektBlank
	
	$nNumberOfPicked:=Size of array:C274(Core_abPick_Picked)
	
End if   //Done initialization

For ($nPicked; 1; $nNumberOfPicked)  //Loop thru picked
	
	If (Core_abPick_Picked{$nPicked})  //Picked
		
		$tPicked:=$tPicked+CorektPipe+Core_atPick_Value{$nPicked}
		
	End if   //Done picked
	
End for   //Done looping thru picked

$tPicked:=Substring:C12($tPicked; 2)  //Remove the first pipe

$0:=$tPicked