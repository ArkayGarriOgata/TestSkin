//%attributes = {"publishedWeb":true}
//eCancelPrint: uses Escape key  
//upr 1342 12/5/94

If (KeyCode=27) | ((((Modifiers\256)%2)=1) & (KeyCode=46))
	<>fContinue:=False:C215
	BEEP:C151
	ALERT:C41("Printing Canceled."+<>sCr+"If You are Viewing this Report On-Screen, Click the 'Next Page' Button to Clear the Report.")
End if 