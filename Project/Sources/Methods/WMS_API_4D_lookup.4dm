//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: WMS_API_4D_lookup - Created v0.1.0-JJG (05/09/16)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 
C_LONGINT:C283($i; $xlNumRows; $xlQTY)
C_TEXT:C284($ttWhere)
ARRAY BOOLEAN:C223(ListBox1; 0)
ARRAY TEXT:C222(rft_Case; 0)
ARRAY TEXT:C222(rft_Skid; 0)
ARRAY TEXT:C222(rft_Bin; 0)
ARRAY LONGINT:C221($xlCaseStatusCode; 0)
ARRAY TEXT:C222(rft_Status; 0)

If (WMS_API_4D_DoLogin)
	$ttWhere:=rft_response
	SQL SET PARAMETER:C823($ttWhere; SQL param in:K49:1)
	SQL EXECUTE:C820(WMS_API_4D_lookupSQL; rft_Case; rft_Skid; $xlCaseStatusCode; rft_Bin)
	If (OK=1)
		If (Not:C34(SQL End selection:C821))
			SQL LOAD RECORD:C822(SQL all records:K49:10)
			$xlQTY:=0
			$xlNumRows:=Size of array:C274(rft_Bin)
			ARRAY TEXT:C222(rft_Status; Size of array:C274($xlCaseStatusCode))
			For ($i; 1; $xlNumRows)
				If (rft_Case{$i}#rft_Skid{$i})  //not a supercase
					$xlQTY:=$xlQTY+Num:C11(WMS_CaseId(rft_Case{$i}; "qty"))
				End if 
				rft_Status{$i}:=wmss_CaseState($xlCaseStatusCode{$i})
			End for 
			
			qtyListed:=$xlQTY
			SetObjectProperties(""; ->rft_error_log; False:C215)
		Else 
			rft_error_log:=rft_response+" not found"
			SetObjectProperties(""; ->rft_error_log; True:C214; ""; False:C215)
			rft_response:=""
		End if 
		SQL CANCEL LOAD:C824
	End if 
	
	WMS_API_4D_DoLogout
Else 
	rft_error_log:="Could not connect to WMS."
	SetObjectProperties(""; ->rft_error_log; True:C214; ""; False:C215)
	rft_response:=""
End if 