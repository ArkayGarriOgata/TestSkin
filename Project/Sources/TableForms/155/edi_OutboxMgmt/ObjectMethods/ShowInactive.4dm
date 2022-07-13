// _______
// Method: [edi_Outbox].edi_OutboxMgmt.ShowInactive   ( ) ->
// By: Mel Bohince @ 04/23/20, 13:32:51
// Description
// 
// ----------------------------------------------------

$onlyActive:=OBJECT Get pointer:C1124(Object named:K67:5; "ShowInactive")
If ($onlyActive->=0)
	Form:C1466.listBoxEntities:=Form:C1466.masterClass.query(Form:C1466.searchBoxQueryActive; "@"+vSearch2+"@").orderBy(Form:C1466.defaultOrderBy)
Else   //include unsent
	Form:C1466.listBoxEntities:=Form:C1466.masterClass.query(Form:C1466.searchBoxQueryInactive; "@"+vSearch2+"@"; 1).orderBy(Form:C1466.defaultOrderBy)
End if 