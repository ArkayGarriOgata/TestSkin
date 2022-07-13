// _______
// Method: [MaintRepairSupply_Bins].ControlCenter.SearchPicker2   ( ) ->
// By: Mel Bohince @ 07/03/19, 15:52:48
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
		SearchPicker SET HELP TEXT($ObjectName; "Part, VPN, Desc, Dept")
		
	: (Form event code:C388=On Data Change:K2:15)
		Form:C1466.parts:=Form:C1466.subClass.query(Form:C1466.searchBoxQueryParts; "@"+vSearch2+"@"; 13).orderBy(Form:C1466.defaultPartsOrderBy)
		
		If (Form:C1466.parts.length>0)
			Form:C1466.clickedPart:=Form:C1466.parts.first()
		End if 
		
		
		//OR DepartmentID = :1
End case 
