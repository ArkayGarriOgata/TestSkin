//%attributes = {"publishedWeb":true}
//(P) gSearchProcess: Searching in its own process If (uSelectFile )  `Choose file
//• 7/16/97 cs rewrote this and spawning process - so that processes is named
// better for process list - now includes file name being searched
//  old code commented out, at bottom of proc - can remove after 1 month
//• 7/24/97 cs found that system OK was not set

NewWindow(499; 293; 6; 0; "Search:")  //;"uCloseLayout")
zDefFilePtr:=->[Vendors:7]
zDefFilePtr:=<>SrchFilePtr
rbSearchEd:=<>UseSearchEd

If (rbSearchEd=0)
	ALL RECORDS:C47(zDefFilePtr->)
	OK:=1  //• 7/24/97 cs needed later
End if 
fAdHocLocal:=False:C215
SET MENU BAR:C67(3)
gSearch
fAdHocLocal:=False:C215
uClearSelection(zDefFilePtr)
uWinListCleanup