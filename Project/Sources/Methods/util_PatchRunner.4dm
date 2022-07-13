//%attributes = {"publishedWeb":true}
//PM:  util_PatchRunner  2/27/01  mlb
//  `read a text file of 4D statements
//and execute them one at a time
//sample text file (patch01.text):
//    search([USER];[USER]ModDate=current date)
//    apply to selection([USER];[USER]ModWho:=◊zResp)
//    •eof
//•030397  MLB  open a window for messages
C_TIME:C306($docRef)
C_TEXT:C284($thePatch)
C_LONGINT:C283($linesExecuted)
$docRef:=Open document:C264("")
$doc:=document
If (ok=1)
	RECEIVE PACKET:C104($docRef; $thePatch; "•")
	CLOSE DOCUMENT:C267($docRef)
	
	$linesExecuted:=util_Patch($thePatch)
	BEEP:C151
	ALERT:C41(String:C10($linesExecuted)+" Lines executed.")
End if   //open doc
uWinListCleanup
//