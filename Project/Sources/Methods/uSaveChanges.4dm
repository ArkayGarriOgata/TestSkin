//%attributes = {"publishedWeb":true}
//uSaveChanges -> integer
//Displays a dialog asking the user if they want to save changes
//to the record before closing the window.

BEEP:C151

$winRef:=NewWindow(310; 90; 6; 1; "")
DIALOG:C40([zz_control:1]; "SaveChanges")
CLOSE WINDOW:C154($winRef)

Case of 
	: (bYes=1)  //yes, save changes all the way back
		fWindClose:=True:C214
	: (bCancel=1)  //cancel close action, keep on screen
	: (bNo=1)  //close the window but cancel changes
		fWindCancel:=True:C214
End case 