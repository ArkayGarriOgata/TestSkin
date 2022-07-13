//%attributes = {"publishedWeb":true}
//(P) notifySetup
//setup user preferences for notifications

C_LONGINT:C283($id)

$id:=uProcessID("User Preferences")

If ($id=-1)  //doesn't exist yet or previously killed
	$id:=uSpawnProcess("NotifyPrefDlog"; 32000; "User Preferences"; True:C214; False:C215)
	<>PrcsListPr:=$id
	If (False:C215)  //list called procedures for 4D Insider
		NotifyPrefDlog
	End if 
	
Else   //hidden
	SHOW PROCESS:C325($id)
	RESUME PROCESS:C320($id)
	BRING TO FRONT:C326($id)
	POST OUTSIDE CALL:C329($id)
End if 