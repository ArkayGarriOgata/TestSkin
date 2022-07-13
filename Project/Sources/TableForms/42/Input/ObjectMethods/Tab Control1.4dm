// ----------------------------------------------------
// User name (OS): work
// Date and time: 05/07/06, 17:08:32
// ----------------------------------------------------
// Method: Customer iTabControl
// ----------------------------------------------------
C_LONGINT:C283($itemRef)
C_TEXT:C284($targetPage)
GET LIST ITEM:C378(iTabControl; *; $itemRef; $targetPage)
Case of 
	: ($targetPage="Budget")
		//ORDER BY([Job_Forms_Items];[Job_Forms_Items]ItemNumber;>)// done in form event on-load in load related method
		
	: ($targetPage="Machines & Material")
		APPEND TO ARRAY:C911(aTabVisited; "Machines & Material")
		
		ORDER BY:C49([Job_Forms_Machines:43]; [Job_Forms_Machines:43]Sequence:5; >)
		COPY NAMED SELECTION:C331([Job_Forms_Machines:43]; "machines")
		ORDER BY:C49([Job_Forms_Materials:55]; [Job_Forms_Materials:55]Sequence:3; >)
		COPY NAMED SELECTION:C331([Job_Forms_Materials:55]; "Related")
		
		
		MakeArrayJFMaterials("Get")  // Added by: Mark Zinke (10/2/13) 
		
	: ($targetPage="Actuals Entered")
		APPEND TO ARRAY:C911(aTabVisited; "Actuals Entered")
		
		ORDER BY:C49([Job_Forms_Machine_Tickets:61]; [Job_Forms_Machine_Tickets:61]Sequence:3; >; [Job_Forms_Machine_Tickets:61]CostCenterID:2; >; [Job_Forms_Machine_Tickets:61]DateEntered:5; >)
		COPY NAMED SELECTION:C331([Job_Forms_Machine_Tickets:61]; "machTicks")
		// ******* Verified  - 4D PS - January  2019 ********
		
		QUERY SELECTION:C341([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]Xfer_Type:2="Issue")
		
		
		// ******* Verified  - 4D PS - January 2019 (end) *********
		ORDER BY:C49([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]Commodity_Key:22; >; [Raw_Materials_Transactions:23]XferDate:3; >)
		COPY NAMED SELECTION:C331([Raw_Materials_Transactions:23]; "rmXfers")
End case 

