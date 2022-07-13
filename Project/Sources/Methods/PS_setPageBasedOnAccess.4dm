//%attributes = {"publishedWeb":true}
//PM: PS_setPageBasedOnAccess() -> 
//@author mlb - 6/26/02  13:14

If (User in group:C338(Current user:C182; "RoleOperations"))  //can make changes
	$canMakeChanges:=True:C214
Else   //hide
	$canMakeChanges:=False:C215
End if 

If (User in group:C338(Current user:C182; "SchedulingAssistant"))  //default showing completed
	bShowCompleted:=1
Else   //hide
	bShowCompleted:=0
End if 