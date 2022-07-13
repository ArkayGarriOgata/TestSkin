//%attributes = {}
// Method: BarCode_HumanReadableSSCC () -> 
// ----------------------------------------------------
// by: mel: 07/14/05, 14:10:20
// ----------------------------------------------------

C_TEXT:C284($1; $sscc; $0)

If (Length:C16($1)>19)
	$sscc:=Insert string:C231($1; " "; 20)
	$sscc:=Insert string:C231($sscc; " "; 11)
	$sscc:=Insert string:C231($sscc; " "; 4)
	$sscc:=Insert string:C231($sscc; ") "; 3)
	$sscc:=Insert string:C231($sscc; "("; 1)
	$0:=$sscc
	
Else 
	$0:=$1
End if 