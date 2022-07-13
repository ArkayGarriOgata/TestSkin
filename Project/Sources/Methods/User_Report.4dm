//%attributes = {}
// -------
// Method: User_Report   ( ) ->
// By: Mel Bohince @ 05/25/18, 13:12:35
// Description
// 
// ----------------------------------------------------

ARRAY LONGINT:C221($aUserNumbers; 0)
ARRAY TEXT:C222($aUserNames; 0)
GET USER LIST:C609($aUserNames; $aUserNumbers)
SORT ARRAY:C229($aUserNames; $aUserNumbers; >)
utl_LogIt("init")
utl_LogIt("USER"+"\t"+"NUM_LOGINS"+"\t"+"LAST_LOGIN")
For ($user; 1; Size of array:C274($aUserNumbers))
	GET USER PROPERTIES:C611($aUserNumbers{$user}; $name; $startup; $password; $nbLogin; $lastLogin)
	utl_LogIt($name+"\t"+String:C10($nbLogin)+"\t"+String:C10($lastLogin; Internal date short special:K1:4))
End for 
utl_LogIt("show")
