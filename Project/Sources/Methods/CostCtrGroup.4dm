//%attributes = {}
// _______
// Method: CostCtrGroup   ( "group name" ) -> collection of cc's most useful attributes
// By: Mel Bohince @ 06/03/21, 07:08:13
// Description
// return a collection of costcenters matching a group
// the group originates from [Cost_Centers]cc_Group
// ----------------------------------------------------
//   see also methods CostCtrCurrent, CostCtrInit, CostCtrGroup


If (Count parameters:C259>0)
	$findGroup:=$1
Else   //test
	//$findGroup:="89.OUTSIDE SERVICE"
	$findGroup:="80"  //.FINISHING"
End if 

$findGroup:="@"+$findGroup+"@"  //do a contains search

CostCtrInit

C_COLLECTION:C1488($cc_group_c; $0)
$cc_group_c:=New collection:C1472
$cc_group_c:=Storage:C1525.CostCenters.query("group = :1"; $findGroup)

$0:=$cc_group_c.orderBy("cc asc")
