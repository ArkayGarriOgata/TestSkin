//%attributes = {}

// Method: User_SetEmailsInCust (custid )  -> distribution list
// ----------------------------------------------------
// Author: Mel Bohince
// Created: 05/06/14, 16:03:09
// ----------------------------------------------------
// Description
// populate 
//
// ----------------------------------------------------
C_TEXT:C284($1; $cust; $r)
$r:=Char:C90(13)
C_TEXT:C284($distList; $0; $email)

If (Count parameters:C259=1)
	$cust:=$1
Else 
	$cust:="00199"
End if 

QUERY:C277([Users_Record_Accesses:94]; [Users_Record_Accesses:94]TableName:2="Customers"; *)
QUERY:C277([Users_Record_Accesses:94];  & ; [Users_Record_Accesses:94]PrimaryKey:3=$cust)
$distList:=""
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
	
	For ($user; 1; Records in selection:C76([Users_Record_Accesses:94]))
		If (Position:C15([Users_Record_Accesses:94]UserInitials:1; " KK FFC MRX BAD LHC LP WJS GG MSK ")=0)  //exclude salesrep lists)
			$email:=Email_WhoAmI("*"; [Users_Record_Accesses:94]UserInitials:1)
			If (Length:C16($email)>6)
				$distList:=$distList+$email+","+$r
			End if 
		End if 
		NEXT RECORD:C51([Users_Record_Accesses:94])
	End for 
	
Else 
	
	ARRAY TEXT:C222($_UserInitials; 0)
	SELECTION TO ARRAY:C260([Users_Record_Accesses:94]UserInitials:1; $_UserInitials)
	
	For ($user; 1; Size of array:C274($_UserInitials); 1)
		If (Position:C15($_UserInitials{$user}; " KK FFC MRX BAD LHC LP WJS GG MSK ")=0)  //exclude salesrep lists)
			$email:=Email_WhoAmI("*"; $_UserInitials{$user})
			If (Length:C16($email)>6)
				$distList:=$distList+$email+","+$r
			End if 
		End if 
		
	End for 
	
End if   // END 4D Professional Services : January 2019 First record

$0:=$distList
