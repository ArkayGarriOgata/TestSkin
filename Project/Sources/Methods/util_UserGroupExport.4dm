//%attributes = {"publishedWeb":true}
//PM: util_UserGroupExport({true}) -> 
//@author Mel - 5/22/03  15:17

C_TEXT:C284($cr)
$cr:=Char:C90(13)
$text:=""
If (Count parameters:C259=0)
	CONFIRM:C162("Export Group names?")
	path:=""
Else 
	ok:=Num:C11($1)
End if 

If (ok=1)
	GET GROUP LIST:C610($aUserNames; $aUserNumbers)
	SORT ARRAY:C229($aUserNames; $aUserNumbers; >)
	For ($i; 1; Size of array:C274($aUserNames))
		If ($aUserNumbers{$i}<0)
			If (Length:C16($aUserNames{$i})>1)
				$text:=$text+$aUserNames{$i}+$cr
			End if 
		End if 
	End for 
	$docRef:=Create document:C266(path+"groups.txt"; "TEXT")
	SEND PACKET:C103($docRef; $text)
	CLOSE DOCUMENT:C267($docRef)
End if 

$text:=""
BEEP:C151
//