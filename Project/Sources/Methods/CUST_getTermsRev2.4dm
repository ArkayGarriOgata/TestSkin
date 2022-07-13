//%attributes = {}
// √_______
// Method: CUST_getTermsRev2   ( cust_id:text {;address_id:text) -> terms:text
// By: MelvinBohince @ 06/03/22, 11:45:50
// Description
// Return standard terms  for a customer
// favoring the billto's address record over the 
// customer's record
// ----------------------------------------------------

C_TEXT:C284($1; $2; $terms; $0)
C_OBJECT:C1216($entity)

$terms:=""  // Net30 || Net60 || etc

If (Count parameters:C259=2)  //check the address record for standard terms
	
	$entity:=ds:C1482.Addresses.query("ID = :1"; $2).first()
	If ($entity#Null:C1517)
		$terms:=$entity.Std_Terms
	End if 
	
End if   //cnt params

If (Length:C16($terms)=0)  //came up empty, try the customer record
	
	If (Count parameters:C259>=1)
		$entity:=ds:C1482.Customers.query("ID = :1"; $1).first()
		If ($entity#Null:C1517)
			$terms:=$entity.Std_Terms
		End if 
		
	Else   //no arg
		$terms:="usage error"
	End if   //cnt params
	
End if   //length terms


$0:=$terms
