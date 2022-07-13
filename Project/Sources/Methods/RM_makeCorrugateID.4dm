//%attributes = {}
// Method: RM_makeCorrugateID (test;length;width;depth) -> 
// ----------------------------------------------------
// by: mel: 05/21/05, 17:45:21
// ----------------------------------------------------
// Description:
// standardize id format, suitable for 10key padding
// ----------------------------------------------------

C_LONGINT:C283($1)
C_REAL:C285($2; $3; $4)
C_TEXT:C284($0)

//200-9.125*15*7.1269
If ($1#0)
	$0:=String:C10($1)+"-"
Else 
	$0:="???-"
End if 

If ($2#0)
	$0:=$0+String:C10($2)
End if 

If ($3#0)
	$0:=$0+"*"+String:C10($3)
End if 

If ($4#0)
	$0:=$0+"*"+String:C10($4)
End if 

$0:=Substring:C12($0; 1; 20)