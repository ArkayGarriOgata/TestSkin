//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 10/30/09, 14:33:02
// ----------------------------------------------------
// Method: ELC_Changed_Releases
// ----------------------------------------------------

C_TEXT:C284($1)

If (Count parameters:C259=0)
	$pid:=New process:C317("ELC_Changed_Releases"; <>lMinMemPart; "ELC Changed Releases"; "init")
	If (False:C215)
		ELC_Changed_Releases
	End if 
	
Else 
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 ELC_query
		
		$numLinks:=ELC_query(->[Customers_ReleaseSchedules:46]CustID:12)
		QUERY SELECTION:C341([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]EDI_Disposition:36#""; *)
		QUERY SELECTION:C341([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Actual_Date:7=!00-00-00!)
		
	Else 
		$criteria:=ELC_getName
		READ ONLY:C145([Customers_ReleaseSchedules:46])
		QUERY:C277([Customers_ReleaseSchedules:46]; [Customers:16]ParentCorp:19=$criteria; *)
		QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]EDI_Disposition:36#""; *)
		QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Actual_Date:7=!00-00-00!)
		
	End if   // END 4D Professional Services : January 2019 ELC_query
	
	pattern_PassThru(->[Customers_ReleaseSchedules:46])
	ViewSetter(2; ->[Customers_ReleaseSchedules:46])
End if 