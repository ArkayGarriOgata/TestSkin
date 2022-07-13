//%attributes = {}
// Method: wms_locationBarcodeToName () -> 
// ----------------------------------------------------
// by: mel: 03/03/05, 10:11:44
// ----------------------------------------------------
// Description:
// 
// Updates:

// ----------------------------------------------------
C_LONGINT:C283($1)
C_TEXT:C284($0)

READ ONLY:C145([WMS_AllowedLocations:73])

SET QUERY LIMIT:C395(1)
QUERY:C277([WMS_AllowedLocations:73]; [WMS_AllowedLocations:73]BarcodedID:2=$1)
If (Records in selection:C76([WMS_AllowedLocations:73])>0)
	$0:=[WMS_AllowedLocations:73]ValidLocation:1
Else 
	$0:=""
End if 

SET QUERY LIMIT:C395(0)
REDUCE SELECTION:C351([WMS_AllowedLocations:73]; 0)
//