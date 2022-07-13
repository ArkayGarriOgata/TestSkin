//%attributes = {"publishedWeb":true}
//PM: ams_DeleteOldJobs() -> 
//@author mlb - 7/1/02  15:21
// Modified by: Mel Bohince (6/14/16) get the items labels

C_DATE:C307($cutOffDate; $1)
$cutOffDate:=$1
If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
	
	$recentSet:=ams_RecentJob($cutOffDate)
	USE SET:C118($recentSet)
	READ WRITE:C146([Jobs:15])
	RELATE ONE SELECTION:C349([Job_Forms:42]; [Jobs:15])
	CREATE SET:C116([Jobs:15]; "recentJobs")
	
	ALL RECORDS:C47([Jobs:15])
	CREATE SET:C116([Jobs:15]; "allRecords")
	
	DIFFERENCE:C122("allRecords"; "recentJobs"; "deleteThese")
	USE SET:C118("deleteThese")
	
	$recentSet:=ams_RecentJob
	CLEAR SET:C117("recentJobs")
	CLEAR SET:C117("allRecords")
	CLEAR SET:C117("deleteThese")
	
Else 
	
	QUERY:C277([Jobs:15]; [Job_Forms:42]VersionDate:58<$cutOffDate)
	
	
End if   // END 4D Professional Services : January 2019 


util_DeleteSelection(->[Jobs:15])
If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
	
	ams_DeleteWithoutHeaderRecord(->[Job_Forms:42]JobNo:2; ->[Jobs:15]JobNo:1)
	
Else 
	
	
	READ ONLY:C145([Jobs:15])
	ALL RECORDS:C47([Jobs:15])
	READ WRITE:C146([Job_Forms:42])
	RELATE MANY SELECTION:C340([Job_Forms:42]JobNo:2)
	CREATE SET:C116([Job_Forms:42]; "keepThese")
	ALL RECORDS:C47([Job_Forms:42])
	CREATE SET:C116([Job_Forms:42]; "allRecords")
	DIFFERENCE:C122("allRecords"; "keepThese"; "keepThese")
	USE SET:C118("keepThese")
	CLEAR SET:C117("allRecords")
	CLEAR SET:C117("keepThese")
	util_DeleteSelection(->[Job_Forms:42])
	
End if   // END 4D Professional Services : January 2019 

If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
	
	ams_DeleteWithoutHeaderRecord(->[Job_Forms_Master_Schedule:67]JobForm:4; ->[Job_Forms:42]JobFormID:5)
	
Else 
	
	READ ONLY:C145([Job_Forms:42])
	ALL RECORDS:C47([Job_Forms:42])
	READ WRITE:C146([Job_Forms_Master_Schedule:67])
	RELATE MANY SELECTION:C340([Job_Forms_Master_Schedule:67]JobForm:4)
	CREATE SET:C116([Job_Forms_Master_Schedule:67]; "keepThese")
	ALL RECORDS:C47([Job_Forms_Master_Schedule:67])
	CREATE SET:C116([Job_Forms_Master_Schedule:67]; "allRecords")
	DIFFERENCE:C122("allRecords"; "keepThese"; "keepThese")
	USE SET:C118("keepThese")
	CLEAR SET:C117("allRecords")
	CLEAR SET:C117("keepThese")
	util_DeleteSelection(->[Job_Forms_Master_Schedule:67])
	
End if   // END 4D Professional Services : January 2019 

If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
	
	ams_DeleteWithoutHeaderRecord(->[Job_Forms_Machine_Tickets:61]JobForm:1; ->[Job_Forms:42]JobFormID:5)
	
Else 
	
	READ ONLY:C145([Job_Forms:42])
	ALL RECORDS:C47([Job_Forms:42])
	READ WRITE:C146([Job_Forms_Machine_Tickets:61])
	RELATE MANY SELECTION:C340([Job_Forms_Machine_Tickets:61]JobForm:1)
	CREATE SET:C116([Job_Forms_Machine_Tickets:61]; "keepThese")
	ALL RECORDS:C47([Job_Forms_Machine_Tickets:61])
	CREATE SET:C116([Job_Forms_Machine_Tickets:61]; "allRecords")
	DIFFERENCE:C122("allRecords"; "keepThese"; "keepThese")
	USE SET:C118("keepThese")
	CLEAR SET:C117("allRecords")
	CLEAR SET:C117("keepThese")
	util_DeleteSelection(->[Job_Forms_Machine_Tickets:61])
	
