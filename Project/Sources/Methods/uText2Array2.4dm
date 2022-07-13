//%attributes = {"publishedWeb":true}
//Procedure: uText2Array2(field;array;pixels;font;size)  081595  MLB
//procedure to replace external in white pack, chop text in to a text array
//with a specified number of characters, breaking on char(13) or white space
//see also util_text2array
C_TEXT:C284($1; $4; $source; $lineText)
C_LONGINT:C283($2; $3; $5; $6; $0; $chars; $lines; $CR; $break)
ARRAY TEXT:C222(axText; 0)
$source:=$1
$width:=$3
$chars:=Round:C94($width/5; 0)  // assume 5 pixel width for average letter
$lineText:=""
$lines:=0
ARRAY TEXT:C222(axText; $lines)

Repeat 
	
	$CR:=Position:C15(Char:C90(13); $source)  //look for a hard return and use it if found
	If (($CR#0) & ($CR<$chars))
		$break:=$CR
		
	Else   //find a break point
		$break:=$chars
		
		If ($break>(Length:C16($source)))  //if you are on the last line, get it all
			$break:=Length:C16($source)
			
		Else   //look for a white space to break on
			While ((Substring:C12($source; $break; 1)#" ") & ($break>1))
				$break:=$break-1
			End while 
		End if 
		
		
	End if 
	
	$lineText:=Substring:C12($source; 1; $break)  //grab front chars
	If ($lineText#"")
		$lines:=$lines+1
		ARRAY TEXT:C222(axText; $lines)
		axText{$lines}:=$lineText
	End if 
	$source:=Substring:C12($source; ($break+1))  //strip the front chars
	
Until ($source="")

$0:=Size of array:C274(axText)