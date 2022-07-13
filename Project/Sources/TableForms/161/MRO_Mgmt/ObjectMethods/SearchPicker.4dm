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
		C_TEXT:C284(vSearch)
		vSearch:=""
		// the let's customise the SearchPicker (if needed)
		C_TEXT:C284($ObjectName)
		$ObjectName:=OBJECT Get name:C1087(Object current:K67:2)
		SearchPicker SET HELP TEXT($ObjectName; "Bin or Part")
		
	: (Form event code:C388=On Data Change:K2:15)
		Form:C1466.bins:=Form:C1466.masterClass.query(Form:C1466.searchBoxQueryBins; "@"+vSearch+"@").orderBy(Form:C1466.defaultBinsOrderBy)
		
		If (Form:C1466.bins.length>0)
			Form:C1466.clickedBin:=Form:C1466.bins.first()
		End if 
		
End case 