End if   // END 4D Professional Services : January 2019 

READ WRITE:C146([Job_Forms_Machine_Tickets:61])
QUERY:C277([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]DateEntered:5<$cutOffDate)
util_DeleteSelection(->[Job_Forms_Machine_Tickets:61])

READ WRITE:C146([WMS_WarehouseOrders:146])
QUERY:C277([WMS_WarehouseOrders:146]; [WMS_WarehouseOrders:146]Needed:5<$cutOffDate)
util_DeleteSelection(->[WMS_WarehouseOrders:146])
If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
	
	ams_DeleteWithoutHeaderRecord(->[Job_Forms_Machines:43]JobForm:1; ->[Job_Forms:42]JobFormID:5)
	
Else 
	
	READ ONLY:C145([Job_Forms:42])
	ALL RECORDS:C47([Job_Forms:42])
	READ WRITE:C146([Job_Forms_Machines:43])
	RELATE MANY SELECTION:C340([Job_Forms_Machines:43]JobForm:1)
	CREATE SET:C116([Job_Forms_Machines:43]; "keepThese")
	ALL RECORDS:C47([Job_Forms_Machines:43])
	CREATE SET:C116([Job_Forms_Machines:43]; "allRecords")
	DIFFERENCE:C122("allRecords"; "keepThese"; "keepThese")
	USE SET:C118("keepThese")
	CLEAR SET:C117("allRecords")
	CLEAR SET:C117("keepThese")
	util_DeleteSelection(->[Job_Forms_Machines:43])
	
End if   // END 4D Professional Services : January 2019 

If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
	
	ams_DeleteWithoutHeaderRecord(->[Job_Forms_Materials:55]JobForm:1; ->[Job_Forms:42]JobFormID:5)
	
Else 
	
	READ ONLY:C145([Job_Forms:42])
	ALL RECORDS:C47([Job_Forms:42])
	READ WRITE:C146([Job_Forms_Materials:55])
	RELATE MANY SELECTION:C340([Job_Forms_Materials:55]JobForm:1)
	CREATE SET:C116([Job_Forms_Materials:55]; "keepThese")
	ALL RECORDS:C47([Job_Forms_Materials:55])
	CREATE SET:C116([Job_Forms_Materials:55]; "allRecords")
	DIFFERENCE:C122("allRecords"; "keepThese"; "keepThese")
	USE SET:C118("keepThese")
	CLEAR SET:C117("allRecords")
	CLEAR SET:C117("keepThese")
	util_DeleteSelection(->[Job_Forms_Materials:55])
	
End if   // END 4D Professional Services : January 2019 

If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
	
	ams_DeleteWithoutHeaderRecord(->[Purchase_Orders_Job_forms:59]JobFormID:2; ->[Job_Forms:42]JobFormID:5)
	
Else 
	
	READ ONLY:C145([Job_Forms:42])
	ALL RECORDS:C47([Job_Forms:42])
	READ WRITE:C146([Purchase_Orders_Job_forms:59])
	RELATE MANY SELECTION:C340([Purchase_Orders_Job_forms:59]JobFormID:2)
	CREATE SET:C116([Purchase_Orders_Job_forms:59]; "keepThese")
	ALL RECORDS:C47([Purchase_Orders_Job_forms:59])
	CREATE SET:C116([Purchase_Orders_Job_forms:59]; "allRecords")
	DIFFERENCE:C122("allRecords"; "keepThese"; "keepThese")
	USE SET:C118("keepThese")
	CLEAR SET:C117("allRecords")
	CLEAR SET:C117("keepThese")
	util_DeleteSelection(->[Purchase_Orders_Job_forms:59])
	
End if   // END 4D Professional Services : January 2019 

If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
	
	ams_DeleteWithoutHeaderRecord(->[Job_Forms_Revision_Notification:119]jobform:1; ->[Job_Forms:42]JobFormID:5)
	
Else 
	
	READ ONLY:C145([Job_Forms:42])
	ALL RECORDS:C47([Job_Forms:42])
	READ WRITE:C146([Job_Forms_Revision_Notification:119])
	ARRAY TEXT:C222($_JobFormID; 0)
	DISTINCT VALUES:C339([Job_Forms:42]JobFormID:5; $_JobFormID)
	SET QUERY DESTINATION:C396(Into set:K19:2; "keepThese")
	QUERY WITH ARRAY:C644([Job_Forms_Revision_Notification:119]jobform:1; $_JobFormID)
	SET QUERY DESTINATION:C396(Into current selection:K19:1)
	ALL RECORDS:C47([Job_Forms_Revision_Notification:119])
	CREATE SET:C116([Job_Forms_Revision_Notification:119]; "allRecords")
	DIFFERENCE:C122("allRecords"; "keepThese"; "keepThese")
	USE SET:C118("keepThese")
	CLEAR SET:C117("allRecords")
	CLEAR SET:C117("keepThese")
	util_DeleteSelection(->[Job_Forms_Revision_Notification:119])
	
	
