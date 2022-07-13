//%attributes = {"publishedWeb":true}
//Procedure: EDI_countCR()  121995  MLB
//count the carrige rtns so arrays can be sized

C_TEXT:C284($2)
C_TEXT:C284($CR)
C_LONGINT:C283($1; $i)

$0:=0
$CR:=Char:C90(13)

For ($i; 1; $1)
	If ($2[[$i]]=$CR)
		$0:=$0+1
	End if 
End for 