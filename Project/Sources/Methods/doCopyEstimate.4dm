//%attributes = {"publishedWeb":true}
//doCopyEstimate
//upr 1239 11/2/94

uSetUp(1; 1)  // based on doModifyRecord()

READ WRITE:C146(filePtr->)
READ WRITE:C146([Estimates:17])

iMode:=5
xText:=""
windowTitle:="Copy Estimate"
$winRef:=OpenFormWindow(->[Estimates:17]; "Input"; ->windowTitle)

DIALOG:C40([Estimates:17]; "CopyEst_dio")
ERASE WINDOW:C160($winRef)
If (OK=1)  //perform search 
	bModMany:=False:C215
	iMode:=2
	
	zwStatusMsg("COPY EST"; "Opening the copy.")
	MODIFY RECORD:C57([Estimates:17]; *)
End if 
CLOSE WINDOW:C154($winRef)

uSetUp(0; 0)