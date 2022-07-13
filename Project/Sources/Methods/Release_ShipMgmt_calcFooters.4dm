//%attributes = {}
// _______
// Method: Release_ShipMgmt_calcFooters   ( ) ->
// By: Mel Bohince @ 06/12/20, 14:00:46
// Description
// 
// ----------------------------------------------------
If (Form:C1466.listBoxEntities#Null:C1517)
	footerCount:=Form:C1466.listBoxEntities.length
	footerQty:=Form:C1466.listBoxEntities.sum("Sched_Qty")
	footerCases:=Form:C1466.listBoxEntities.sum("NumberOfCases")
End if 


