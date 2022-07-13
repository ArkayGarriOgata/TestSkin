//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 03/18/11, 14:35:26
// ----------------------------------------------------
// Method: Pjt_getName
// ----------------------------------------------------

C_TEXT:C284($1)
C_TEXT:C284($0)

$0:=""

MESSAGES OFF:C175
If ([Customers_Projects:9]id:1#$1)
	READ ONLY:C145([Customers_Projects:9])
	SET QUERY LIMIT:C395(1)
	QUERY:C277([Customers_Projects:9]; [Customers_Projects:9]id:1=$1)
	If (Records in selection:C76([Customers_Projects:9])=1)
		$0:=[Customers_Projects:9]Name:2
	End if 
	SET QUERY LIMIT:C395(0)
	REDUCE SELECTION:C351([Customers_Projects:9]; 0)
Else 
	$0:=[Customers_Projects:9]Name:2
End if 