//%attributes = {}
// Method: User_GetInitials () -> 
// ----------------------------------------------------
// by: mel: 05/09/05, 14:17:46
// ----------------------------------------------------
// Modified by: Mel Bohince (4/20/20) orda'fy it
C_TEXT:C284($1; $0; $user)
If (Count parameters:C259=1)
	$user:=$1
Else 
	$user:=Current user:C182
End if 

C_OBJECT:C1216($user_es)
$user_es:=ds:C1482.Users.query("UserName = :1"; $user)
If ($user_es.length>0)
	$0:=$user_es.first().Initials
Else 
	$0:="n/f"
End if 

