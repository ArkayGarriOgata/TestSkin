//%attributes = {}
// _______
// Method: CostCtrBuildPidArrays   ( ) ->
// By: Mel Bohince @ 06/03/21, 14:49:28
// Description
// set up the arrays that control the scheduling windows and pids
// ----------------------------------------------------

C_TEXT:C284($groupName; $1)
C_LONGINT:C283($0)

If (Count parameters:C259>0)
	$groupName:=$1
Else 
	$groupName:="."  //all should have period in the group, e.g. 80.FINISHING
End if 

CostCtrInit

C_COLLECTION:C1488($cc_group_c)
$cc_group_c:=CostCtrGroup($groupName)

ARRAY TEXT:C222(<>psCC; 0)  //key, such as C/C's id "412"
ARRAY TEXT:C222(<>psDESC; 0)  //storage for the desc = menu item text
ARRAY LONGINT:C221(<>psPID; 0)  //storage for process IDs
ARRAY LONGINT:C221(<>psWIN; 0)  //storage for window references

COLLECTION TO ARRAY:C1562($cc_group_c.extract("cc"); <>psCC)
COLLECTION TO ARRAY:C1562($cc_group_c.extract("desc"); <>psDESC)

ARRAY LONGINT:C221(<>psPID; $cc_group_c.length)  //storage for process IDs
ARRAY LONGINT:C221(<>psWIN; $cc_group_c.length)  //storage for window references

$0:=$cc_group_c.length
