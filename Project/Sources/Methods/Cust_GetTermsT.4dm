//%attributes = {}
//Method: Cust_GetTermsT(tCustomerID;tBillToAddressID)=>tTerms
//Description: This method will return the terms based on BillToAddressID or customer ID

If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $tCustomerID)
	C_TEXT:C284($2; $tBillToAddressID)
	C_TEXT:C284($0; $tTerms)
	
	$tCustomerID:=$1
	$tBillToAddressID:=$2
	
	$tTerms:=CorektBlank
	
End if   //Done initialize

Case of   //Terms
		
	: ($tBillToAddressID=CorektBlank)
	: ($tCustomerID=CorektBlank)
		
	: (Core_Query_UniqueRecordB(->[Addresses:30]ID:1; ->$tBillToAddressID; ->$oUnique))
		
		$tTerms:=$oUnique.Terms
		
	: (Core_Query_UniqueRecordB(->[Customers:16]ID:1; ->$tCustomerID; ->$oUnique))
		
		$tTerms:=$oUnique.Std_Terms
		
End case   //Done terms

$0:=$tTerms