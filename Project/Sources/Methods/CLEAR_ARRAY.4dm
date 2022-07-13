//%attributes = {}
//© 2015 Footprints Inc. All Rights Reserved.
//Method: Method: CLEAR_ARRAY - Created `v1.0.0-PJK (12/22/15)
C_BOOLEAN:C305(<>fDebug)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 


//$1=->Array
C_POINTER:C301($1)
$xlSize:=Size of array:C274($1->)
If ($xlSize>0)
	DELETE FROM ARRAY:C228($1->; 1; $xlSize)
End if 