End if   // END 4D Professional Services : January 2019 

If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
	
	ams_DeleteWithoutHeaderRecord(->[Job_Forms_CloseoutSummaries:87]JobForm:1; ->[Job_Forms:42]JobFormID:5)
	
Else 
	
	
	READ ONLY:C145([Job_Forms:42])
	ALL RECORDS:C47([Job_Forms:42])
	READ WRITE:C146([Job_Forms_CloseoutSummaries:87])
	RELATE MANY SELECTION:C340([Job_Forms_CloseoutSummaries:87]JobForm:1)
	CREATE SET:C116([Job_Forms_CloseoutSummaries:87]; "keepThese")
	ALL RECORDS:C47([Job_Forms_CloseoutSummaries:87])
	CREATE SET:C116([Job_Forms_CloseoutSummaries:87]; "allRecords")
	DIFFERENCE:C122("allRecords"; "keepThese"; "keepThese")
	USE SET:C118("keepThese")
	CLEAR SET:C117("allRecords")
	CLEAR SET:C117("keepThese")
	util_DeleteSelection(->[Job_Forms_CloseoutSummaries:87])
	
	
End if   // END 4D Professional Services : January 2019 

If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
	
	ams_DeleteWithoutHeaderRecord(->[Job_DieBoards:152]JobformId:1; ->[Job_Forms:42]JobFormID:5)
	
Else 
	
	If (<>fContinue)
		
		READ ONLY:C145([Job_Forms:42])
		ALL RECORDS:C47([Job_Forms:42])
		READ WRITE:C146([Job_DieBoards:152])
		RELATE ONE SELECTION:C349([Job_Forms:42]; [Job_DieBoards:152])
		CREATE SET:C116([Job_DieBoards:152]; "keepThese")
		ALL RECORDS:C47([Job_DieBoards:152])
		CREATE SET:C116([Job_DieBoards:152]; "allRecords")
		DIFFERENCE:C122("allRecords"; "keepThese"; "keepThese")
		USE SET:C118("keepThese")
		CLEAR SET:C117("allRecords")
		CLEAR SET:C117("keepThese")
		util_DeleteSelection(->[Job_DieBoards:152])
		
	End if 
	
End if   // END 4D Professional Services : January 2019 

If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
	
	ams_DeleteWithoutHeaderRecord(->[Job_Forms_Items_Labels:149]jobform:5; ->[Job_Forms:42]JobFormID:5)  // Modified by: Mel Bohince (6/14/16) 
	
Else 
	
	If (<>fContinue)
		
		READ ONLY:C145([Job_Forms:42])
		ALL RECORDS:C47([Job_Forms:42])
		READ WRITE:C146([Job_Forms_Items_Labels:149])
		ARRAY TEXT:C222($_JobFormID; 0)
		DISTINCT VALUES:C339([Job_Forms:42]JobFormID:5; $_JobFormID)
		SET QUERY DESTINATION:C396(Into set:K19:2; "keepThese")
		QUERY WITH ARRAY:C644([Job_Forms_Items_Labels:149]jobform:5; $_JobFormID)
		SET QUERY DESTINATION:C396(Into current selection:K19:1)
		ALL RECORDS:C47([Job_Forms_Items_Labels:149])
		CREATE SET:C116([Job_Forms_Items_Labels:149]; "allRecords")
		DIFFERENCE:C122("allRecords"; "keepThese"; "keepThese")
		USE SET:C118("keepThese")
		CLEAR SET:C117("allRecords")
		CLEAR SET:C117("keepThese")
		util_DeleteSelection(->[Job_Forms_Items_Labels:149])
		
	End if 
	
End if   // END 4D Professional Services : January 2019 


