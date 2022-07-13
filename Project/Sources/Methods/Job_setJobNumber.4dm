//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 11/03/06, 16:42:03
// ----------------------------------------------------
// Method: Job_setJobNumber
// Description
// was $jobId:=Seq444uence number([Jobs])+◊aOffSet{Table(->[Jobs])}
//`THIS TABLE WILL DEPEND ON ID SERIES BEING DIFFERENT AT EACH LOCATION
// ----------------------------------------------------

C_TEXT:C284($server)
C_LONGINT:C283($nextID; $0)

$server:="?"
$nextID:=-3

If (app_getNextID(Table:C252(->[Jobs:15]); ->$server; ->$nextID))
	$nextID:=$nextID  //THIS TABLE WILL DEPEND ON ID SERIES BEING DIFFERENT AT EACH LOCATION
	
Else 
	$nextID:=-1
	CANCEL:C270
End if 

$0:=$nextID