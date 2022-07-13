//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 01/27/14, 08:38:05
// ----------------------------------------------------
// Method: GetArtReceivedDate(cpn)
// Description:
// Returns the Art Received Date
// ----------------------------------------------------
// Modified by: Mel Bohince (6/24/19) use the parameter passed
// Modified by: Mel Bohince (10/25/21) line 14 ref'd wrong table

C_TEXT:C284($1; $0)  // Modified by: Mel Bohince (6/24/19) use the parameter passed
If (Count parameters:C259=1)  // Modified by: Mel Bohince (6/24/19) 
	QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]ProductCode:1=$1)  // Modified by: Mel Bohince (6/24/19) use the parameter passed
	If (Records in selection:C76([Finished_Goods:26])>0)  // Modified by: Mel Bohince (6/24/19) use the parameter passed
		$0:=String:C10([Finished_Goods:26]ArtReceivedDate:56)
	Else 
		$0:="cpn n/f"  // Modified by: Mel Bohince (6/24/19) use the parameter passed
	End if 
Else 
	$0:="missing cpn"  // Modified by: Mel Bohince (6/24/19) use the parameter passed
End if 