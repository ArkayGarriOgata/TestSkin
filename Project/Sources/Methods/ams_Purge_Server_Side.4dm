//%attributes = {"publishedWeb":true}
//PM: ams_Purge_Server_Side, was ams_PurgeUI() -> 
//@author mlb - 7/1/02  09:02
//change logic of doPurge so that it is customer centric
//keep 2 fiscal years plus the current YTD
// Modified by: Mel Bohince (6/17/16) use Date3 and fix spec_inks foreign key
// Modified by: Mel Bohince (1/13/17) inside CloseCustOrders, make sure if closed they have a closed date

C_BOOLEAN:C305(<>fContinue)  //• 11/21/97 cs flag for PO purge routines
<>fContinue:=True:C214
C_DATE:C307(<>cutOffDate1; <>cutOffDate2; <>cutOffDate3; $date)

$year:=Year of:C25(Current date:C33)-1  //going after a complete fiscal year boundary
$date:=Date:C102("01/01/"+String:C10($year))
<>cutOffDate1:=$date  //keep 1 yrs plus current

$year:=Year of:C25(Current date:C33)-2  //going after a complete fiscal year boundary
$date:=Date:C102("01/01/"+String:C10($year))
<>cutOffDate2:=$date  //keep 2 yrs plus current

$year:=Year of:C25(Current date:C33)-3  //going after a complete fiscal year boundary
$date:=Date:C102("01/01/"+String:C10($year))
<>cutOffDate3:=$date  //keep 3 yrs plus current

utl_Logfile("purge.log"; "START, Cutoff dates of "+String:C10(<>cutOffDate1)+" and "+String:C10(<>cutOffDate2)+" and "+String:C10(<>cutOffDate3))
utl_Logfile("purge.log"; "pre-report")
//doPurgeChk4Hole   //save on server BTW
utl_Logfile("purge.log"; "Obsolete table clearings")
ams_DeleteObsoleteRecords(->[PNGA_SQL_Tasks:104])  // Modified by: Mel Bohince (6/18/14) 
ams_DeleteObsoleteRecords(->[PNGA_SQL_Sync:191])  // Modified by: Mel Bohince (6/18/14) 
ams_DeleteObsoleteRecords(->[PNGA_SQL_Log:192])  // Modified by: Mel Bohince (6/18/14) 
ams_DeleteObsoleteRecords(->[PNGA_SQL_OnError:24])  // Modified by: Mel Bohince (6/18/14) 
ams_DeleteObsoleteRecords(->[ProductionSchedules_MakeReady:126])  // Modified by: Mel Bohince (6/18/14) 
ams_DeleteObsoleteRecords(->[Job_Forms_Issue_Tickets:90])
//ams_DeleteObsoleteRecords (->[JTB_Logs])
ams_DeleteObsoleteRecords(->[JPSI_Logs:115])
ams_DeleteObsoleteRecords(->[JPSI_Job_Physical_Support_Items:111])
ams_DeleteObsoleteRecords(->[x_saved_sets:127])  //[x_fax_follow_ups])
ams_DeleteObsoleteRecords(->[Finished_Goods_Inv_Summaries:64])
//ams_DeleteObsoleteRecords (->[Purchase_Orders_Requisitions])
utl_Logfile("purge.log"; "Closing Orders and Jobs")
ORD_ContractHeaders
CloseCustOrders  // Modified by: Mel Bohince (1/29/15) updated queries
CloseJobHdrs

//******************
//*******Customer Based *
//******************
utl_Logfile("purge.log"; "Customer based")
If (True:C214)
	ams_RecentCustomers  //mark recent customers to keep
	QUERY:C277([Customers:16]; [Customers:16]Active:15=False:C215)
	//util_DeleteSelection (->[Customers])  //cut off the head and the body will die
	APPLY TO SELECTION:C70([Customers:16]; [Customers:16]ID:1:="9"+Substring:C12([Customers:16]ID:1; 2))
End if 

//go after all tables that reference the CustomerID
If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
	
	ams_DeleteWithoutHeaderRecord(->[Customers_Brand_Lines:39]CustID:1; ->[Customers:16]ID:1)
	
Else 
	
	If (<>fContinue)
		
		READ ONLY:C145([Customers:16])
		ALL RECORDS:C47([Customers:16])
		READ WRITE:C146([Customers_Brand_Lines:39])
		RELATE MANY SELECTION:C340([Customers_Brand_Lines:39]CustID:1)
		CREATE SET:C116([Customers_Brand_Lines:39]; "keepThese")
		ALL RECORDS:C47([Customers_Brand_Lines:39])
		CREATE SET:C116([Customers_Brand_Lines:39]; "allRecords")
		DIFFERENCE:C122("allRecords"; "keepThese"; "keepThese")
		USE SET:C118("keepThese")
		CLEAR SET:C117("allRecords")
		CLEAR SET:C117("keepThese")
		util_DeleteSelection(->[Customers_Brand_Lines:39])
		
	End if 
	
End if   // END 4D Professional Services : January 2019 

If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
	
	ams_DeleteWithoutHeaderRecord(->[Customers_Addresses:31]CustID:1; ->[Customers:16]ID:1)
	
Else 
	
	If (<>fContinue)
		
		READ ONLY:C145([Customers:16])
		ALL RECORDS:C47([Customers:16])
		READ WRITE:C146([Customers_Addresses:31])
		If (Not:C34(<>modification4D_10_05_19))  // BEGIN 4D Professional Services : Query With array
			
			ARRAY TEXT:C222($_CustID; 0)
			DISTINCT VALUES:C339([Customers:16]ID:1; $_CustID)
			SET QUERY DESTINATION:C396(Into set:K19:2; "keepThese")
			QUERY WITH ARRAY:C644([Customers_Addresses:31]CustID:1; $_CustID)
			SET QUERY DESTINATION:C396(Into current selection:K19:1)
			
		Else 
			
			RELATE MANY SELECTION:C340([Customers_Addresses:31]CustID:1)
			CREATE SET:C116([Customers_Addresses:31]; "keepThese")
			
		End if   // END 4D Professional Services : January 2019 
		
		ALL RECORDS:C47([Customers_Addresses:31])
		CREATE SET:C116([Customers_Addresses:31]; "allRecords")
		DIFFERENCE:C122("allRecords"; "keepThese"; "keepThese")
		USE SET:C118("keepThese")
		CLEAR SET:C117("allRecords")
		CLEAR SET:C117("keepThese")
		util_DeleteSelection(->[Customers_Addresses:31])
		
	End if 
	
