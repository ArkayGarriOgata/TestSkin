//%attributes = {"publishedWeb":true}
//PM:  JMI_makeJobIt  111099  mlb
//return a well formed job item number

C_TEXT:C284($0)  //returned jobit
C_TEXT:C284($1)  //form number 
C_LONGINT:C283($2)  //item number

If (Count parameters:C259=2)
	$0:=$1+"."+String:C10($2; "00")
Else   //jobit without periods
	If (Position:C15("."; $1)=0)
		$0:=Substring:C12($1; 1; 5)+"."+Substring:C12($1; 6; 2)+"."+Substring:C12($1; 8; 2)
	Else 
		$0:=$1
	End if 
End if 