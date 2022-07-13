//%attributes = {"publishedWeb":true}
//PM:  User_AllowedRecords(tablename{;user initials})-> num recs  3/27/00  mlb
//get a selection of records to which a user has been given access
// see also User_AllowedCustomer, User_AllowedRecords, User_AllowedSelection
//
// Modified by: Mel Bohince (4/16/21) allow designer to imperonate a user and
// lock in <>modification4D_14_01_19
// Modified by: Mel Bohince (6/3/21) use Storage

C_TEXT:C284($1; $2)
C_LONGINT:C283($0)
$tableName:=$1

If (True:C214)  // Modified by: Mel Bohince (6/3/21) use Storage
	C_OBJECT:C1216($return_o)
	C_POINTER:C301($fieldPtr)
	Case of 
		: ($tableName=(Table name:C256(->[Customers:16])))
			$fieldPtr:=->[Customers:16]ID:1
			
		: ($tableName=(Table name:C256(->[Customers_Projects:9])))
			$fieldPtr:=->[Customers_Projects:9]id:1
			
		Else 
			uConfirm($tableName+" not set up in User_AllowedRecords( )"; "Dang"; "Ok")
			$fieldPtr:=->[Customers:16]ID:1
	End case 
	
	$return_o:=User_AllowedAccess("assigned_records"; $fieldPtr)
	ARRAY TEXT:C222($_PrimaryKey; 0)
	OB GET ARRAY:C1229($return_o; "allowedRecordIDs"; $_PrimaryKey)
	QUERY WITH ARRAY:C644($fieldPtr->; $_PrimaryKey)
	
Else   //old way
	//If (Count parameters=2)
	//$user:=$2
	//Else 
	//$user:=<>zResp
	//End if 
	
	//If (Current user="Designer")  // Modified by: Mel Bohince (4/16/21) 
	//$user:=Request("Impersonate who?";$user;"Continue";"Ok")
	//End if 
	
	//QUERY([Users_Record_Accesses];[Users_Record_Accesses]UserInitials=$user;*)
	//QUERY([Users_Record_Accesses]; & ;[Users_Record_Accesses]TableName=$tableName)
	
	//ARRAY TEXT($_PrimaryKey;0)
	
	//Case of 
	//: ($tableName=(Table name(->[Customers])))
	//zwStatusMsg ("Relating";" Searching "+Table name(->[Customers])+" file. Please Wait...")
	//DISTINCT VALUES([Users_Record_Accesses]PrimaryKey;$_PrimaryKey)
	//QUERY WITH ARRAY([Customers]ID;$_PrimaryKey)
	//zwStatusMsg ("";"")
	//$0:=Records in selection([Customers])
	
	//: ($tableName=(Table name(->[Customers_Projects])))
	//zwStatusMsg ("Relating";" Searching "+Table name(->[Customers_Projects])+" file. Please Wait...")
	//DISTINCT VALUES([Users_Record_Accesses]PrimaryKey;$_PrimaryKey)
	//QUERY WITH ARRAY([Customers_Projects]id;$_PrimaryKey)
	//zwStatusMsg ("";"")
	//$0:=Records in selection([Customers_Projects])
	//End case 
End if 