End if   // END 4D Professional Services : January 2019 

If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
	
	ams_DeleteWithoutHeaderRecord(->[Customers_Contacts:52]CustID:1; ->[Customers:16]ID:1)
	
Else 
	
	If (<>fContinue)
		
		READ ONLY:C145([Customers:16])
		ALL RECORDS:C47([Customers:16])
		READ WRITE:C146([Customers_Contacts:52])
		RELATE MANY SELECTION:C340([Customers_Contacts:52]CustID:1)
		CREATE SET:C116([Customers_Contacts:52]; "keepThese")
		ALL RECORDS:C47([Customers_Contacts:52])
		CREATE SET:C116([Customers_Contacts:52]; "allRecords")
		DIFFERENCE:C122("allRecords"; "keepThese"; "keepThese")
		USE SET:C118("keepThese")
		CLEAR SET:C117("allRecords")
		CLEAR SET:C117("keepThese")
		util_DeleteSelection(->[Customers_Contacts:52])
		
	End if 
	
End if   // END 4D Professional Services : January 2019 

If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
	
	ams_DeleteWithoutHeaderRecord(->[Customers_Projects:9]Customerid:3; ->[Customers:16]ID:1)
	
Else 
	
	If (<>fContinue)
		
		READ ONLY:C145([Customers:16])
		ALL RECORDS:C47([Customers:16])
		READ WRITE:C146([Customers_Projects:9])
		RELATE MANY SELECTION:C340([Customers_Projects:9]Customerid:3)
		CREATE SET:C116([Customers_Projects:9]; "keepThese")
		ALL RECORDS:C47([Customers_Projects:9])
		CREATE SET:C116([Customers_Projects:9]; "allRecords")
		DIFFERENCE:C122("allRecords"; "keepThese"; "keepThese")
		USE SET:C118("keepThese")
		CLEAR SET:C117("allRecords")
		CLEAR SET:C117("keepThese")
		util_DeleteSelection(->[Customers_Projects:9])
		
	End if 
	
End if   // END 4D Professional Services : January 2019 

//ams_DeleteWithoutHeaderRecord (->[_obsolete_Projects_Requests]Custid;->[Customers]ID)
If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
	
	ams_DeleteWithoutHeaderRecord(->[Process_Specs:18]Cust_ID:4; ->[Customers:16]ID:1)
	
Else 
	
	
	If (<>fContinue)
		
		READ ONLY:C145([Customers:16])
		ALL RECORDS:C47([Customers:16])
		READ WRITE:C146([Process_Specs:18])
		RELATE MANY SELECTION:C340([Process_Specs:18]Cust_ID:4)
		CREATE SET:C116([Process_Specs:18]; "keepThese")
		ALL RECORDS:C47([Process_Specs:18])
		CREATE SET:C116([Process_Specs:18]; "allRecords")
		DIFFERENCE:C122("allRecords"; "keepThese"; "keepThese")
		USE SET:C118("keepThese")
		CLEAR SET:C117("allRecords")
		CLEAR SET:C117("keepThese")
		util_DeleteSelection(->[Process_Specs:18])
		
	End if 
	
End if   // END 4D Professional Services : January 2019 

If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
	
	ams_DeleteWithoutHeaderRecord(->[Process_Specs_Machines:28]CustID:2; ->[Customers:16]ID:1)
	
Else 
	
	If (<>fContinue)
		
		READ ONLY:C145([Customers:16])
		ALL RECORDS:C47([Customers:16])
		READ WRITE:C146([Process_Specs_Machines:28])
		RELATE MANY SELECTION:C340([Process_Specs_Machines:28]CustID:2)
		CREATE SET:C116([Process_Specs_Machines:28]; "keepThese")
		ALL RECORDS:C47([Process_Specs_Machines:28])
		CREATE SET:C116([Process_Specs_Machines:28]; "allRecords")
		DIFFERENCE:C122("allRecords"; "keepThese"; "keepThese")
		USE SET:C118("keepThese")
		CLEAR SET:C117("allRecords")
		CLEAR SET:C117("keepThese")
		util_DeleteSelection(->[Process_Specs_Machines:28])
		
	End if 
	
End if   // END 4D Professional Services : January 2019 

If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
	
	ams_DeleteWithoutHeaderRecord(->[Process_Specs_Materials:56]CustID:2; ->[Customers:16]ID:1)
	
Else 
	
	If (<>fContinue)
		
		READ ONLY:C145([Customers:16])
		ALL RECORDS:C47([Customers:16])
		READ WRITE:C146([Process_Specs_Materials:56])
		RELATE MANY SELECTION:C340([Process_Specs_Materials:56]CustID:2)
		CREATE SET:C116([Process_Specs_Materials:56]; "keepThese")
		ALL RECORDS:C47([Process_Specs_Materials:56])
		CREATE SET:C116([Process_Specs_Materials:56]; "allRecords")
		DIFFERENCE:C122("allRecords"; "keepThese"; "keepThese")
		USE SET:C118("keepThese")
		CLEAR SET:C117("allRecords")
		CLEAR SET:C117("keepThese")
		util_DeleteSelection(->[Process_Specs_Materials:56])
		
	End if 
	
End if   // END 4D Professional Services : January 2019 

If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
	
	ams_DeleteWithoutHeaderRecord(->[Estimates:17]Cust_ID:2; ->[Customers:16]ID:1)
	
Else 
	
	
	If (<>fContinue)
		
		READ ONLY:C145([Customers:16])
		ALL RECORDS:C47([Customers:16])
		READ WRITE:C146([Estimates:17])
		RELATE MANY SELECTION:C340([Estimates:17]Cust_ID:2)
		CREATE SET:C116([Estimates:17]; "keepThese")
		ALL RECORDS:C47([Estimates:17])
		CREATE SET:C116([Estimates:17]; "allRecords")
		DIFFERENCE:C122("allRecords"; "keepThese"; "keepThese")
		USE SET:C118("keepThese")
		CLEAR SET:C117("allRecords")
		CLEAR SET:C117("keepThese")
		util_DeleteSelection(->[Estimates:17])
		
	End if 
	
