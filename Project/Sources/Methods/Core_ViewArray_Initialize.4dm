//%attributes = {"invisible":true,"shared":true}
//Method:  Core_ViewArray_Initialize(sStatus{;$pViewArray}{;sMessage})
//Description:  This method will inititlaize the values for the
//  form Core_ViewArray

If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $3; $tPhase; $tMessage)
	C_POINTER:C301($2; $pViewArray)
	
	C_TEXT:C284($tColumnName)
	
	C_TEXT:C284($tHeader)
	C_TEXT:C284($tHeaderName)
	C_POINTER:C301($pnHeaderVariable)
	
	C_LONGINT:C283($nTable; $nField)
	C_LONGINT:C283($nNumberOfParameters)
	C_LONGINT:C283($nColumn; $nNumberOfColumns)
	
	$nNumberOfParameters:=Count parameters:C259
	
	$tPhase:=$1
	
	If ($nNumberOfParameters>=2)  //Optional parameters
		$pViewArray:=$2
		If ($nNumberOfParameters>=3)
			$tMessage:=$3
		End if 
	End if   //Done optional parameters
	
End if   //Done initialize

Case of   //Phase
		
	: ($tPhase=CorektPhaseInitialize)
		
		$nNumberOfColumns:=Size of array:C274(Core_patViewArray_Header->)
		
		For ($nColumn; 1; $nNumberOfColumns)  //Loop thru columns
			
			$paColumn:=Core_papViewArray_Column->{$nColumn}
			RESOLVE POINTER:C394($paColumn; $tColumnName; $nTable; $nField)
			
			$tHeaderName:="Core_nViewArray_Header"+String:C10($nColumn)
			
			LISTBOX INSERT COLUMN:C829(*; "Core_abViewArray"; $nColumn; $tColumnName; $paColumn->; $tHeaderName; $tHeaderName)
			
			OBJECT SET TITLE:C194(*; $tHeaderName; Core_patViewArray_Header->{$nColumn})
			
		End for   //Done looping thru columns
		
		OBJECT SET ENTERABLE:C238(*; "Core_abViewArray"; False:C215)
		
End case   //Done phase