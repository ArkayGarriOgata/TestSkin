//%attributes = {}
//Method:  Core_Text_RemoveLineT(tSourceText{;ptLine})=>tMissingLineText
//Description:  This method will remove the line from text
//  and return the line in pointer if applied

If (True:C214)  //Intialization
	
	C_TEXT:C284($1; $tSourceText)
	C_POINTER:C301($2; $ptLine)
	C_TEXT:C284($0; $tMissingLineText)
	
	C_TEXT:C284($tLine)
	C_BOOLEAN:C305($bReturnLine)
	C_LONGINT:C283($nPositionCR)
	
	$tSourceText:=$1
	
	$bReturnLine:=False:C215
	
	If (Count parameters:C259>=2)
		$ptLine:=$2
		$bReturnLine:=True:C214
	End if 
	
	$tMissingLineText:=CorektBlank
	
End if   //Done Initialize

$nPositionCR:=Position:C15(CorektCR; $tSourceText)

If ($nPositionCR>0)  //Found a CR
	
	$tLine:=Substring:C12($tSourceText; 1; $nPositionCR)
	
	$tMissingLineText:=Substring:C12($tSourceText; $nPositionCR+1)
	
Else   //No CR
	
	$tLine:=$tSourceText
	$tMissingLineText:=CorektBlank
	
End if   //Done found a CR

If ($bReturnLine)  //Return line
	
	$ptLine->:=$tLine
	
End if   //Done return line

$0:=$tMissingLineText