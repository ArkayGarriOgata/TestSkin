// _______
// Method: [Salesmen].ControlCenter.NoRepCustomersBtn   ( ) ->
// By: Mel Bohince @ 12/11/19, 11:23:41
// Description
// 
// ----------------------------------------------------


Form:C1466.customers:=ds:C1482.Customers.query("( SalesmanID = :1 "; "UN").orderBy("Name asc")
customerSelection:="NO REP"