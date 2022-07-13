//%attributes = {"publishedWeb":true}
// ----------------------------------------------------
// Method: NotifierSpawn
// ----------------------------------------------------

//used to spawn the notifier deamon
C_LONGINT:C283($ID)
C_TIME:C306(<>PrefTime)

<>xPrefText:=[Users:5]Preference:14
NotifyParseDept([Users:5]WorksInDept:15)
<>PrefTime:=Num:C11(uParseString([Users:5]Preference:14; 2; "•"))

If (<>PrefTime>0) & (<>xPrefText#"")
	$ID:=New process:C317("NotifyStartup"; <>lMinMemPart; "$•NotifyDeamon")
	If (False:C215)  //insider reference
		NotifyStartup
	End if 
End if 