//%attributes = {"publishedWeb":true}
//PM: txt_Gremlinizer(->theText)

//see also util_textNoGremlins

//@author mlb - 5/8/02  16:02

C_POINTER:C301($1; $textPtr)
C_LONGINT:C283($i; $char)

$textPtr:=$1
For ($i; 1; Length:C16($textPtr->))
	$char:=Character code:C91($textPtr->[[$i]])
	Case of 
		: ($char=9)  //CR is ok
			
			
		: ($char=13)  //CR is ok
			
			
		: ($char<32)
			$textPtr->[[$i]]:="~"
			
		: ($char>233)
			$textPtr->[[$i]]:="•"
	End case 
End for 