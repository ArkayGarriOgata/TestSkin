//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: WMS_API_4D_skidAlreadyUsed - Created v0.1.0-JJG (05/11/16)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

C_BOOLEAN:C305($0; $fUnUsed)
C_TEXT:C284($ttSQL)
ARRAY TEXT:C222($sttBinID; 0)
$fUnUsed:=False:C215

If (WMS_API_4D_DoLogin)
	
	$ttSQL:="SELECT bin_id FROM cases WHERE skid_number = ?"
	SQL SET PARAMETER:C823(rft_skid_label_id; SQL param in:K49:1)
	SQL EXECUTE:C820($ttSQL; $sttBinID)
	
	If (OK=1)
		If (Not:C34(SQL End selection:C821))
			SQL LOAD RECORD:C822(SQL all records:K49:10)
		End if 
		SQL CANCEL LOAD:C824
		
		If (Size of array:C274($sttBinID)>0)
			wmss_init("Scan an unused pallet label!")
			wmss_throwError(rft_skid_label_id+" is already put away in bin "+$sttBinID{1})
			
		Else 
			$fUnUsed:=True:C214
		End if 
		
	Else 
		wmss_throwError("WMS query failed.\rTry closing window.")
	End if 
	
	WMS_API_4D_DoLogout
	
Else 
	wmss_throwError("Connection to WMS failed.\rTry closing window.")
End if 

$0:=$fUnUsed