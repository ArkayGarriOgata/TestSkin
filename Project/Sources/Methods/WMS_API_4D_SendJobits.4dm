//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: wms_api_4D_SendJobits - Created v0.1.0-JJG (05/05/16)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 


C_LONGINT:C283($i; $xlProgBar; $xlProgressOld; $xlProgressNew; $xlNumRecs)
$xlNumRecs:=Records in selection:C76([Job_Forms_Items:44])

ON ERR CALL:C155("")
//SQL LOGIN("IP:"+WMS_API_4D_GetLoginHost +":"+WMS_API_4D_GetLoginPort ;WMS_API_4D_GetLoginUser ;WMS_API_4D_GetLoginPassword ;*)

If (WMS_API_4D_DoLogin)
	$xlProgBar:=Progress New
	Progress SET TITLE($xlProgBar; "Jobit Export"; 0; "Processing jobits for export to WMS"; True:C214)
	For ($i; 1; $xlNumRecs)
		$xlProgressNew:=100*$i/$xlNumRecs
		If ($xlProgressNew#$xlProgressOld)
			$xlProgressOld:=$xlProgressNew
			Progress SET PROGRESS($xlProgBar; $xlProgressNew/100)
		End if 
		
		GOTO SELECTED RECORD:C245([Job_Forms_Items:44]; $i)
		WMS_API_4D_SendJobits_Do
		
	End for 
	Progress QUIT($xlProgBar)
	
	WMS_API_4D_DoLogout
Else 
	ALERT:C41("The Jobit could not be sent to WMS, try one label later.")
End if 