//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: WMS_API_4D_getCasesByRelease - Created v0.1.0-JJG (05/16/16)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

C_LONGINT:C283($0; $1; $xlNumRows; $xlReleaseNumber)
C_TEXT:C284($ttSQL)
ARRAY LONGINT:C221(aPackQty; 0)
ARRAY TEXT:C222(aJobit; 0)
ARRAY TEXT:C222(aPallet; 0)
ARRAY TEXT:C222(aLocation; 0)
ARRAY LONGINT:C221(aNumCases; 0)
ARRAY LONGINT:C221(aTotalPicked; 0)
$xlReleaseNumber:=$1
$xlNumRows:=-1

READ ONLY:C145([Finished_Goods_Locations:35])  //need to grab record numbers
READ ONLY:C145([Job_Forms_Items:44])  //need to grab some fields
<>WMS_ERROR:=0

Case of 
	: (Not:C34(WMS_API_4D_DoLogin))
		utl_Logfile("wms_api.log"; String:C10([WMS_aMs_Exports:153]id:1)+": "+"Could not connect to WMS database. ")
		
	: (Not:C34(WMS_API_4D_getCasesByRelSQL($xlReleaseNumber)))
		utl_Logfile("wms_api.log"; String:C10([WMS_aMs_Exports:153]id:1)+": "+"No case were found for release "+String:C10($xlReleaseNumber))
		
	Else 
		$xlNumRows:=Size of array:C274(aPackQty)
		WMS_API_4D_getCasesByRelLoop
		
End case 

$0:=$xlNumRows