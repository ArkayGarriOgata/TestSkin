//%attributes = {"publishedWeb":true}
//(P) mSearch: Accesses 4D Adhoc Searching
//• 7/16/97 cs moved code from process so as  to name Process
// with file name being searched

C_BOOLEAN:C305(fAdHocLocal)

If (fAdHocLocal)  //on output list
	zSetUsageLog(zDefFilePtr; "AH>Search"; Current method name:C684)
	rbSearchEd:=1
	gSearch
	
Else   //selected from splash screen
	If (uSelectFile)  //• 7/16/97 cs ask user for file choice
		<>SrchFilePtr:=zDefFilePtr
		<>UseSearchEd:=rbSearchEd
		uSpawnProcess("gSearchProcess"; 48000; Table name:C256(zDefFilePtr)+" Search"; True:C214; True:C214)
		If (False:C215)  //list called procedures for 4D Insider
			gSearchProcess
		End if 
	End if 
End if 