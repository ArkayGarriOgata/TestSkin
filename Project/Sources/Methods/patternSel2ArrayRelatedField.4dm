//%attributes = {}
// -------
// Method: patternSel2ArrayRelatedField   ( ) ->
// By: Mel Bohince @ 03/27/19, 08:08:11
// Description
// 
// ----------------------------------------------------
//note that [Customers_Order_Lines]SalesRep is not in mastertable
//so need to make the "many to one" automatic, ex: many releases to one orderline, to get salesrep

//GET FIELD RELATION ( Starting field of a relation ; Status of the Many-to-One relation ; Status of the One-to-Many relation {; *} )  
GET FIELD RELATION:C920([Customers_ReleaseSchedules:46]OrderLine:4; $one; $many)  //so it can be restored
SET FIELD RELATION:C919([Customers_ReleaseSchedules:46]OrderLine:4; Automatic:K51:4; Do not modify:K51:1)

SELECTION TO ARRAY:C260([Customers_ReleaseSchedules:46]CustomerRefer:3; $ptr_Shipements_PO->; \
[Customers_ReleaseSchedules:46]Sched_Date:5; $_Sched_Date; \
[Customers_ReleaseSchedules:46]Actual_Date:7; $_Actual_Date; \
[Customers_ReleaseSchedules:46]Actual_Qty:8; $_Actual_Qty; \
[Customers_ReleaseSchedules:46]OriginalRelQty:24; $_OriginalRelQty; \
[Customers_ReleaseSchedules:46]LastRelease:20; $ptr_Shipements_lastrelease->; \
[Customers_ReleaseSchedules:46]OrderLine:4; $ptr_Shipements_orderLine->; \
[Customers_Order_Lines:41]SalesRep:34; $ptr_Shipements_Responsable->)

SET FIELD RELATION:C919([Customers_ReleaseSchedules:46]OrderLine:4; $one; $many)
