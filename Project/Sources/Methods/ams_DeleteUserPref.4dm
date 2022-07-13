//%attributes = {}

// Method: ams_DeleteUserPref ( )  -> 
// ----------------------------------------------------
// Author: Mel Bohince
// Created: 02/04/15, 15:26:59
// ----------------------------------------------------
// Description
// remove pref that are old or the user was terminated
//
// ----------------------------------------------------

C_LONGINT:C283($daysToKeep; $1)
$daysToKeep:=$1*-1

ARRAY TEXT:C222($TermedUsers; 0)

Begin SQL
	
	select distinct(UserName) from UserPrefs where UserName not in 
	(select UserName from Users where DOT < '01/01/1995') into :$TermedUsers;
	
End SQL

READ WRITE:C146([UserPrefs:184])
QUERY WITH ARRAY:C644([UserPrefs:184]UserName:2; $TermedUsers)
If (Records in selection:C76([UserPrefs:184])>0)
	util_DeleteSelection(->[UserPrefs:184])
End if 

$oneMonth:=Add to date:C393(Current date:C33; 0; 0; $daysToKeep)
QUERY:C277([UserPrefs:184]; [UserPrefs:184]PrefType:4="AskMeProduct"; *)
QUERY:C277([UserPrefs:184];  & ; [UserPrefs:184]DateField:9<$oneMonth)
If (Records in selection:C76([UserPrefs:184])>0)
	util_DeleteSelection(->[UserPrefs:184])
End if 