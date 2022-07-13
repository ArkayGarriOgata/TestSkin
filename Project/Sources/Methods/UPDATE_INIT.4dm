//%attributes = {}
//© 2015 Footprints Inc. All Rights Reserved.
//Method: Method: UPDATE_INIT - Created `v1.0.0-PJK (12/7/15)
C_BOOLEAN:C305(<>fDebug)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

//STD_InitComponent 
If (((Current user:C182="Administrator") | (Current user:C182="Designer")) & Not:C34(Is compiled mode:C492))  //v3.0.2-PJK (9/29/14) 
	//ON EVENT CALL("STD_EventListener")  //v3.0.2-PJK (9/29/14)
Else   //v3.0.2-PJK (9/29/14)
	
End if 
INIT_GLOBALS
READ WRITE:C146([zz_control:1])  //v3.0.2-PJK (9/29/14)
ALL RECORDS:C47([zz_control:1])  //v3.0.2-PJK (9/29/14)
GetDatafileVersion(-><>kt2Version; -><>kxiVersData)  //v3.0.2-PJK (9/29/14)

//UPDATE_DO   //v3.0.2-PJK (9/29/14) 
UNLOAD RECORD:C212([zz_control:1])  //v3.0.2-PJK (9/29/14)

