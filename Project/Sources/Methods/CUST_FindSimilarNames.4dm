//%attributes = {"publishedWeb":true}
//CUST_FindSimilarNames formerly known as (p) sChkForDupCust
//$1 is Newly enter customer name

ARRAY TEXT:C222(aToFind; 0)
C_BOOLEAN:C305($0)
C_LONGINT:C283(cbCorrect)  //cbbox on dialog
C_TEXT:C284(sCurntCust)

sCurntCust:=[Customers:16]Name:2
$0:=True:C214
$RecNum:=Record number:C243([Customers:16])
PUSH RECORD:C176([Customers:16])
gTruncCustName($1; ->aToFind)  //parse newly entered customer name
If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
	QUERY:C277([Customers:16]; [Customers:16]Name:2=sCurntCust)
	
	//need this check in case all words in customer name are 'key' words, then later
	//for loop will have NOTHING to check on, and wil lnot correctly find a duplicate,
	//if there is actually a duplicate
	Case of 
		: ($RecNum=-3)  //the record where the change occured is NEW 
			CREATE SET:C116([Customers:16]; "Matches")
		: (Records in selection:C76([Customers:16])=0)  //none found
			CREATE EMPTY SET:C140([Customers:16]; "Matches")
		: ($RecNum=Record number:C243([Customers:16]))  //name found is this the same?
			CREATE EMPTY SET:C140([Customers:16]; "Matches")  //no other found
		Else   //one found and it is different than the one entered, we are checking
			CREATE SET:C116([Customers:16]; "Matches")
	End case 
	
	For ($i; 1; Size of array:C274(aToFind))
		QUERY:C277([Customers:16]; [Customers:16]Name:2="@"+aToFind{$i}+"@")
		CREATE SET:C116([Customers:16]; "Found")
		UNION:C120("Matches"; "Found"; "Matches")
	End for 
	ARRAY TEXT:C222(aToFind; 0)
	CLEAR SET:C117("Found")
	
Else 
	QUERY:C277([Customers:16]; [Customers:16]Name:2=sCurntCust)
	$doUnion:=False:C215
	Case of 
		: ($RecNum=-3)  //the record where the change occured is NEW 
			CREATE SET:C116([Customers:16]; "Matches")
			$doUnion:=True:C214
		: (Records in selection:C76([Customers:16])=0)
			//none found
		: ($RecNum=Record number:C243([Customers:16]))  //name found is this the same?
			//no other found
		Else   //one found and it is different than the one entered, we are checking
			CREATE SET:C116([Customers:16]; "Matches")
			$doUnion:=True:C214
	End case 
	
	ARRAY TEXT:C222($_Name; Size of array:C274(aToFind))
	For ($i; 1; Size of array:C274(aToFind))
		$_Name{$i}:="@"+aToFind{$i}+"@"
	End for 
	
	
	If ($doUnion)
		SET QUERY DESTINATION:C396(Into set:K19:2; "Found")
		QUERY WITH ARRAY:C644([Customers:16]Name:2; $_Name)
		SET QUERY DESTINATION:C396(Into current selection:K19:1)
		UNION:C120("Matches"; "Found"; "Matches")
		CLEAR SET:C117("Found")
	Else 
		SET QUERY DESTINATION:C396(Into set:K19:2; "Matches")
		QUERY WITH ARRAY:C644([Customers:16]Name:2; $_Name)
		SET QUERY DESTINATION:C396(Into current selection:K19:1)
	End if 
	ARRAY TEXT:C222(aToFind; 0)
	
End if   // END 4D Professional Services : January 2019 

If (Records in set:C195("Matches")>0)
	USE SET:C118("Matches")
	SELECTION TO ARRAY:C260([Customers:16]ID:1; aCustId; [Customers:16]Name:2; aCustName)
	SORT ARRAY:C229(aCustName; aCustId; >)
	$Size:=Size of array:C274(aCustId)+1
	INSERT IN ARRAY:C227(aCustId; $Size)
	INSERT IN ARRAY:C227(aCustName; $Size)
	aCustId{$Size}:="-1"
	aCustName{$Size}:="New Entry Valid, Create New Customer"
	sDlogTitle:="Customer May Already Exist! Verify Entry"
	//uOpenWindow (300;225;1)
	$winRef:=Open form window:C675([zz_control:1]; "ChooseCustomer"; Sheet form window:K39:12)
	DIALOG:C40([zz_control:1]; "ChooseCustomer")
	CLOSE WINDOW:C154($winRef)
	
	If (OK=1)
		Case of 
			: (aCustId=$Size)  //user selected "Valid original..."
				If ((Current user:C182#"Designer") | (Not:C34(Current user:C182#"Admin@"))) & (Not:C34(User in group:C338(Current user:C182; "AccountManager")))
					ALERT:C41("Your Privleges DO NOT allow You to Create a Duplicate Customer."+<>sCR+"To Create or Reassign the Customer, '"+$1+"', Please See Your Database Administrator or Accounting Personnel.")
					POP RECORD:C177([Customers:16])
					ONE RECORD SELECT:C189([Customers:16])
					[Customers:16]Name:2:=Old:C35([Customers:16]Name:2)  //•020596  MLB  
					$0:=False:C215  //no user priv
				Else   //no change, allow creation as it stands
					POP RECORD:C177([Customers:16])
					ONE RECORD SELECT:C189([Customers:16])
				End if 
			: (cbCorrect=1)  //`user selected an existing record, & wants to change the spelling
				POP RECORD:C177([Customers:16])
				[Customers:16]Name:2:=sCurntCust  //reassign spelling correction         
			Else   //user selected an existing record
				POP RECORD:C177([Customers:16])  //empty stack
				ALERT:C41("To Modify This Customer, Select 'Mod' from the Customer Palette."+<>sCr+"To Reassign This Customer to Another Sales "+"Person, Please See Your Database Administrator.")
				$0:=False:C215
		End case 
	Else   //user canceled, clear name
		POP RECORD:C177([Customers:16])
		ONE RECORD SELECT:C189([Customers:16])
		[Customers:16]Name:2:=Old:C35([Customers:16]Name:2)  //•020596  MLB  
	End if 
Else   //no other records found, create new allowed
	POP RECORD:C177([Customers:16])
	ONE RECORD SELECT:C189([Customers:16])
End if 