//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 01/10/06, 16:32:53
// ----------------------------------------------------
// Method: PO_getPOvendorId
// Description
// pass a vendor id of po back to a ip variable
// ----------------------------------------------------

C_TEXT:C284(<>VendorId)
C_TEXT:C284($1)

<>VendorId:=""

SET QUERY LIMIT:C395(1)
QUERY:C277([Purchase_Orders:11]; [Purchase_Orders:11]PONo:1=$1)
SET QUERY LIMIT:C395(0)

If (Records in selection:C76([Purchase_Orders:11])>0)
	<>VendorId:=[Purchase_Orders:11]VendorID:2
Else 
	<>VendorId:="-n/f-"
End if 