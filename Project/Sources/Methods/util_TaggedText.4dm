//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 05/16/07, 10:59:46
// ----------------------------------------------------
// Method: util_TaggedText("put | get";tag;text;->container)
// Description
// put and get tagged values from a text field/variable
//
// Parameters
// ----------------------------------------------------
//If (Count parameters>0)
C_TEXT:C284($1; $tagBegin; $2; $tagEnd; $3; $text; $0; $return)
C_POINTER:C301($containerPtr; $4)
C_LONGINT:C283($positionBegin; $positionEnd; $numChars)
$tagBegin:="<"+$2+">"
$tagEnd:="</"+$2+">"
$text:=$3
$containerPtr:=$4
//End if 
$return:=""

Case of 
		//: (Count parameters=0)  `test
		//xText:="123_"
		//$text:=Request("enter tagged string";"")
		//If (ok=1)
		//$return:=util_TaggedText ("put";"test";$text;->xText)
		//xText:=xText+"321"
		//$return:=util_TaggedText ("get";"test";"";->xText)
		//$return:=util_TaggedText ("put";"test";$text+"more";->xText)
		//End if 
		
	: ($1="put")
		//replace if it already exists
		$positionBegin:=Position:C15($tagBegin; $containerPtr->)
		If ($positionBegin>0)  //delete it
			$positionEnd:=Position:C15($tagEnd; $containerPtr->)
			If ($positionEnd>0)
				$numChars:=$positionEnd-$positionBegin+Length:C16($tagEnd)
				$containerPtr->:=Delete string:C232($containerPtr->; $positionBegin; $numChars)
			End if 
		End if 
		
		If (Length:C16($text)>0)  //append the item
			$containerPtr->:=$containerPtr->+$tagBegin+$text+$tagEnd
		End if 
		$return:=$containerPtr->
		
	: ($1="get")
		$positionBegin:=Position:C15($tagBegin; $containerPtr->)
		If ($positionBegin>0)
			$positionBegin:=$positionBegin+Length:C16($tagBegin)  //
			$positionEnd:=Position:C15($tagEnd; $containerPtr->)
			If ($positionEnd>0)
				$numChars:=$positionEnd-$positionBegin
				$return:=Substring:C12($containerPtr->; $positionBegin; $numChars)
			End if 
		End if 
		
End case 

$0:=$return
