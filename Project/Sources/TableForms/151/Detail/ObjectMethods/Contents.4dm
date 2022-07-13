// _______
// Method: [Tool_Drawers].Detail.PartNumber   ( ) ->
// By: Mel Bohince @ 06/07/19, 15:15:27
// Description
// 
// ----------------------------------------------------


$numCR:=0
$insertAt:=0
$text:=Form:C1466.ent.Contents
For ($char; 1; Length:C16($text))
	If ($text[[$char]]=Char:C90(Carriage return:K15:38))
		$numCR:=$numCR+1
		If ($numCR=3)  //last visiabel line in list view
			If (Length:C16($text)>$char)
				$insertAt:=$char
			End if 
		End if 
	End if 
End for 

If ($insertAt>0)
	Form:C1466.ent.Contents:=Insert string:C231($text; "…"; $insertAt)
End if 
