// _______
// Method: [Customers_ReleaseSchedules].ShipMgmt.searchBtn   ( ) ->
// By: Mel Bohince @ 06/29/20, 10:36:37
// Description
// use the 4D query editor
// ----------------------------------------------------
READ ONLY:C145([Customers_ReleaseSchedules:46])
USE ENTITY SELECTION:C1513(Form:C1466.listBoxEntities)

SET AUTOMATIC RELATIONS:C310(True:C214; True:C214)
QUERY:C277([Customers_ReleaseSchedules:46])
SET AUTOMATIC RELATIONS:C310(False:C215; False:C215)

Form:C1466.listBoxEntities:=Create entity selection:C1512([Customers_ReleaseSchedules:46])

Release_ShipMgmt_calcFooters

REDUCE SELECTION:C351([Customers_ReleaseSchedules:46]; 0)
