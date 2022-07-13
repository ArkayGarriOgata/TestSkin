// _______
// Method: [MaintRepairSupply_Bins].ControlCenter.SearchPicker   ( ) ->
// By: Mel Bohince @ 07/03/19, 15:53:16
// Description
// 
// ----------------------------------------------------


Case of 
		
	: (Form event code:C388=On Load:K2:1)
		// Init the var itself
		// this can be done anywhere else in your code
		vSearch:=""
		// the let's customise the SearchPicker (if needed)
		C_TEXT:C284($ObjectName)
		$ObjectName:=OBJECT Get name:C1087(Object current:K67:2)
		SearchPicker SET HELP TEXT($ObjectName; Form:C1466.displayedField)
		GOTO OBJECT:C206(*; "$ObjectName")
		//so the original list can be restored
		Form:C1466.original_c:=Form:C1466.data.copy()
		
	: (Form event code:C388=On Data Change:K2:15)
		If (Length:C16(vSearch)>0)  //user is hunting
			
			Form:C1466.data:=Form:C1466.data.query(Form:C1466.displayedField+" = :1"; "@"+vSearch+"@").orderBy(Form:C1466.displayedField)
			
		Else   //user clicked the X, so get the original collection back, if it had been queried
			
			If (Form:C1466.data.length#Form:C1466.original_c.length)
				Form:C1466.data:=Form:C1466.original_c
			End if 
			
		End if 
		
End case 
