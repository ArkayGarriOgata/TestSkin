USE SET:C118("twoLoaded")
If (allReleases=0)
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
		
		QUERY SELECTION:C341([Customers_Order_Lines:41]; [Customers_Order_Lines:41]Status:9="Closed")
		CREATE SET:C116([Customers_Order_Lines:41]; "closedOrders")
		RELATE MANY SELECTION:C340([Customers_ReleaseSchedules:46]OrderLine:4)  //get the closed releases
		
		CREATE SET:C116([Customers_ReleaseSchedules:46]; "closedRelease")
		DIFFERENCE:C122("oneLoaded"; "closedOrders"; "displayOrders")  //don't display the closed orders
		
		USE SET:C118("displayOrders")
		CLEAR SET:C117("closedOrders")
		//CLEAR SET("displayOrders")
		
		DIFFERENCE:C122("twoLoaded"; "closedRelease"; "displayRels")
		//•060995  MLB  UPR 1642 alway show unshiped releases
		
		USE SET:C118("twoLoaded")
		QUERY SELECTION:C341([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OpenQty:16>0)
		CREATE SET:C116([Customers_ReleaseSchedules:46]; "openRels")
		UNION:C120("displayRels"; "openRels"; "displayRels")
		CLEAR SET:C117("openRels")
		CLEAR SET:C117("closedRelease")
		//end 1642
		
		USE SET:C118("displayRels")
		
	Else 
		
		QUERY SELECTION:C341([Customers_Order_Lines:41]; [Customers_Order_Lines:41]Status:9="Closed")
		CREATE SET:C116([Customers_Order_Lines:41]; "displayOrders")
		RELATE MANY SELECTION:C340([Customers_ReleaseSchedules:46]OrderLine:4)  //get the closed releases
		CREATE SET:C116([Customers_ReleaseSchedules:46]; "displayRels")
		DIFFERENCE:C122("oneLoaded"; "displayOrders"; "displayOrders")  //don't display the closed orders
		USE SET:C118("displayOrders")
		
		DIFFERENCE:C122("twoLoaded"; "displayRels"; "displayRels")
		USE SET:C118("twoLoaded")
		SET QUERY DESTINATION:C396(Into set:K19:2; "openRels")
		QUERY SELECTION:C341([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OpenQty:16>0)
		SET QUERY DESTINATION:C396(Into current selection:K19:1)
		
		UNION:C120("displayRels"; "openRels"; "displayRels")
		CLEAR SET:C117("openRels")
		USE SET:C118("displayRels")
		
	End if   // END 4D Professional Services : January 2019 query selection
	
End if 
sAskMeTotals
//