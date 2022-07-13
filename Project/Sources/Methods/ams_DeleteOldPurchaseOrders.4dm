//%attributes = {"publishedWeb":true}
//PM: ams_DeleteOldPurchaseOrders() -> 
//@author mlb - 7/3/02  13:44
// Modified by: Mel Bohince (6/14/16) 

C_DATE:C307($cutOff; $1)
$cutOff:=$1  //!04/01/01!

READ WRITE:C146([Purchase_Orders:11])
QUERY:C277([Purchase_Orders:11]; [Purchase_Orders:11]PODate:4<$cutOff)
util_DeleteSelection(->[Purchase_Orders:11])

$cutOff:=Add to date:C393($cutOff; 1; 0; 0)
QUERY:C277([Purchase_Orders:11]; [Purchase_Orders:11]Status:15="Full@"; *)
QUERY:C277([Purchase_Orders:11];  | ; [Purchase_Orders:11]Status:15="clos@"; *)
QUERY:C277([Purchase_Orders:11];  & ; [Purchase_Orders:11]PODate:4<$cutOff)
util_DeleteSelection(->[Purchase_Orders:11])

$cutOff:=Add to date:C393($cutOff; 1; 0; 0)
QUERY:C277([Purchase_Orders:11]; [Purchase_Orders:11]Status:15="Full@"; *)
QUERY:C277([Purchase_Orders:11];  | ; [Purchase_Orders:11]Status:15="Cl@"; *)
QUERY:C277([Purchase_Orders:11];  & ; [Purchase_Orders:11]INX_autoPO:48=True:C214; *)
QUERY:C277([Purchase_Orders:11];  & ; [Purchase_Orders:11]PODate:4<$cutOff)
util_DeleteSelection(->[Purchase_Orders:11])

QUERY:C277([Purchase_Orders:11]; [Purchase_Orders:11]Status:15="Can@")
util_DeleteSelection(->[Purchase_Orders:11])
If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
	
	ams_DeleteWithoutHeaderRecord(->[Purchase_Orders_Chg_Orders:13]PONo:3; ->[Purchase_Orders:11]PONo:1)
	
Else 
	
	If (<>fContinue)
		
		READ ONLY:C145([Purchase_Orders:11])
		ALL RECORDS:C47([Purchase_Orders:11])
		READ WRITE:C146([Purchase_Orders_Chg_Orders:13])
		RELATE MANY SELECTION:C340([Purchase_Orders_Chg_Orders:13]PONo:3)
		CREATE SET:C116([Purchase_Orders_Chg_Orders:13]; "keepThese")
		ALL RECORDS:C47([Purchase_Orders_Chg_Orders:13])
		CREATE SET:C116([Purchase_Orders_Chg_Orders:13]; "allRecords")
		DIFFERENCE:C122("allRecords"; "keepThese"; "keepThese")
		USE SET:C118("keepThese")
		CLEAR SET:C117("allRecords")
		CLEAR SET:C117("keepThese")
		util_DeleteSelection(->[Purchase_Orders_Chg_Orders:13])
		
	End if 
	
End if   // END 4D Professional Services : January 2019 

READ ONLY:C145([Purchase_Orders_Items:12])
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
	
	util_outerJoin(->[Purchase_Orders_Items:12]POItemKey:1; ->[Raw_Materials_Locations:25]POItemKey:19)
	
	
Else 
	
	
	zwStatusMsg("Relating"; " Searching "+Table name:C256(->[Purchase_Orders_Items:12])+" file. Please Wait...")
	RELATE ONE SELECTION:C349([Raw_Materials_Locations:25]; [Purchase_Orders_Items:12])
	zwStatusMsg(""; "")
	
End if   // END 4D Professional Services : January 2019 query selection

$inventory_RecentSet:=ams_RecentRMInventory
If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
	
	CREATE SET:C116([Purchase_Orders_Items:12]; "Keepers")
	ams_DeleteWithoutHeaderRecord(->[Purchase_Orders_Items:12]PONo:2; ->[Purchase_Orders:11]PONo:1)
	CLEAR SET:C117("Keepers")
	
