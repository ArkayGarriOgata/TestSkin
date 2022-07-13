//%attributes = {"publishedWeb":true}
//PM: wms_resetItemMaster() -> 
//@author Mel - 5/14/03  17:11

APPLY TO SELECTION:C70([WMS_ItemMasters:123]; [WMS_ItemMasters:123]SKU:2:="")
FIRST RECORD:C50([WMS_ItemMasters:123])
APPLY TO SELECTION:C70([WMS_ItemMasters:123]; [WMS_ItemMasters:123]LOT:3:="")
FIRST RECORD:C50([WMS_ItemMasters:123])
APPLY TO SELECTION:C70([WMS_ItemMasters:123]; [WMS_ItemMasters:123]LOCATION:4:="")
FIRST RECORD:C50([WMS_ItemMasters:123])
APPLY TO SELECTION:C70([WMS_ItemMasters:123]; [WMS_ItemMasters:123]STATE:5:="")
FIRST RECORD:C50([WMS_ItemMasters:123])
APPLY TO SELECTION:C70([WMS_ItemMasters:123]; [WMS_ItemMasters:123]UOM:6:="")
FIRST RECORD:C50([WMS_ItemMasters:123])
APPLY TO SELECTION:C70([WMS_ItemMasters:123]; [WMS_ItemMasters:123]QTY:7:=0)
FIRST RECORD:C50([WMS_ItemMasters:123])
APPLY TO SELECTION:C70([WMS_ItemMasters:123]; [WMS_ItemMasters:123]DATE_MFG:8:=!00-00-00!)
FIRST RECORD:C50([WMS_ItemMasters:123])
APPLY TO SELECTION:C70([WMS_ItemMasters:123]; [WMS_ItemMasters:123]CUST:9:="")