End if   // END 4D Professional Services : January 2019 

If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
	
	ams_DeleteWithoutHeaderRecord(->[Estimates_Carton_Specs:19]CustID:6; ->[Customers:16]ID:1)
	
Else 
	
	If (<>fContinue)
		
		READ ONLY:C145([Customers:16])
		ALL RECORDS:C47([Customers:16])
		READ WRITE:C146([Estimates_Carton_Specs:19])
		ARRAY TEXT:C222($_CustID; 0)
		DISTINCT VALUES:C339([Customers:16]ID:1; $_CustID)
		SET QUERY DESTINATION:C396(Into set:K19:2; "keepThese")
		QUERY WITH ARRAY:C644([Estimates_Carton_Specs:19]CustID:6; $_CustID)
		SET QUERY DESTINATION:C396(Into current selection:K19:1)
		ALL RECORDS:C47([Estimates_Carton_Specs:19])
		CREATE SET:C116([Estimates_Carton_Specs:19]; "allRecords")
		DIFFERENCE:C122("allRecords"; "keepThese"; "keepThese")
		USE SET:C118("keepThese")
		CLEAR SET:C117("allRecords")
		CLEAR SET:C117("keepThese")
		util_DeleteSelection(->[Estimates_Carton_Specs:19])
		
	End if 
	
End if   // END 4D Professional Services : January 2019 

If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
	
	ams_DeleteWithoutHeaderRecord(->[Finished_Goods:26]CustID:2; ->[Customers:16]ID:1)
	
Else 
	
	
	If (<>fContinue)
		
		READ ONLY:C145([Customers:16])
		ALL RECORDS:C47([Customers:16])
		READ WRITE:C146([Finished_Goods:26])
		RELATE MANY SELECTION:C340([Finished_Goods:26]CustID:2)
		CREATE SET:C116([Finished_Goods:26]; "keepThese")
		ALL RECORDS:C47([Finished_Goods:26])
		CREATE SET:C116([Finished_Goods:26]; "allRecords")
		DIFFERENCE:C122("allRecords"; "keepThese"; "keepThese")
		USE SET:C118("keepThese")
		CLEAR SET:C117("allRecords")
		CLEAR SET:C117("keepThese")
		util_DeleteSelection(->[Finished_Goods:26])
		
	End if 
	
End if   // END 4D Professional Services : January 2019 

If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
	
	ams_DeleteWithoutHeaderRecord(->[Finished_Goods_Transactions:33]CustID:12; ->[Customers:16]ID:1)
	
Else 
	
	
	If (<>fContinue)
		
		READ ONLY:C145([Customers:16])
		ALL RECORDS:C47([Customers:16])
		READ WRITE:C146([Finished_Goods_Transactions:33])
		RELATE MANY SELECTION:C340([Finished_Goods_Transactions:33]CustID:12)
		CREATE SET:C116([Finished_Goods_Transactions:33]; "keepThese")
		ALL RECORDS:C47([Finished_Goods_Transactions:33])
		CREATE SET:C116([Finished_Goods_Transactions:33]; "allRecords")
		DIFFERENCE:C122("allRecords"; "keepThese"; "keepThese")
		USE SET:C118("keepThese")
		CLEAR SET:C117("allRecords")
		CLEAR SET:C117("keepThese")
		util_DeleteSelection(->[Finished_Goods_Transactions:33])
		
	End if 
	
End if   // END 4D Professional Services : January 2019 

If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
	
	ams_DeleteWithoutHeaderRecord(->[Finished_Goods_SizeAndStyles:132]CustID:52; ->[Customers:16]ID:1)  //
	
Else 
	
	
	If (<>fContinue)
		
		READ ONLY:C145([Customers:16])
		ALL RECORDS:C47([Customers:16])
		READ WRITE:C146([WMS_ItemMasters:123])
		If (Not:C34(<>modification4D_10_05_19))  // BEGIN 4D Professional Services : Query With array
			
			ARRAY TEXT:C222($_CustID; 0)
			DISTINCT VALUES:C339([Customers:16]ID:1; $_CustID)
			SET QUERY DESTINATION:C396(Into set:K19:2; "keepThese")
			QUERY WITH ARRAY:C644([Finished_Goods_SizeAndStyles:132]CustID:52; $_CustID)
			SET QUERY DESTINATION:C396(Into current selection:K19:1)
			
			
		Else 
			
			RELATE MANY SELECTION:C340([Finished_Goods_SizeAndStyles:132]CustID:52)
			CREATE SET:C116([Finished_Goods_SizeAndStyles:132]; "keepThese")
			
		End if   // END 4D Professional Services : January 2019 
		
		ALL RECORDS:C47([Finished_Goods_SizeAndStyles:132])
		CREATE SET:C116([Finished_Goods_SizeAndStyles:132]; "allRecords")
		DIFFERENCE:C122("allRecords"; "keepThese"; "keepThese")
		USE SET:C118("keepThese")
		CLEAR SET:C117("allRecords")
		CLEAR SET:C117("keepThese")
		util_DeleteSelection(->[Finished_Goods_SizeAndStyles:132])
		
	End if 
	
End if   // END 4D Professional Services : January 2019 

If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
	
	ams_DeleteWithoutHeaderRecord(->[Finished_Goods_PackingSpecs:91]FileOutlineNum:1; ->[Finished_Goods_SizeAndStyles:132]FileOutlineNum:1)  //
	
