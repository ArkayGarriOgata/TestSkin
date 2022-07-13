//%attributes = {}
// -------
// Method: util_convertMMtoInches   ( real{;text}) -> {text}
// By: Mel Bohince @ 12/14/17, 11:36:45
// Description
// 
// ----------------------------------------------------
C_REAL:C285($1; $0)
C_TEXT:C284($2)

If (Count parameters:C259=1)
	$0:=$1*0.0393701
Else 
	$0:=Num:C11($2)*0.0393701
End if 