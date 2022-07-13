//%attributes = {}
// Method: EDI_GetNextIDfromPreferences
// ----------------------------------------------------
//former: fGetNextIdByPreference(seqName)  102898  MLB
//user controlled Id numbers

C_LONGINT:C283($0)

READ WRITE:C146([edi_Preferences:157])
QUERY:C277([edi_Preferences:157]; [edi_Preferences:157]PrefName:2="Sequence"; *)
QUERY:C277([edi_Preferences:157];  & ; [edi_Preferences:157]UserName:1=$1)

If (Records in selection:C76([edi_Preferences:157])#1)
	CREATE RECORD:C68([edi_Preferences:157])
	[edi_Preferences:157]UserName:1:=$1
	[edi_Preferences:157]PrefName:2:="Sequence"
	[edi_Preferences:157]Prefs:3:=Request:C163("Please enter starting ID number for"+$1+": "; "1")
	SAVE RECORD:C53([edi_Preferences:157])
End if 

If (fLockNLoad(->[edi_Preferences:157]))
	$0:=Num:C11([edi_Preferences:157]Prefs:3)
	[edi_Preferences:157]Prefs:3:=String:C10(Num:C11([edi_Preferences:157]Prefs:3)+1)
	SAVE RECORD:C53([edi_Preferences:157])
Else 
	uConfirm("Next ID_NUMBER process stopped by user"; "OK"; "Help")
	CANCEL:C270
	$0:=-1
End if 
REDUCE SELECTION:C351([edi_Preferences:157]; 0)