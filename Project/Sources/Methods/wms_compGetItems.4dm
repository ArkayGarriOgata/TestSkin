//%attributes = {"publishedWeb":true}
//PM: wms_compGetItems() -> 
//@author Mel - 5/9/03  16:52

//comp_getItems
C_TEXT:C284($1)

If (Count parameters:C259=1)
	QUERY:C277([WMS_Compositions:124]; [WMS_Compositions:124]Container:1=$1)
End if 

READ WRITE:C146([WMS_ItemMasters:123])
RELATE ONE SELECTION:C349([WMS_ItemMasters:123]; [WMS_Compositions:124])