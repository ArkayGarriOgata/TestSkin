//%attributes = {"publishedWeb":true}
//Procedure: qryCustomer(fieldPtr;expression;{ptr to expresion};{expres})  090895 
//•090895  MLB  UPR 993
//•121197  MLB  to support lead! export

C_LONGINT:C283($0)
C_POINTER:C301($1; $3)
C_TEXT:C284($2; $4)

Case of 
	: (Count parameters:C259=4)  //•121197  MLB  to support lead! export
		If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) REDUCE SELECTION
			
			QUERY:C277([Customers_Contacts:52]; [Customers_Contacts:52]ContactID:2=$4)
			If (Records in selection:C76([Customers_Contacts:52])>0)
				QUERY:C277([Customers:16]; [Customers:16]ID:1=[Customers_Contacts:52]CustID:1)
			Else 
				REDUCE SELECTION:C351([Customers:16]; 0)
			End if 
			REDUCE SELECTION:C351([Customers_Contacts:52]; 0)
			
		Else 
			
			QUERY:C277([Customers:16]; [Customers_Contacts:52]ContactID:2=$4)
			
		End if   // END 4D Professional Services : January 2019 
		
	: (Count parameters:C259=2)
		QUERY:C277([Customers:16]; $1->=$2)
		
	Else 
		QUERY:C277([Customers:16]; $1->=$3->)
End case 

$0:=Records in selection:C76([Customers:16])