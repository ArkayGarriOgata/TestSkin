//%attributes = {"invisible":true,"shared":true}
//  Method:  Core_Dialog_PickT(patSource/papSource{;oPick})=>tPicked
//  Description:  Displays a list that allows a user to Pick from the list.
//    There can be up to one level of subcategories to Pick from.
//    But they must be indented and seperated by corsSubID
//    Returns a list of Picked elements
//      If you pass in a pointer to a single Element then it will only show the Picked one 
//      If you pass in a pointer to text for element use CorektSeperator to distinguish
//        which elements get Picked.

If (True:C214)  //Initialize
	
	C_POINTER:C301($1; $pSourceArray)
	C_OBJECT:C1216($2; $oPick)
	C_TEXT:C284($0; $tPicked)
	
	C_LONGINT:C283($nNumberOfParameters)
	
	C_OBJECT:C1216($oWindow)
	
	$pSourceArray:=$1
	
	$oPick:=New object:C1471()
	$oPick.tPicked:="0"
	$oPick.bPickMultiple:=False:C215
	$oPick.tFind:="Name"
	
	$oWindow:=New object:C1471()
	$oWindow.tFormName:="Core_Pick"
	
	$nNumberOfParameters:=Count parameters:C259
	
	If ($nNumberOfParameters>=2)  //Optional parameters
		$oPick:=$2
	End if   //Done optional parameters
	
End if   //Done Initialize

$nWindowReference:=Core_Window_OpenRelativeToN($oWindow)

Core_Pick_Initialize(CorektPhasePreDialog; $pSourceArray; ->$oPick)

DIALOG:C40("Core_Pick"; $oPick)

$tPicked:=Choose:C955((OK=1); Core_Pick_PickedT; CorektBlank)

Compiler_Core_Array(Current method name:C684; 0)

CLOSE WINDOW:C154($nWindowReference)

$0:=$tPicked

