// _______
// Method: [Customers_ReleaseSchedules].ShipMgmtConsolidation   ( ) ->
// By: Mel Bohince @ 04/14/21, 08:23:08
// Description
// 
// ----------------------------------------------------

If (Form event code:C388=On Load:K2:1)
	C_TEXT:C284(consolidationID)
	consolidationID:=Form:C1466.consolidationID
	C_LONGINT:C283(countPO; sumCases)
	C_REAL:C285(avgSpaces)
	If (Form:C1466.shipments#Null:C1517)  //calculate footers
		countPO:=Form:C1466.shipments.length
		sumCases:=Form:C1466.shipments.sum("numCases")
		avgSpaces:=Round:C94(Form:C1466.shipments.average("caseSpaces"); 2)
	End if 
	
	If (Form:C1466.calcSummary_c#Null:C1517)  //calculate footers
		sumPallets:=Round:C94(Form:C1466.calcSummary_c.sum("countPallets"); 2)
	End if 
	
End if 

