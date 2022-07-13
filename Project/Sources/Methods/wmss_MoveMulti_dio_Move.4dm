//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: MoveMulti_dio_Move - Created v0.1.0-JJG (05/06/16)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

If (<>fWMS_Use4D)
	wmss_MoveMulti_dio_Move_4D
	
Else 
	wmss_MoveMulti_dio_Move_MySQL
	
End if 