//%attributes = {}
// Method: CSM_setField (->target;->chkbox;"value";clear) -> null
// ----------------------------------------------------
// by: mel: 10/23/03, 15:35:42
// ----------------------------------------------------

C_POINTER:C301($1; $2)
C_TEXT:C284($3)

If (Count parameters:C259>=4)
	$clear:=$4
Else 
	$clear:=False:C215
End if 

If ($2->=1)
	If ($clear)
		$1->:=""
	Else 
		$1->:=Replace string:C233($1->; " None "; "")
	End if 
	
	If (Position:C15($3; $1->)=0)
		$1->:=$1->+" "+$3+" "
	End if 
Else 
	$1->:=Replace string:C233($1->; " "+$3+" "; "")
	If (Length:C16($1->)<3)
		$1->:=" None "
	End if 
End if 