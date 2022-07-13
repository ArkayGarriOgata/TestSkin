//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 10/04/06, 09:13:39
// ----------------------------------------------------
// Method: Cust_getTeam
// Description
//  get sales rep, coord,  pln from cust record
// Modified by: Mel Bohince (2/5/14) add optional customer service
// Modified by: MelvinBohince (6/8/22) add optional 2nd customer service (for pricing email)

C_TEXT:C284($custid; $1)
C_POINTER:C301($2; $3; $4; $5; $6)
C_BOOLEAN:C305($changedRecord)

$custid:=$1

If ([Customers:16]ID:1#$custid)
	READ ONLY:C145([Customers:16])
	SET QUERY LIMIT:C395(1)
	QUERY:C277([Customers:16]; [Customers:16]ID:1=$custid)
	SET QUERY LIMIT:C395(0)
	$changedRecord:=True:C214
Else 
	$changedRecord:=False:C215
End if 

$2->:=[Customers:16]SalesmanID:3
$3->:=[Customers:16]SalesCoord:45
$4->:=[Customers:16]PlannerID:5
If (Count parameters:C259>4)
	$5->:=[Customers:16]CustomerService:46
End if 

If (Count parameters:C259>5)  // Modified by: MelvinBohince (6/8/22) add optional 2nd customer service (for pricing email)
	$6->:=[Customers:16]CustomerService2:68
End if 

If ($changedRecord)
	REDUCE SELECTION:C351([Customers:16]; 0)
End if 