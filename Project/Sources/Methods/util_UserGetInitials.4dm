//%attributes = {}
// _______
// Method: util_UserGetInitials   ( {username}) ->
// By: Mel Bohince @ 04/30/19, 15:42:11
// Description
// 
// ----------------------------------------------------


C_TEXT:C284($username; $1; $0)

If (Count parameters:C259=1)
	$username:=$1
Else 
	$username:=Current user:C182
End if 

QUERY:C277([Users:5]; [Users:5]UserName:11=$username)
If (Records in selection:C76([Users:5])=1)
	$0:=[Users:5]Initials:1
Else 
	$0:="n/f"
End if 
