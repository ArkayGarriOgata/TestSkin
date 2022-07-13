// _______
// Method: [Salesmen].ControlCenter.ActiveRepsBtn   ( ) ->
// By: Mel Bohince @ 12/10/19, 10:27:43
// Description
// 
// ----------------------------------------------------



Form:C1466.reps:=ds:C1482.Salesmen.query("( Active = :1 "; True:C214).orderBy("FirstName asc")
repSelection:="ACTIVE"


