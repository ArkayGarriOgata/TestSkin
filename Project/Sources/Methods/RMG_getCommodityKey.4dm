//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 05/10/06, 12:21:59
// ----------------------------------------------------
// Method: RMG_getCommodityKey(comCode;subgroup)
// Description
// return a properly formed commodity key or null
//replaces method uSetCommKey
// ----------------------------------------------------

C_LONGINT:C283($1)
C_TEXT:C284($2; $0)

$0:=""

If ($1>0)
	If (Length:C16($2)>0)
		$0:=String:C10($1; "00")+"-"+$2
	End if 
End if 