Else 
	
	
	If (<>fContinue)
		
		READ ONLY:C145([Finished_Goods_SizeAndStyles:132])
		ALL RECORDS:C47([Finished_Goods_SizeAndStyles:132])
		READ WRITE:C146([Finished_Goods_PackingSpecs:91])
		If (Not:C34(<>modification4D_10_05_19))  // BEGIN 4D Professional Services : Query With array
			
			ARRAY TEXT:C222($_FileOutlineNum; 0)
			DISTINCT VALUES:C339([Finished_Goods_SizeAndStyles:132]FileOutlineNum:1; $_FileOutlineNum)
			SET QUERY DESTINATION:C396(Into set:K19:2; "keepThese")
			QUERY WITH ARRAY:C644([Finished_Goods_PackingSpecs:91]FileOutlineNum:1; $_FileOutlineNum)
			SET QUERY DESTINATION:C396(Into current selection:K19:1)
			
			
		Else 
			
			RELATE MANY SELECTION:C340([Finished_Goods_PackingSpecs:91]FileOutlineNum:1)
			CREATE SET:C116([Finished_Goods_PackingSpecs:91]; "keepThese")
			
			
		End if   // END 4D Professional Services : January 2019 
		ALL RECORDS:C47([Finished_Goods_PackingSpecs:91])
		CREATE SET:C116([Finished_Goods_PackingSpecs:91]; "allRecords")
		DIFFERENCE:C122("allRecords"; "keepThese"; "keepThese")
		USE SET:C118("keepThese")
		CLEAR SET:C117("allRecords")
		CLEAR SET:C117("keepThese")
		util_DeleteSelection(->[Finished_Goods_PackingSpecs:91])
		
	End if 
	
End if   // END 4D Professional Services : January 2019 

If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
	
	ams_DeleteWithoutHeaderRecord(->[Finished_Goods_SnS_Additions:150]FileOutlineNum:1; ->[Finished_Goods_SizeAndStyles:132]FileOutlineNum:1)  //
	
Else 
	
	
	If (<>fContinue)
		
		READ ONLY:C145([Finished_Goods_SizeAndStyles:132])
		ALL RECORDS:C47([Finished_Goods_SizeAndStyles:132])
		READ WRITE:C146([Finished_Goods_SnS_Additions:150])
		RELATE MANY SELECTION:C340([Finished_Goods_SnS_Additions:150]FileOutlineNum:1)
		CREATE SET:C116([Finished_Goods_SnS_Additions:150]; "keepThese")
		ALL RECORDS:C47([Finished_Goods_SnS_Additions:150])
		CREATE SET:C116([Finished_Goods_SnS_Additions:150]; "allRecords")
		DIFFERENCE:C122("allRecords"; "keepThese"; "keepThese")
		USE SET:C118("keepThese")
		CLEAR SET:C117("allRecords")
		CLEAR SET:C117("keepThese")
		util_DeleteSelection(->[Finished_Goods_SnS_Additions:150])
		
	End if 
	
End if   // END 4D Professional Services : January 2019 

If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
	
	ams_DeleteWithoutHeaderRecord(->[Finished_Goods_Specifications:98]cust_id:77; ->[Customers:16]ID:1)
	
Else 
	
	
	If (<>fContinue)
		
		READ ONLY:C145([Customers:16])
		ALL RECORDS:C47([Customers:16])
		READ WRITE:C146([Finished_Goods_Specifications:98])
		If (Not:C34(<>modification4D_10_05_19))  // BEGIN 4D Professional Services : Query With array
			
			ARRAY TEXT:C222($_cust_id; 0)
			DISTINCT VALUES:C339([Customers:16]ID:1; $_cust_id)
			SET QUERY DESTINATION:C396(Into set:K19:2; "keepThese")
			QUERY WITH ARRAY:C644([Finished_Goods_Specifications:98]cust_id:77; $_cust_id)
			SET QUERY DESTINATION:C396(Into current selection:K19:1)
			
		Else 
			
			RELATE MANY SELECTION:C340([Finished_Goods_Specifications:98]cust_id:77)
			CREATE SET:C116([Finished_Goods_Specifications:98]; "keepThese")
			
		End if   // END 4D Professional Services : January 2019 
		ALL RECORDS:C47([Finished_Goods_Specifications:98])
		CREATE SET:C116([Finished_Goods_Specifications:98]; "allRecords")
		DIFFERENCE:C122("allRecords"; "keepThese"; "keepThese")
		USE SET:C118("keepThese")
		CLEAR SET:C117("allRecords")
		CLEAR SET:C117("keepThese")
		util_DeleteSelection(->[Finished_Goods_Specifications:98])
		
	End if 
	
End if   // END 4D Professional Services : January 2019 

If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
	
	ams_DeleteWithoutHeaderRecord(->[Finished_Goods_Specs_Inks:188]id_added_by_converter:7; ->[Finished_Goods_Specifications:98]Ink:24)  // Modified by: Mel Bohince (6/17/16) 
	
Else 
	
	If (<>fContinue)
		
		READ ONLY:C145([Finished_Goods_Specifications:98])
		ALL RECORDS:C47([Finished_Goods_Specifications:98])
		READ WRITE:C146([Finished_Goods_Specs_Inks:188])
		RELATE MANY SELECTION:C340([Finished_Goods_Specs_Inks:188]id_added_by_converter:7)
		CREATE SET:C116([Finished_Goods_Specs_Inks:188]; "keepThese")
		ALL RECORDS:C47([Finished_Goods_Specs_Inks:188])
		CREATE SET:C116([Finished_Goods_Specs_Inks:188]; "allRecords")
		DIFFERENCE:C122("allRecords"; "keepThese"; "keepThese")
		USE SET:C118("keepThese")
		CLEAR SET:C117("allRecords")
		CLEAR SET:C117("keepThese")
		util_DeleteSelection(->[Finished_Goods_Specs_Inks:188])
		
	End if 
	
End if   // END 4D Professional Services : January 2019 

If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
	
	ams_DeleteWithoutHeaderRecord(->[Finished_Goods_Inv_Summaries:64]CustID:12; ->[Customers:16]ID:1)
	
