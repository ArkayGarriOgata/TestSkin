//(S) [CONTROL]RMadjust'bView
//created  upr 1858 cs
Case of 
	: ((Records in selection:C76([Raw_Materials_Locations:25])=0) & (rReal1<0))
		BEEP:C151
		ALERT:C41("Please enter a valid bin location to reduce the quantity.")
		REJECT:C38
	: (Records in selection:C76([Purchase_Orders_Items:12])=0) & (Records in selection:C76([Raw_Materials:21])=0)
		BEEP:C151
		ALERT:C41(" PO item or R/M not found.")  //3/27/95    
		REJECT:C38
	Else 
		If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) create set
			
			CREATE SET:C116([Raw_Materials_Transactions:23]; "Currentx")  //save off current selections in these files
			CREATE SET:C116([Raw_Materials:21]; "CurrentRm")
			CREATE SET:C116([Raw_Materials_Locations:25]; "CurrentB")
			CREATE SET:C116([Purchase_Orders_Items:12]; "CurrentP")
			
		Else 
			//you just need Currentx
			
			CREATE SET:C116([Raw_Materials_Transactions:23]; "Currentx")  //save off current selections in these files
			
		End if   // END 4D Professional Services : January 2019 
		
		Case of 
			: (Records in selection:C76([Raw_Materials:21])=1)  //record in RM file 
				QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]Raw_Matl_Code:1=[Raw_Materials:21]Raw_Matl_Code:1; *)
			: (Records in selection:C76([Purchase_Orders_Items:12])>=1)  //no bin yet
				QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]Raw_Matl_Code:1=[Purchase_Orders_Items:12]Raw_Matl_Code:15; *)
			: (Records in selection:C76([Raw_Materials_Locations:25])>=1)  //use rm_b@in      
				QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]Raw_Matl_Code:1=[Raw_Materials_Locations:25]Raw_Matl_Code:1; *)
		End case 
		QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]Xfer_Type:2="Adjust@")
		
		If (Records in selection:C76([Raw_Materials_Transactions:23])>0)
			$Count:=Records in selection:C76([Raw_Materials_Transactions:23])
			ARRAY TEXT:C222(asCode; $Count)
			ARRAY DATE:C224(aDate; $Count)
			ARRAY REAL:C219(arQuantity; $Count)
			ARRAY TEXT:C222(aReason; $Count)
			ARRAY TEXT:C222(aLocation; $Count)
			SELECTION TO ARRAY:C260([Raw_Materials_Transactions:23]Raw_Matl_Code:1; asCode; [Raw_Materials_Transactions:23]XferDate:3; aDate; [Raw_Materials_Transactions:23]Reason:5; aReason; [Raw_Materials_Transactions:23]Qty:6; arQuantity; [Raw_Materials_Transactions:23]Location:15; aLocation)
			t2b:="RM Code"
			t2:="Adjustments for Raw Materials"
			uDialog("DisplayAdj"; 450; 200; 8)
		Else 
			ALERT:C41("No Adjustment transactions found.")
		End if 
		If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3)
			
			USE SET:C118("Currentx")  //return current selections in these files
			USE SET:C118("CurrentRm")
			USE SET:C118("CurrentB")
			USE SET:C118("CurrentP")
			CLEAR SET:C117("Currentx")  //clear sets
			CLEAR SET:C117("CurrentRm")
			CLEAR SET:C117("CurrentB")
			CLEAR SET:C117("CurrentP")
			
		Else 
			
			USE SET:C118("Currentx")  //return current selections in these files
			CLEAR SET:C117("Currentx")  //clear sets
			
		End if   // END 4D Professional Services : January 2019 
		
End case 
//
//EOS