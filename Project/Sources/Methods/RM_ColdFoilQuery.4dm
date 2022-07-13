//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 01/23/14, 14:23:59
// ----------------------------------------------------
// Method: RM_ColdFoilQuery
// Description:
// One place to search for cold fold records.
// ----------------------------------------------------
// Modified by: Mel Bohince (1/29/14) add comm 05


If (Count parameters:C259=0)
	QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]CommodityCode:26=9; *)
	QUERY:C277([Raw_Materials:21];  | ; [Raw_Materials:21]Description:4="@cold foil@")  //some 05's are really coldfoils
	
Else 
	// ******* Verified  - 4D PS - January  2019 ********
	
	QUERY SELECTION:C341([Raw_Materials:21];  | ; [Raw_Materials:21]Commodity_Key:2="09@"; *)
	QUERY SELECTION:C341([Raw_Materials:21];  | ; [Raw_Materials:21]Description:4="@cold foil@")
	
	
	// ******* Verified  - 4D PS - January 2019 (end) *********
End if 