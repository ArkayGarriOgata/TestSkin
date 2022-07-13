//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 01/13/10, 09:35:41
// ----------------------------------------------------
// Method: ADDR_getCity
// ----------------------------------------------------

C_TEXT:C284($0)
C_TEXT:C284($1)

READ ONLY:C145([Addresses:30])
SET QUERY LIMIT:C395(1)
QUERY:C277([Addresses:30]; [Addresses:30]ID:1=$1)
SET QUERY LIMIT:C395(0)

If (Records in selection:C76([Addresses:30])>0)
	$0:=[Addresses:30]City:6
Else 
	$0:="N/F"
End if 