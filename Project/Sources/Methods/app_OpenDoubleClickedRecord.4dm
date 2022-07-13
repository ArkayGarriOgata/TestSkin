//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 09/28/06, 12:06:19
// ----------------------------------------------------
// Method: app_OpenDoubleClickedRecord
// ----------------------------------------------------

C_POINTER:C301($1; $tablePtr)
C_LONGINT:C283($2; $mode)

$tablePtr:=$1

GET HIGHLIGHTED RECORDS:C902($tablePtr->; "doubleclickedSet")

If (Count parameters:C259>=2)
	$mode:=$2
	If ($mode=0)
		If (iMode=1)
			$mode:=2
		Else 
			$mode:=iMode
		End if 
	End if 
Else 
	If (iMode=1)
		$mode:=2
	Else 
		$mode:=iMode
	End if 
End if 

If ($mode=3)
	DISPLAY SELECTION:C59($tablePtr->; *)
Else 
	If (Read only state:C362($tablePtr->))
		UNLOAD RECORD:C212($tablePtr->)
		READ WRITE:C146($tablePtr->)
		LOAD RECORD:C52($tablePtr->)
		$reloaded:=True:C214
	Else 
		$reloaded:=False:C215
	End if 
	MODIFY RECORD:C57($tablePtr->; *)
	If ($reloaded)
		UNLOAD RECORD:C212($tablePtr->)
		READ ONLY:C145($tablePtr->)
		LOAD RECORD:C52($tablePtr->)
	End if 
End if 
UNLOAD RECORD:C212($tablePtr->)

ControlCtrFill($tablePtr)  // Added by: Mark Zinke (3/22/13)