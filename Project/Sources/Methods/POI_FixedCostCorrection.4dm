//%attributes = {}
// Method: POI_FixedCostCorrection () -> 
// ----------------------------------------------------
// by: mel: 11/09/04, 09:44:06
// ----------------------------------------------------
// Description:
// find fixed cost poitems (if necessary) and correct their unit costs and the bins and xfers
// ----------------------------------------------------

C_DATE:C307($1; $2)

Case of 
	: (Count parameters:C259=1)  //find candidate poitems
		
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
			QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]XferDate:3=$1; *)
			QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]Xfer_Type:2="Receipt")
			
			If (Records in selection:C76([Raw_Materials_Transactions:23])>0)
				SELECTION TO ARRAY:C260([Raw_Materials_Transactions:23]POItemKey:4; $aPOIs)
				QUERY WITH ARRAY:C644([Purchase_Orders_Items:12]POItemKey:1; $aPOIs)
				QUERY SELECTION:C341([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]FixedCost:51=True:C214)
				FIRST RECORD:C50([Purchase_Orders_Items:12])
				While (Not:C34(End selection:C36([Purchase_Orders_Items:12])))
					POI_FixedCostCorrection
					NEXT RECORD:C51([Purchase_Orders_Items:12])
				End while 
			End if 
		Else 
			
			QUERY BY FORMULA:C48([Purchase_Orders_Items:12]; \
				([Purchase_Orders_Items:12]FixedCost:51=True:C214)\
				 & ([Raw_Materials_Transactions:23]XferDate:3>=$1)\
				 & ([Raw_Materials_Transactions:23]Xfer_Type:2="Receipt")\
				)
			If (Records in selection:C76([Purchase_Orders_Items:12])>0)
				APPLY TO SELECTION:C70([Purchase_Orders_Items:12]; POI_FixedCostCorrection)
			End if 
			
		End if   // END 4D Professional Services : January 2019 query selection
		
		
		
	: (Count parameters:C259=2)  //find candidate poitems
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
			
			QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]XferDate:3>=$1; *)
			QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]XferDate:3<=$2; *)
			QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]Xfer_Type:2="Receipt")
			
			If (Records in selection:C76([Raw_Materials_Transactions:23])>0)
				SELECTION TO ARRAY:C260([Raw_Materials_Transactions:23]POItemKey:4; $aPOIs)
				QUERY WITH ARRAY:C644([Purchase_Orders_Items:12]POItemKey:1; $aPOIs)
				
				READ WRITE:C146([Purchase_Orders_Items:12])
				QUERY SELECTION:C341([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]FixedCost:51=True:C214)
				FIRST RECORD:C50([Purchase_Orders_Items:12])
				While (Not:C34(End selection:C36([Purchase_Orders_Items:12])))
					POI_FixedCostCorrection
					NEXT RECORD:C51([Purchase_Orders_Items:12])
				End while 
			End if 
			
			
		Else 
			
			
			QUERY BY FORMULA:C48([Purchase_Orders_Items:12]; \
				([Purchase_Orders_Items:12]FixedCost:51=True:C214)\
				 & ([Raw_Materials_Transactions:23]XferDate:3>=$1)\
				 & ([Raw_Materials_Transactions:23]XferDate:3<=$2)\
				 & ([Raw_Materials_Transactions:23]Xfer_Type:2="Receipt")\
				)
			If (Records in selection:C76([Purchase_Orders_Items:12])>0)
				APPLY TO SELECTION:C70([Purchase_Orders_Items:12]; POI_FixedCostCorrection)
			End if 
			
			
		End if   // END 4D Professional Services : January 2019 query selection
		
	Else   //do the current po item
		//[Purchase_Orders_Items]UnitPrice:=[Purchase_Orders_Items]ExtPrice/[Purchase_Orders_Items]Qty_Received
		//SAVE RECORD([Purchase_Orders_Items])
		
		RMX_setCosts([Purchase_Orders_Items:12]POItemKey:1; [Purchase_Orders_Items:12]UnitPrice:10)
		
		QUERY:C277([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]POItemKey:19=[Purchase_Orders_Items:12]POItemKey:1)  //there shouldn't be any, these are direct purchases normally
		If (Records in selection:C76([Raw_Materials_Locations:25])>0)
			APPLY TO SELECTION:C70([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]ActCost:18:=[Purchase_Orders_Items:12]UnitPrice:10)
		End if 
End case 