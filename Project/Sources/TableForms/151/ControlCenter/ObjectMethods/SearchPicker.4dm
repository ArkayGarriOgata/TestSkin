//Searchpicker sample code

Case of 
		
	: (Form event code:C388=On Load:K2:1)
		// Init the var itself
		// this can be done anywhere else in your code
		C_TEXT:C284(vSearch)
		vSearch:=""
		// the let's customise the SearchPicker (if needed)
		C_TEXT:C284($ObjectName)
		$ObjectName:=OBJECT Get name:C1087(Object current:K67:2)
		SearchPicker SET HELP TEXT($ObjectName; "Bin Content Tag")
		
	: (Form event code:C388=On Data Change:K2:15)
		If (Position:C15("avail"; vSearch)=0) & (Position:C15("empty"; vSearch)=0)
			Form:C1466.toolDrawers.data:=ds:C1482.Tool_Drawers.query("Bin = :1 OR Contents =:1 OR Tags = :1 "; "@"+vSearch+"@").orderBy("Bin asc")
		Else 
			Form:C1466.toolDrawers.data:=ds:C1482.Tool_Drawers.query("Contents =:1 OR Contents = :2  OR Contents = :3"; "@"+vSearch+"@"; ""; "Available").orderBy("Bin asc")
		End if 
		
End case 
