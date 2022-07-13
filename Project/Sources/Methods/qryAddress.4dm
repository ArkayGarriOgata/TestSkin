//%attributes = {"publishedWeb":true}
//Procedure: qryAddress(CustKey;type)  112597  MLB
//find an address record

C_TEXT:C284($1)
C_TEXT:C284($2)

REDUCE SELECTION:C351([Addresses:30]; 0)
If (Count parameters:C259=2)
	If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) REDUCE SELECTION
		
		QUERY:C277([Customers_Addresses:31]; [Customers_Addresses:31]CustID:1=$1; *)
		QUERY:C277([Customers_Addresses:31];  & ; [Customers_Addresses:31]AddressType:3=$2)
		If (Records in selection:C76([Customers_Addresses:31])>0)
			QUERY:C277([Addresses:30]; [Addresses:30]ID:1=[Customers_Addresses:31]CustAddrID:2)
		End if 
		
	Else 
		
		QUERY:C277([Addresses:30]; [Customers_Addresses:31]CustID:1=$1; *)
		QUERY:C277([Addresses:30];  & ; [Customers_Addresses:31]AddressType:3=$2)
		
	End if   // END 4D Professional Services : January 2019 
	
Else 
	QUERY:C277([Addresses:30]; [Addresses:30]ID:1=$1)
End if 

$0:=Records in selection:C76([Addresses:30])