Else 
	
	If (<>fContinue)
		
		READ ONLY:C145([Purchase_Orders:11])
		ALL RECORDS:C47([Purchase_Orders:11])
		READ WRITE:C146([Purchase_Orders_Items:12])
		
		If (Not:C34(<>modification4D_10_05_19))  // BEGIN 4D Professional Services : Query With array
			
			ARRAY TEXT:C222($_PONo; 0)
			DISTINCT VALUES:C339([Purchase_Orders:11]PONo:1; $_PONo)
			SET QUERY DESTINATION:C396(Into set:K19:2; "keepThese")
			QUERY WITH ARRAY:C644([Purchase_Orders_Items:12]PONo:2; $_PONo)
			SET QUERY DESTINATION:C396(Into current selection:K19:1)
			
		Else 
			
			RELATE MANY SELECTION:C340([Purchase_Orders_Items:12]PONo:2)
			
		End if   // END 4D Professional Services : January 2019 
		
		
		ALL RECORDS:C47([Purchase_Orders_Items:12])
		CREATE SET:C116([Purchase_Orders_Items:12]; "allRecords")
		DIFFERENCE:C122("allRecords"; "keepThese"; "keepThese")
		USE SET:C118("keepThese")
		CLEAR SET:C117("allRecords")
		CLEAR SET:C117("keepThese")
		util_DeleteSelection(->[Purchase_Orders_Items:12])
		
	End if 
	
	
End if   // END 4D Professional Services : January 2019 

If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
	
	ams_DeleteWithoutHeaderRecord(->[Purchase_Orders_Job_forms:59]POItemKey:1; ->[Purchase_Orders_Items:12]POItemKey:1)
	
Else 
	
	
	If (<>fContinue)
		
		READ ONLY:C145([Purchase_Orders_Items:12])
		ALL RECORDS:C47([Purchase_Orders_Items:12])
		READ WRITE:C146([Purchase_Orders_Job_forms:59])
		RELATE MANY SELECTION:C340([Purchase_Orders_Job_forms:59]POItemKey:1)
		CREATE SET:C116([Purchase_Orders_Job_forms:59]; "keepThese")
		ALL RECORDS:C47([Purchase_Orders_Job_forms:59])
		CREATE SET:C116([Purchase_Orders_Job_forms:59]; "allRecords")
		DIFFERENCE:C122("allRecords"; "keepThese"; "keepThese")
		USE SET:C118("keepThese")
		CLEAR SET:C117("allRecords")
		CLEAR SET:C117("keepThese")
		util_DeleteSelection(->[Purchase_Orders_Job_forms:59])
		
	End if 
	
End if   // END 4D Professional Services : January 2019 

If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
	
	ams_DeleteWithoutHeaderRecord(->[Raw_Materials_Transactions:23]POItemKey:4; ->[Purchase_Orders_Items:12]POItemKey:1)
	
Else 
	
	If (<>fContinue)
		
		READ ONLY:C145([Purchase_Orders_Items:12])
		ALL RECORDS:C47([Purchase_Orders_Items:12])
		READ WRITE:C146([Raw_Materials_Transactions:23])
		RELATE MANY SELECTION:C340([Raw_Materials_Transactions:23]POItemKey:4)
		CREATE SET:C116([Raw_Materials_Transactions:23]; "keepThese")
		ALL RECORDS:C47([Raw_Materials_Transactions:23])
		CREATE SET:C116([Raw_Materials_Transactions:23]; "allRecords")
		DIFFERENCE:C122("allRecords"; "keepThese"; "keepThese")
		USE SET:C118("keepThese")
		CLEAR SET:C117("allRecords")
		CLEAR SET:C117("keepThese")
		util_DeleteSelection(->[Raw_Materials_Transactions:23])
		
	End if 
	
End if   // END 4D Professional Services : January 2019 


