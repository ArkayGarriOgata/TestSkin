For ($row; 1; 9)
	$ptrCheckBox:=Get pointer:C304("cb"+String:C10($row))
	If ($ptrCheckBox->=1)
		If ($row<9)
			JML_BlockTimeCalcMachine($ptrCheckBox; iSheets)
		Else 
			JML_BlockTimeCalcMachine($ptrCheckBox; iSheets*iUp)
		End if 
	End if 
End for 