//%attributes = {"publishedWeb":true}
//PM: wms_locationExists() -> 
//@author Mel - 5/9/03  16:50


C_BOOLEAN:C305($0)
C_TEXT:C284($1)
C_LONGINT:C283($bc)

READ ONLY:C145([WMS_AllowedLocations:73])
SET QUERY LIMIT:C395(1)
QUERY:C277([WMS_AllowedLocations:73]; [WMS_AllowedLocations:73]ValidLocation:1=$1)
If (Records in selection:C76([WMS_AllowedLocations:73])>0)
	$0:=True:C214
Else   //maybe it was scanned
	$bc:=Num:C11($1)
	QUERY:C277([WMS_AllowedLocations:73]; [WMS_AllowedLocations:73]BarcodedID:2=$bc)
	If (Records in selection:C76([WMS_AllowedLocations:73])>0)
		$0:=True:C214
	Else 
		$0:=False:C215
	End if 
End if 
SET QUERY LIMIT:C395(0)
