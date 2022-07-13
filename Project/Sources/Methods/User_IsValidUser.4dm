//%attributes = {}

// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 03/21/11, 16:36:39
// ----------------------------------------------------
// Method: User_IsValidUser
// Description
// see if user intials is someone who can log in
//
// Parameters
// ----------------------------------------------------
C_TEXT:C284($1)
SET QUERY DESTINATION:C396(Into variable:K19:4; $found)
QUERY:C277([Users:5]; [Users:5]Initials:1=$1; *)
QUERY:C277([Users:5]; [Users:5]UserName:11#"")
SET QUERY DESTINATION:C396(Into current selection:K19:1)
If ($found>0)
	$0:=True:C214
Else 
	$0:=False:C215
End if 