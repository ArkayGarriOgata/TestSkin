// _______
// Method: [Vendors].VendorMgmt.ShowInactive   ( ) ->
// By: Mel Bohince @ 04/16/20, 15:47:08
// Description
// 
// ----------------------------------------------------

$onlyActive:=OBJECT Get pointer:C1124(Object named:K67:5; "ShowInactive")
If ($onlyActive->=0)
	Form:C1466.listBoxEntities:=Form:C1466.masterClass.query(Form:C1466.searchBoxQueryActive; "@"+vSearch2+"@"; True:C214).orderBy(Form:C1466.defaultOrderBy)
Else   //include inactives
	Form:C1466.listBoxEntities:=Form:C1466.masterClass.query(Form:C1466.searchBoxQueryInactive; "@"+vSearch2+"@").orderBy(Form:C1466.defaultOrderBy)
End if 
