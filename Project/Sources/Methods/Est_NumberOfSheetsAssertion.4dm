//%attributes = {"publishedWeb":true}
//PM:  Est_NumberOfSheetsAssertion  10/10/00  mlb
//recalc the number of Sheets for a form when
//the number of sheets for an item is changed
//see also Est_SubformBreakDown, JBNSubformRatio, Job_SubformBreakDown
// Modified by: Mel Bohince (10/13/15) check htat all items on sf have same net sheets

SAVE RECORD:C53([Estimates_FormCartons:48])
$numberOfSheetsEntered:=[Estimates_DifferentialsForms:47]NumberSheets:4
SELECTION TO ARRAY:C260([Estimates_FormCartons:48]NetSheets:7; $netSheets; [Estimates_FormCartons:48]SubFormNumber:10; $sf)
SORT ARRAY:C229($sf; $netSheets)
ARRAY LONGINT:C221($aSubFormNumber; 0)
ARRAY LONGINT:C221($aSubFormSheets; 0)

If (Size of array:C274($netSheets)>0)
	$numberOfSheetsCalculated:=0
	$currentSF:=-1
	For ($i; 1; Size of array:C274($netSheets))
		If ($currentSF#$sf{$i})
			$numberOfSheetsCalculated:=$numberOfSheetsCalculated+$netSheets{$i}
			$currentSF:=$sf{$i}
			APPEND TO ARRAY:C911($aSubFormNumber; $sf{$i})
			APPEND TO ARRAY:C911($aSubFormSheets; $netSheets{$i})
		Else   // Modified by: Mel Bohince (10/13/15) test if same net as other items on sf
			$hit:=Find in array:C230($aSubFormNumber; $sf{$i})
			If ($hit>-1)
				If ($netSheets{$i}#$aSubFormSheets{$hit})
					BEEP:C151
					ALERT:C41("Net Sheets inconsistent on subform "+String:C10($sf{$i})+" "+String:C10($netSheets{$i})+" v "+String:C10($aSubFormSheets{$hit}))
				End if 
			End if 
		End if 
	End for 
End if 

If ($numberOfSheetsCalculated#$numberOfSheetsEntered)
	uConfirm("You entered "+String:C10($numberOfSheetsEntered)+" net sheets on the form, but it looks like you need "+String:C10($numberOfSheetsCalculated); "Change"; "Ignor")
	If (OK=1)
		[Estimates_DifferentialsForms:47]NumberSheets:4:=$numberOfSheetsCalculated
	Else 
		BEEP:C151
		BEEP:C151
		If ($numberOfSheetsEntered<$numberOfSheetsCalculated)
			ALERT:C41("WARNING: You may not sheet enough for all your subforms.")
		Else 
			ALERT:C41("WARNING: You may be over sheeting.")
		End if 
		
	End if 
End if 