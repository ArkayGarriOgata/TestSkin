//%attributes = {"publishedWeb":true}
//PM: util_TextParser() -> 
//formerly zTextParser()  020497  MLB
//parse a tab delimited string to an array
//•073197  MLB  selfexpanding if $1 is too small
//•1/25/00  mlb  switch delimitor comparisons to ascii(demilim)
C_LONGINT:C283($1; i; $j; $params)
C_TEXT:C284($2; $0)
$params:=Count parameters:C259
Case of 
	: ($params>=2)  //constructor
		ARRAY TEXT:C222(aParseArray; 0)
		ARRAY TEXT:C222(aParseArray; $1)
		$0:=""
		
		C_TEXT:C284($t; $cr)
		If ($params=2)
			$cr:=Char:C90(13)
			$t:=Char:C90(9)
		Else 
			$cr:=Char:C90($4)
			$t:=Char:C90($3)
		End if 
		
		$j:=1
		For ($i; 1; Length:C16($2))
			If (Character code:C91($2[[$i]])#Character code:C91($t)) & (Character code:C91($2[[$i]])#Character code:C91($cr))
				aParseArray{$j}:=aParseArray{$j}+$2[[$i]]
				
			Else 
				$j:=$j+1
				If (Size of array:C274(aParseArray)<$j)  //•073197  MLB  selfexpanding
					ARRAY TEXT:C222(aParseArray; $j)
				End if 
				
			End if 
		End for 
		$0:=String:C10($j)
		
	: ($params=1)  //return the field numbered by the argument
		If ($1<=Size of array:C274(aParseArray))
			$0:=aParseArray{$1}  //return the field
		Else 
			BEEP:C151
			ALERT:C41("Beyond end of zTextParser's record."; "Whoa!")
			$0:=""
		End if 
		
	Else   //destruct
		ARRAY TEXT:C222(aParseArray; 0)
		$0:=""
End case 
//