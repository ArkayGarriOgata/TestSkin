//%attributes = {}
// Method: FG_getBrandLine () -> 
// ----------------------------------------------------
// by: mel: 06/22/04, 16:59:51
// ----------------------------------------------------
// Description:
// return customer Line when given the cpn

C_TEXT:C284($1)
C_TEXT:C284($0)

$0:=""
MESSAGES OFF:C175
READ ONLY:C145([Finished_Goods:26])
SET QUERY LIMIT:C395(1)
QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]ProductCode:1=$1)
If (Records in selection:C76([Finished_Goods:26])=1)
	$0:=[Finished_Goods:26]Line_Brand:15
End if 
SET QUERY LIMIT:C395(0)
REDUCE SELECTION:C351([Finished_Goods:26]; 0)