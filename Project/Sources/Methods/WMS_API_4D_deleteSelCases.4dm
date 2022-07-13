//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: WMS_API_4D_deleteSelCases - Created v0.1.0-JJG (05/12/16)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

C_LONGINT:C283($i)
C_TEXT:C284($ttSQL)
C_BOOLEAN:C305($fDelete)

If (WMS_API_4D_DoLogin)
	$ttSQL:=WMS_API_4D_deleteSelCasesSQL
	$fDelete:=(rft_response="BNV-99-99-9")
	
	For ($i; 1; Size of array:C274(Listbox1))
		If (Listbox1{$i})
			If (Not:C34($fDelete))
				SQL SET PARAMETER:C823(rft_Bin{$i}; SQL param in:K49:1)
				SQL SET PARAMETER:C823(<>zResp; SQL param in:K49:1)
			End if 
			SQL SET PARAMETER:C823(rft_case{$i}; SQL param in:K49:1)
			SQL EXECUTE:C820($ttSQL)
			If (OK=1)
				rft_Skid{$i}:="------------------"
				rft_Status{$i}:="DELETED"
				rft_Bin{$i}:="BNV-99-99-9"
			Else 
				rft_Status{$i}:="NOT DELETED"
			End if 
			SQL CANCEL LOAD:C824  //return cursor
			
			
		End if 
	End for 
	
	WMS_API_4D_DoLogout
Else 
	uConfirm("Sorry, could not connect to WMS at this time."; "Try Later"; "Help")
	
End if 