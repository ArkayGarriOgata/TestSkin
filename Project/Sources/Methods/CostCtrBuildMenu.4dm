//%attributes = {}
// _______
// Method: CostCtrBuildMenu   ( $groupName ) -> $menuDefinition text
// By: Mel Bohince @ 06/03/21, 14:14:01
// Description
// build a data-based menu for Scheduling module
// ----------------------------------------------------
C_TEXT:C284($groupName; $1; $0; $menuDefinition)

If (Count parameters:C259>0)
	$groupName:=$1
Else 
	$groupName:="Outside Service"
End if 

CostCtrInit

C_COLLECTION:C1488($cc_group_c)
$cc_group_c:=CostCtrGroup($groupName)

$menuDefinition:=$cc_group_c.extract("desc").join(";")

$0:=$menuDefinition
