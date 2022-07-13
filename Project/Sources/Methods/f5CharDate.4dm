//%attributes = {"publishedWeb":true}
//Procedure: f5CharDate()  072595  MLB
//return a 5 char date like, 09/23, unless date = 0, then return blank

C_POINTER:C301($1; $datePtr)
C_TEXT:C284($0)

$datePtr:=$1

If ($datePtr->#!00-00-00!)
	$0:=Substring:C12(String:C10($datePtr->; <>MIDDATE); 1; 5)
Else 
	$0:="."
End if 