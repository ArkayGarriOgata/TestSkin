//%attributes = {}

// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 04/21/16, 12:03:43
// ----------------------------------------------------
// Method: ADDR_getCountry
// Description
// 
//
// Parameters
// ----------------------------------------------------

C_TEXT:C284($0)
C_TEXT:C284($1)

READ ONLY:C145([Addresses:30])
SET QUERY LIMIT:C395(1)
QUERY:C277([Addresses:30]; [Addresses:30]ID:1=$1)
SET QUERY LIMIT:C395(0)

If (Records in selection:C76([Addresses:30])>0)
	$0:=[Addresses:30]Country:9
Else 
	$0:="N/F"
End if 