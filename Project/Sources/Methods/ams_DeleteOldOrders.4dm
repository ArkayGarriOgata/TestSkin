//%attributes = {"publishedWeb":true}
//PM: ams_DeleteOldOrders() -> 
//@author mlb - 7/1/02  15:21

C_DATE:C307($cutOffDate; $1)
$cutOffDate:=$1

QUERY:C277([Customers_Orders:40]; [Customers_Orders:40]Status:10="Closed"; *)
QUERY:C277([Customers_Orders:40];  & ; [Customers_Orders:40]DateClosed:49<$cutOffDate)
util_DeleteSelection(->[Customers_Orders:40])

QUERY:C277([Customers_Orders:40]; [Customers_Orders:40]Status:10="Hold@"; *)
QUERY:C277([Customers_Orders:40];  & ; [Customers_Orders:40]DateOpened:6<$cutOffDate)
util_DeleteSelection(->[Customers_Orders:40])

// Modified by: Mel Bohince (1/10/19) Rejected and Kill are not used
//QUERY([Customers_Orders];[Customers_Orders]Status="Rejected")
//util_DeleteSelection (->[Customers_Orders])

//QUERY([Customers_Orders];[Customers_Orders]Status="Kill")
//util_DeleteSelection (->[Customers_Orders])

QUERY:C277([Customers_Orders:40]; [Customers_Orders:40]Status:10="Cancel")
util_DeleteSelection(->[Customers_Orders:40])


QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]Qty_Open:11>0; *)
QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]Status:9="Accepted")
CREATE SET:C116([Customers_Order_Lines:41]; "keepers")
If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
	
	ams_DeleteWithoutHeaderRecord(->[Customers_Order_Lines:41]OrderNumber:1; ->[Customers_Orders:40]OrderNumber:1; "keepers")
	
	
Else 
	
	If (<>fContinue)
		
		READ ONLY:C145([Customers_Orders:40])
		ALL RECORDS:C47([Customers_Orders:40])
		READ WRITE:C146([Customers_Order_Lines:41])
		RELATE MANY SELECTION:C340([Customers_Order_Lines:41]OrderNumber:1)
		CREATE SET:C116([Customers_Order_Lines:41]; "keepThese")
		ALL RECORDS:C47([Customers_Order_Lines:41])
		CREATE SET:C116([Customers_Order_Lines:41]; "allRecords")
		DIFFERENCE:C122("allRecords"; "keepThese"; "keepThese")
		DIFFERENCE:C122("keepThese"; "keepers"; "keepThese")
		USE SET:C118("keepThese")
		CLEAR SET:C117("allRecords")
		CLEAR SET:C117("keepThese")
		util_DeleteSelection(->[Customers_Order_Lines:41])
		
	End if 
	
	
End if   // END 4D Professional Services : January 2019 

CLEAR SET:C117("keepers")
If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
	
	ams_DeleteWithoutHeaderRecord(->[Customers_Order_Change_Orders:34]OrderNo:5; ->[Customers_Orders:40]OrderNumber:1)
	
Else 
	
	If (<>fContinue)
		
		READ ONLY:C145([Customers_Orders:40])
		ALL RECORDS:C47([Customers_Orders:40])
		READ WRITE:C146([Customers_Order_Change_Orders:34])
		If (Not:C34(<>modification4D_10_05_19))  // BEGIN 4D Professional Services : Query With array
			
			ARRAY LONGINT:C221($_OrderNumber; 0)
			DISTINCT VALUES:C339([Customers_Orders:40]OrderNumber:1; $_OrderNumber)
			SET QUERY DESTINATION:C396(Into set:K19:2; "keepThese")
			QUERY WITH ARRAY:C644([Customers_Order_Change_Orders:34]OrderNo:5; $_OrderNumber)
			SET QUERY DESTINATION:C396(Into current selection:K19:1)
			
		Else 
			
			RELATE MANY SELECTION:C340([Customers_Order_Change_Orders:34]OrderNo:5)
			CREATE SET:C116([Customers_Order_Change_Orders:34]; "keepThese")
			
		End if   // END 4D Professional Services : January 2019 
		
		ALL RECORDS:C47([Customers_Order_Change_Orders:34])
		CREATE SET:C116([Customers_Order_Change_Orders:34]; "allRecords")
		DIFFERENCE:C122("allRecords"; "keepThese"; "keepThese")
		USE SET:C118("keepThese")
		CLEAR SET:C117("allRecords")
		CLEAR SET:C117("keepThese")
		util_DeleteSelection(->[Customers_Order_Change_Orders:34])
		
	End if 
	
End if   // END 4D Professional Services : January 2019 

QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Actual_Date:7=!00-00-00!)
CREATE SET:C116([Customers_ReleaseSchedules:46]; "keepers")
If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
	
	ams_DeleteWithoutHeaderRecord(->[Customers_ReleaseSchedules:46]OrderLine:4; ->[Customers_Order_Lines:41]OrderLine:3; "keepers")
	
Else 
	
	
	If (<>fContinue)
		
		READ ONLY:C145([Customers_Order_Lines:41])
		ALL RECORDS:C47([Customers_Order_Lines:41])
		READ WRITE:C146([Customers_ReleaseSchedules:46])
		RELATE MANY SELECTION:C340([Customers_ReleaseSchedules:46]OrderLine:4)
		CREATE SET:C116([Customers_ReleaseSchedules:46]; "keepThese")
		ALL RECORDS:C47([Customers_ReleaseSchedules:46])
		CREATE SET:C116([Customers_ReleaseSchedules:46]; "allRecords")
		DIFFERENCE:C122("allRecords"; "keepThese"; "keepThese")
		DIFFERENCE:C122("keepThese"; "keepers"; "keepThese")
		USE SET:C118("keepThese")
		CLEAR SET:C117("allRecords")
		CLEAR SET:C117("keepThese")
		util_DeleteSelection(->[Customers_ReleaseSchedules:46])
		
	End if 
	
End if   // END 4D Professional Services : January 2019 
CLEAR SET:C117("keepers")
If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
	
	ams_DeleteWithoutHeaderRecord(->[Customers_Invoices:88]OrderLine:4; ->[Customers_Order_Lines:41]OrderLine:3)
	
Else 
	
	If (<>fContinue)
		
		READ ONLY:C145([Customers_Order_Lines:41])
		ALL RECORDS:C47([Customers_Order_Lines:41])
		READ WRITE:C146([Customers_Invoices:88])
		RELATE MANY SELECTION:C340([Customers_Invoices:88]OrderLine:4)
		CREATE SET:C116([Customers_Invoices:88]; "keepThese")
		ALL RECORDS:C47([Customers_Invoices:88])
		CREATE SET:C116([Customers_Invoices:88]; "allRecords")
		DIFFERENCE:C122("allRecords"; "keepThese"; "keepThese")
		USE SET:C118("keepThese")
		CLEAR SET:C117("allRecords")
		CLEAR SET:C117("keepThese")
		util_DeleteSelection(->[Customers_Invoices:88])
		
	End if 
	
End if   // END 4D Professional Services : January 2019 

If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
	
	ams_DeleteWithoutHeaderRecord(->[Customers_BilledPayUse:86]Orderline:1; ->[Customers_Order_Lines:41]OrderLine:3)
	
Else 
	
	If (<>fContinue)
		
		READ ONLY:C145([Customers_Order_Lines:41])
		ALL RECORDS:C47([Customers_Order_Lines:41])
		READ WRITE:C146([Customers_BilledPayUse:86])
		RELATE MANY SELECTION:C340([Customers_BilledPayUse:86]Orderline:1)
		CREATE SET:C116([Customers_BilledPayUse:86]; "keepThese")
		ALL RECORDS:C47([Customers_BilledPayUse:86])
		CREATE SET:C116([Customers_BilledPayUse:86]; "allRecords")
		DIFFERENCE:C122("allRecords"; "keepThese"; "keepThese")
		USE SET:C118("keepThese")
		CLEAR SET:C117("allRecords")
		CLEAR SET:C117("keepThese")
		util_DeleteSelection(->[Customers_BilledPayUse:86])
		
	End if 
	
End if   // END 4D Professional Services : January 2019 

// Modified by: Mel Bohince (6/14/16) 
If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
	
	ams_DeleteWithoutHeaderRecord(->[Customers_Order_Changed_Items:176]id_added_by_converter:41; ->[Customers_Order_Change_Orders:34]OrderChg_Items:6)
	
Else 
	
	
	If (<>fContinue)
		
		READ ONLY:C145([Customers_Order_Change_Orders:34])
		ALL RECORDS:C47([Customers_Order_Change_Orders:34])
		READ WRITE:C146([Customers_Order_Changed_Items:176])
		RELATE MANY SELECTION:C340([Customers_Order_Changed_Items:176]id_added_by_converter:41)
		CREATE SET:C116([Customers_Order_Changed_Items:176]; "keepThese")
		ALL RECORDS:C47([Customers_Order_Changed_Items:176])
		CREATE SET:C116([Customers_Order_Changed_Items:176]; "allRecords")
		DIFFERENCE:C122("allRecords"; "keepThese"; "keepThese")
		USE SET:C118("keepThese")
		CLEAR SET:C117("allRecords")
		CLEAR SET:C117("keepThese")
		util_DeleteSelection(->[Customers_Order_Changed_Items:176])
		
	End if 
	
End if   // END 4D Professional Services : January 2019 

