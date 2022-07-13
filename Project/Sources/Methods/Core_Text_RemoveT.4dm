//%attributes = {}
//Method:  Core_Text_RemoveT(tStripStatement;patStripCharacter;{nLocation}{;nAllowed})=>tStripStatement
//Description:  This procedure returns Statement strip of any characters found 
//  in the patStopCharacter.
//  nLocation=0 Everywhere (default)
//  nLocation=1 Start only.
//  nLocation=2 End only.
//  nLocation=3 Start and End.
//  nLocation=4 Between and End
//  nLocation=5 Between and End and Start

If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $0; $tStripStatement)
	C_POINTER:C301($2; $patStripCharacter)
	C_LONGINT:C283($3; $nLocation)
	C_LONGINT:C283($4; $nAllowed)
	
	C_BOOLEAN:C305($bDone)
	
	C_LONGINT:C283($nNumberOfParmeters)
	C_LONGINT:C283($nRemoveCharacter; $nNumberOfRemoveCharcters; $nLastCharacter)
	C_LONGINT:C283($nChar; $nCount; $nPosition)
	C_LONGINT:C283($nRemove)
	
	C_TEXT:C284($tRemoveCharacter)
	C_TEXT:C284($tEndStripStatement)
	C_TEXT:C284($tStartStripStatement)
	
	$tStripStatement:=$1
	$patStripCharacter:=$2
	$nLocation:=0
	$nAllowed:=2  //Used with between
	
	$nNumberOfParmeters:=Count parameters:C259
	
	If ($nNumberOfParmeters>=3)  //Optional parameters
		$nLocation:=$3
		If ($nNumberOfParmeters>=4)  //Allowed
			$nAllowed:=$4
		End if 
	End if   //Done optional parameters
	
End if   //Done Initialize

Case of   //Where
		
	: ($nLocation=0)  //Replace all of the characters
		
		$nNumberOfRemoveCharcters:=Size of array:C274($patStripCharacter->)
		
		For ($nRemoveCharacter; 1; $nNumberOfRemoveCharcters)
			
			$tRemoveCharacter:=$patStripCharacter->{$nRemoveCharacter}
			$tStripStatement:=Replace string:C233($tStripStatement; $tRemoveCharacter; CorektBlank; *)  //Replace all of these characters with nothing 
			
		End for 
		
	: ($nLocation=1)  //Replace just the front
		
		Repeat 
			
			$nLastCharacter:=Length:C16($tStripStatement)
			$bDone:=True:C214
			
			Case of 
				: ($nLastCharacter=0)
				: (Find in array:C230($patStripCharacter->; $tStripStatement[[1]])>0)
					$tStripStatement:=Substring:C12($tStripStatement; 2)
					$bDone:=False:C215
			End case 
			
		Until ($bDone)
		
	: ($nLocation=2)  //Replace the end
		
		$bDone:=False:C215
		
		Repeat 
			
			$nLastCharacter:=Length:C16($tStripStatement)
			$bDone:=True:C214
			
			Case of 
				: ($nLastCharacter=0)
				: (Find in array:C230($patStripCharacter->; $tStripStatement[[$nLastCharacter]])>0)
					$tStripStatement:=Substring:C12($tStripStatement; 1; $nLastCharacter-1)
					$bDone:=False:C215
			End case 
			
		Until ($bDone)
		
	: ($nLocation=3)  //Replace the front and end
		
		$tStripStatement:=Core_Text_RemoveT($tStripStatement; $patStripCharacter; 1)  //Strip the front
		$tStripStatement:=Core_Text_RemoveT($tStripStatement; $patStripCharacter; 2)  //Strip the end
		
	: ($nLocation=4)  //Replace between and end
		
		$nLastCharacter:=Length:C16($tStripStatement)
		
		For ($nPosition; $nLastCharacter; 1; -1)  //Characters
			
			$tRemoveCharacter:=$tStripStatement[[$nPosition]]
			$nChar:=Character code:C91($tRemoveCharacter)
			
			Case of   //Remove
					
				: ((Find in array:C230($patStripCharacter->; $tRemoveCharacter)#CoreknNoMatchFound) & ($nRemove>0))  //Started counting
					
					$nCount:=$nCount+1
					
				: (Find in array:C230($patStripCharacter->; $tRemoveCharacter)#CoreknNoMatchFound)  //First occurrence
					
					$nCount:=1
					$nRemove:=$nPosition
					
				: ($nCount>$nAllowed)  //Found to many consecutive
					
					$tStartStripStatement:=Substring:C12($tStripStatement; 1; $nPosition)
					$tEndStripStatement:=Substring:C12($tStripStatement; $nRemove)
					
					$tStripStatement:=$tStartStripStatement+$tEndStripStatement
					
					$nCount:=0
					$nRemove:=0
					
				Else   //Everything is ok
					
					$nCount:=0
					$nRemove:=0
					
			End case   //Done remove
			
		End for   //Done characters
		
	: ($nLocation=5)  //Replace between and end and start
		
		$tStripStatement:=Core_Text_RemoveT($tStripStatement; $patStripCharacter; 4)  //Strip between and end
		$tStripStatement:=Core_Text_RemoveT($tStripStatement; $patStripCharacter; 1)  //Strip the front
		
End case   //Done where

$0:=$tStripStatement  //Return the stripped out stopchars