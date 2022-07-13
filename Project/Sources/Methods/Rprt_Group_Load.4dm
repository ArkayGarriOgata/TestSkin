//%attributes = {}
//Method:  Rprt_Group_Load(patGroup)
//Description:  This method 

If (True:C214)  //Initialize 
	
	C_POINTER:C301($1; $patGroup)
	
	$patGroup:=$1
	
End if   //Done Initialize

APPEND TO ARRAY:C911($patGroup->; GrupktAccounting)
APPEND TO ARRAY:C911($patGroup->; GrupktCustomerService)
APPEND TO ARRAY:C911($patGroup->; GrupktProduction)
APPEND TO ARRAY:C911($patGroup->; GrupktQualityAssurance)
APPEND TO ARRAY:C911($patGroup->; GrupktSale)
