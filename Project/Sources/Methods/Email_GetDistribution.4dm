//%attributes = {}

// Method: Email_GetDistribution ( )  -> comma deliminated email distribution list 
// ----------------------------------------------------
// Author: Mel Bohince
// Created: 05/06/14, 15:33:02
// ----------------------------------------------------
// Description
// get the email addresses in the customer's notifications field
//
// ----------------------------------------------------
// Modified by: Mel Bohince (8/18/14) default to kris

C_TEXT:C284($1; $cust)
C_TEXT:C284($0; $distList)
If (Count parameters:C259=1)
	$cust:=$1
Else 
	$cust:="00199"
End if 
READ ONLY:C145([Customers:16])
QUERY:C277([Customers:16]; [Customers:16]ID:1=$cust)
If (Records in selection:C76([Customers:16])>0)
	$distList:=Replace string:C233([Customers:16]NotifyEmails:49; Char:C90(13); "")
	If (Length:C16($distList)=0)
		$distList:="kristopher.koertge@arkay.com"
	End if 
	
Else 
	$distList:=""
End if 
REDUCE SELECTION:C351([Customers:16]; 0)
$0:=$distList
