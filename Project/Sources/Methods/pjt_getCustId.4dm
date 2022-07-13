//%attributes = {}

// Method: pjt_getCustId ( pjtID )  -> custID
// ----------------------------------------------------
// Author: Mel Bohince
// Created: 05/13/14, 10:05:33
// ----------------------------------------------------
// Description
// rtn cust id of pjt 
//
// ----------------------------------------------------
C_TEXT:C284($1; $0)

If ([Customers_Projects:9]id:1#$1)
	QUERY:C277([Customers_Projects:9]; [Customers_Projects:9]id:1=$1)
End if 

If (Length:C16([Customers_Projects:9]Customerid:3)=5)
	$0:=[Customers_Projects:9]Customerid:3
Else 
	$0:=""
End if 