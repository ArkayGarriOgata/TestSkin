//%attributes = {}
// Method: ELC_delforPreparation () -> 
// ----------------------------------------------------
// by: mel: 11/29/04, 11:42:59
// ----------------------------------------------------
// Description:
// delete all existing forecasts for lauder
// ----------------------------------------------------

BEEP:C151
CONFIRM:C162("Delete Estee Lauder forecasts?"; "Delete..."; "Cancel")
If (OK=1)
	
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 ELC_query
		
		ELC_query(->[Customers_ReleaseSchedules:46]CustID:12; 2)
		QUERY SELECTION:C341([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]CustomerRefer:3="<@")
		
		BEEP:C151
		CONFIRM:C162("Delete from which Estee Lauder source?"; "Old EDI"; "SAP EDI")
		If (OK=1)
			QUERY SELECTION:C341([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Shipto:10#"00190"; *)
			QUERY SELECTION:C341([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Shipto:10#"02852")
		Else 
			QUERY SELECTION:C341([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Shipto:10="00190"; *)
			QUERY SELECTION:C341([Customers_ReleaseSchedules:46];  | ; [Customers_ReleaseSchedules:46]Shipto:10="02852")
		End if 
		
	Else 
		$criteria:=ELC_getName
		READ WRITE:C146([Customers_ReleaseSchedules:46])
		BEEP:C151
		CONFIRM:C162("Delete from which Estee Lauder source?"; "Old EDI"; "SAP EDI")
		If (OK=1)
			QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Shipto:10#"00190"; *)
			QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Shipto:10#"02852"; *)
			QUERY:C277([Customers_ReleaseSchedules:46]; [Customers:16]ParentCorp:19=$criteria; *)
			QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]CustomerRefer:3="<@")
		Else 
			QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Shipto:10="00190"; *)
			QUERY:C277([Customers_ReleaseSchedules:46];  | ; [Customers_ReleaseSchedules:46]Shipto:10="02852"; *)
			QUERY:C277([Customers_ReleaseSchedules:46]; [Customers:16]ParentCorp:19=$criteria; *)
			QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]CustomerRefer:3="<@")
		End if 
		
	End if   // END 4D Professional Services : January 2019 ELC_query
	
	
	If (Records in selection:C76([Customers_ReleaseSchedules:46])>0)
		util_DeleteSelection(->[Customers_ReleaseSchedules:46])
	Else 
		BEEP:C151
		ALERT:C41("No EL forecasts found.")
	End if 
	
End if 