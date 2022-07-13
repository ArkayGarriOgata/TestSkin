// _______
// Method: [Finished_Goods_Locations].FGL_Mgmt.SearchPicker2   ( ) ->
// By: Mel Bohince @ 09/23/20, 14:25:22
// Description
// 
// ----------------------------------------------------
// Modified by: Mel Bohince (12/8/20) set Form.editEntity:=New object if nothing selected

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
		SearchPicker SET HELP TEXT($ObjectName; "Jobit, Skid, CPN, Bin")
		
	: (Form event code:C388=On Data Change:K2:15)
		If (Not:C34(searchWidgetInited))  //don't query on first call
			searchWidgetInited:=True:C214
			
		Else 
			
			Case of 
				: (Length:C16(vSearch2)>2)
					$onlyActive:=OBJECT Get pointer:C1124(Object named:K67:5; "ShowInactive")
					If ($onlyActive->=0)
						Form:C1466.listBoxEntities:=Form:C1466.masterClass.query(Form:C1466.searchBoxQueryActive; "@"+vSearch2+"@"; True:C214).orderBy(Form:C1466.defaultOrderBy)
					Else   //include inactives
						Form:C1466.listBoxEntities:=Form:C1466.masterClass.query(Form:C1466.searchBoxQueryInactive; "@"+vSearch2+"@").orderBy(Form:C1466.defaultOrderBy)
					End if 
					
				: (Length:C16(vSearch2)=0)  // Modified by: Mel Bohince (12/8/20) 
					Form:C1466.listBoxEntities:=New object:C1471  //clear the list
					
				Else 
					//wait for more chars
			End case 
			
		End if   //inited
		
		Form:C1466.editEntity:=New object:C1471  // Modified by: Mel Bohince (12/8/20)//force a click
		
End case 

