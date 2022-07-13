//%attributes = {"publishedWeb":true}
//PM: util_setDateIfNull(->datefield;date) -> true if set
//@author mlb - 4/10/02  12:32

C_POINTER:C301($1)
C_DATE:C307($2)

If ($1->=!00-00-00!)
	$1->:=$2
	$0:=True:C214
Else 
	$0:=False:C215
End if 