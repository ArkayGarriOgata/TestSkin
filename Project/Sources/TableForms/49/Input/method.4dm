Case of 
	: (Form event code:C388=On Load:K2:1)
		RELATE MANY:C262([Customers_Bills_of_Lading:49])
		ORDER BY:C49([Customers_Bills_of_Lading_Manif:181]; [Customers_Bills_of_Lading_Manif:181]Item:1; >)
		tText10:=fGetAddressText([Customers_Bills_of_Lading:49]ShipTo:3; "*")
		tText12:=fGetAddressText([Customers_Bills_of_Lading:49]BillTo:4; "*")
		[Customers_Bills_of_Lading:49]zCount:6:=[Customers_Bills_of_Lading:49]zCount:6+1
		
	: (Form event code:C388=On Validate:K2:3)
		[Customers_Bills_of_Lading:49]Total_Cartons:12:=Sum:C1([Customers_Bills_of_Lading_Manif:181]Total_Amt:9)
		[Customers_Bills_of_Lading:49]Total_Cases:14:=Sum:C1([Customers_Bills_of_Lading_Manif:181]NumCases:6)
		[Customers_Bills_of_Lading:49]Total_Wgt:18:=Sum:C1([Customers_Bills_of_Lading_Manif:181]Total_Wt:11)
		[Customers_Bills_of_Lading:49]zCount:6:=[Customers_Bills_of_Lading:49]zCount:6-1
End case 
//