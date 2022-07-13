//%attributes = {"publishedWeb":true}
//(p) x_change2 used in an apply to selection
//called from cu_subgroupchng
//$1 - pointer - to ComKey field
//$2 - pointer - to subgroup field
//$3 - string - Comm key
//$4 - string - Subgroup name
//$5 - pointer (optional) - to commodity code field
//$6 - longint  (optional) - new commodity code
//• 8/22/97 cs created
//• 6/10/98 cs modified so that move can assign to NEW commodity also

C_POINTER:C301($1; $2; $5)
C_TEXT:C284($3; $4)
C_LONGINT:C283($6)

$1->:=$3

If (Not:C34(Is nil pointer:C315($2)))
	$2->:=$4
End if 

If (Count parameters:C259>4)
	$5->:=$6
End if 