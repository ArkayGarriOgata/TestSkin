//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 05/22/06, 16:54:53
// ----------------------------------------------------
// Method: Cust_GetTerms
// Description
// get the default terms for customers
// ----------------------------------------------------

C_TEXT:C284($custid; $1)
C_POINTER:C301($2; $3; $4; $5)
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

$2->:=[Customers:16]Std_Terms:13
$3->:=[Customers:16]Std_Incoterms:11
$4->:=[Customers:16]Std_ShipVia:9

If ($changedRecord)
	REDUCE SELECTION:C351([Customers:16]; 0)
End if 