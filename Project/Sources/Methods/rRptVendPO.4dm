//%attributes = {"publishedWeb":true}
//(P) uRptVendPO: Outstanding Vendor POs

zDefFilePtr:=->[Purchase_Orders:11]
QUERY:C277([Purchase_Orders:11]; [Purchase_Orders:11]Status:15#"Closed")
If (Records in selection:C76([Purchase_Orders:11])=0)
	BEEP:C151
	ALERT:C41("There are no outstanding POs!")
Else 
	util_PAGE_SETUP(->[Purchase_Orders:11]; "OutstByVendRpt")
	PRINT SETTINGS:C106
	If (OK=1)
		If (uNowOrDelay)
			//get outstanding POs
			ORDER BY:C49([Purchase_Orders:11]; [Vendors:7]Name:2; >; [Purchase_Orders:11]Required:27; <)
			BREAK LEVEL:C302(1)
			ACCUMULATE:C303([Purchase_Orders:11]ChgdOrderAmt:13)
			FORM SET OUTPUT:C54([Purchase_Orders:11]; "OutstByVendRpt")
			dAsof:=Current date:C33
			PRINT SELECTION:C60([Purchase_Orders:11]; *)
		End if 
	End if 
End if 