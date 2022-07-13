//%attributes = {}
// Method: ADDR_getLeadTime () -> 
// ----------------------------------------------------
// by: mel: 06/14/05, 17:11:16
// ----------------------------------------------------

C_LONGINT:C283($0)
C_TEXT:C284($1)

READ ONLY:C145([Addresses:30])
SET QUERY LIMIT:C395(1)
QUERY:C277([Addresses:30]; [Addresses:30]ID:1=$1)
SET QUERY LIMIT:C395(0)

If (Records in selection:C76([Addresses:30])>0)
	$0:=[Addresses:30]TransLeadDays:38
Else 
	$0:=0
End if 