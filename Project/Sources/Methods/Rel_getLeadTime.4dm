//%attributes = {}
// Method: Rel_getLeadTime () -> 
// ----------------------------------------------------
// by: mel: 09/08/04, 17:21:50
// ----------------------------------------------------

C_LONGINT:C283($0)
C_TEXT:C284($1)

$0:=0

READ ONLY:C145([Addresses:30])
SET QUERY LIMIT:C395(1)
QUERY:C277([Addresses:30]; [Addresses:30]ID:1=$1)
If (Records in selection:C76([Addresses:30])>0)
	$0:=[Addresses:30]TransLeadDays:38
End if 
SET QUERY LIMIT:C395(0)
REDUCE SELECTION:C351([Addresses:30]; 0)