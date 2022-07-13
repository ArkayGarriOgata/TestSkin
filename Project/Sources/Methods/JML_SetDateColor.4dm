//%attributes = {}
// Method: JML_SetDateColor (->checkbox;->obj) ->nul 
// ----------------------------------------------------
// by: mel: 08/20/03, 12:38:18
//mlb 4/29/06 don't allow changes before job is released
// ----------------------------------------------------
// Description:
// change color of checkbox and adjacent field
// ----------------------------------------------------

C_POINTER:C301($1; $2)
C_TEXT:C284($3)

If ($1->=1)
	Core_ObjectSetColor($1; -(Dark green:K11:10+(256*White:K11:1)))
	Core_ObjectSetColor($2; -(White:K11:1+(256*Dark green:K11:10)))
Else 
	Core_ObjectSetColor($1; -(Black:K11:16+(256*White:K11:1)))
	Core_ObjectSetColor($2; -(White:K11:1+(256*Red:K11:4)))
End if 
//mlb 4/29/06
If (Count parameters:C259=3)
	If (jobHasBeenReleased)
		OBJECT SET ENABLED:C1123($1->; True:C214)
	Else 
		OBJECT SET ENABLED:C1123($1->; False:C215)
	End if 
End if 