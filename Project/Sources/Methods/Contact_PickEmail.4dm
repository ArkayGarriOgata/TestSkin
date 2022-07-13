//%attributes = {"publishedWeb":true}
//PM:  Contact_PickEmail0045;"Purchasing Agent")  090602  mlb
//make an array of contact email addresses

ARRAY TEXT:C222(aEmailAddress; 0)

READ ONLY:C145([Customers_Contacts:52])
READ ONLY:C145([Contacts:51])
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
	
	QUERY:C277([Customers_Contacts:52]; [Customers_Contacts:52]CustID:1=$1)
	RELATE ONE SELECTION:C349([Customers_Contacts:52]; [Contacts:51])
	QUERY SELECTION:C341([Contacts:51]; [Contacts:51]EmailAddress:14#"")  //=$2)
	
Else 
	
	QUERY:C277([Contacts:51]; [Customers_Contacts:52]CustID:1=$1; *)
	QUERY:C277([Contacts:51]; [Contacts:51]EmailAddress:14#"")  //=$2)
	
End if   // END 4D Professional Services : January 2019 query selection

SELECTION TO ARRAY:C260([Contacts:51]EmailAddress:14; aEmailAddress; [Contacts:51]FirstName:27; $aFirstname; [Contacts:51]LastName:26; $aLastName)  //[CONTACTS];aContactRecord;
SORT ARRAY:C229($afirstname; $aLastName; aEmailAddress; >)
For ($i; 1; Size of array:C274(aEmailAddress))
	aEmailAddress{$i}:="<"+$aFirstname{$i}+" "+$aLastName{$i}+">"+" "+aEmailAddress{$i}
End for 

If (Count parameters:C259=3)
	$0:=Find in array:C230(aEmailAddress; $3)
	If ($0<0)
		$0:=0
	End if 
Else 
	$0:=0
End if 

REDUCE SELECTION:C351([Customers_Contacts:52]; 0)
REDUCE SELECTION:C351([Contacts:51]; 0)