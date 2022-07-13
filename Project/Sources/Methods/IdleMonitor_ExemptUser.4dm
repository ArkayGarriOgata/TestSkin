//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: IdleMonitor_ExemptUser - Created v0.1.0-JJG (02/04/16)
// Modified by: Mel Bohince (11/20/18) curfew for off hours and not at plant
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

C_BOOLEAN:C305($0; $fExempt)
$fExempt:=False:C215

If (User in group:C338(Current user:C182; "RoleSuperUser"))  //Admin and Designer
	$fExempt:=True:C214
	
Else 
	// Modified by: Mel Bohince (2/11/16) test group directly and make specific group
	If (User in group:C338(Current user:C182; "ExemptFromTimeOut"))
		$fExempt:=True:C214
	End if 
	
	// Modified by: Mel Bohince (11/20/18) curfew for off hours and not at plant
	If (Not:C34(User in group:C338(Current user:C182; "Roanoke")))
		If (Current time:C178>?21:30:00?)
			$fExempt:=False:C215
		End if 
	End if 
End if 


$0:=$fExempt