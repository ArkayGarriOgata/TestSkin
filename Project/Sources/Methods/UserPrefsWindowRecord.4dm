//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 01/31/13, 15:33:03
// ----------------------------------------------------
// Method: UserPrefsWindowRecord
// Description:
// Makes sure each user has a [UserPrefs] ButtonLayout record.
// ----------------------------------------------------

C_BOOLEAN:C305(<>bButtons)

QUERY:C277([UserPrefs:184]; [UserPrefs:184]UserName:2=Current user:C182; *)
QUERY:C277([UserPrefs:184];  & ; [UserPrefs:184]PrefType:4="ButtonLayout")

If (Records in selection:C76([UserPrefs:184])=0)
	CREATE RECORD:C68([UserPrefs:184])
	[UserPrefs:184]UserName:2:=Current user:C182
	[UserPrefs:184]PrefType:4:="ButtonLayout"
	[UserPrefs:184]TextField:5:="1:2:3:4:5:6:7:8:9:10:11:12:13:14:15:16"
	[UserPrefs:184]TextField2:3:="1:1:1:1:1:1:1:1:1:1:1:1:1:1:1:1"
	[UserPrefs:184]TextField3:11:="Icons"
	SAVE RECORD:C53([UserPrefs:184])
End if 

If (Substring:C12([UserPrefs:184]TextField3:11; 1; 1)="B")  // Modified by: Mark Zinke (2/26/13) Removed char ref symbols and added substring command.
	<>bButtons:=True:C214
Else 
	<>bButtons:=False:C215
End if 

UNLOAD RECORD:C212([UserPrefs:184])