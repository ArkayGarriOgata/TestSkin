//%attributes = {"publishedWeb":true}
//Procedure: EDI_GetField(field#;tabbed string)  122195  MLB
//return a specified field from a tab delimited string

C_TEXT:C284($2; $0; $string)
C_LONGINT:C283($1; $i; $length; $beginFld; $endFld)  //field number

$string:=$2
$length:=Length:C16($string)

If ($length>0)
	Case of   //make sure it ends with a tab
		: ($string[[$length]]=<>TB)
			//cool      
		: ($string[[$length]]=<>CR)
			$string:=Change string:C234($string; <>TB; $length)
			
		Else 
			$string:=$string+<>TB
			$length:=$length+1
	End case 
	
	$tabCounter:=0
	$beginFld:=1
	$endFld:=0
	//*get the positions of the tabs
	For ($i; 1; $length)
		If ($string[[$i]]=<>TB)  //look for tabs
			$tabCounter:=$tabCounter+1  //count tabs, as they match fields
			//$tabPosition{$tabCounter}:=$i
			If ($tabCounter=$1)  //at the end of the target field
				$endFld:=$i-$beginFld  //get the number of chars
				$i:=$i+$length  //break
			Else 
				$beginFld:=$i+1
			End if 
		End if 
	End for 
	
	//*rtn the substring
	$0:=Substring:C12($string; $beginFld; $endFld)
	
Else 
	$0:=""
End if 