READ ONLY:C145([Finished_Goods_Locations:35])
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
	
	ALL RECORDS:C47([Finished_Goods_Locations:35])
	util_outerJoin(->[Job_Forms_Items:44]Jobit:4; ->[Finished_Goods_Locations:35]Jobit:33)
	CREATE SET:C116([Job_Forms_Items:44]; "Keepers")
	ams_DeleteWithoutHeaderRecord(->[Job_Forms_Items:44]JobForm:1; ->[Job_Forms:42]JobFormID:5; "Keepers")
	CLEAR SET:C117("Keepers")
	
	util_outerJoin(->[Job_Forms_Items_Costs:92]Jobit:3; ->[Finished_Goods_Locations:35]Jobit:33)
	CREATE SET:C116([Job_Forms_Items_Costs:92]; "Keepers")
	ams_DeleteWithoutHeaderRecord(->[Job_Forms_Items_Costs:92]JobForm:1; ->[Job_Forms:42]JobFormID:5; "Keepers")
	CLEAR SET:C117("Keepers")
	
Else 
	
	zwStatusMsg("Relating"; " Searching "+Table name:C256(->[Job_Forms_Items:44])+" file. Please Wait...")
	ALL RECORDS:C47([Finished_Goods_Locations:35])
	ARRAY TEXT:C222($_Jobit; 0)
	DISTINCT VALUES:C339([Finished_Goods_Locations:35]Jobit:33; $_Jobit)
	SET QUERY DESTINATION:C396(Into set:K19:2; "Keepers")
	QUERY WITH ARRAY:C644([Job_Forms_Items:44]Jobit:4; $_Jobit)
	SET QUERY DESTINATION:C396(Into current selection:K19:1)
	zwStatusMsg(""; "")
	If (<>fContinue)
		
		READ ONLY:C145([Job_Forms:42])
		ALL RECORDS:C47([Job_Forms:42])
		
		READ WRITE:C146([Job_Forms_Items:44])
		RELATE MANY SELECTION:C340([Job_Forms_Items:44]JobForm:1)
		CREATE SET:C116([Job_Forms_Items:44]; "keepThese")
		
		ALL RECORDS:C47([Job_Forms_Items:44])
		CREATE SET:C116([Job_Forms_Items:44]; "allRecords")
		
		DIFFERENCE:C122("allRecords"; "keepThese"; "deleteThese")
		DIFFERENCE:C122("deleteThese"; "Keepers"; "deleteThese")
		
		
		USE SET:C118("deleteThese")
		CLEAR SET:C117("allRecords")
		CLEAR SET:C117("keepThese")
		CLEAR SET:C117("deleteThese")
		
		util_DeleteSelection(->[Job_Forms_Items:44])
		
	End if 
	CLEAR SET:C117("Keepers")
	zwStatusMsg("Relating"; " Searching "+Table name:C256(->[Job_Forms_Items_Costs:92])+" file. Please Wait...")
	SET QUERY DESTINATION:C396(Into set:K19:2; "Keepers")
	QUERY WITH ARRAY:C644([Job_Forms_Items_Costs:92]Jobit:3; $_Jobit)
	zwStatusMsg(""; "")
	SET QUERY DESTINATION:C396(Into current selection:K19:1)
	
	If (<>fContinue)
		
		READ ONLY:C145([Job_Forms:42])
		ALL RECORDS:C47([Job_Forms:42])
		
		READ WRITE:C146([Job_Forms_Items_Costs:92])
		ARRAY TEXT:C222($_JobFormID; 0)
		DISTINCT VALUES:C339([Job_Forms:42]JobFormID:5; $_JobFormID)
		SET QUERY DESTINATION:C396(Into set:K19:2; "keepThese")
		QUERY WITH ARRAY:C644([Job_Forms_Items_Costs:92]JobForm:1; $_JobFormID)
		SET QUERY DESTINATION:C396(Into current selection:K19:1)
		
		ALL RECORDS:C47([Job_Forms_Items_Costs:92])
		CREATE SET:C116([Job_Forms_Items_Costs:92]; "allRecords")
		
		DIFFERENCE:C122("allRecords"; "keepThese"; "deleteThese")
		DIFFERENCE:C122("deleteThese"; "Keepers"; "deleteThese")
		
		
		USE SET:C118("deleteThese")
		CLEAR SET:C117("allRecords")
		CLEAR SET:C117("keepThese")
		CLEAR SET:C117("deleteThese")
		
		util_DeleteSelection(->[Job_Forms_Items_Costs:92])
		
	End if 
	CLEAR SET:C117("Keepers")
	
End if   // END 4D Professional Services : January 2019 query selection

REDUCE SELECTION:C351([Finished_Goods_Locations:35]; 0)