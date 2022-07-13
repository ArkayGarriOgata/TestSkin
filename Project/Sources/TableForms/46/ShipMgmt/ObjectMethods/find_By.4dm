// Method: Form.findBy
// ----------------------------------------------------
// User name (OS): Mel Bohince  : 06/16/20, 10:30:01
// ----------------------------------------------------
// the search widget is too slow when on WAN, so wait for the complete criterian
// Modified by: Mel Bohince (7/16/20) use Form.elcOpenFirm as basis for queries

If (Form event code:C388=On Data Change:K2:15)
	
	If (Length:C16(Form:C1466.findBy)>0)
		$criterian:="@"+Form:C1466.findBy+"@"
	Else 
		$criterian:="@"
	End if 
	
	//$onlyActive:=OBJECT Get pointer(Object named;"ShowInactive")
	//If ($onlyActive->=0)
	Form:C1466.listBoxEntities:=Form:C1466.elcOpenFirm.query(Form:C1466.searchBoxQueryActive; $criterian).orderBy(Form:C1466.defaultOrderBy)
	//Else 
	//Form.listBoxEntities:=Form.elcOpenFirm.query(Form.searchBoxQueryInactive;$criterian).orderBy(Form.defaultOrderBy)
	//End if 
	
	If (Form:C1466.listBoxEntities.length>0)
		Form:C1466.editEntity:=Form:C1466.listBoxEntities.first()
	End if 
	
	asQueryTypes{0}:="Quick search..."
	asQueryTypes:=0
	
	Form:C1466.message:="Releases containing "+Form:C1466.findBy
	Form:C1466.findBy:=""
	
	OBJECT SET ENABLED:C1123(*; "select@"; False:C215)
	Release_ShipMgmt_calcFooters
End if 