Else 
	
	If (<>fContinue)
		
		READ ONLY:C145([Customers:16])
		ALL RECORDS:C47([Customers:16])
		READ WRITE:C146([Finished_Goods_Inv_Summaries:64])
		ARRAY TEXT:C222($_CustID; 0)
		DISTINCT VALUES:C339([Customers:16]ID:1; $_CustID)
		SET QUERY DESTINATION:C396(Into set:K19:2; "keepThese")
		QUERY WITH ARRAY:C644([Finished_Goods_Inv_Summaries:64]CustID:12; $_CustID)
		SET QUERY DESTINATION:C396(Into current selection:K19:1)
		ALL RECORDS:C47([Finished_Goods_Inv_Summaries:64])
		CREATE SET:C116([Finished_Goods_Inv_Summaries:64]; "allRecords")
		DIFFERENCE:C122("allRecords"; "keepThese"; "keepThese")
		USE SET:C118("keepThese")
		CLEAR SET:C117("allRecords")
		CLEAR SET:C117("keepThese")
		util_DeleteSelection(->[Finished_Goods_Inv_Summaries:64])
		
	End if 
	
End if   // END 4D Professional Services : January 2019 

If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
	
	ams_DeleteWithoutHeaderRecord(->[Prep_Charges:103]ControlNumber:1; ->[Finished_Goods_Specifications:98]ControlNumber:2)  //08/24/07
	
Else 
	
	
	If (<>fContinue)
		
		READ ONLY:C145([Finished_Goods_Specifications:98])
		ALL RECORDS:C47([Finished_Goods_Specifications:98])
		READ WRITE:C146([Prep_Charges:103])
		RELATE MANY SELECTION:C340([Prep_Charges:103]ControlNumber:1)
		CREATE SET:C116([Prep_Charges:103]; "keepThese")
		ALL RECORDS:C47([Prep_Charges:103])
		CREATE SET:C116([Prep_Charges:103]; "allRecords")
		DIFFERENCE:C122("allRecords"; "keepThese"; "keepThese")
		USE SET:C118("keepThese")
		CLEAR SET:C117("allRecords")
		CLEAR SET:C117("keepThese")
		util_DeleteSelection(->[Prep_Charges:103])
		
	End if 
	
End if   // END 4D Professional Services : January 2019 

If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
	
	ams_DeleteWithoutHeaderRecord(->[Job_MakeVsBuy:97]id:1; ->[Customers:16]ID:1)
	
Else 
	
	If (<>fContinue)
		
		READ ONLY:C145([Customers:16])
		ALL RECORDS:C47([Customers:16])
		READ WRITE:C146([Job_MakeVsBuy:97])
		ARRAY TEXT:C222($_id; 0)
		DISTINCT VALUES:C339([Customers:16]ID:1; $_id)
		SET QUERY DESTINATION:C396(Into set:K19:2; "keepThese")
		QUERY WITH ARRAY:C644([Job_MakeVsBuy:97]id:1; $_id)
		SET QUERY DESTINATION:C396(Into current selection:K19:1)
		ALL RECORDS:C47([Job_MakeVsBuy:97])
		CREATE SET:C116([Job_MakeVsBuy:97]; "allRecords")
		DIFFERENCE:C122("allRecords"; "keepThese"; "keepThese")
		USE SET:C118("keepThese")
		CLEAR SET:C117("allRecords")
		CLEAR SET:C117("keepThese")
		util_DeleteSelection(->[Job_MakeVsBuy:97])
		
	End if 
	
End if   // END 4D Professional Services : January 2019 

If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
	
	ams_DeleteWithoutHeaderRecord(->[Customers_Orders:40]CustID:2; ->[Customers:16]ID:1)
	
	
Else 
	
	If (<>fContinue)
		
		READ ONLY:C145([Customers:16])
		ALL RECORDS:C47([Customers:16])
		READ WRITE:C146([Customers_Orders:40])
		RELATE MANY SELECTION:C340([Customers_Orders:40]CustID:2)
		CREATE SET:C116([Customers_Orders:40]; "keepThese")
		ALL RECORDS:C47([Customers_Orders:40])
		CREATE SET:C116([Customers_Orders:40]; "allRecords")
		DIFFERENCE:C122("allRecords"; "keepThese"; "keepThese")
		USE SET:C118("keepThese")
		CLEAR SET:C117("allRecords")
		CLEAR SET:C117("keepThese")
		util_DeleteSelection(->[Customers_Orders:40])
		
	End if 
	
End if   // END 4D Professional Services : January 2019 

If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
	
	ams_DeleteWithoutHeaderRecord(->[Customers_Order_Lines:41]CustID:4; ->[Customers:16]ID:1)
	
Else 
	
	
	If (<>fContinue)
		
		READ ONLY:C145([Customers:16])
		ALL RECORDS:C47([Customers:16])
		READ WRITE:C146([Customers_Order_Lines:41])
		RELATE MANY SELECTION:C340([Customers_Order_Lines:41]CustID:4)
		CREATE SET:C116([Customers_Order_Lines:41]; "keepThese")
		ALL RECORDS:C47([Customers_Order_Lines:41])
		CREATE SET:C116([Customers_Order_Lines:41]; "allRecords")
		DIFFERENCE:C122("allRecords"; "keepThese"; "keepThese")
		USE SET:C118("keepThese")
		CLEAR SET:C117("allRecords")
		CLEAR SET:C117("keepThese")
		util_DeleteSelection(->[Customers_Order_Lines:41])
		
	End if 
	
End if   // END 4D Professional Services : January 2019 

If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
	
	ams_DeleteWithoutHeaderRecord(->[Customers_ReleaseSchedules:46]CustID:12; ->[Customers:16]ID:1)
	
Else 
	
	If (<>fContinue)
		
		READ ONLY:C145([Customers:16])
		ALL RECORDS:C47([Customers:16])
		READ WRITE:C146([Customers_ReleaseSchedules:46])
		RELATE MANY SELECTION:C340([Customers_ReleaseSchedules:46]CustID:12)
		CREATE SET:C116([Customers_ReleaseSchedules:46]; "keepThese")
		ALL RECORDS:C47([Customers_ReleaseSchedules:46])
		CREATE SET:C116([Customers_ReleaseSchedules:46]; "allRecords")
		DIFFERENCE:C122("allRecords"; "keepThese"; "keepThese")
		USE SET:C118("keepThese")
		CLEAR SET:C117("allRecords")
		CLEAR SET:C117("keepThese")
		util_DeleteSelection(->[Customers_ReleaseSchedules:46])
		
	End if 
	
End if   // END 4D Professional Services : January 2019 

