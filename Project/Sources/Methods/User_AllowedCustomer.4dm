//%attributes = {}
// _______
// Method: User_AllowedCustomer   (cust_id;customer_name;calledFrom ) -> true | false
// By: Mel Bohince @ 03/16/11, 12:37:18
// Description
//   // restrict access to customers to which user was assigned
// see also User_AllowedCustomer, User_AllowedRecords, User_AllowedSelection
// ----------------------------------------------------
// Modified by: Mel Bohince (4/18/13) don't test if custid blank and $2 blank
// Modified by: Mel Bohince (4/22/13) return TRUE if nothing to test
// Modified by: Garri Ogata (10/07/20) Block out creating [x_Usage_Stats].
// Modified by: Mel Bohince (6/3/21) use Storage

C_TEXT:C284($1; $custId; $user; $customerName; $2; $calledFrom; $3)
$custId:=$1
$customerName:=$2
$calledFrom:=$3

C_LONGINT:C283($numCusts)
C_BOOLEAN:C305($0)

If (Length:C16($custId)=5) | (Length:C16($customerName)>0)  // Modified by: Mel Bohince (4/18/13) don't test if custid blank and $2 blan
	
	If (User in group:C338(Current user:C182; "ExemptFromCustRestriction"))  //& (False)
		$0:=True:C214
		
	Else   //not exempt
		$user:=User_GetInitials  //based on login identity
		
		If (Length:C16($1)=0)  //find id by cust name, ignore $1
			C_OBJECT:C1216($cust_e)
			$cust_e:=ds:C1482.Customers.query("Name=:1"; $customerName).first()
			If ($cust_e#Null:C1517) & (Length:C16($customerName)>0)
				$custId:=$cust_e.ID
			Else 
				$custId:="n/f"
			End if 
			
		End if 
		
		If (Length:C16($custId)=5)  //specified existing custid
			If (True:C214)  // Modified by: Mel Bohince (6/3/21) use Storage
				C_OBJECT:C1216($return_o)
				$return_o:=User_AllowedAccess($custId; ->[Customers:16]ID:1)
				$0:=$return_o.success
				
			Else   //old way
				//SET QUERY DESTINATION(Into variable;$numCusts)
				//QUERY([Users_Record_Accesses];[Users_Record_Accesses]UserInitials=$user;*)
				//QUERY([Users_Record_Accesses]; & ;[Users_Record_Accesses]TableName="Customers";*)
				//QUERY([Users_Record_Accesses]; & ;[Users_Record_Accesses]PrimaryKey=$custId)
				//SET QUERY DESTINATION(Into current selection)
				//If ($numCusts>0)  //copacetic
				//$0:=True
				
				//Else   //report transgression
				//$0:=False
				
				//If (False)  //Block out GO (10/07/20)
				
				//  //CREATE RECORD([x_Usage_Stats])
				//  //[x_Usage_Stats]id:=app_AutoIncrement (->[x_Usage_Stats])
				//  //[x_Usage_Stats]who:=Current user
				//  //[x_Usage_Stats]when_:=TS_ISO_String_TimeStamp 
				//  //[x_Usage_Stats]what:="Access Violation"
				//  //[x_Usage_Stats]description:=$user+" - "+$custId+" "+$calledFrom
				//  //SAVE RECORD([x_Usage_Stats])
				
				//End if   //Done block out GO (10/07/20)
				
				//End if   //copacetic
			End if   //new way
			
		Else   //must be a new customer
			$0:=True:C214
		End if 
		
	End if   //exempt
	
Else   //bad length
	$0:=True:C214
End if   //something to test

//