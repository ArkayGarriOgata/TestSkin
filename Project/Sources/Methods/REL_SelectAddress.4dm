//%attributes = {}
// _______
// Method: REL_SetAddress   (custid;addresstype;addressBeforePick ) -> the picked id
// By: Mel Bohince @ 06/12/20, 08:41:48
// Description
// offer a list of allowed addresses of type specified to pick from
// assumes that the address type has a space, like "Bill to" and field does not, like "Billto"
// return either the pick or the original
// ----------------------------------------------------

C_OBJECT:C1216($address_es)
ARRAY TEXT:C222($addressIDs; 0)
C_TEXT:C284($choosenAddressID; $addressType; $fieldName; $1; $2; $3; $0)

If (Count parameters:C259=3)
	$custID:=$1
	$addressType:=$2
	$choosenAddressID:=$3
Else   //testing
	$custID:="00121"
	$addressType:="Bill to"
	$choosenAddressID:="11111"
End if 

$fieldName:=Replace string:C233($addressType; " "; "")

$address_es:=ds:C1482.Customers_Addresses.query("CustID = :1 and AddressType = :2"; $custID; $addressType)  //find the allowed addresses of requested type

If ($address_es.length>0)  //convert to array to use legacy address picker dialog
	COLLECTION TO ARRAY:C1562($address_es.toCollection("CustAddrID"); $addressIDs; "CustAddrID")
	SORT ARRAY:C229($addressIDs; >)
	
	sPickAddress(->$addressIDs; ->$choosenAddressID)  //offer the legacy address picker
	
Else 
	uConfirm("No Bill-tos found for CustID = "+$custID; "Keep "+$choosenAddressID; "Cancel")
End if 

$0:=$choosenAddressID
