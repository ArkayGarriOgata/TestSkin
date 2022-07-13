//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 03/04/09, 12:31:30
// ----------------------------------------------------
// Method: x_wms_allowed_location_main
// Description
// 
//
// Parameters
// ----------------------------------------------------
READ WRITE:C146([Finished_Goods_Locations:35])
QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Reason:42="BNR@"; *)
QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]Reason:42="@-@")
APPLY TO SELECTION:C70([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Reason:42:="")
REDUCE SELECTION:C351([Finished_Goods_Locations:35]; 0)

READ WRITE:C146([WMS_AllowedLocations:73])
QUERY:C277([WMS_AllowedLocations:73]; [WMS_AllowedLocations:73]ValidLocation:1="FX@")
util_DeleteSelection(->[WMS_AllowedLocations:73])

C_TEXT:C284($line)
$line:=""
C_TEXT:C284($t; $r)
$t:=Char:C90(9)
$r:=Char:C90(13)

ALL RECORDS:C47([WMS_AllowedLocations:73])
APPLY TO SELECTION:C70([WMS_AllowedLocations:73]; [WMS_AllowedLocations:73]BarcodedID:2:=wms_convert_bin_id("wms"; [WMS_AllowedLocations:73]ValidLocation:1))

REDUCE SELECTION:C351([WMS_AllowedLocations:73]; 0)

Repeat 
	$docRef:=Open document:C264("")
	While ($docRef#?00:00:00?) & (ok=1)
		RECEIVE PACKET:C104($docRef; $line; $r)
		If (ok=1)
			util_TextParser(7; $line; Character code:C91($t); Character code:C91($r))
			CREATE RECORD:C68([WMS_AllowedLocations:73])
			[WMS_AllowedLocations:73]BarcodedID:2:=util_TextParser(1)
			[WMS_AllowedLocations:73]Description:6:=util_TextParser(7)
			[WMS_AllowedLocations:73]ReasonRequired:3:=(Position:C15("defect"; [WMS_AllowedLocations:73]Description:6)>0)
			[WMS_AllowedLocations:73]ValidLocation:1:=wms_convert_bin_id("ams"; util_TextParser(1))
			SAVE RECORD:C53([WMS_AllowedLocations:73])
		End if 
	End while 
	CLOSE DOCUMENT:C267($docRef)
Until ($docRef=?00:00:00?)


