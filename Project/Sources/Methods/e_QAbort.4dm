//%attributes = {"publishedWeb":true}
//(P) uQAbort: Called by ON EVENT CALL used in Print Layout routines

If ((keycode=81) | (keycode=113))
	BEEP:C151
	CONFIRM:C162("Are you sure you want to ABORT this process!")
	If (OK=1)
		fLoop:=False:C215
	End if 
End if 