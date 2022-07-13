//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 11/06/06, 11:54:44
// ----------------------------------------------------
// Method: app_set_id_as_string
// Description
//this is a facade to app_getNextID so that it behaves as a function
// was String((Seq444uence number([Customers])+◊aOffSet{Table(->[Customers])});"00000")
// ----------------------------------------------------

// Modified by: Garri Ogata (5/7/21) for id's that did not pass in $2 "0000000" type format
//  use "00000" format instead and do not add the server ie "0" value to the id this was needed
//  because [Addresses] reached 10,000 plus records

C_TEXT:C284($string_id; $0; $server; $format; $2)
C_LONGINT:C283($nextID)

$server:="?"
$nextID:=-3
$tableNumber:=$1  //Table(->[Customers])

If (Count parameters:C259=2)
	$format:=$2
Else   //format to five digits
	//$format:="0000"  // default set for a serverid+4  // Removed by: Garri Ogata (5/7/21) 
	$format:="00000"
End if 

If (app_getNextID($tableNumber; ->$server; ->$nextID))
	
	//$string_id:=$server+String($nextID;$format)// Removed by: Garri Ogata (5/7/21) 
	
	If (Count parameters:C259=2)  //ID custom Added by: Garri Ogata (5/7/21) 
		
		$string_id:=$server+String:C10($nextID; $format)
		
	Else   //IDs good till 99,999
		
		$string_id:=String:C10($nextID; $format)
		
	End if   //Done id custom
	
Else 
	$string_id:="-1"
	CANCEL:C270
End if 

$0:=$string_id