//%attributes = {"publishedWeb":true}
//PM: fYYYYMM(date) -> str
//@author mlb - 4/24/01  13:08
C_DATE:C307($1)
C_TEXT:C284($2)
C_TEXT:C284($0)
If (Count parameters:C259=1)
	$0:=String:C10(Year of:C25($1); "0000")+String:C10(Month of:C24($1); "00")
Else 
	$0:=String:C10(Year of:C25($1); "0000")+$2+String:C10(Month of:C24($1); "00")
End if 
//