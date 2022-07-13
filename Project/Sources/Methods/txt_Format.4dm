//%attributes = {"publishedWeb":true}
//PM:  txt_Format>string;"Left|Center|Right";fieldWidth{;format})->text  1/21/0
//pad a string within a specified filed

C_POINTER:C301($1)  //the string value
C_TEXT:C284($2; $0; $field; $4)  //format left center or right
C_LONGINT:C283($3; $len; $where)  //number of characters for the field

$field:=" "*$3
$0:="ERR"

If (Type:C295($1->)=Is string var:K8:2) | (Type:C295($1->)=Is text:K8:3) | (Type:C295($1->)=Is alpha field:K8:1)
	Case of 
		: ($2="Right")
			$len:=Length:C16($1->)
			$where:=($3-$len)+1
			$0:=Change string:C234($field; $1->; $where)
			
		: ($2="Left")
			$0:=Change string:C234($field; $1->; 1)
			
		: ($2="Center")
			$len:=Length:C16($1->)
			$where:=($3-$len)/2
			$0:=Change string:C234($field; $1->; $where)
	End case 
Else 
	If (Count parameters:C259=3)
		$format:="###,###,###.##"
	Else 
		$format:=$4
	End if 
	$value:=String:C10($1->; $format)
	Case of 
		: ($2="Right")
			$len:=Length:C16($value)
			If ($len>$3)
				BEEP:C151
				zwStatusMsg("ERR"; $value+" is too long in txt_Format")
			End if 
			$where:=($3-$len)+1
			$0:=Change string:C234($field; $value; $where)
			
		: ($2="Left")
			$0:=Change string:C234($field; $value; 1)
			
		: ($2="Center")
			$len:=Length:C16($value)
			$where:=($3-$len)/2
			$0:=Change string:C234($field; $value; $where)
	End case 
End if 
//