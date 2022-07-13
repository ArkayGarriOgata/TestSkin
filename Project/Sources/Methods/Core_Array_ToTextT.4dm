//%attributes = {}
//Method: Core_Array_ToTextT(paValue{;tSeperator})=>tText
//Description:  This method will return the array as text

If (True:C214)  //Initialize
	
	C_POINTER:C301($1; $paValue)
	C_TEXT:C284($2; $tSeperator)
	C_TEXT:C284($0; $tText)
	
	C_LONGINT:C283($nNumberOfParameters)
	C_LONGINT:C283($nValue; $nNumberOfValues)
	
	C_OBJECT:C1216($oProgress)
	
	$paValue:=$1
	
	$tText:=CorektBlank
	
	$nNumberOfParameters:=Count parameters:C259
	
	$tSeperator:=CorektComma
	
	If ($nNumberOfParameters>=2)
		$tSeperator:=$2
	End if 
	
	$nNumberOfValues:=Size of array:C274($paValue->)
	
	$oProgress:=New object:C1471()
	
	$oProgress.nProgressID:=Prgr_NewN
	$oProgress.nNumberOfLoops:=$nNumberOfValues
	$oProgress.tTitle:="Creating text"
	
End if   //Done Initialize

For ($nValue; 1; $nNumberOfValues)  //Loop thru values
	
	If (Prgr_ContinueB($oProgress))  //Progress
		
		$oProgress.nLoop:=$nValue
		$oProgress.tMessage:="Adding"+CorektSpace+$paValue->{$nValue}
		
		Prgr_Message($oProgress)
		
		If ($nValue=$nNumberOfValues)
			
			$tText:=$tText+$paValue->{$nValue}
			
		Else 
			
			$tText:=$tText+$paValue->{$nValue}+$tSeperator
			
		End if 
		
	Else   //Progress canceled
		
		$nValue:=$nNumberOfValues+1  //Cancel loop
		
	End if   //Done progress
	
End for   //Done looping thru values

Prgr_Quit($oProgress)

$0:=$tText