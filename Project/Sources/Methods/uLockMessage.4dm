//%attributes = {"publishedWeb":true}
//(P) uLockMessage: presents message informing user the record is locked
//Example: uLockMessage(»[CUSTOMER])
//• 6/6/97 cs made this a floating message so processing can continue
//$1 - pointer to file
//$2 - string (optional) any - flag - make this afloating message
//  calling procedure is responsible for closing message window & resetting flag

C_POINTER:C301($1)  //pointer to file
C_TEXT:C284($2)
C_BOOLEAN:C305(fWindOpen)  //• 6/6/97 cs 

LOCKED BY:C353($1->; lEditProcNo; sEditUser; sEditMachin; sEditProces)
sfilename:=Table name:C256($1)

If (Count parameters:C259=1)
	NewWindow(420; 170; 6; 1; "")
	BEEP:C151
	DIALOG:C40([zz_control:1]; "LockMsg_Dlg")
	CLOSE WINDOW:C154
Else 
	//• 6/6/97 cs start  
	If (Not:C34(fWindOpen))
		NewWindow(400; 80; 6; -724; "")
		fWindOpen:=True:C214
	End if 
	GOTO XY:C161(2; 2)
	MESSAGE:C88(Char:C90(13)*7)  //clear any previous message
	MESSAGE:C88(" A Locked Record has been encountered, Attempting to gain Access:"+Char:C90(13)+Char:C90(13))  //tell user about problem
	MESSAGE:C88(" Locked By User: "+sEditUser+Char:C90(13))
	MESSAGE:C88(" Workstation: "+sEditMachin+Char:C90(13))
	MESSAGE:C88(" Process: "+sEditProces+Char:C90(13))
	MESSAGE:C88(" File:"+sFileName)
	//• 6/6/97 cs  end
End if 