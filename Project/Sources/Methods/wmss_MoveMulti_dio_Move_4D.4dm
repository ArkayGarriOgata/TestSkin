//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: MoveMulti_dio_Move_4D - Created v0.1.0-JJG (05/06/16)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

C_LONGINT:C283($i)


If (WMS_API_4D_DoLogin)
	
	For ($i; 1; Size of array:C274(ListBox1))
		If (Position:C15("SKIP"; rft_Case{$i})=0)
			SQL EXECUTE:C820(wmss_MoveMulti_dio_Move_4D_SQL($i))
			SQL CANCEL LOAD:C824
			If (OK=0)
				rft_Status{$i}:="FAILED"
			Else 
				rft_Status{$i}:="UPDATED"
				
				//trick ams into processing transaction
				wmss_MoveMulti__4D_AMS_export($i)
				
			End if 
		End if 
	End for 
	
	WMS_API_4D_DoLogout
	
	uConfirm("Reset")
	If (ok=1)
		wmss_initMoveMulti
	End if 
	
Else 
	rft_error_log:="Could not connect to WMS."
End if 