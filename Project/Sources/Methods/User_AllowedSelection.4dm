//%attributes = {}
// _______
// Method: User_AllowedSelection   (->table ) ->
// By: Mel Bohince @ 04/22/11, 13:30:00
// Description
// limit selection of records to customers that the user has access
// use the tablePtr to determine which field is the foreignKey to the 
// customer table return the selection that intersects allowed
//  and the original selection
// see also User_AllowedCustomer, User_AllowedRecords, User_AllowedSelection
// ----------------------------------------------------
// Modified by: Mel Bohince (6/3/21) use Storage

C_POINTER:C301($1; $tablePtr; $customer_id_field_ptr)  //table with selection

$tablePtr:=$1  //determint the foreign key based on this table
Case of 
	: ((User in group:C338(Current user:C182; "SalesManager")) | (User in group:C338(Current user:C182; "ProjectsManager")))  // & (False)
		$restrict:=False:C215
		
	: ($tablePtr=(->[Customers:16]))
		$customer_id_field_ptr:=->[Customers:16]ID:1
		$restrict:=True:C214
		
	: ($tablePtr=(->[Finished_Goods:26]))
		$customer_id_field_ptr:=->[Finished_Goods:26]CustID:2
		$restrict:=True:C214
		
	: ($tablePtr=(->[Jobs:15]))
		$customer_id_field_ptr:=->[Jobs:15]CustID:2
		$restrict:=True:C214
		
	: ($tablePtr=(->[Job_Forms:42]))
		$customer_id_field_ptr:=->[Job_Forms:42]cust_id:82
		$restrict:=True:C214
		
	: ($tablePtr=(->[Job_Forms_Items:44]))
		$customer_id_field_ptr:=->[Job_Forms_Items:44]CustId:15
		$restrict:=True:C214
		
	: ($tablePtr=(->[Customers_Order_Lines:41]))
		$customer_id_field_ptr:=->[Customers_Order_Lines:41]CustID:4
		$restrict:=True:C214
		
	: ($tablePtr=(->[Customers_Orders:40]))
		$customer_id_field_ptr:=->[Customers_Orders:40]CustID:2
		$restrict:=True:C214
		
	: ($tablePtr=(->[Customers_Invoices:88]))
		$customer_id_field_ptr:=->[Customers_Invoices:88]CustomerID:6
		$restrict:=True:C214
		
	: ($tablePtr=(->[Finished_Goods_SizeAndStyles:132]))
		$customer_id_field_ptr:=->[Finished_Goods_SizeAndStyles:132]CustID:52
		$restrict:=True:C214
		
	: ($tablePtr=(->[Finished_Goods:26]))
		$customer_id_field_ptr:=->[Finished_Goods:26]CustID:2
		$restrict:=True:C214
		
	: ($tablePtr=(->[Finished_Goods_Specifications:98]))
		$customer_id_field_ptr:=->[Finished_Goods_Specifications:98]cust_id:77
		$restrict:=True:C214
		
	: ($tablePtr=(->[Process_Specs:18]))
		$customer_id_field_ptr:=->[Process_Specs:18]Cust_ID:4
		$restrict:=True:C214
		
	: ($tablePtr=(->[Estimates:17]))
		$customer_id_field_ptr:=->[Estimates:17]Cust_ID:2
		$restrict:=True:C214
		
	: ($tablePtr=(->[Estimates_Carton_Specs:19]))
		$customer_id_field_ptr:=->[Estimates_Carton_Specs:19]CustID:6
		$restrict:=True:C214
		
	Else 
		$restrict:=False:C215  //no restriction
End case 

If ($restrict)
	CREATE SET:C116($tablePtr->; "original_selection")
	If (True:C214)  // Modified by: Mel Bohince (6/3/21) use Storage
		//get the array of custId allowed
		C_OBJECT:C1216($return_o)
		$return_o:=User_AllowedAccess("assigned_records"; ->[Customers:16]ID:1)
		ARRAY TEXT:C222($allowed_custids; 0)
		OB GET ARRAY:C1229($return_o; "allowedRecordIDs"; $allowed_custids)
		
	Else   //old way
		//READ ONLY([Users_Record_Accesses])
		//QUERY([Users_Record_Accesses];[Users_Record_Accesses]UserInitials=User_GetInitials ;*)
		//QUERY([Users_Record_Accesses]; & ;[Users_Record_Accesses]TableName="Customers")
		//SELECTION TO ARRAY([Users_Record_Accesses]PrimaryKey;$allowed_custids)
		//REDUCE SELECTION([Users_Record_Accesses];0)
	End if 
	
	// get the allowed
	QUERY WITH ARRAY:C644($customer_id_field_ptr->; $allowed_custids)
	CREATE SET:C116($tablePtr->; "allowed_selection")
	
	//compare, remove the not-allowed
	INTERSECTION:C121("original_selection"; "allowed_selection"; "allowed_selection")
	USE SET:C118("allowed_selection")
	CLEAR SET:C117("original_selection")
	CLEAR SET:C117("allowed_selection")
End if 