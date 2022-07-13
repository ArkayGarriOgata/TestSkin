//%attributes = {"publishedWeb":true}
//PM: NotifyParseDept() -> 
//parses user depratment(s) into an array ◊UserDepart
//$1 - user department list
//• 8/8/97 cs  created

C_TEXT:C284($1; xText)
ARRAY TEXT:C222(<>UserDepart; 0)
ARRAY TEXT:C222(<>UserDepart; 100)

If ($1#"")
	xText:=$1  //assign so that string can be destructed in processing
	$Count:=1
	
	For ($i; 1; 100)
		<>UserDepart{$i}:=uParseString(xtext; 1; "•"; ->xText)
		$Count:=$Count+1
		
		If (Length:C16(xText)=0)  //end of department list reached
			ARRAY TEXT:C222(<>UserDepart; $i)  //re size array to used size
			$i:=101
			$Count:=$Count-1
			ARRAY TEXT:C222(<>UserDepart; $Count)
		End if 
	End for 
Else 
	ARRAY TEXT:C222(<>UserDepart; 0)
End if 