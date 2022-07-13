//%attributes = {"publishedWeb":true}
//PM: ams_RecentRMInventory() -> 
//@author mlb - 7/3/02  11:56

C_TEXT:C284($0; $1)

$0:=""

If (Count parameters:C259=1)
	READ ONLY:C145([Raw_Materials_Locations:25])
	ALL RECORDS:C47([Raw_Materials_Locations:25])
	CREATE SET:C116([Raw_Materials_Locations:25]; "recentRMbin")
	$0:="recentRMbin"
	REDUCE SELECTION:C351([Raw_Materials_Locations:25]; 0)
Else 
	CLEAR SET:C117("recentRMbin")
End if 