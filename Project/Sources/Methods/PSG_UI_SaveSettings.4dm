//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 02/17/14, 11:17:02
// ----------------------------------------------------
// Method: PSG_UI_SaveSettings
// Description:
// Sets the radio and checkboxes.
// ----------------------------------------------------

C_TEXT:C284($1; $tSave)

QUERY:C277([UserPrefs:184]; [UserPrefs:184]UserName:2=Current user:C182; *)
QUERY:C277([UserPrefs:184];  & ; [UserPrefs:184]PrefType:4="GlueSettings")
If (Records in selection:C76([UserPrefs:184])=0)
	CREATE RECORD:C68([UserPrefs:184])
	[UserPrefs:184]PrefType:4:="GlueSettings"
	[UserPrefs:184]UserName:2:=Current user:C182
	[UserPrefs:184]TextField:5:="101000111111111111"
	SAVE RECORD:C53([UserPrefs:184])
End if 

If ($1="Set")
	f1:=Num:C11(Substring:C12([UserPrefs:184]TextField:5; 1; 1))
	f2:=Num:C11(Substring:C12([UserPrefs:184]TextField:5; 2; 1))
	
	rb1:=Num:C11(Substring:C12([UserPrefs:184]TextField:5; 3; 1))
	rb2:=Num:C11(Substring:C12([UserPrefs:184]TextField:5; 4; 1))
	rb3:=Num:C11(Substring:C12([UserPrefs:184]TextField:5; 5; 1))
	rb4:=Num:C11(Substring:C12([UserPrefs:184]TextField:5; 6; 1))
	
	cb1:=Num:C11(Substring:C12([UserPrefs:184]TextField:5; 7; 1))
	cb2:=Num:C11(Substring:C12([UserPrefs:184]TextField:5; 8; 1))
	cb3:=Num:C11(Substring:C12([UserPrefs:184]TextField:5; 9; 1))
	cb4:=Num:C11(Substring:C12([UserPrefs:184]TextField:5; 10; 1))
	cb5:=Num:C11(Substring:C12([UserPrefs:184]TextField:5; 11; 1))
	cb6:=Num:C11(Substring:C12([UserPrefs:184]TextField:5; 12; 1))
	cb7:=Num:C11(Substring:C12([UserPrefs:184]TextField:5; 13; 1))
	cb8:=Num:C11(Substring:C12([UserPrefs:184]TextField:5; 14; 1))
	cb9:=Num:C11(Substring:C12([UserPrefs:184]TextField:5; 15; 1))
	cb10:=Num:C11(Substring:C12([UserPrefs:184]TextField:5; 16; 1))
	cb11:=Num:C11(Substring:C12([UserPrefs:184]TextField:5; 17; 1))
	cb12:=Num:C11(Substring:C12([UserPrefs:184]TextField:5; 18; 1))
	
Else 
	$tSave:=String:C10(f1)+String:C10(f2)
	$tSave:=$tSave+String:C10(rb1)+String:C10(rb2)+String:C10(rb3)+String:C10(rb4)
	$tSave:=$tSave+String:C10(cb1)+String:C10(cb2)+String:C10(cb3)
	$tSave:=$tSave+String:C10(cb4)+String:C10(cb5)+String:C10(cb6)
	$tSave:=$tSave+String:C10(cb7)+String:C10(cb8)+String:C10(cb9)
	$tSave:=$tSave+String:C10(cb10)+String:C10(cb11)+String:C10(cb12)
	[UserPrefs:184]TextField:5:=$tSave
	SAVE RECORD:C53([UserPrefs:184])
End if 