// Modified by: Mel Bohince (6/14/16) 
If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
	
	ams_DeleteWithoutHeaderRecord(->[Purchase_Orders_PO_Clauses:165]id_added_by_converter:7; ->[Purchase_Orders:11]PO_Clauses:33)
	
Else 
	
	If (<>fContinue)
		
		READ ONLY:C145([Purchase_Orders:11])
		ALL RECORDS:C47([Purchase_Orders:11])
		READ WRITE:C146([Purchase_Orders_PO_Clauses:165])
		RELATE MANY SELECTION:C340([Purchase_Orders_PO_Clauses:165]id_added_by_converter:7)
		CREATE SET:C116([Purchase_Orders_PO_Clauses:165]; "keepThese")
		ALL RECORDS:C47([Purchase_Orders_PO_Clauses:165])
		CREATE SET:C116([Purchase_Orders_PO_Clauses:165]; "allRecords")
		DIFFERENCE:C122("allRecords"; "keepThese"; "keepThese")
		USE SET:C118("keepThese")
		CLEAR SET:C117("allRecords")
		CLEAR SET:C117("keepThese")
		util_DeleteSelection(->[Purchase_Orders_PO_Clauses:165])
		
	End if 
	
End if   // END 4D Professional Services : January 2019 

If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
	
	ams_DeleteWithoutHeaderRecord(->[Purchase_Orders_ChgOrder_Items:166]id_added_by_converter:10; ->[Purchase_Orders_Chg_Orders:13]POCO_Items:9)
	
Else 
	
	
	If (<>fContinue)
		
		READ ONLY:C145([Purchase_Orders_Chg_Orders:13])
		ALL RECORDS:C47([Purchase_Orders_Chg_Orders:13])
		READ WRITE:C146([Purchase_Orders_ChgOrder_Items:166])
		RELATE MANY SELECTION:C340([Purchase_Orders_ChgOrder_Items:166]id_added_by_converter:10)
		CREATE SET:C116([Purchase_Orders_ChgOrder_Items:166]; "keepThese")
		ALL RECORDS:C47([Purchase_Orders_ChgOrder_Items:166])
		CREATE SET:C116([Purchase_Orders_ChgOrder_Items:166]; "allRecords")
		DIFFERENCE:C122("allRecords"; "keepThese"; "keepThese")
		USE SET:C118("keepThese")
		CLEAR SET:C117("allRecords")
		CLEAR SET:C117("keepThese")
		util_DeleteSelection(->[Purchase_Orders_ChgOrder_Items:166])
		
	End if 
	
End if   // END 4D Professional Services : January 2019 

If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
	
	ams_DeleteWithoutHeaderRecord(->[Purchase_Orders_Releases:79]POitemKey:1; ->[Purchase_Orders_Items:12]POItemKey:1)
	
Else 
	
	
	If (<>fContinue)
		
		READ ONLY:C145([Purchase_Orders_Items:12])
		ALL RECORDS:C47([Purchase_Orders_Items:12])
		READ WRITE:C146([Purchase_Orders_Releases:79])
		ARRAY TEXT:C222($_POItemKey; 0)
		DISTINCT VALUES:C339([Purchase_Orders_Items:12]POItemKey:1; $_POItemKey)
		SET QUERY DESTINATION:C396(Into set:K19:2; "keepThese")
		QUERY WITH ARRAY:C644([Purchase_Orders_Releases:79]POitemKey:1; $_POItemKey)
		SET QUERY DESTINATION:C396(Into current selection:K19:1)
		ALL RECORDS:C47([Purchase_Orders_Releases:79])
		CREATE SET:C116([Purchase_Orders_Releases:79]; "allRecords")
		DIFFERENCE:C122("allRecords"; "keepThese"; "keepThese")
		USE SET:C118("keepThese")
		CLEAR SET:C117("allRecords")
		CLEAR SET:C117("keepThese")
		util_DeleteSelection(->[Purchase_Orders_Releases:79])
		
	End if 
	
End if   // END 4D Professional Services : January 2019 
