// _______
// Method: [Finished_Goods_Locations].aMsWMS_Comparison.SearchPicker   ( ) ->
// By: Mel Bohince @ 11/10/20, 09:55:45
// Description
// 
// ----------------------------------------------------



Case of 
		
	: (Form event code:C388=On Load:K2:1)
		// Init the var itself
		// this can be done anywhere else in your code
		C_TEXT:C284($ObjectName; vSearch)
		vSearch:=""
		
		// customise the SearchPicker
		$ObjectName:=OBJECT Get name:C1087(Object current:K67:2)
		SearchPicker SET HELP TEXT($ObjectName; "CustID, CPN, Jobit, Location")
		GOTO OBJECT:C206(*; "$ObjectName")
		
	: (Form event code:C388=On Data Change:K2:15)
		
		If (Not:C34(searchWidgetInited))  // Modified by: Mel Bohince (7/18/20) it was running in first on load
			searchWidgetInited:=True:C214
		Else 
			If (Length:C16(vSearch)>0)
				$criter:=("@"+vSearch+"@")
				Form:C1466.listBoxEntities:=Form:C1466.listBoxEntities.query("CustID=:1 or ProductCode=:1 or Jobit=:1  or Location=:1"; $criter).orderBy(Form:C1466.defaultOrderBy)
				Form:C1466.message:="Locations containing "+vSearch
			Else 
				Form:C1466.listBoxEntities:=Form:C1466.fg_locations_c
				Form:C1466.message:="All Locations "
			End if 
		End if 
		
		OBJECT SET ENABLED:C1123(*; "select@"; False:C215)
		
		If (Form:C1466.listBoxEntities#Null:C1517)
			footerCount:=Form:C1466.listBoxEntities.length
			footerQty:=Form:C1466.listBoxEntities.sum("QtyOH")
			footerCases:=Form:C1466.listBoxEntities.sum("WMSqty")
		End if 
		
		
End case 
