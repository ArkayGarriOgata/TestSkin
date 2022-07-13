//(s) jobformid
If (In header:C112) & (Level:C101=1)
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
		
		QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]POItemKey:4=[Purchase_Orders_Job_forms:59]POItemKey:1)
		QUERY SELECTION:C341([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]Xfer_Type:2="Receipt"; *)
		QUERY SELECTION:C341([Raw_Materials_Transactions:23];  | ; [Raw_Materials_Transactions:23]Xfer_Type:2="Issue")
		
	Else 
		
		QUERY BY FORMULA:C48([Raw_Materials_Transactions:23]; \
			([Raw_Materials_Transactions:23]POItemKey:4=[Purchase_Orders_Job_forms:59]POItemKey:1)\
			 & (([Raw_Materials_Transactions:23]Xfer_Type:2="Receipt") | ([Raw_Materials_Transactions:23]Xfer_Type:2="Issue"))\
			)
		
		
	End if   // END 4D Professional Services : January 2019 query selection
	
End if 
//