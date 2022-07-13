//%attributes = {"publishedWeb":true}
//PM:  txt_ReplaceStringext;old char #;new charNum) -text  060399  mlb
//couldn't successfully use Replace String to set é to e
C_LONGINT:C283($2; $3; $i)
C_TEXT:C284($1; $0; $buffer)
$buffer:=$1
For ($i; 1; Length:C16($1))
	If (Character code:C91($buffer[[$i]])=$2)
		$buffer[[$i]]:=Char:C90($3)
	End if 
End for 
$0:=$buffer
//