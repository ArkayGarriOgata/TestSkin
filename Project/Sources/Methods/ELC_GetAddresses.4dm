//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 10/28/09, 11:37:35
// ----------------------------------------------------
// Method: ELC_GetAddresses
// Description
// select the address linked to ELC
// ----------------------------------------------------

C_TEXT:C284($1)

If (Count parameters:C259=0)
	$pid:=New process:C317("ELC_GetAddresses"; <>lMinMemPart; "ELC Addresses"; "init")
	
Else 
	
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 ELC_query
		
		$numLinks:=ELC_query(->[Customers_Addresses:31]CustID:1)
		RELATE ONE SELECTION:C349([Customers_Addresses:31]; [Addresses:30])
		
		
	Else 
		$criteria:=ELC_getName
		READ ONLY:C145([Customers_Addresses:31])
		QUERY BY FORMULA:C48([Addresses:30]; \
			([Addresses:30]ID:1=[Customers_Addresses:31]CustAddrID:2)\
			 & ([Customers_Addresses:31]CustID:1=[Customers:16]ID:1)\
			 & ([Customers:16]ParentCorp:19=$criteria))
		
		
	End if   // END 4D Professional Services : January 2019 ELC_query
	pattern_PassThru(->[Addresses:30])
	ViewSetter(2; ->[Addresses:30])
End if 