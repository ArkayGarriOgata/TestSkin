//%attributes = {}
//Method:  Adrs_Analyze
//Desctiption:  This method can be used to analyze values of [Address]

//[Table]AddressID

//[Addresses]ID

//[Customers_Addresses]CustAddrID

//[Customers_Orders]defaultBillTo
//[Customers_Orders]defaultShipto

//[Customers_Order_Lines]defaultBillto
//[Customers_Order_Lines]defaultShipTo

//[Customers_ReleaseSchedules]Billto
//[Customers_ReleaseSchedules]Shipto

//[Estimates]z_Bill_To_ID
//[Estimates]z_ShippingTo


If (True:C214)  //Initialize
	
	
End if   //Done initialize

Case of 
		
	: (True:C214)  //State
		
		$esState:=ds:C1482.Addresses.query("Active = :1 AND Country # :2 AND State # :3"; True:C214; "US"; CorektBlank)  //143 records
		
		$cState:=$esState.distinct("State")  //48 Distinct values
		
		
		
End case 