If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
	
	ams_DeleteWithoutHeaderRecord(->[Customers_Bills_of_Lading:49]CustID:2; ->[Customers:16]ID:1)
	
Else 
	
	If (<>fContinue)
		
		READ ONLY:C145([Customers:16])
		ALL RECORDS:C47([Customers:16])
		READ WRITE:C146([Customers_Bills_of_Lading:49])
		If (Not:C34(<>modification4D_10_05_19))  // BEGIN 4D Professional Services : Query With array
			
			ARRAY TEXT:C222($_CustID; 0)
			DISTINCT VALUES:C339([Customers:16]ID:1; $_CustID)
			SET QUERY DESTINATION:C396(Into set:K19:2; "keepThese")
			QUERY WITH ARRAY:C644([Customers_Bills_of_Lading:49]CustID:2; $_CustID)
			SET QUERY DESTINATION:C396(Into current selection:K19:1)
			
		Else 
			
			RELATE MANY SELECTION:C340([Customers_Bills_of_Lading:49]CustID:2)
			CREATE SET:C116([Customers_Bills_of_Lading:49]; "keepThese")
			
		End if   // END 4D Professional Services : January 2019 
		ALL RECORDS:C47([Customers_Bills_of_Lading:49])
		CREATE SET:C116([Customers_Bills_of_Lading:49]; "allRecords")
		DIFFERENCE:C122("allRecords"; "keepThese"; "keepThese")
		USE SET:C118("keepThese")
		CLEAR SET:C117("allRecords")
		CLEAR SET:C117("keepThese")
		util_DeleteSelection(->[Customers_Bills_of_Lading:49])
		
	End if 
	
End if   // END 4D Professional Services : January 2019 

If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
	
	ams_DeleteWithoutHeaderRecord(->[Customers_Invoices:88]CustomerID:6; ->[Customers:16]ID:1)
	
Else 
	
	If (<>fContinue)
		
		READ ONLY:C145([Customers:16])
		ALL RECORDS:C47([Customers:16])
		READ WRITE:C146([Customers_Invoices:88])
		RELATE MANY SELECTION:C340([Customers_Invoices:88]CustomerID:6)
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
	
	ams_DeleteWithoutHeaderRecord(->[Customers_Order_Change_Orders:34]CustID:2; ->[Customers:16]ID:1)
	
Else 
	
	
	If (<>fContinue)
		
		READ ONLY:C145([Customers:16])
		ALL RECORDS:C47([Customers:16])
		READ WRITE:C146([Customers_Order_Change_Orders:34])
		RELATE MANY SELECTION:C340([Customers_Order_Change_Orders:34]CustID:2)
		CREATE SET:C116([Customers_Order_Change_Orders:34]; "keepThese")
		ALL RECORDS:C47([Customers_Order_Change_Orders:34])
		CREATE SET:C116([Customers_Order_Change_Orders:34]; "allRecords")
		DIFFERENCE:C122("allRecords"; "keepThese"; "keepThese")
		USE SET:C118("keepThese")
		CLEAR SET:C117("allRecords")
		CLEAR SET:C117("keepThese")
		util_DeleteSelection(->[Customers_Order_Change_Orders:34])
		
	End if 
	
End if   // END 4D Professional Services : January 2019 

//ams_DeleteWithoutHeaderRecord (->[CustomerBookings]Custid;->[CUSTOMER]ID)
If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
	
	ams_DeleteWithoutHeaderRecord(->[QA_Corrective_Actions:105]Custid:5; ->[Customers:16]ID:1)
	
Else 
	
	
	If (<>fContinue)
		
		READ ONLY:C145([Customers:16])
		ALL RECORDS:C47([Customers:16])
		READ WRITE:C146([QA_Corrective_Actions:105])
		If (Not:C34(<>modification4D_10_05_19))  // BEGIN 4D Professional Services : Query With array
			
			ARRAY TEXT:C222($_Custid; 0)
			DISTINCT VALUES:C339([Customers:16]ID:1; $_Custid)
			SET QUERY DESTINATION:C396(Into set:K19:2; "keepThese")
			QUERY WITH ARRAY:C644([QA_Corrective_Actions:105]Custid:5; $_Custid)
			SET QUERY DESTINATION:C396(Into current selection:K19:1)
			
			
		Else 
			
			RELATE MANY SELECTION:C340([QA_Corrective_Actions:105]Custid:5)
			CREATE SET:C116([QA_Corrective_Actions:105]; "keepThese")
			
			
		End if   // END 4D Professional Services : January 2019 
		
		ALL RECORDS:C47([QA_Corrective_Actions:105])
		CREATE SET:C116([QA_Corrective_Actions:105]; "allRecords")
		DIFFERENCE:C122("allRecords"; "keepThese"; "keepThese")
		USE SET:C118("keepThese")
		CLEAR SET:C117("allRecords")
		CLEAR SET:C117("keepThese")
		util_DeleteSelection(->[QA_Corrective_Actions:105])
		
	End if 
	
End if   // END 4D Professional Services : January 2019 

If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
	
	ams_DeleteWithoutHeaderRecord(->[Jobs:15]CustID:2; ->[Customers:16]ID:1)
	
Else 
	
	
	If (<>fContinue)
		
		READ ONLY:C145([Customers:16])
		ALL RECORDS:C47([Customers:16])
		READ WRITE:C146([Jobs:15])
		RELATE MANY SELECTION:C340([Jobs:15]CustID:2)
		CREATE SET:C116([Jobs:15]; "keepThese")
		ALL RECORDS:C47([Jobs:15])
		CREATE SET:C116([Jobs:15]; "allRecords")
		DIFFERENCE:C122("allRecords"; "keepThese"; "keepThese")
		USE SET:C118("keepThese")
		CLEAR SET:C117("allRecords")
		CLEAR SET:C117("keepThese")
		util_DeleteSelection(->[Jobs:15])
		
	End if 
	
End if   // END 4D Professional Services : January 2019 

If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
	
	ams_DeleteWithoutHeaderRecord(->[Job_Forms_Items:44]CustId:15; ->[Customers:16]ID:1)
	
