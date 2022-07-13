tText:=""
//QUERY([Raw_Materials_Locations];[Raw_Materials_Locations]POItemKey=[Raw_Materials_Transactions]POItemKey;*)
//QUERY([Raw_Materials_Locations]; & ;[Raw_Materials_Locations]Location=[Raw_Materials_Transactions]Location)

// Modified by: Mel Bohince (1/14/20) 
C_OBJECT:C1216($entSel)
$entSel:=ds:C1482.Raw_Materials_Locations.query("POItemKey = :1 and Location = :2"; [Raw_Materials_Transactions:23]POItemKey:4; [Raw_Materials_Transactions:23]viaLocation:11)
If ($entSel.length=0)
	ALERT:C41([Raw_Materials_Transactions:23]viaLocation:11+" doesn't have PO "+[Raw_Materials_Transactions:23]POItemKey:4)
	[Raw_Materials_Transactions:23]viaLocation:11:=""
End if 