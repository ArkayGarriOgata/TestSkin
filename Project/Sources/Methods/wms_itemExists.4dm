//%attributes = {"publishedWeb":true}
//PM: wms_itemExists() -> 
//@author Mel - 5/9/03  16:32

C_BOOLEAN:C305($0)
C_TEXT:C284($1; $2)
SET QUERY LIMIT:C395(1)
READ WRITE:C146([WMS_ItemMasters:123])
If (Count parameters:C259=1)
	QUERY:C277([WMS_ItemMasters:123]; [WMS_ItemMasters:123]Skidid:1=$1)
Else 
	QUERY:C277([WMS_ItemMasters:123]; [WMS_ItemMasters:123]PalletID:11=$2)
End if 
SET QUERY LIMIT:C395(0)
If (Records in selection:C76([WMS_ItemMasters:123])>0)
	$0:=True:C214
Else 
	$0:=False:C215
End if 