Else 
	
	If (<>fContinue)
		
		READ ONLY:C145([Customers:16])
		ALL RECORDS:C47([Customers:16])
		READ WRITE:C146([Job_Forms_Items:44])
		RELATE MANY SELECTION:C340([Job_Forms_Items:44]CustId:15)
		CREATE SET:C116([Job_Forms_Items:44]; "keepThese")
		ALL RECORDS:C47([Job_Forms_Items:44])
		CREATE SET:C116([Job_Forms_Items:44]; "allRecords")
		DIFFERENCE:C122("allRecords"; "keepThese"; "keepThese")
		USE SET:C118("keepThese")
		CLEAR SET:C117("allRecords")
		CLEAR SET:C117("keepThese")
		util_DeleteSelection(->[Job_Forms_Items:44])
		
	End if 
	
End if   // END 4D Professional Services : January 2019 

If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
	
	ams_DeleteWithoutHeaderRecord(->[Raw_Materials_Allocations:58]CustID:2; ->[Customers:16]ID:1)
	
Else 
	
	If (<>fContinue)
		
		READ ONLY:C145([Customers:16])
		ALL RECORDS:C47([Customers:16])
		READ WRITE:C146([Raw_Materials_Allocations:58])
		ARRAY TEXT:C222($_CustID; 0)
		DISTINCT VALUES:C339([Customers:16]ID:1; $_CustID)
		SET QUERY DESTINATION:C396(Into set:K19:2; "keepThese")
		QUERY WITH ARRAY:C644([Raw_Materials_Allocations:58]CustID:2; $_CustID)
		SET QUERY DESTINATION:C396(Into current selection:K19:1)
		ALL RECORDS:C47([Raw_Materials_Allocations:58])
		CREATE SET:C116([Raw_Materials_Allocations:58]; "allRecords")
		DIFFERENCE:C122("allRecords"; "keepThese"; "keepThese")
		USE SET:C118("keepThese")
		CLEAR SET:C117("allRecords")
		CLEAR SET:C117("keepThese")
		
		
		util_DeleteSelection(->[Raw_Materials_Allocations:58])
		
	End if 
	
End if   // END 4D Professional Services : January 2019 

If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
	
	ams_DeleteWithoutHeaderRecord(->[WMS_Label_Tracking:75]CustId:2; ->[Customers:16]ID:1)
	
	
Else 
	
	If (<>fContinue)
		
		READ ONLY:C145([Customers:16])
		ALL RECORDS:C47([Customers:16])
		READ WRITE:C146([WMS_Label_Tracking:75])
		ARRAY TEXT:C222($_CustId; 0)
		DISTINCT VALUES:C339([Customers:16]ID:1; $_CustId)
		SET QUERY DESTINATION:C396(Into set:K19:2; "keepThese")
		QUERY WITH ARRAY:C644([WMS_Label_Tracking:75]CustId:2; $_CustId)
		SET QUERY DESTINATION:C396(Into current selection:K19:1)
		ALL RECORDS:C47([WMS_Label_Tracking:75])
		CREATE SET:C116([WMS_Label_Tracking:75]; "allRecords")
		DIFFERENCE:C122("allRecords"; "keepThese"; "keepThese")
		USE SET:C118("keepThese")
		CLEAR SET:C117("allRecords")
		CLEAR SET:C117("keepThese")
		util_DeleteSelection(->[WMS_Label_Tracking:75])
		
	End if 
	
End if   // END 4D Professional Services : January 2019 
//ams_DeleteWithoutHeaderRecord (->[JobCloseSum]Customer;->[CUSTOMER]ID)
If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
	
	ams_DeleteWithoutHeaderRecord(->[JPSI_Job_Physical_Support_Items:111]Custid:7; ->[Customers:16]ID:1)
	
Else 
	
	If (<>fContinue)
		
		READ ONLY:C145([Customers:16])
		ALL RECORDS:C47([Customers:16])
		READ WRITE:C146([JPSI_Job_Physical_Support_Items:111])
		ARRAY TEXT:C222($_Custid; 0)
		DISTINCT VALUES:C339([Customers:16]ID:1; $_Custid)
		SET QUERY DESTINATION:C396(Into set:K19:2; "keepThese")
		QUERY WITH ARRAY:C644([JPSI_Job_Physical_Support_Items:111]Custid:7; $_Custid)
		SET QUERY DESTINATION:C396(Into current selection:K19:1)
		ALL RECORDS:C47([JPSI_Job_Physical_Support_Items:111])
		CREATE SET:C116([JPSI_Job_Physical_Support_Items:111]; "allRecords")
		DIFFERENCE:C122("allRecords"; "keepThese"; "keepThese")
		USE SET:C118("keepThese")
		CLEAR SET:C117("allRecords")
		CLEAR SET:C117("keepThese")
		util_DeleteSelection(->[JPSI_Job_Physical_Support_Items:111])
		
	End if 
	
End if   // END 4D Professional Services : January 2019 

utl_Logfile("purge.log"; "Old and unused")
ams_DeleteUnusedProjects
//******************
//*******Age Based *
//******************'
utl_Logfile("purge.log"; "Estimates before "+String:C10(<>cutOffDate3; Internal date short:K1:7))
ams_DeleteOldEstimates(<>cutOffDate3)

utl_Logfile("purge.log"; "Jobs before "+String:C10(<>cutOffDate3; Internal date short:K1:7))
ams_DeleteOldJobs(<>cutOffDate3)

utl_Logfile("purge.log"; "Orders before "+String:C10(<>cutOffDate3; Internal date short:K1:7))
ams_DeleteOldOrders(<>cutOffDate3)

utl_Logfile("purge.log"; "Releases before "+String:C10(<>cutOffDate3; Internal date short:K1:7))
ams_DeleteOldReleases(<>cutOffDate3)

utl_Logfile("purge.log"; "Invoices before "+String:C10(<>cutOffDate3; Internal date short:K1:7))
ams_DeleteOldInvoices(<>cutOffDate3)

utl_Logfile("purge.log"; "BOLs before "+String:C10(<>cutOffDate3; Internal date short:K1:7))
ams_DeleteOldBOL(<>cutOffDate3)

utl_Logfile("purge.log"; "SSCCs older that 5 years")
ams_DeleteOldSSCC(5)

