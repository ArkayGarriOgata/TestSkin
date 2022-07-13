// _______
// Method: [Salesmen].ControlCenter.SearchPicker2   ( ) ->
// By: Mel Bohince @ 12/11/19, 11:15:10
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
		SearchPicker SET HELP TEXT($ObjectName; "Name or ID")
		
	: (Form event code:C388=On Data Change:K2:15)
		If (Length:C16(vSearch2)=0)
			Form:C1466.customers:=ds:C1482.Customers.query("( Active = :1 "; True:C214).orderBy("Name asc")
			customerSelection:="ACTIVE"
		Else 
			Form:C1466.customers:=ds:C1482.Customers.query("( Name = :1 OR ID = :1"; "@"+vSearch2+"@"; 13).orderBy("Name asc")
			customerSelection:="@"+vSearch2+"@"
		End if 
		
End case 
