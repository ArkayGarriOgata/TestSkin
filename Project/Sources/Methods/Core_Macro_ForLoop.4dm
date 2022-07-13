//%attributes = {"invisible":true,"shared":true}
//ForLoop:  Core_Macro_ForLoop({*}{!}Array/Field)=>tForLoopCode
//Description:  This method will help create code for a For Loop
//   !  means add early termination condition.
//   * means add thermometer.

If (True:C214)  //Initialize
	
	C_TEXT:C284($tForLoopObject; $tForLoopCode)
	C_BOOLEAN:C305($bTerminateLoop)
	C_LONGINT:C283($nObjectType)
	C_TEXT:C284($tTableName; $tObjectName)
	
	C_BOOLEAN:C305($bProgress)
	
	GET MACRO PARAMETER:C997(Highlighted method text:K5:18; $tForLoopObject)
	
	$bTerminateLoop:=Choose:C955((Position:C15("!"; $tForLoopObject)>0); True:C214; False:C215)  //Do we want to terminate early
	$tForLoopObject:=Replace string:C233($tForLoopObject; "!"; CorektBlank; *)  //Remove all the !
	
	$bProgress:=Choose:C955((Position:C15("*"; $tForLoopObject)>0); True:C214; False:C215)  //Do we want progress
	$tForLoopObject:=Replace string:C233($tForLoopObject; "*"; CorektBlank; *)  //Remove all the *
	
End if   //Done Initialize

$nObjectType:=Core_Code_GetTableFieldArrayN($tForLoopObject)

Case of   //Type of object
		
	: ($nObjectType=CoreknCodeTable)  //Table
		
		$tObjectName:=Substring:C12($tForLoopObject; 2)  //Remove the [
		$tObjectName:=Substring:C12($tObjectName; 1; Length:C16($tForLoopObject)-2)  //Remove the ]
		
		$tTableName:=$tForLoopObject
		
	: ($nObjectType=CoreknCodeField)  //Field
		
		$tObjectName:=Substring:C12($tForLoopObject; Position:C15("]"; $tForLoopObject)+1)  //Remove the [TableName]
		
		$tTableName:=Substring:C12($tForLoopObject; 1; Position:C15("]"; $tForLoopObject))
		
	: ($nObjectType=CoreknCodeArray)  //Array
		
		Case of 
				
			: (Position:C15("$"; $tForLoopObject)>0)  //Local array
				$tObjectName:=Substring:C12($tForLoopObject; 4)  //Remove the $at
				
			: (Position:C15(">"; $tForLoopObject)>0)  //InterProcess array
				$tObjectName:=Substring:C12($tForLoopObject; 5)  //Remove the <>at
				
			Else   //Process array
				
				$tObjectName:=Substring:C12($tForLoopObject; 3)  //at
				
		End case 
		
End case   //End type of object

$tForLoopCode:=CorektBlank

$tForLoopCode:=$tForLoopCode+"If (True)  //Initialize"+CorektDoubleSpace

$tForLoopCode:=$tForLoopCode+Command name:C538(283)+"($n"+$tObjectName+";$nNumberOf"+$tObjectName+"s)"+CorektDoubleSpace  //C_LONGINT

If ($nObjectType=3)  //array
	$tForLoopCode:=$tForLoopCode+"$nNumberOf"+$tObjectName+"s:="+Command name:C538(274)+"("+$tForLoopObject+")"+CorektDoubleSpace  //Size of array
Else 
	$tForLoopCode:=$tForLoopCode+"$nNumberOf"+$tObjectName+"s:="+Command name:C538(76)+"("+$tTableName+")"+CorektDoubleSpace  //Records In Selection
	$tForLoopCode:=$tForLoopCode+Command name:C538(50)+"("+$tTableName+")"+CorektDoubleSpace  //FIRST RECORD
End if 

If ($bProgress)
	
	$tForLoopCode:=$tForLoopCode+"C_OBJECT($oProgress)"+CorektDoubleSpace
	$tForLoopCode:=$tForLoopCode+"$oProgress:=New object()"+CorektDoubleSpace
	$tForLoopCode:=$tForLoopCode+"$oProgress.nProgressID:=Prgr_NewN"+CorektCR
	$tForLoopCode:=$tForLoopCode+"$oProgress.nNumberOfLoops:=$nNumberOf"+$tObjectName+"s"+CorektCR
	$tForLoopCode:=$tForLoopCode+"$oProgress.tTitle:="+CorektDoubleQuote+"Looping thru"+CorektSpace+$tObjectName+CorektDoubleQuote+CorektDoubleSpace
	
End if 

$tForLoopCode:=$tForLoopCode+"End if   //Done Initialize"+CorektDoubleSpace

$tForLoopCode:=$tForLoopCode+"For ($n"+$tObjectName+";1;$nNumberOf"+$tObjectName+"s) //Loop through "+$tObjectName+CorektDoubleSpace

If ($bTerminateLoop)
	If ($nObjectType=3)  //array
		$tForLoopCode:=$tForLoopCode+"If ("+$tForLoopObject+"{$n"+$tObjectName+"}=)"+CorektCR
		$tForLoopCode:=$tForLoopCode+"$n"+$tObjectName+" := $nNumberOf"+$tObjectName+"s + 1"+CorektCR
		$tForLoopCode:=$tForLoopCode+" End If"+CorektDoubleSpace
	Else 
		$tForLoopCode:=$tForLoopCode+"If ("+$tForLoopObject+"=)"+CorektCR
		$tForLoopCode:=$tForLoopCode+"$n"+$tObjectName+" := $nNumberOf"+$tObjectName+"s + 1"+CorektCR
		$tForLoopCode:=$tForLoopCode+" End If"+CorektDoubleSpace
	End if 
	
End if 

If ($nObjectType#3)  //Table or Record 
	$tForLoopCode:=$tForLoopCode+Command name:C538(51)+"("+$tTableName+")"+CorektDoubleSpace  //NEXT RECORD
End if 

If ($bProgress)  //Add progress
	
	$tForLoopCode:=$tForLoopCode+"$oProgress.nLoop:=$n"+$tObjectName+CorektCR
	$tForLoopCode:=$tForLoopCode+"$oProgress.tMessage:=String($n"+$tObjectName+")"+CorektDoubleQuote+" of "+CorektDoubleQuote+"+String($nNumberOf"+$tObjectName+"s)"+CorektCR
	$tForLoopCode:=$tForLoopCode+"Prgr_Message ($oProgress)"+CorektDoubleSpace
	
End if   //Done add progress

$tForLoopCode:=$tForLoopCode+"End for //Done looping through "+$tObjectName+CorektDoubleSpace

If ($bProgress)
	$tForLoopCode:=$tForLoopCode+"Prgr_Quit ($oProgress)"+CorektCR
End if 

SET MACRO PARAMETER:C998(Highlighted method text:K5:18; $tForLoopCode)
