//%attributes = {"publishedWeb":true}
//(p) PisetupRMfrz
//called from apply to selection
//31099 mlb marty wants to use tags in a blind count
// Modified by: Mel Bohince (12/18/15) clear the consignment
// Modified by: Mel Bohince (11/27/19) //consignment is excluded from the selection
[Raw_Materials_Locations:25]PiFreezeQty:23:=[Raw_Materials_Locations:25]QtyOH:9
[Raw_Materials_Locations:25]QtyOH:9:=0  //31099 mlb marty wants to use tags in a blind count
[Raw_Materials_Locations:25]PiDoNotDelete:24:=True:C214
