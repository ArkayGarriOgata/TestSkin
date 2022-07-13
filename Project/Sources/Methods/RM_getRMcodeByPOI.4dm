//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 10/26/05, 10:18:48
// ----------------------------------------------------
// Method: RM_getRMcodeByPOI(poitemkey) ->
// Description
// spawn as new process to get an RM code into ◊Raw_Matl_Code while on a POI rec
//or use as function
//usage:
//   ◊Raw_Matl_Code:=""
//   $pid:=New process("RM_getRMcodeByPOI";32*1024;"GetRMcode";sCriterion1)
//   Repeat 
//      DELAY PROCESS(Current process;10)
//   Until (Length(◊Raw_Matl_Code)>0)
// ----------------------------------------------------

C_TEXT:C284($poi; $1)
C_TEXT:C284(<>Raw_Matl_Code; $0)

$poi:=$1

READ ONLY:C145([Purchase_Orders_Items:12])
SET QUERY LIMIT:C395(1)
QUERY:C277([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]POItemKey:1=$poi)
SET QUERY LIMIT:C395(0)
If (Records in selection:C76([Purchase_Orders_Items:12])>0)
	<>Raw_Matl_Code:=[Purchase_Orders_Items:12]Raw_Matl_Code:15
Else 
	<>Raw_Matl_Code:="Not_Found"
End if 
$0:=<>Raw_Matl_Code