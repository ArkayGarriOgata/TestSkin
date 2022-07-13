//%attributes = {}
//Method:  Core_PluralizeT(tSingular;nCount{;tPlural})=>tCorrectTense
//Description:  This method will pluralize a word

If (True:C214)
	
	C_TEXT:C284($1; $tSingular)
	C_REAL:C285($2; $rCount)
	C_TEXT:C284($3; $tPlural)
	C_TEXT:C284($0; $tCorrectTense)
	
	$tSingular:=$1
	$rCount:=$2
	
	$tPlural:=$tSingular+"s"
	
	If (Count parameters:C259>=3)
		$tPlural:=$3
	End if 
	
	$tCorrectTense:=$tPlural
	
End if 

$tCorrectTense:=Choose:C955(\
($rCount=1); \
$tSingular; \
$tPlural)

$0:=$tCorrectTense