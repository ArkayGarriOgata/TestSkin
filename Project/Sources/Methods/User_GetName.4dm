//%attributes = {}
// -------
// Method: User_GetName   ( ) ->
// By: Mel Bohince @ 04/26/17, 09:03:27
// Description
// 
// ----------------------------------------------------

C_TEXT:C284($1; $0; $user)
If (Count parameters:C259=1)
	$user:=$1
Else 
	$user:=Current user:C182
End if 

READ ONLY:C145([Users:5])
QUERY:C277([Users:5]; [Users:5]Initials:1=$user)
$0:=[Users:5]UserName:11+" x"+[Users:5]PhoneExtension:37
REDUCE SELECTION:C351([Users:5]; 0)