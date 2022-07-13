// _______
// Method: [Vendors].VendorMgmt.SearchPicker2   ( ) ->
// By: Mel Bohince @ 04/16/20, 15:47:15
// Description
// 
// ----------------------------------------------------

Case of 
		
	: (Form event code:C388=On Load:K2:1)
		// Init the var itself
		// this can be done anywhere else in your code
		C_TEXT:C284(vSearch2)
		vSearch2:=""
		// the let's customise the SearchPicker (if needed)
		C_TEXT:C284($ObjectName)
		$ObjectName:=OBJECT Get name:C1087(Object current:K67:2)
		// The exemple below shows how to set a label (ex : "name") inside the search zone
		SearchPicker SET HELP TEXT($ObjectName; "Id, Subject, PO, Xref")
		
	: (Form event code:C388=On Data Change:K2:15)
		$onlyActive:=OBJECT Get pointer:C1124(Object named:K67:5; "ShowInactive")
		If ($onlyActive->=0)
			Form:C1466.listBoxEntities:=Form:C1466.masterClass.query(Form:C1466.searchBoxQueryActive; "@"+vSearch2+"@"; True:C214).orderBy(Form:C1466.defaultOrderBy)
		Else   //include inactives
			Form:C1466.listBoxEntities:=Form:C1466.masterClass.query(Form:C1466.searchBoxQueryInactive; "@"+vSearch2+"@").orderBy(Form:C1466.defaultOrderBy)
		End if 
		
		If (Form:C1466.listBoxEntities.length>0)
			Form:C1466.editEntity:=Form:C1466.listBoxEntities.first()
		End if 
End case 
