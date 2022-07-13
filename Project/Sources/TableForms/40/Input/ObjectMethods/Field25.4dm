//upr 1329 1/11/95 made manditory also
//•120998  MLB Y2K Remediation
If (sDateLimitor(->[Customers_Orders:40]DateOpened:6; 31)<=0)
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
		
		FIRST RECORD:C50([Customers_Order_Lines:41])
		While (Not:C34(End selection:C36([Customers_Order_Lines:41])))
			If ([Customers_Order_Lines:41]DateOpened:13=!00-00-00!)
				[Customers_Order_Lines:41]DateOpened:13:=[Customers_Orders:40]DateOpened:6
				SAVE RECORD:C53([Customers_Order_Lines:41])
			End if 
			NEXT RECORD:C51([Customers_Order_Lines:41])
		End while 
		FIRST RECORD:C50([Customers_Order_Lines:41])
		
	Else 
		
		ARRAY LONGINT:C221($_Customers_Order_Lines; 0)
		C_DATE:C307($date)
		SELECTION TO ARRAY:C260([Customers_Order_Lines:41]; $_Customers_Order_Lines)
		$date:=[Customers_Orders:40]DateOpened:6
		QUERY SELECTION:C341([Customers_Order_Lines:41]; [Customers_Order_Lines:41]DateOpened:13=!00-00-00!)
		APPLY TO SELECTION:C70([Customers_Order_Lines:41]; [Customers_Order_Lines:41]DateOpened:13:=$date)
		CREATE SELECTION FROM ARRAY:C640([Customers_Order_Lines:41]; $_Customers_Order_Lines)
		FIRST RECORD:C50([Customers_Order_Lines:41])
		
	End if   // END 4D Professional Services : January 2019 First record
	// 4D Professional Services : after Order by , query or any query type you don't need First record  
	
End if 
//