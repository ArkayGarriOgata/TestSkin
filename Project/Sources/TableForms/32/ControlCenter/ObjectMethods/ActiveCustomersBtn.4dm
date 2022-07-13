// _______
// Method: [Salesmen].ControlCenter.ActiveCustomersBtn   ( ) ->
// By: Mel Bohince @ 12/11/19, 10:30:02
// Description
// 
// ----------------------------------------------------


Form:C1466.customers:=ds:C1482.Customers.query("( Active = :1 "; True:C214).orderBy("Name asc")
customerSelection:="ACTIVE"
