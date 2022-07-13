//%attributes = {}
// -------
// Method: INV_PaysOverShip   ( custid ; billto id) ->
// By: Mel Bohince @ 02/25/19, 15:17:23
// Description
// return true if the billto or customer will pay for an overshipment
// first see if the billto is ticked, if not, then check the customer
// ----------------------------------------------------
C_BOOLEAN:C305($willPayOvershipment; $0)

$willPayOvershipment:=False:C215

If ([Addresses:30]ID:1#$2)
	QUERY:C277([Addresses:30]; [Addresses:30]ID:1=$2)
End if 

If ([Addresses:30]Pays_Overship:46)
	$willPayOvershipment:=True:C214
Else 
	
	If ([Customers:16]ID:1#$1)
		QUERY:C277([Customers:16]; [Customers:16]ID:1=$1)
	End if 
	
	If ([Customers:16]Pays_Overship:42)
		$willPayOvershipment:=True:C214
	End if 
End if 

$0:=$willPayOvershipment


