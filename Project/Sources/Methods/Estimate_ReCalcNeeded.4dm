//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 06/07/06, 16:18:01
// ----------------------------------------------------
// Method: Estimate_ReCalcNeeded
// Description
// clear some field so that user is signaled to recalculate
// ----------------------------------------------------
// Modified by: Garri Ogata (5/10/21) commented out adding " "


C_TEXT:C284($1)

If (Count parameters:C259=1)
	QUERY:C277([Estimates_Differentials:38]; [Estimates_Differentials:38]Id:1=$1)
End if 

[Estimates_Differentials:38]TotalPieceYld:10:=0
[Estimates_Differentials:38]TotalPieces:8:=0
[Estimates_Differentials:38]CostTTL:14:=0

SAVE RECORD:C53([Estimates_Differentials:38])

//[Estimates_DifferentialsForms]Notes:=[Estimates_DifferentialsForms]Notes+" "// Modified by: Garri Ogata (5/10/21) 
