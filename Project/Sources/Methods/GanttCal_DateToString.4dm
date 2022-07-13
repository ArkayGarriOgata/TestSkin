//%attributes = {}
//© 2015 Footprints Inc. All Rights Reserved.
//Method: Method: GanttCal_DateToString - Created `v1.0.0-PJK (12/22/15)
C_BOOLEAN:C305(<>fDebug)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

C_DATE:C307($1)
C_TIME:C306($2)
C_TEXT:C284($0)

//  returns format 2015-11-24 07:00

$0:=String:C10($1; ISO date:K1:8; $2)
//$xlMonth:=Month of($1)
//$xlDay:=Day of($1)
//$xlYear:=Year of($1)

//$ttTime:=String($2;1)


//$0:=String($xlYear)+"-"+String($xlMonth)+"-"+String($xlDay)+"T"+$ttTime

