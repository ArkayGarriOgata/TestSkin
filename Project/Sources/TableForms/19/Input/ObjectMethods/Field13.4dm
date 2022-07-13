//(s) [carton spec]input - Custid
//script inserted with field (on layout) 1/9/97 -cs -
//based on [estimate]customer id from [estimate] input layout

READ ONLY:C145([Customers:16])  //••
C_LONGINT:C283($recNo)
$recNo:=-1
Case of 
	: ([Estimates_Carton_Specs:19]CustID:6="")  //•1/10/97 added  so that user can clear cust id field
		//do nothing record number set to -1 (clears text display)
	: (([Estimates_Carton_Specs:19]CustID:6="?") | ([Estimates_Carton_Specs:19]CustID:6="0"))
		$recNo:=fPickList(->[Customers:16]ID:1; ->[Customers:16]Name:2; ->[Customers:16]SalesmanID:3)
	Else 
		qryCustomer(->[Customers:16]ID:1; ""; ->[Estimates_Carton_Specs:19]CustID:6)
		If (fLimitRecAccess(->[Customers:16])=1)
			$recNo:=Record number:C243([Customers:16])
		Else   //build a pick list
			CONFIRM:C162("Customer not found, do you want to pick from list?")
			If (ok=1)
				$recNo:=fPickList(->[Customers:16]ID:1; ->[Customers:16]Name:2; ->[Customers:16]SalesmanID:3)
			Else 
				$recNo:=-1
			End if 
		End if 
End case 

If ($recNo>=0)
	GOTO RECORD:C242([Customers:16]; $recNo)
	[Estimates_Carton_Specs:19]CustID:6:=[Customers:16]ID:1
	Text1:=[Customers:16]Name:2
	
	// temporarily remove this code until carton specs are enterd at the est
	//  level and not at the budget level    
	
	uBuildBrandList
	uBuildAddrSelec("Bill to")
	
	If ([Estimates_Carton_Specs:19]ProductCode:5="")  //if the product has not yet been entered go to the product field
		GOTO OBJECT:C206([Estimates_Carton_Specs:19]ProductCode:5)
	End if 
Else 
	[Estimates_Carton_Specs:19]CustID:6:=""
	Text1:="No Customer specified."
	ARRAY TEXT:C222(aBrand; 0)
	ARRAY TO LIST:C287(aBrand; "Product Lines")
End if 
READ WRITE:C146([Customers:16])  //••
//eop 