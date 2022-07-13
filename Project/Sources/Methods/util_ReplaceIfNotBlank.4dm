//%attributes = {}
// ----------------------------------------------------
// User name: Mel Bohince
// Created: 04/24/07, 14:39:09
// ----------------------------------------------------
// Method: util_ReplaceIfNotBlank(->target;->source{;"no-overlay"})  --> true if replaced
// Description
// don't overwrite a field with a blank or 0 or 00/00/00
//if param 3, don't overrite a non-blank field
// ----------------------------------------------------

// ----------------------------------------------------
C_POINTER:C301($targetPtr; $1; $sourcePtr; $2)
$targetPtr:=$1
$sourcePtr:=$2
C_BOOLEAN:C305($change; $0; $no_overlay)
$change:=False:C215
C_TEXT:C284($3)
If (Count parameters:C259>2)
	$no_overlay:=True:C214
Else 
	$no_overlay:=False:C215
End if 


$typeTarget:=Type:C295($targetPtr->)
$typeSource:=Type:C295($sourcePtr->)

Case of 
		//: ($typeTarget#$typeSource)
		//$0:=False
		
	: (($typeSource=Is alpha field:K8:1) | ($typeSource=Is text:K8:3))
		If (Length:C16($sourcePtr->)>0)
			$change:=True:C214
		End if 
		
		If ($no_overlay)  //pre-pend
			If (Length:C16($targetPtr->)>0)
				$change:=False:C215
				//$targetPtr->:=$sourcePtr->+Char(13)+$targetPtr->`bad things happen with this line
			End if 
		End if 
		
	: (($typeSource=Is real:K8:4) | ($typeSource=Is integer:K8:5) | ($typeSource=Is longint:K8:6))
		If (($sourcePtr->)#0)
			$change:=True:C214
		End if 
		
		If ($no_overlay)
			If (($targetPtr->)#0)
				$change:=False:C215
			End if 
		End if 
		
	: ($typeSource=Is date:K8:7)
		If (($sourcePtr->)>!00-00-00!)
			$change:=True:C214
		End if 
		
		If ($no_overlay)
			If (($targetPtr->)>!00-00-00!)
				$change:=False:C215
			End if 
		End if 
		
End case 

If ($change)
	$targetPtr->:=$sourcePtr->
End if 

$0:=$change

