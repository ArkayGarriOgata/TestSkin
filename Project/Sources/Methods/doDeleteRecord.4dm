//%attributes = {"publishedWeb":true}
//doDeleteRecord
//mod `9/21/94

uSetUp(1; 1)
gClearFlags
fDel:=True:C214
fromDelete:=True:C214
bModMany:=False:C215
READ WRITE:C146(filePtr->)

$winRef:=Open form window:C675(filePtr->; "Input"; Plain form window:K39:10)
SET WINDOW TITLE:C213(fNameWindow(FilePtr)+" Deleting records"; $winRef)
NumRecs1:=fSelectBy  //generic search equal or range on any four fields
CLOSE WINDOW:C154($winRef)

If (OK=1)
	Case of 
		: (NumRecs1=1)  // something is going to go   
			gValidDelete(filePtr)  //9/21/94
			
		: (NumRecs1>1)
			BEEP:C151
			ALERT:C41(String:C10(NumRecs1)+" records match your criterion."+Char:C90(13)+"Please be more specific."+Char:C90(13)+"No deletions occured!")
	End case 
End if   //ok
fromDelete:=False:C215
uSetUp(0; 0)
READ ONLY:C145(filePtr->)
UNLOAD RECORD:C212(filePtr->)