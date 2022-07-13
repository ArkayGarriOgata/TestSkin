// _______
// Method: [Customers_ReleaseSchedules].PickUpList.SearchPicker   ( ) ->
// By: Mel Bohince @ 06/08/20, 21:02:56
// Description
// 
// ----------------------------------------------------
// Modified by: Mel Bohince (7/16/20) use Form.elcOpenFirm as basis for queries
// Modified by: Mel Bohince (7/20/20) wait for more than 3 characters before searching

Case of 
		
	: (Form event code:C388=On Load:K2:1)
		// Init the var itself
		// this can be done anywhere else in your code
		C_TEXT:C284($ObjectName; vSearch)
		vSearch:=""
		
		// customise the SearchPicker
		$ObjectName:=OBJECT Get name:C1087(Object current:K67:2)
		SearchPicker SET HELP TEXT($ObjectName; "PO, CPN, Shipto, Mode")
		GOTO OBJECT:C206(*; "$ObjectName")
		
	: (Form event code:C388=On Data Change:K2:15)
		utl_LogIt(Timestamp:C1445+"\t PickUpList.SearchPicker OnDataChg"; 0)
		
		$onlyReady:=OBJECT Get pointer:C1124(Object named:K67:5; "showReadyOnly")
		
		// Modified by: Mel Bohince (7/16/20) use Form.elcOpenFirm as basis for queries
		If ($onlyReady->=0)
			If (Not:C34(searchWidgetInited))  // Modified by: Mel Bohince (7/18/20) it was running in first on load
				searchWidgetInited:=True:C214
			Else 
				Case of 
					: (Length:C16(vSearch)>2)  // Modified by: Mel Bohince (7/20/20) modified 1/21/21 so "rfm" would work
						Form:C1466.listBoxEntities:=Form:C1466.elcOpenFirm.query(Form:C1466.searchBoxQueryActive; "@"+vSearch+"@").orderBy(Form:C1466.defaultOrderBy)
						
					: (Length:C16(vSearch)=0)
						Form:C1466.listBoxEntities:=Form:C1466.elcOpenFirm
						
					Else 
						//wait for more typing
				End case 
				
			End if 
		Else 
			Form:C1466.listBoxEntities:=Form:C1466.openReady.query(Form:C1466.searchBoxQueryActive; "@"+vSearch+"@").orderBy(Form:C1466.defaultOrderBy)
		End if 
		
		If (Form:C1466.listBoxEntities.length>0)
			Form:C1466.editEntity:=Form:C1466.listBoxEntities.first()
		End if 
		
		OBJECT SET ENABLED:C1123(*; "select@"; False:C215)
		
		Release_ShipMgmt_calcFooters
		
End case 
