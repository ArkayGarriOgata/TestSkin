If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
	
	CUT NAMED SELECTION:C334([Customers_Bills_of_Lading:49]; "doingfind")
	
	
Else 
	
	ARRAY LONGINT:C221($_doingfind; 0)
	LONGINT ARRAY FROM SELECTION:C647([Customers_Bills_of_Lading:49]; $_doingfind)
End if   // END 4D Professional Services : January 2019 

$findThis:=Request:C163("What BOL Shippers# are you looking for?"; ""; "Find"; "Cancel")
If (ok=1)
	QUERY:C277([Customers_Bills_of_Lading:49]; [Customers_Bills_of_Lading:49]ShippersNo:1=(Num:C11($findThis)))
	If (Records in selection:C76([Customers_Bills_of_Lading:49])=0)
		uConfirm("Shippers Number "+$findThis+" was not found."; "Try Ship Date"; "You Kiddin Me")
		If (ok=1)
			$findThis:=Request:C163("What ShipDate are you looking for?"; String:C10(Current date:C33; Internal date short special:K1:4); "Find"; "Cancel")
			QUERY:C277([Customers_Bills_of_Lading:49]; [Customers_Bills_of_Lading:49]ShipDate:20=(Date:C102($findThis)))
			//util_FindAndHighlight (->[Customers_Bills_of_Lading]ShipTo;->)
			
			If (Records in selection:C76([Customers_Bills_of_Lading:49])=0)
				uConfirm("ShipDate "+$findThis+" was not found."; "Try Shipto"; "You Kiddin Me")
				If (ok=1)
					$findThis:=Request:C163("What ShipTo are you looking for?"; ""; "Find"; "Cancel")
					QUERY:C277([Customers_Bills_of_Lading:49]; [Customers_Bills_of_Lading:49]ShipTo:3=$findThis)
					If (Records in selection:C76([Customers_Bills_of_Lading:49])=0)
						uConfirm("Not found."; "Query"; "Cancel")
						If (ok=1)
							QUERY:C277([Customers_Bills_of_Lading:49])
						Else 
							If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
								
								USE NAMED SELECTION:C332("doingfind")
								
							Else 
								
								CREATE SELECTION FROM ARRAY:C640([Customers_Bills_of_Lading:49]; $_doingfind)
							End if   // END 4D Professional Services : January 2019 
							
						End if 
						
					Else 
						If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
							
							CLEAR NAMED SELECTION:C333("doingfind")
							
						Else 
							
						End if   // END 4D Professional Services : January 2019 
						
					End if 
					
				Else 
					If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
						
						USE NAMED SELECTION:C332("doingfind")
						
					Else 
						
						CREATE SELECTION FROM ARRAY:C640([Customers_Bills_of_Lading:49]; $_doingfind)
					End if   // END 4D Professional Services : January 2019 
					
				End if 
				
			Else 
				If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
					
					CLEAR NAMED SELECTION:C333("doingfind")
					
				Else 
					
				End if   // END 4D Professional Services : January 2019 
				
			End if 
			
		Else 
			If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
				
				USE NAMED SELECTION:C332("doingfind")
				
			Else 
				
				CREATE SELECTION FROM ARRAY:C640([Customers_Bills_of_Lading:49]; $_doingfind)
			End if   // END 4D Professional Services : January 2019 
			
		End if 
		
	Else 
		If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
			
			CLEAR NAMED SELECTION:C333("doingfind")
			
		Else 
			
		End if   // END 4D Professional Services : January 2019 
		
	End if 
	
Else 
	If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
		
		USE NAMED SELECTION:C332("doingfind")
		
	Else 
		
		CREATE SELECTION FROM ARRAY:C640([Customers_Bills_of_Lading:49]; $_doingfind)
	End if   // END 4D Professional Services : January 2019 
	
End if 
