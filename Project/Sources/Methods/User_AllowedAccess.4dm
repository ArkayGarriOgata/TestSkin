//%attributes = {}
// Method: User_AllowedAccess   ( option ; fieldPtr ) -> {success:true|false, allowedIds:array}
// By: Mel Bohince @ 05/20/21, 15:47:46
// Description
// use Storage to cache permissable customers and projects,
// 3 options, fieldPtr is used as a switch:
//   init, set up the cache for the user, uses lazy call, returns an object with success and the number of allowed customers|projects based on fieldPtr
//   assigned_records, return an object with a success bool and an array of allowed customer or project ids
//   else, tests if paramerter 1 is a cust ID  or project id in the cache, returns object with success and index in the length attribute
// ----------------------------------------------------
// see also User_AllowedCustomer, User_AllowedRecords, User_AllowedSelection

C_TEXT:C284($option; $1; $tableName; $fieldName)
C_POINTER:C301($2; $fieldPtr)
C_OBJECT:C1216($0; $return_o)

$return_o:=New object:C1471
$return_o.success:=False:C215  // always the pessimist
$return_o.length:=0
//$return_o.allowedEntities:=Null  //server can't pass back a es in v17

If (Count parameters:C259>0)
	$option:=$1
	$fieldPtr:=$2
	$fieldName:=Field name:C257($fieldPtr)
	$tableName:=Table name:C256(Table:C252($fieldPtr))
	
Else   //testing
	//$option:="init"  //"02101"//"assigned_customers"  //"init"//"00121"
	//$fieldPtr:=->[Customers]ID
	//$fieldName:=Field name($fieldPtr)
	//$tableName:=Table name(Table($fieldPtr))
	//some useage:
	$return_o:=User_AllowedAccess("assigned_records"; ->[Customers:16]ID:1)  //will call User_AllowedAccess ("init";->[Customers]ID)
	$return_o:=User_AllowedAccess("00121"; ->[Customers:16]ID:1)
	
	$return_o:=User_AllowedAccess("assigned_records"; ->[Customers_Projects:9]id:1)  //will call User_AllowedAccess ("init";->[Customers_Projects]id)
	$return_o:=User_AllowedAccess("01931"; ->[Customers_Projects:9]id:1)
End if   //params

//utl_Logfile ("debug.log";"User_AllowedAccess('"+$option+"';'"+$tableName+"')")

Case of 
	: ($option="init")  // set up the list of allowed customers' id in Storage, once per session
		
		$user:=User_GetInitials
		If (Current user:C182="Designer")
			$user:=Request:C163("Impersonate who?"; $user; "Continue"; "Ok")
		End if 
		
		C_OBJECT:C1216($userRecordAccesses_es)  //get the customers that the current user has access to
		$userRecordAccesses_es:=ds:C1482.Users_Record_Accesses.query("UserInitials = :1 and TableName = :2"; $user; $tableName)
		If ($userRecordAccesses_es.length>0)  //user has allowed customers or projects set, so grab those ID's and put in a Storage collection
			
			ARRAY TEXT:C222($aAllowedIds_t; 0)  //going to now strip out the "PrimaryKey" attribute so we don't get an array of objects
			COLLECTION TO ARRAY:C1562($userRecordAccesses_es.toCollection("PrimaryKey"); $aAllowedIds_t; "PrimaryKey")
			
			Use (Storage:C1525)
				//init the structure
				If (Storage:C1525.UserAllowed_o=Null:C1517)  //first time in this session
					Storage:C1525.UserAllowed_o:=New shared object:C1526
				End if 
				
				Use (Storage:C1525.UserAllowed_o)
					
					If (Storage:C1525.UserAllowed_o[$tableName]=Null:C1517)  //has this table not been requested before?
						Storage:C1525.UserAllowed_o[$tableName]:=New shared collection:C1527
					End if 
					
				End use 
				//structure ready
				
				Use (Storage:C1525.UserAllowed_o[$tableName])  //name a collection of primary keys on this table that this user can access
					
					Storage:C1525.UserAllowed_o[$tableName].clear()  //reset
					
					C_COLLECTION:C1488($allowedKeys_c)  //          use to be: 
					$allowedKeys_c:=New shared collection:C1527  //            For ($i;0;Size of array($aAllowedIds_t)-1)
					ARRAY TO COLLECTION:C1563($allowedKeys_c; $aAllowedIds_t)  // Storage.UserAllowed_o[$collectionName][$i]:=$aAllowedIds_t{$i+1} 
					Storage:C1525.UserAllowed_o[$tableName]:=$allowedKeys_c  //End for 
					
				End use 
				
			End use   //storage
			
			//optional if not running on the server
			//c_text($queryString)
			//$queryString:=$fieldName+" in :1"
			//C_OBJECT($allowedEntities_es)
			//$allowedEntities_es:=ds[$tableName].query($queryString;$allowedKeys_c)
			//$return_o.allowedEntities:=$allowedEntities_es
			
			$return_o.length:=Storage:C1525.UserAllowed_o[$tableName].length
			$return_o.success:=$return_o.length>0
			
		End if   //assigned Users_Record_Accesses
		
		//utl_Logfile ("debug.log";"    init "+$fieldName+" "+JSON Stringify($return_o))
		
		
	: ($option="assigned_records")  //return an array of allow customer id's
		
		If (Storage:C1525.UserAllowed_o[$tableName]=Null:C1517)  //has this table not been requested before?
			$return_o:=User_AllowedAccess("init"; $fieldPtr)
		End if 
		
		ARRAY TEXT:C222($aAllowedIds_t; 0)
		COLLECTION TO ARRAY:C1562(Storage:C1525.UserAllowed_o[$tableName]; $aAllowedIds_t)
		
		$return_o.success:=(Size of array:C274($aAllowedIds_t)>0)
		OB SET ARRAY:C1227($return_o; "allowedRecordIDs"; $aAllowedIds_t)
		
		
	Else   //passed in a customer | project id 
		
		If (Count parameters:C259>0)  //not testing, stop the recursion
			
			If (Storage:C1525.UserAllowed_o[$tableName]=Null:C1517)  //has this table not been requested before?
				$return_o:=User_AllowedAccess("init"; $fieldPtr)
			End if 
			
			$return_o.length:=Storage:C1525.UserAllowed_o[$tableName].indexOf($option)
			If ($return_o.length>-1)
				$return_o.success:=True:C214
			End if 
		End if 
		
End case 

//utl_Logfile ("debug.log";"       "+$option+" "+$fieldName+" "+JSON Stringify($return_o))
$0:=$return_o
