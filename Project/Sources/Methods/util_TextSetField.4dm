//%attributes = {}
//Method: util_TextSetField
// Description
// former  zTextSetField(fieldnum;string;newvalue{;fielddelim;recdelim})122295  MLB
//renamed: EDI_putField()  122295  MLB
//put a value into a tabbed string
//base on: EDIgetField, now zTextGetField
C_TEXT:C284($2; $0; $string; $newValue; $3)
$string:=$2
$newValue:=$3
C_TEXT:C284($T; $CR)
C_LONGINT:C283($1; $i; $length; $beginFld; $endFld; $4; $5)  //field number
C_BOOLEAN:C305($endCR)
$length:=Length:C16($string)
If (Count parameters:C259<=2)  //•102898  MLB  
	$T:=Char:C90(9)
	$CR:=Char:C90(13)
Else 
	$T:=Char:C90($4)
	$CR:=Char:C90($5)
End if 

If ($length>0)
	Case of   //make sure it ends with a tab
		: ($string[[$length]]=$T)
			$endCR:=False:C215  //cool      
		: ($string[[$length]]=$CR)
			$string:=Change string:C234($string; $T; $length)
			$endCR:=True:C214
		Else 
			$string:=$string+$T
			$length:=$length+1
			$endCR:=False:C215
	End case 
	
	$tabCounter:=0
	$beginFld:=1
	$endFld:=0
	//*get the positions of the tabs
	For ($i; 1; $length)
		If ($string[[$i]]=$T)  //look for tabs
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
	$0:=Substring:C12($string; 1; $beginFld-1)+$newValue+Substring:C12($string; $beginFld+$endFld)
	If ($endCR)  //put the CR back on    
		$0:=Change string:C234($0; $CR; Length:C16($0))
	End if 
	
Else   //null
	$0:=""
End if 
//