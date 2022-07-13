//%attributes = {}
// _______
// Method: ADDR_isValid   ($aBillTo{$i} ) ->
// By: Mel Bohince @ 10/09/19, 11:18:08
// Description
// test to see if an address id is valid
// ----------------------------------------------------
// Modified by: MelvinBohince (1/12/22) change to orda

C_TEXT:C284($1; $id)
C_BOOLEAN:C305($0)

If (Count parameters:C259=1)
	$id:=$1
Else   //testing
	$id:="?????"  //test cases:   ""//"n/a"  //"09626"  //
End if 

$0:=(ds:C1482.Addresses.query("ID = :1"; $id).length>0)
