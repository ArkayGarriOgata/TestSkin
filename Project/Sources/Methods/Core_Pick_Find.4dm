//%attributes = {}
//Method:  Core_Pick_Find
//Description:  This method handles the find for the select form
//  The only event for this object is on after keystroke

If (True:C214)  //Intialization
	
	C_LONGINT:C283($nRow)
	C_TEXT:C284($tFind)
	C_POINTER:C301($pColumnArray)
	C_LONGINT:C283($nColumn; $nNumberOfColumns)
	
End if   //Done initialization

$tFind:=Get edited text:C655

If ($tFind#CorektBlank)  //Something to find
	
	$tFind:=$tFind+"@"
	
	$nNumberOfColumns:=4
	
	For ($nColumn; 1; $nNumberOfColumns)  //Loop through Column
		
		$pColumnArray:=Get pointer:C304("Core_atPick_Value")  //+String($nColumn))
		
		$nRow:=Find in array:C230($pColumnArray->; $tFind)
		
		If ($nRow>0)  //Found
			
			Core_Pick_Select($nRow)
			
			$nColumn:=$nNumberOfColumns+1
			
		End if   //Done found
		
	End for   //Done looping through Column
	
End if   //Done something to find