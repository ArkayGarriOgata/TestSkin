//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 10/20/05, 15:50:31
// ----------------------------------------------------
// Method: txt_Trim
// Description
// remove leading and trailing blanks
//
// Parameters
// ----------------------------------------------------
C_TEXT:C284($1; $0; $textToTrim)
C_LONGINT:C283($i; $start; $end; $len)
$start:=0
$end:=0
$textToTrim:=$1
$len:=Length:C16($textToTrim)
If ($len<80)
	For ($i; 1; (Length:C16($textToTrim)))
		If ((Character code:C91($textToTrim[[$i]]))>32)
			If ($start=0)
				$start:=$i
			End if 
			$end:=$i
		End if 
	End for 
	
Else 
	For ($i; 1; $len)
		If ((Character code:C91($textToTrim[[$i]]))>32)
			$start:=$i
			$i:=$len+1  //break
		End if 
	End for 
	
	For ($i; $len; 1; -1)
		If ((Character code:C91($textToTrim[[$i]]))>32)
			$end:=$i
			$i:=-1  //break
		End if 
	End for 
End if 

If ($start>0)
	$0:=Substring:C12($textToTrim; $start; ($end-$start+1))
Else 
	$0:=""
End if 



