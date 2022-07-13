//%attributes = {"publishedWeb":true}
//PM:  CUST_new  3/24/00  mlb
//create a new customer

C_TEXT:C284($0)

If (True:C214)
	ViewSetter(1; ->[Customers:16])
Else 
	//create the record, return the id, modify the record
End if 
$0:="00000"