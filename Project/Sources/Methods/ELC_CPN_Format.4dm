//%attributes = {}
// Method: ELC_CPN_Format
//Former EL_makeCPN(text) -> 0000-00-0000 style
//@author mlb - 3/27/03  18:14

C_TEXT:C284($1; $0)

If (Length:C16($1)=10)
	$cpn:=Insert string:C231($1; "-"; 5)
	$cpn:=Insert string:C231($cpn; "-"; 8)
	$0:=$cpn
Else 
	$0:=$1
End if 