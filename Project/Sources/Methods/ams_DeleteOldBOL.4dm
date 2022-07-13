//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 08/02/07, 10:18:05
// ----------------------------------------------------
// Method: ams_DeleteOldBOL
// ----------------------------------------------------

C_DATE:C307($cutOff; $1)

$cutOff:=$1  //!04/01/01!

READ WRITE:C146([Customers_Bills_of_Lading:49])
QUERY:C277([Customers_Bills_of_Lading:49]; [Customers_Bills_of_Lading:49]ShipDate:20<$cutOff)

util_DeleteSelection(->[Customers_Bills_of_Lading:49])

If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 ams_DeleteWithoutHeaderRecord
	
	ams_DeleteWithoutHeaderRecord(->[Customers_Bills_of_Lading_Manif:181]ShippersNo:17; ->[Customers_Bills_of_Lading:49]ShippersNo:1)
	
Else 
	
	
	If (<>fContinue)
		ARRAY LONGINT:C221($_ShippersNo; 0)
		READ ONLY:C145([Customers_Bills_of_Lading:49])
		ALL RECORDS:C47([Customers_Bills_of_Lading:49])
		READ WRITE:C146([Customers_Bills_of_Lading_Manif:181])
		DISTINCT VALUES:C339([Customers_Bills_of_Lading:49]ShippersNo:1; $_ShippersNo)
		
		SET QUERY DESTINATION:C396(Into set:K19:2; "keepThese")
		QUERY WITH ARRAY:C644([Customers_Bills_of_Lading_Manif:181]ShippersNo:17; $_ShippersNo)
		SET QUERY DESTINATION:C396(Into current selection:K19:1)
		
		ALL RECORDS:C47([Customers_Bills_of_Lading_Manif:181])
		CREATE SET:C116([Customers_Bills_of_Lading_Manif:181]; "allRecords")
		DIFFERENCE:C122("allRecords"; "keepThese"; "keepThese")
		USE SET:C118("keepThese")
		CLEAR SET:C117("allRecords")
		CLEAR SET:C117("keepThese")
		
		
		util_DeleteSelection(->[Customers_Bills_of_Lading_Manif:181])
		
	End if 
	
End if   // END 4D Professional Services : January 2019 query selection
