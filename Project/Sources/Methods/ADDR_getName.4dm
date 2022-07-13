//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 07/01/09, 11:38:00
// ----------------------------------------------------
// Method: ADDR_getName
// ----------------------------------------------------

C_TEXT:C284($0)
C_TEXT:C284($1)

READ ONLY:C145([Addresses:30])
SET QUERY LIMIT:C395(1)
QUERY:C277([Addresses:30]; [Addresses:30]ID:1=$1)
SET QUERY LIMIT:C395(0)

If (Records in selection:C76([Addresses:30])>0)
	$0:=[Addresses:30]Name:2
Else 
	$0:="N/F"
End if 