//%attributes = {"publishedWeb":true}
//x_ExportOrder    see also x_ImportOrderObj  `5/2/95  
//[CustomerOrder]   _01
//        < >>[OrderLines]    _02
//                        < >>[ReleaseSchedule] _04
//        < >>[OrderChgHistory]    _03  
//$1 Order number to export

READ ONLY:C145([Customers_Orders:40])
READ ONLY:C145([Customers_Order_Lines:41])
READ ONLY:C145([Customers_Order_Change_Orders:34])
READ ONLY:C145([Customers_ReleaseSchedules:46])

C_TEXT:C284($1; $order)

$order:=$1

If ([Customers_Orders:40]OrderNumber:1#Num:C11($order))
	QUERY:C277([Customers_Orders:40]; [Customers_Orders:40]OrderNumber:1=Num:C11($order))
End if 

Case of 
	: (Records in selection:C76([Customers_Orders:40])=1)
		CREATE SET:C116([Customers_Orders:40]; "Order")
		uClearSelection(->[Customers_Order_Change_Orders:34])
		uClearSelection(->[Customers_Order_Lines:41])
		uClearSelection(->[Customers_ReleaseSchedules:46])
		RELATE MANY:C262([Customers_Orders:40]OrderNumber:1)  //get orderlines and cco's
		
		CREATE SET:C116([Customers_Order_Change_Orders:34]; "ChangeOrders")
		
		CREATE SET:C116([Customers_Order_Lines:41]; "Orderlines")
		If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
			
			QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OrderLine:4=$order+"@")
			//PROJECT SELECTION([ReleaseSchedule]OrderLine)
			CREATE SET:C116([Customers_ReleaseSchedules:46]; "Releases")
			
		Else 
			
			//we remplace when we use this set
			
		End if   // END 4D Professional Services : January 2019 
		
		USE SET:C118("Order")
		FIRST RECORD:C50([Customers_Orders:40])
		SET CHANNEL:C77(12; $Order+"_01")
		For ($i; 1; Records in selection:C76([Customers_Orders:40]))
			SEND RECORD:C78([Customers_Orders:40])
			NEXT RECORD:C51([Customers_Orders:40])
		End for 
		SET CHANNEL:C77(11)
		CLEAR SET:C117("Order")
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
			
			USE SET:C118("Orderlines")
			FIRST RECORD:C50([Customers_Order_Lines:41])
			
		Else 
			
			USE SET:C118("Orderlines")
			// see line 27
			
		End if   // END 4D Professional Services : January 2019 First record
		// 4D Professional Services : after Order by , query or any query type you don't need First record  
		
		SET CHANNEL:C77(12; $order+"_02")
		For ($i; 1; Records in selection:C76([Customers_Order_Lines:41]))
			SEND RECORD:C78([Customers_Order_Lines:41])
			NEXT RECORD:C51([Customers_Order_Lines:41])
		End for 
		SET CHANNEL:C77(11)
		CLEAR SET:C117("Orderlines")
		
		USE SET:C118("ChangeOrders")
		FIRST RECORD:C50([Customers_Order_Change_Orders:34])
		SET CHANNEL:C77(12; $order+"_03")
		For ($i; 1; Records in selection:C76([Customers_Order_Change_Orders:34]))
			SEND RECORD:C78([Customers_Order_Change_Orders:34])
			NEXT RECORD:C51([Customers_Order_Change_Orders:34])
		End for 
		SET CHANNEL:C77(11)
		CLEAR SET:C117("ChangeOrders")
		If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
			
			If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
				
				USE SET:C118("Releases")
				FIRST RECORD:C50([Customers_ReleaseSchedules:46])
				
			Else 
				
				USE SET:C118("Releases")
				// see line 28
				
			End if   // END 4D Professional Services : January 2019 First record
			// 4D Professional Services : after Order by , query or any query type you don't need First record  
			
		Else 
			
			QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OrderLine:4=$order+"@")
			
		End if   // END 4D Professional Services : January 2019 
		
		SET CHANNEL:C77(12; $order+"_04")
		For ($i; 1; Records in selection:C76([Customers_ReleaseSchedules:46]))
			SEND RECORD:C78([Customers_ReleaseSchedules:46])
			NEXT RECORD:C51([Customers_ReleaseSchedules:46])
		End for 
		SET CHANNEL:C77(11)
		If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
			
			CLEAR SET:C117("Releases")
			
		Else 
			
			
		End if   // END 4D Professional Services : January 2019 
		
	: (Records in selection:C76([Customers_Orders:40])>1)
		ALERT:C41("Can Only Export One CustomerOrder at a Time.")
	: (Records in selection:C76([Customers_Orders:40])=0)
		ALERT:C41("No CustomerOrder numbered "+$order+" found.")
End case 