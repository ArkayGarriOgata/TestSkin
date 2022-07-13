//%attributes = {}

// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 03/27/13, 14:19:11
// ----------------------------------------------------
// Method: FG_getDescription

// ----------------------------------------------------

C_TEXT:C284($1)
C_TEXT:C284($0)

$0:=""
MESSAGES OFF:C175
READ ONLY:C145([Finished_Goods:26])
SET QUERY LIMIT:C395(1)
QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]ProductCode:1=$1)
If (Records in selection:C76([Finished_Goods:26])=1)
	$0:=[Finished_Goods:26]CartonDesc:3
End if 
SET QUERY LIMIT:C395(0)
REDUCE SELECTION:C351([Finished_Goods:26]; 0)