utl_Logfile("purge.log"; "FG before "+String:C10(<>cutOffDate3; Internal date short:K1:7))
ams_DeleteOldFinishedGoods(<>cutOffDate3)

utl_Logfile("purge.log"; "PSPEC before "+String:C10(<>cutOffDate3; Internal date short:K1:7))
ams_DeleteOldProcessSpecs(<>cutOffDate3)

utl_Logfile("purge.log"; "JML over 3 months old")
ams_DeleteCompleteJML

utl_Logfile("purge.log"; "RMX before "+String:C10(<>cutOffDate3; Internal date short:K1:7))
ams_DeleteOldRMXfers(<>cutOffDate3)

utl_Logfile("purge.log"; "Delfors older than a year")
ams_DeleteOldDELFORS(<>cutOffDate2)  //keep 2 years

ams_DeleteOldToDoTasks  //uses a year from current date
ams_DeleteUserPref(30)

//******************
//*******Vendor Based *
//******************
utl_Logfile("purge.log"; "Vendors before "+String:C10(<>cutOffDate3; Internal date short:K1:7))
ams_RecentVendors(<>cutOffDate3)  //mark recent vendors to keep
READ WRITE:C146([Vendors:7])
QUERY:C277([Vendors:7]; [Vendors:7]Active:15=False:C215)
util_DeleteSelection(->[Vendors:7])  //cut off the head and the body will die
ams_DeleteSuggestedVendors
If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
	
	ams_DeleteWithoutHeaderRecord(->[Purchase_Orders:11]VendorID:2; ->[Vendors:7]ID:1)
	
Else 
	
	
	If (<>fContinue)
		
		READ ONLY:C145([Vendors:7])
		ALL RECORDS:C47([Vendors:7])
		READ WRITE:C146([Purchase_Orders:11])
		RELATE MANY SELECTION:C340([Purchase_Orders:11]VendorID:2)
		CREATE SET:C116([Purchase_Orders:11]; "keepThese")
		ALL RECORDS:C47([Purchase_Orders:11])
		CREATE SET:C116([Purchase_Orders:11]; "allRecords")
		DIFFERENCE:C122("allRecords"; "keepThese"; "keepThese")
		USE SET:C118("keepThese")
		CLEAR SET:C117("allRecords")
		CLEAR SET:C117("keepThese")
		
		
		util_DeleteSelection(->[WMS_ItemMasters:123])
		
	End if 
	
End if   // END 4D Professional Services : January 2019 

If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : Set final step
	
	ams_DeleteWithoutHeaderRecord(->[Purchase_Orders_Chg_Orders:13]PONo:3; ->[Purchase_Orders:11]PONo:1)
	
Else 
	
	
	If (<>fContinue)
		
		READ ONLY:C145([Purchase_Orders:11])
		ALL RECORDS:C47([Purchase_Orders:11])
		READ WRITE:C146([Purchase_Orders_Chg_Orders:13])
		If (Not:C34(<>modification4D_10_05_19))  // BEGIN 4D Professional Services : Query With array
			
			ARRAY TEXT:C222($_PONo; 0)
			DISTINCT VALUES:C339([Purchase_Orders:11]PONo:1; $_PONo)
			SET QUERY DESTINATION:C396(Into set:K19:2; "keepThese")
			QUERY WITH ARRAY:C644([Purchase_Orders_Chg_Orders:13]PONo:3; $_PONo)
			SET QUERY DESTINATION:C396(Into current selection:K19:1)
			
			
		Else 
			
			RELATE MANY SELECTION:C340([Purchase_Orders_Chg_Orders:13]PONo:3)
			CREATE SET:C116([Purchase_Orders_Chg_Orders:13]; "keepThese")
			
			
		End if   // END 4D Professional Services : January 2019 
		
		ALL RECORDS:C47([Purchase_Orders_Chg_Orders:13])
		CREATE SET:C116([Purchase_Orders_Chg_Orders:13]; "allRecords")
		DIFFERENCE:C122("allRecords"; "keepThese"; "keepThese")
		USE SET:C118("keepThese")
		CLEAR SET:C117("allRecords")
		CLEAR SET:C117("keepThese")
		
		
		util_DeleteSelection(->[WMS_ItemMasters:123])
		
	End if 
	
End if   // END 4D Professional Services : January 2019 

$inventory_RecentSet:=ams_RecentRMInventory("all")
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
	ams_DeleteWithoutHeaderRecord(->[Purchase_Orders_Items:12]PONo:2; ->[Purchase_Orders:11]PONo:1; "Keepers")
	CLEAR SET:C117("Keepers")
	
Else 
	
	CREATE SET:C116([Purchase_Orders_Items:12]; "Keepers")
	If (<>fContinue)
		
		READ ONLY:C145([Purchase_Orders:11])
		ALL RECORDS:C47([Purchase_Orders:11])
		READ WRITE:C146([Purchase_Orders_Items:12])
		RELATE MANY SELECTION:C340([Purchase_Orders_Items:12]PONo:2)
		CREATE SET:C116([Purchase_Orders_Items:12]; "keepThese")
		ALL RECORDS:C47([Purchase_Orders_Items:12])
		CREATE SET:C116([Purchase_Orders_Items:12]; "allRecords")
		DIFFERENCE:C122("allRecords"; "keepThese"; "keepThese")
		DIFFERENCE:C122("keepThese"; "Keepers"; "keepThese")
		USE SET:C118("keepThese")
		CLEAR SET:C117("allRecords")
		CLEAR SET:C117("keepThese")
		util_DeleteSelection(->[Purchase_Orders_Items:12])
		
	End if 
	
	CLEAR SET:C117("Keepers")
	
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

utl_Logfile("purge.log"; "POs before "+String:C10(<>cutOffDate3; Internal date short:K1:7))
ams_DeleteOldPurchaseOrders(<>cutOffDate3)
ams_DeleteOldRawMaterials
ams_DeleteOldRMgroups
ams_DeleteOldEDI(<>cutOffDate3)  // Modified by: Mel Bohince (6/14/16) 

utl_Logfile("purge.log"; "FINI.")



//doPurgeChk4Hole   //save on server BTW

